from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from enum import Enum

class PactStatus(str, Enum):
    PENDING = "pending"
    ACCEPTED = "accepted"
    COMPLETED = "completed"
    DECLINED = "declined"
    CANCELLED = "cancelled"

class PactBase(BaseModel):
    title: str
    description: str
    recipient_name: str
    recipient_phone: str
    recipient_id: Optional[str] = None

class PactCreate(PactBase):
    pass

class PactUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    status: Optional[PactStatus] = None
    completed_at: Optional[datetime] = None

class PactResponse(PactBase):
    id: str
    creator_id: str
    status: PactStatus = PactStatus.PENDING
    created_at: datetime
    updated_at: datetime
    completed_at: Optional[datetime] = None
    is_completed: bool = False

    class Config:
        from_attributes = True

class PactInDB(PactResponse):
    pass

class ContactPersona(BaseModel):
    id: str
    name: str
    phone: str
    email: str
    avatar_url: str
    relationship: str  # "friend", "family", "colleague", "partner"
