# schemas.py
from pydantic import BaseModel

class UserCreate(BaseModel):
    username: str
    email: str
    password: str

class EventCreate(BaseModel):
    title: str
    description: str
    location: str
    date: str
    time: str

class BusinessCreate(BaseModel):
    name: str
    description: str
    location: str
