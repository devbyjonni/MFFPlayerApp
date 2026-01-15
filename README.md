#  MFFPlayerApp
A **SwiftUI app** that fetches and displays **Malmö FF player data** from a custom Python backend (FastAPI), using **BeautifulSoup** for scraping and **SwiftData** for local persistence.

## Features
- Fetches real-time **Malmö FF player data** via Python Backend
- Displays player **name, number, and image**
- Uses **SwiftUI List & AsyncImage** for a native look
- Caches player data locally using **SwiftData** for offline access
- **Pull-to-refresh** support

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

