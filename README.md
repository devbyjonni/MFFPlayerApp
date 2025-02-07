## **⚽ MFFPlayerApp**
A SwiftUI app that fetches and displays **Malmö FF player data** using a FastAPI backend with **web scraping** and **SwiftData** for local storage.

### **🚀 Features**
✅ Fetches real-time **Malmö FF player data** from FastAPI backend  
✅ Displays player **name, number, image, and statistics**  
✅ Uses **SwiftUI's `AsyncImage` & `@Observable`** for a smooth UI  
✅ Caches player data locally using **SwiftData** for offline access  
✅ Supports **auto-refresh & manual refresh** of player data  
✅ **Error handling & loading indicators** for a seamless experience  

---

### **🛠 Tech Stack**
#### **Frontend:**
- **SwiftUI** (`async/await`, `@Observable`, `@Query` for SwiftData)
- **SwiftData** for persistent local storage
- **Swift Concurrency** for optimized API calls
- **MVVM Architecture** with `PlayerViewModel`

#### **Backend:**
- **FastAPI (`Python 3`)** for API and data management
- **Playwright** (for scraping player data dynamically)
- **Railway** (for deploying the FastAPI backend)

---


