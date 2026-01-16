import requests
from bs4 import BeautifulSoup

URL = "https://www.mff.se/lag/herr/spelare/andrej-djuric/"
headers = {
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36"
}
response = requests.get(URL, headers=headers)
soup = BeautifulSoup(response.text, 'html.parser')

# Print the whole thing nicely formatted
print(soup.prettify())
