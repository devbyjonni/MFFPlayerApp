from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel
from typing import List
import uvicorn
import scraper
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI()

class Player(BaseModel):
    name: str
    number: str
    image: str
    details_url: str
    bio: str = ""
    dob: str = ""
    position: str = ""
    stats_games: int = 0
    stats_goals: int = 0
    stats_assists: int = 0
    stats_yellow: int = 0
    stats_red: int = 0

class Token(BaseModel):
    access_token: str
    token_type: str

@app.get("/")
def read_root():
    return {"message": "MFF Player API is running"}

@app.get("/players", response_model=List[Player])
def get_players():
    logger.info("Request received for /players")
    players = scraper.get_players()
    if not players:
        # In case of empty list, return empty rather than error if no players found
        return []
    return players

@app.post("/token", response_model=Token)
def login():
    # Mock authentication to satisfy the iOS App's requirement
    return {"access_token": "mock-jwt-token", "token_type": "bearer"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
