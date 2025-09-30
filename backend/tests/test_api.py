import pytest
from fastapi.testclient import TestClient
from main import app
from unittest.mock import patch, AsyncMock

client = TestClient(app)

# Mock Firebase service for testing
@pytest.fixture
def mock_firebase_service():
    with patch('app.routes.firebase_service') as mock:
        mock.verify_token = AsyncMock(return_value={
            "uid": "test_user_123",
            "email": "test@example.com",
            "name": "Test User"
        })
        mock.get_user = AsyncMock(return_value={
            "uid": "test_user_123",
            "email": "test@example.com",
            "display_name": "Test User",
            "photo_url": "",
            "created_at": "2024-01-01T00:00:00Z",
            "updated_at": "2024-01-01T00:00:00Z"
        })
        mock.create_pact = AsyncMock(return_value=True)
        mock.get_pacts_by_creator = AsyncMock(return_value=[])
        mock.get_pacts_by_recipient = AsyncMock(return_value=[])
        mock.update_pact = AsyncMock(return_value=True)
        mock.delete_pact = AsyncMock(return_value=True)
        yield mock

class TestHealthCheck:
    def test_health_check(self):
        """Test health check endpoint"""
        response = client.get("/api/v1/health")
        assert response.status_code == 200
        assert response.json()["status"] == "healthy"

class TestContacts:
    def test_get_contacts(self, mock_firebase_service):
        """Test getting all contacts"""
        response = client.get(
            "/api/v1/contacts",
            headers={"Authorization": "Bearer test_token"}
        )
        assert response.status_code == 200
        contacts = response.json()
        assert len(contacts) > 0
        assert "id" in contacts[0]
        assert "name" in contacts[0]
        assert "phone" in contacts[0]

    def test_get_contacts_with_search(self, mock_firebase_service):
        """Test searching contacts"""
        response = client.get(
            "/api/v1/contacts?search=Emily",
            headers={"Authorization": "Bearer test_token"}
        )
        assert response.status_code == 200
        contacts = response.json()
        assert len(contacts) > 0
        assert any("Emily" in contact["name"] for contact in contacts)

    def test_get_contacts_by_relationship(self, mock_firebase_service):
        """Test filtering contacts by relationship"""
        response = client.get(
            "/api/v1/contacts?relationship=friend",
            headers={"Authorization": "Bearer test_token"}
        )
        assert response.status_code == 200
        contacts = response.json()
        assert all(contact["relationship"] == "friend" for contact in contacts)

    def test_get_contact_by_id(self, mock_firebase_service):
        """Test getting a specific contact"""
        response = client.get(
            "/api/v1/contacts/emily_001",
            headers={"Authorization": "Bearer test_token"}
        )
        assert response.status_code == 200
        contact = response.json()
        assert contact["id"] == "emily_001"
        assert contact["name"] == "Emily Johnson"

    def test_get_contact_not_found(self, mock_firebase_service):
        """Test getting non-existent contact"""
        response = client.get(
            "/api/v1/contacts/nonexistent",
            headers={"Authorization": "Bearer test_token"}
        )
        assert response.status_code == 404

class TestPacts:
    def test_create_pact(self, mock_firebase_service):
        """Test creating a new pact"""
        pact_data = {
            "title": "Test Pact",
            "description": "This is a test pact",
            "recipient_id": "emily_001",
            "recipient_name": "Emily Johnson",
            "recipient_phone": "+1-555-0101"
        }
        
        response = client.post(
            "/api/v1/pacts",
            json=pact_data,
            headers={"Authorization": "Bearer test_token"}
        )
        assert response.status_code == 200
        pact = response.json()
        assert pact["title"] == "Test Pact"
        assert pact["creator_id"] == "test_user_123"
        assert pact["status"] == "pending"

    def test_create_pact_invalid_recipient(self, mock_firebase_service):
        """Test creating pact with invalid recipient"""
        pact_data = {
            "title": "Test Pact",
            "description": "This is a test pact",
            "recipient_id": "nonexistent",
            "recipient_name": "Nonexistent",
            "recipient_phone": "+1-555-0000"
        }
        
        response = client.post(
            "/api/v1/pacts",
            json=pact_data,
            headers={"Authorization": "Bearer test_token"}
        )
        assert response.status_code == 404

    def test_get_created_pacts(self, mock_firebase_service):
        """Test getting user's created pacts"""
        response = client.get(
            "/api/v1/pacts?type=created",
            headers={"Authorization": "Bearer test_token"}
        )
        assert response.status_code == 200
        pacts = response.json()
        assert isinstance(pacts, list)

    def test_get_received_pacts(self, mock_firebase_service):
        """Test getting user's received pacts"""
        response = client.get(
            "/api/v1/pacts?type=received",
            headers={"Authorization": "Bearer test_token"}
        )
        assert response.status_code == 200
        pacts = response.json()
        assert isinstance(pacts, list)

    def test_accept_pact(self, mock_firebase_service):
        """Test accepting a pact"""
        response = client.post(
            "/api/v1/pacts/test_pact_123/accept",
            headers={"Authorization": "Bearer test_token"}
        )
        assert response.status_code == 200
        assert response.json()["message"] == "Pact accepted successfully"

    def test_complete_pact(self, mock_firebase_service):
        """Test completing a pact"""
        response = client.post(
            "/api/v1/pacts/test_pact_123/complete",
            headers={"Authorization": "Bearer test_token"}
        )
        assert response.status_code == 200
        assert response.json()["message"] == "Pact completed successfully"

    def test_decline_pact(self, mock_firebase_service):
        """Test declining a pact"""
        response = client.post(
            "/api/v1/pacts/test_pact_123/decline",
            headers={"Authorization": "Bearer test_token"}
        )
        assert response.status_code == 200
        assert response.json()["message"] == "Pact declined successfully"

    def test_delete_pact(self, mock_firebase_service):
        """Test deleting a pact"""
        response = client.delete(
            "/api/v1/pacts/test_pact_123",
            headers={"Authorization": "Bearer test_token"}
        )
        assert response.status_code == 200
        assert response.json()["message"] == "Pact deleted successfully"

class TestAuthentication:
    def test_unauthenticated_request(self):
        """Test request without authentication"""
        response = client.get("/api/v1/contacts")
        assert response.status_code == 401

    def test_invalid_token(self, mock_firebase_service):
        """Test request with invalid token"""
        mock_firebase_service.verify_token.return_value = None
        
        response = client.get(
            "/api/v1/contacts",
            headers={"Authorization": "Bearer invalid_token"}
        )
        assert response.status_code == 401

class TestUserProfile:
    def test_get_user_profile(self, mock_firebase_service):
        """Test getting user profile"""
        response = client.get(
            "/api/v1/users/me",
            headers={"Authorization": "Bearer test_token"}
        )
        assert response.status_code == 200
        user = response.json()
        assert user["uid"] == "test_user_123"
        assert user["email"] == "test@example.com"

    def test_update_user_profile(self, mock_firebase_service):
        """Test updating user profile"""
        update_data = {
            "display_name": "Updated Name",
            "photo_url": "https://example.com/photo.jpg"
        }
        
        response = client.put(
            "/api/v1/users/me",
            json=update_data,
            headers={"Authorization": "Bearer test_token"}
        )
        assert response.status_code == 200
        user = response.json()
        assert user["display_name"] == "Updated Name"
