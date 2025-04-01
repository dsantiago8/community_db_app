# routers/events.py
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from .. import models, schemas, database

router = APIRouter()

@router.post("/events/")
def create_event(event: schemas.EventCreate, db: Session = Depends(database.SessionLocal)):
    new_event = models.Event(**event.dict())
    db.add(new_event)
    db.commit()
    db.refresh(new_event)
    return new_event
