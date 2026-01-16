#  MFFPlayerApp
A **SwiftUI app** that fetches and displays **Malmö FF player data** from a custom Python backend (FastAPI), using **BeautifulSoup** for scraping and **SwiftData** for local persistence.

## Features
- **Live Scraping**: Python backend extracts real-time player data from MFF.se.
- **On-Demand Details**: Fetches detailed biography, age, position, and season statistics (Games, Goals, Cards).
- **Native iOS UI**: Built with `SwiftUI` for a smooth, premium feel.
- **Offline Capabilities**: Uses `SwiftData` to cache players for offline access.
- **Pull-to-refresh**: Updates data on demand.

---

## Tech Stack
### Frontend (iOS)
- **SwiftUI** (`List`, `@Observable`, `@Query`)
- **SwiftData** for persistent local storage
- **Swift Concurrency** (`async`/`await`)
- **MVVM Architecture**

### Backend (Python)
- **FastAPI** for serving data
- **BeautifulSoup4** for scraping `mff.se`
- **Uvicorn** server

---

## How It Works
1. **Backend Scrapes Data**: `scraper.py` parses `mff.se` HTML.
2. **App Fetches Data**: `PlayerViewModel` requests `GET /players`.
3. **Persistence**: Data is saved to `SwiftData` for offline viewing.

