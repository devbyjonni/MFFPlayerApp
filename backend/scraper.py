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
        
        # Based on typical MFF structure (needs verification against live HTML)
        # Looking for article or div elements that represent players.
        # Often constructed as links <a> with specific classes or looking for images.
        
        # Let's inspect typical patterns. We try to find all 'a' tags that look like player cards.
        # Usually they contain an image and some text.
        
        # Strategy: Find all links that go to /lag/herr/spelare/NAME
        links = soup.find_all('a', href=True)
        
        for link in links:
            href = link['href']
            if "/lag/herr/spelare/" in href and href != URL:
                # This is likely a player link
                # Try to extract details from inside the link
                
                # Check for Name
                name_tag = link.find(['span', 'h3', 'p'], class_=lambda x: x and 'name' in x.lower() if x else False)
                if not name_tag:
                    # Fallback: check closest H3 or just text
                    name = link.get_text(separator=" ", strip=True)
                else:
                    name = name_tag.get_text(strip=True)
                
                # Clean up name (often has number attached in text)
                # Example text: "Johan Dahlin 27"
                
                # Check for Image
                img_tag = link.find('img')
                # MFF site often uses lazy loading, so check data-src too
                image_url = ""
                if img_tag:
                    image_url = img_tag.get('src') or img_tag.get('data-src') or ""
                
                # Check for Number
                number = ""
                # Simple heuristic: look for digits at end of string
                parts = name.split()
                if parts and parts[-1].isdigit():
                    number = parts[-1]
                    name = " ".join(parts[:-1]) # Remove number from name
                
                # Avoid duplicates and non-player links (like "Ledarstab" if it shares structure)
                # We filter by ensuring we found a likely number or a valid name
                
                if name and len(name) > 2:
                     # Check if we already have this player (by url)
                    if not any(p['details_url'] == href for p in players):
                        players.append({
                            "name": name,
                            "number": number, # Default to empty if not found
                            "image": image_url,
                            "details_url": href
                        })

        logger.info(f"Found {len(players)} players.")
        return players

    except Exception as e:
        logger.error(f"Error scraping players: {e}")
        return []

if __name__ == "__main__":
    data = get_players()
    for p in data:
        print(p)
