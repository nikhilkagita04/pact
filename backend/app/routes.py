from fastapi import APIRouter, Depends, HTTPException, status
from typing import List, Optional
from models.user import UserResponse, UserUpdate
from models.pact import PactCreate, PactResponse, PactUpdate, ContactPersona
from services.firebase_service import firebase_service
from services.mock_contacts import get_mock_contacts, get_contact_by_id, search_contacts, get_contacts_by_relationship
from app.auth import get_current_user
import uuid
from datetime import datetime

router = APIRouter()

# User routes
@router.get("/users/me", response_model=UserResponse)
async def get_current_user_profile(current_user: dict = Depends(get_current_user)):
    """Get current user's profile"""
    user_data = await firebase_service.get_user(current_user["uid"])
    if not user_data:
        raise HTTPException(status_code=404, detail="User not found")
    
    return UserResponse(**user_data)

@router.put("/users/me", response_model=UserResponse)
async def update_current_user_profile(
    user_update: UserUpdate,
    current_user: dict = Depends(get_current_user)
):
    """Update current user's profile"""
    update_data = user_update.dict(exclude_unset=True)
    update_data["updated_at"] = datetime.now()
    
    success = await firebase_service.update_user(current_user["uid"], update_data)
    if not success:
        raise HTTPException(status_code=500, detail="Failed to update user")
    
    # Return updated user data
    user_data = await firebase_service.get_user(current_user["uid"])
    return UserResponse(**user_data)

# Contact routes
@router.get("/contacts", response_model=List[ContactPersona])
async def get_contacts(
    search: Optional[str] = None,
    relationship: Optional[str] = None,
    current_user: dict = Depends(get_current_user)
):
    """Get mock contacts for development"""
    contacts = get_mock_contacts()
    
    if search:
        contacts = search_contacts(search)
    
    if relationship:
        contacts = get_contacts_by_relationship(relationship)
    
    return contacts

@router.get("/contacts/{contact_id}", response_model=ContactPersona)
async def get_contact(
    contact_id: str,
    current_user: dict = Depends(get_current_user)
):
    """Get a specific contact by ID"""
    contact = get_contact_by_id(contact_id)
    if not contact:
        raise HTTPException(status_code=404, detail="Contact not found")
    
    return contact

# Pact routes
@router.post("/pacts", response_model=PactResponse)
async def create_pact(
    pact_data: PactCreate,
    current_user: dict = Depends(get_current_user)
):
    """Create a new pact"""
    pact_id = str(uuid.uuid4())
    
    # Get recipient info from contacts
    recipient = get_contact_by_id(pact_data.recipient_id) if pact_data.recipient_id else None
    if not recipient:
        raise HTTPException(status_code=404, detail="Recipient not found")
    
    pact_dict = {
        "id": pact_id,
        "creator_id": current_user["uid"],
        "recipient_id": recipient.id,
        "recipient_name": recipient.name,
        "recipient_phone": recipient.phone,
        "title": pact_data.title,
        "description": pact_data.description,
        "status": "pending",
        "is_completed": False,
        "created_at": datetime.now(),
        "updated_at": datetime.now()
    }
    
    success = await firebase_service.create_pact(pact_dict)
    if not success:
        raise HTTPException(status_code=500, detail="Failed to create pact")
    
    return PactResponse(**pact_dict)

@router.get("/pacts", response_model=List[PactResponse])
async def get_user_pacts(
    type: str = "created",  # "created" or "received"
    current_user: dict = Depends(get_current_user)
):
    """Get user's pacts (created or received)"""
    if type == "created":
        pacts = await firebase_service.get_pacts_by_creator(current_user["uid"])
    elif type == "received":
        pacts = await firebase_service.get_pacts_by_recipient(current_user["uid"])
    else:
        raise HTTPException(status_code=400, detail="Invalid type parameter")
    
    return [PactResponse(**pact) for pact in pacts]

@router.get("/pacts/{pact_id}", response_model=PactResponse)
async def get_pact(
    pact_id: str,
    current_user: dict = Depends(get_current_user)
):
    """Get a specific pact by ID"""
    # This would need to be implemented in firebase_service
    # For now, return a mock response
    raise HTTPException(status_code=501, detail="Not implemented yet")

@router.put("/pacts/{pact_id}", response_model=PactResponse)
async def update_pact(
    pact_id: str,
    pact_update: PactUpdate,
    current_user: dict = Depends(get_current_user)
):
    """Update a pact"""
    update_data = pact_update.dict(exclude_unset=True)
    update_data["updated_at"] = datetime.now()
    
    success = await firebase_service.update_pact(pact_id, update_data)
    if not success:
        raise HTTPException(status_code=500, detail="Failed to update pact")
    
    # Return updated pact (would need to fetch from DB)
    raise HTTPException(status_code=501, detail="Not implemented yet")

@router.delete("/pacts/{pact_id}")
async def delete_pact(
    pact_id: str,
    current_user: dict = Depends(get_current_user)
):
    """Delete a pact"""
    success = await firebase_service.delete_pact(pact_id)
    if not success:
        raise HTTPException(status_code=500, detail="Failed to delete pact")
    
    return {"message": "Pact deleted successfully"}

@router.post("/pacts/{pact_id}/accept")
async def accept_pact(
    pact_id: str,
    current_user: dict = Depends(get_current_user)
):
    """Accept a pact request"""
    update_data = {
        "status": "accepted",
        "updated_at": datetime.now()
    }
    
    success = await firebase_service.update_pact(pact_id, update_data)
    if not success:
        raise HTTPException(status_code=500, detail="Failed to accept pact")
    
    return {"message": "Pact accepted successfully"}

@router.post("/pacts/{pact_id}/complete")
async def complete_pact(
    pact_id: str,
    current_user: dict = Depends(get_current_user)
):
    """Mark a pact as completed"""
    update_data = {
        "status": "completed",
        "is_completed": True,
        "completed_at": datetime.now(),
        "updated_at": datetime.now()
    }
    
    success = await firebase_service.update_pact(pact_id, update_data)
    if not success:
        raise HTTPException(status_code=500, detail="Failed to complete pact")
    
    return {"message": "Pact completed successfully"}

@router.post("/pacts/{pact_id}/decline")
async def decline_pact(
    pact_id: str,
    current_user: dict = Depends(get_current_user)
):
    """Decline a pact request"""
    update_data = {
        "status": "declined",
        "updated_at": datetime.now()
    }
    
    success = await firebase_service.update_pact(pact_id, update_data)
    if not success:
        raise HTTPException(status_code=500, detail="Failed to decline pact")
    
    return {"message": "Pact declined successfully"}

# Health check
@router.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy", "message": "Pact API is running"}
