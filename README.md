#  MFFPlayerApp
A **SwiftUI app** that fetches and displays **Malmö FF player data** from a FastAPI backend, using **web scraping** and **SwiftData** for local storage.

## Features
✅ Fetches real-time **Malmö FF player data** via FastAPI  
✅ Displays player **name, number, image, and statistics**  
✅ Uses **SwiftUI’s `AsyncImage` & `@Observable`** for a smooth UI  
✅ **JWT Authentication** with secure API access  
✅ Caches player data locally using **SwiftData** for offline access  
✅ Supports **auto-refresh & manual refresh** of player data  
✅ **Error handling & loading indicators** for a seamless experience  

---

## Tech Stack
### Frontend (iOS)
- **SwiftUI** (`async/await`, `@Observable`, `@Query` for SwiftData)
- **SwiftData** for persistent local storage
- **Swift Concurrency** (`async`/`await`) for optimized API calls
- **MVVM Architecture** with `PlayerViewModel`

### Backend (FastAPI)
- **FastAPI (`Python 3`)** for API and data management
- **Playwright** for scraping JavaScript-rendered content dynamically
- **OAuth2 with JWT** for secure authentication
- **Railway** for cloud deployment  
- **Docker** for containerized backend services  

---

## How It Works
1️⃣ **User logs in** → The app requests a JWT token from the FastAPI backend  
2️⃣ **Token is stored in-memory** → Used for all authenticated API calls  
3️⃣ **Players are fetched** from the backend via `GET /players`  
4️⃣ **Data is stored in SwiftData** → Available offline  
5️⃣ **Auto-refresh & pull-to-refresh** keep player data updated  

---
