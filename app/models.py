# models.py
from sqlalchemy import Column, Integer, String, Text, ForeignKey, Date, Time
from sqlalchemy.orm import relationship
from .database import Base

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String(50), unique=True, index=True)
    email = Column(String(100), unique=True, index=True)
    password_hash = Column(String(255))
    created_at = Column(Date)

class Event(Base):
    __tablename__ = "events"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(100))
    description = Column(Text)
    location = Column(String(100))
    date = Column(Date)
    time = Column(Time)
    organizer_id = Column(Integer, ForeignKey("users.id"))

class Business(Base):
    __tablename__ = "businesses"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100))
    description = Column(Text)
    location = Column(String(100))
    owner_id = Column(Integer, ForeignKey("users.id"))
