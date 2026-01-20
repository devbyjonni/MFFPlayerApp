import requests
from bs4 import BeautifulSoup
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

URL = "https://www.mff.se/lag/herr/spelare/"

def get_players():
    try:
        logger.info(f"Fetching data from {URL}")
        headers = {
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36"
        }
        response = requests.get(URL, headers=headers)
        response.raise_for_status()
        
        soup = BeautifulSoup(response.text, 'html.parser')
        players = []
        current_position = ""
        
        # Determine strict scan order: Headers define the category for subsequent players
        # We look for h2 headers (Målvakter, etc) and 'a' tags for players
        elements = soup.find_all(['h2', 'a'])
        
        known_positions = ["Målvakter", "Försvarare", "Mittfältare", "Anfallare"]
        
        for element in elements:
            if element.name == 'h2':
                text = element.get_text(strip=True)
                # Check if this header is one of our known categories
                # (sometimes there might be other h2s, so we filter)
                if any(pos in text for pos in known_positions):
                    current_position = text
                    logger.info(f"Found category: {current_position}")
            
            elif element.name == 'a' and element.get('href'):
                link = element
                href = link['href']
                
                # Verify it's a player link
                if "/lag/herr/spelare/" in href and href != URL:
                    # Check for Name (Priority: class "person-name")
                    name_tag = link.find(class_="person-name")
                    name = ""
                    if name_tag:
                        name = name_tag.get_text(strip=True)
                    else:
                        # Fallback strategies
                        name_tag = link.find(['span', 'h3', 'p'], class_=lambda x: x and 'name' in x.lower() if x else False)
                        if name_tag:
                            name = name_tag.get_text(strip=True)
                        else:
                            name = link.get_text(separator=" ", strip=True)

                    # Check for Number
                    number = ""
                    number_tag = link.find(class_="person-number")
                    if number_tag:
                        number = number_tag.get_text(strip=True)
                    else:
                         # Fallback heuristic: look for digits at end of string
                        parts = name.split()
                        if parts and parts[-1].isdigit():
                            number = parts[-1]
                            name = " ".join(parts[:-1]) # Remove number from name
                        if parts and parts[-1].isdigit():
                            name = " ".join(parts[:-1]) # Remove number from name

                    # Check for Image
                    img_tag = link.find('img')
                    image_url = ""
                    if img_tag:
                        image_url = img_tag.get('src') or img_tag.get('data-src') or ""
                    
                    if name and len(name) > 2:
                         # Check if we already have this player
                        if not any(p['details_url'] == href for p in players):
                            players.append({
                                "name": name,
                                "number": number,
                                "image": image_url,
                                "details_url": href,
                                "position": current_position # Assign the current section category
                            })

        logger.info(f"Found {len(players)} players. Fetching details for each...")
        
        # Enrich with details
        full_players = []
        for p in players:
            # logger.info(f"Scraping details for {p['name']}...")
            details = get_player_details(p['details_url'])
            if details:
                p.update(details)
            full_players.append(p)
            
        return full_players

    except Exception as e:
        logger.error(f"Error scraping players: {e}")
        return []

def get_player_details(url):
    try:
        # logger.info(f"Fetching details from {url}")
        headers = {
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36"
        }
        response = requests.get(url, headers=headers)
        response.raise_for_status()
        
        soup = BeautifulSoup(response.text, 'html.parser')
        details = {
            "bio": "",
            "dob": "",
            # "position": "", # Configured from list page now
            "stats_games": 0,
            "stats_goals": 0,
            "stats_assists": 0,
            "stats_yellow": 0,
            "stats_red": 0
        }

        # 1. Parse Bio (person-info)
        info_box = soup.find(class_="person-info")
        if info_box:
            # Get all paragraphs
            paragraphs = info_box.find_all('p')
            bio_text = "\n\n".join([p.get_text(strip=True) for p in paragraphs])
            details["bio"] = bio_text
        
        # 2. Parse Stats (person-quick-facts)
        # Structure is usually <ul><li><h3>Label</h3><p>Value</p></li>...</ul>
        quick_facts = soup.find(class_="person-quick-facts")
        if quick_facts:
            facts = quick_facts.find_all('li')
            for fact in facts:
                label = fact.find('h3')
                value = fact.find('p')
                if label and value:
                    label_text = label.get_text(strip=True).lower()
                    value_text = value.get_text(strip=True)
                    
                    if "född" in label_text or "födelsedatum" in label_text:
                        details["dob"] = value_text
                    elif "position" in label_text:
                        details["position"] = value_text
        
        # 3. Parse Season Stats (person-stats)
        # <li class="person-stats-item" data-stats-type="games">...</li>
        stats_section = soup.find(class_="person-stats")
        if stats_section:
            stat_items = stats_section.find_all(class_="person-stats-item")
            for item in stat_items:
                stat_type = item.get("data-stats-type")
                value_tag = item.find('p')
                if stat_type and value_tag:
                    value_text = value_tag.get_text(strip=True)
                    # Try to parse int, typically "9", "0", etc.
                    try:
                        int_val = int(value_text)
                        
                        # Map known types to our response keys
                        if stat_type == "games":
                            details["stats_games"] = int_val
                        elif stat_type == "goals":
                            details["stats_goals"] = int_val
                        elif stat_type == "assists":
                            details["stats_assists"] = int_val
                        elif stat_type == "yellow_cards":
                            details["stats_yellow"] = int_val
                        elif stat_type == "red_cards":
                            details["stats_red"] = int_val
                    except ValueError:
                        pass # Not an integer

        return details

    except Exception as e:
        logger.error(f"Error scraping details: {e}")
        return None

if __name__ == "__main__":
    data = get_players()
    for p in data:
        print(p)
