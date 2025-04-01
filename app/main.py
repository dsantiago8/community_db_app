# main.py
from fastapi import FastAPI
from app.database import engine, Base
from app.routers import events

app = FastAPI()

Base.metadata.create_all(bind=engine)

@app.get("/")
def read_root():
    return {"message": "Welcome to the Community Event and Marketplace API!"}

app.include_router(events.router, prefix="/api")
