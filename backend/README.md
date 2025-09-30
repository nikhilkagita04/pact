# Pact Backend API

A Python FastAPI backend for the Pact relationship app, providing authentication, contact management, and pact tracking functionality.

## Features

- 🔐 Firebase Authentication integration
- 👥 Mock contact personas for development
- 🤝 Pact creation and management
- 📊 Real-time status tracking
- 🧪 Comprehensive unit tests
- 📚 Auto-generated API documentation

## Quick Start

### Prerequisites

- Python 3.9+
- pip
- Firebase project (optional for development)

### Installation

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. Set up environment variables (optional):
```bash
# For production Firebase integration
export FIREBASE_SERVICE_ACCOUNT_PATH="/path/to/service-account-key.json"
```

3. Run the development server:
```bash
python main.py
```

The API will be available at `http://localhost:8000`

### API Documentation

- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

## API Endpoints

### Authentication
- `GET /api/v1/users/me` - Get current user profile
- `PUT /api/v1/users/me` - Update user profile

### Contacts
- `GET /api/v1/contacts` - Get all mock contacts
- `GET /api/v1/contacts/{contact_id}` - Get specific contact
- Query parameters:
  - `search` - Search by name or phone
  - `relationship` - Filter by relationship type

### Pacts
- `POST /api/v1/pacts` - Create new pact
- `GET /api/v1/pacts` - Get user's pacts
  - Query parameter: `type` (created/received)
- `PUT /api/v1/pacts/{pact_id}` - Update pact
- `DELETE /api/v1/pacts/{pact_id}` - Delete pact
- `POST /api/v1/pacts/{pact_id}/accept` - Accept pact
- `POST /api/v1/pacts/{pact_id}/complete` - Complete pact
- `POST /api/v1/pacts/{pact_id}/decline` - Decline pact

## Mock Data

The backend includes 8 mock personas for development:

- **Emily Johnson** (Friend) - `emily_001`
- **Alex Chen** (Friend) - `alex_002`
- **Sarah Williams** (Family) - `sarah_003`
- **Michael Brown** (Colleague) - `michael_004`
- **Dad** (Family) - `dad_005`
- **Mom** (Family) - `mom_006`
- **Jessica Martinez** (Partner) - `jessica_007`
- **David Kim** (Colleague) - `david_008`

## Testing

Run the test suite:

```bash
# Run all tests
python -m pytest tests/ -v

# Run with coverage
python -m pytest tests/ --cov=. --cov-report=html
```

## Development

### Project Structure

```
backend/
├── app/
│   ├── __init__.py
│   ├── auth.py          # Authentication middleware
│   └── routes.py        # API endpoints
├── models/
│   ├── __init__.py
│   ├── user.py          # User data models
│   └── pact.py          # Pact data models
├── services/
│   ├── __init__.py
│   ├── firebase_service.py  # Firebase integration
│   └── mock_contacts.py     # Mock contact data
├── tests/
│   └── test_api.py      # API tests
├── main.py              # FastAPI app
├── requirements.txt     # Dependencies
└── README.md
```

### Adding New Features

1. Define data models in `models/`
2. Add service logic in `services/`
3. Create API endpoints in `app/routes.py`
4. Write tests in `tests/`
5. Update documentation

## Production Deployment

For production deployment:

1. Set up Firebase service account
2. Configure environment variables
3. Use a production WSGI server (e.g., Gunicorn)
4. Set up proper CORS origins
5. Enable HTTPS

## License

This project is part of the Pact relationship app.
