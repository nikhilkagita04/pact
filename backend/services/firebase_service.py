import firebase_admin
from firebase_admin import credentials, firestore, auth
from typing import Optional, List, Dict, Any
import os
from datetime import datetime
import json

class FirebaseService:
    def __init__(self):
        self.db = None
        self._initialize_firebase()

    def _initialize_firebase(self):
        """Initialize Firebase Admin SDK"""
        try:
            # Check if we're in a test environment
            if os.getenv('PYTEST_CURRENT_TEST') or os.getenv('TESTING'):
                print("Test environment detected. Using mock Firebase service.")
                return
            
            # Clear any existing Firebase apps first
            if firebase_admin._apps:
                print("Clearing existing Firebase apps...")
                for app in list(firebase_admin._apps.values()):
                    try:
                        firebase_admin.delete_app(app)
                    except Exception as e:
                        print(f"Error deleting app: {e}")
            
            # Try to load from service account key first
            service_account_path = os.getenv('FIREBASE_SERVICE_ACCOUNT_PATH')
            if service_account_path and os.path.exists(service_account_path):
                try:
                    cred = credentials.Certificate(service_account_path)
                    firebase_admin.initialize_app(cred, {
                        'projectId': 'pact-7331b'
                    })
                    self.db = firestore.client()
                    print("Firebase initialized successfully with service account!")
                    return
                except Exception as e:
                    print(f"Error: Firebase not initialized with service account. Error: {e}")
            
            # Try to initialize with project ID only (for development)
            try:
                # Initialize with project ID
                firebase_admin.initialize_app(options={
                    'projectId': 'pact-7331b'
                })
                self.db = firestore.client()
                print("Firebase initialized successfully with real Firestore!")
                return
            except Exception as e:
                print(f"Failed to initialize with project ID: {e}")
            
            # Try to get default credentials (works in production)
            try:
                cred = credentials.ApplicationDefault()
                firebase_admin.initialize_app(cred, {
                    'projectId': 'pact-7331b'
                })
                self.db = firestore.client()
                print("Firebase initialized successfully with real Firestore!")
                return
            except Exception as e:
                print(f"Failed to initialize with default credentials: {e}")
            
            print("Error: Firebase not initialized. Please set up Firebase credentials.")
            print("Please download a real service account key from Firebase Console")
            print("Go to: https://console.firebase.google.com/project/pact-7331b/settings/serviceaccounts/adminsdk")
            raise Exception("Firebase initialization failed. Please download a real service account key from Firebase Console.")
        except Exception as e:
            print(f"Firebase initialization failed: {e}")
            raise Exception("Firebase initialization failed. Please download a real service account key from Firebase Console.")

    async def verify_token(self, token: str) -> Optional[Dict[str, Any]]:
        """Verify Firebase ID token and return user data"""
        try:
            decoded_token = auth.verify_id_token(token)
            return decoded_token
        except Exception as e:
            print(f"Token verification failed: {e}")
            return None

    async def get_user(self, uid: str) -> Optional[Dict[str, Any]]:
        """Get user data from Firestore"""
        if not self.db:
            raise Exception("Firebase not initialized")
        
        try:
            doc = self.db.collection('users').document(uid).get()
            if doc.exists:
                return doc.to_dict()
            return None
        except Exception as e:
            print(f"Error getting user: {e}")
            return None

    async def create_user(self, user_data: Dict[str, Any]) -> bool:
        """Create a new user in Firestore"""
        if not self.db:
            raise Exception("Firebase not initialized")
        
        try:
            self.db.collection('users').document(user_data['uid']).set(user_data)
            return True
        except Exception as e:
            print(f"Error creating user: {e}")
            return False

    async def update_user(self, uid: str, user_data: Dict[str, Any]) -> bool:
        """Update user data in Firestore"""
        if not self.db:
            raise Exception("Firebase not initialized")
        
        try:
            self.db.collection('users').document(uid).update(user_data)
            return True
        except Exception as e:
            print(f"Error updating user: {e}")
            return False

    async def create_pact(self, pact_data: Dict[str, Any]) -> bool:
        """Create a new pact in Firestore"""
        if not self.db:
            raise Exception("Firebase not initialized")
        
        try:
            self.db.collection('pacts').document(pact_data['id']).set(pact_data)
            return True
        except Exception as e:
            print(f"Error creating pact: {e}")
            return False

    async def get_pacts_by_creator(self, creator_id: str) -> List[Dict[str, Any]]:
        """Get all pacts created by a user"""
        if not self.db:
            raise Exception("Firebase not initialized")
        
        try:
            docs = self.db.collection('pacts').where('creator_id', '==', creator_id).stream()
            return [doc.to_dict() for doc in docs]
        except Exception as e:
            print(f"Error getting pacts: {e}")
            return []

    async def get_pacts_by_recipient(self, recipient_id: str) -> List[Dict[str, Any]]:
        """Get all pacts where user is the recipient"""
        if not self.db:
            raise Exception("Firebase not initialized")
        
        try:
            docs = self.db.collection('pacts').where('recipient_id', '==', recipient_id).stream()
            return [doc.to_dict() for doc in docs]
        except Exception as e:
            print(f"Error getting recipient pacts: {e}")
            return []

    async def update_pact(self, pact_id: str, update_data: Dict[str, Any]) -> bool:
        """Update a pact in Firestore"""
        if not self.db:
            raise Exception("Firebase not initialized")
        
        try:
            self.db.collection('pacts').document(pact_id).update(update_data)
            return True
        except Exception as e:
            print(f"Error updating pact: {e}")
            return False

    async def delete_pact(self, pact_id: str) -> bool:
        """Delete a pact from Firestore"""
        if not self.db:
            raise Exception("Firebase not initialized")
        
        try:
            self.db.collection('pacts').document(pact_id).delete()
            return True
        except Exception as e:
            print(f"Error deleting pact: {e}")
            return False

# Global instance
firebase_service = FirebaseService()
