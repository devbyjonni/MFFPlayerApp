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
        raise HTTPException(status_code=500, detail="Failed to fetch players")
    return players

class PlayerDetailsRequest(BaseModel):
    url: str

class PlayerDetails(BaseModel):
    bio: str
    dob: str
    position: str
    stats_games: int
    stats_goals: int
    stats_assists: int
    stats_yellow: int
    stats_red: int

@app.post("/players/details", response_model=PlayerDetails)
def get_details(request: PlayerDetailsRequest):
    logger.info(f"Request received for details: {request.url}")
    details = scraper.get_player_details(request.url)
    if not details:
        raise HTTPException(status_code=500, detail="Failed to fetch details")
    return details

@app.post("/token", response_model=Token)
def login():
    # Mock authentication to satisfy the iOS App's requirement
    return {"access_token": "mock-jwt-token", "token_type": "bearer"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
