# 🔥 Firebase Setup Guide for Pact

## **Why Firebase is Perfect for Pact**

1. **Unified Platform**: Same backend for landing page AND the actual app
2. **Real-time Database**: Perfect for commitment tracking
3. **Authentication**: Ready for user accounts
4. **Hosting**: Fast, global CDN
5. **Analytics**: Built-in Google Analytics
6. **Generous Free Tier**: Perfect for startup phase

---

## **Step 1: Create Firebase Project**

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Name: `pact-app` (or your preference)
4. Enable Google Analytics: **Yes**
5. Choose your Analytics account
6. Click "Create project"

---

## **Step 2: Enable Required Services**

### **Firestore Database**
1. In Firebase Console → "Firestore Database"
2. Click "Create database"
3. Choose "Start in test mode" (we'll secure it later)
4. Select your region (closest to your users)

### **Authentication** (for future app)
1. Go to "Authentication" → "Get started"
2. Enable "Email/Password" provider
3. Enable "Google" provider (optional)

### **Hosting**
1. Go to "Hosting" → "Get started"
2. Install Firebase CLI: `npm install -g firebase-tools`
3. We'll configure this in Step 4

---

## **Step 3: Get Your Config**

1. Go to Project Settings (gear icon)
2. Scroll to "Your apps" section
3. Click "Web app" icon (`</>`)
4. Name: `pact-landing`
5. Enable Firebase Hosting: **Yes**
6. Copy the config object

**Replace this in `script.js` (lines 9-17):**
```javascript
const firebaseConfig = {
  apiKey: "your-actual-api-key",
  authDomain: "your-project.firebaseapp.com",
  projectId: "your-project-id",
  storageBucket: "your-project.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abcdef123456"
};
```

---

## **Step 4: Deploy to Firebase Hosting**

### **Initialize Firebase in your project:**
```bash
cd /Users/nikhilkagita/Desktop/pact
firebase login
firebase init
```

### **Select these options:**
- ✅ Firestore: Configure security rules and indexes
- ✅ Hosting: Configure files for Firebase Hosting
- Use existing project: Select your `pact-app`
- Firestore rules: `firestore.rules` (default)
- Firestore indexes: `firestore.indexes.json` (default)
- Public directory: `.` (current directory)
- Single-page app: **No**
- Overwrite index.html: **No**

### **Deploy:**
```bash
firebase deploy
```

Your site will be live at: `https://your-project.firebaseapp.com`

---

## **Step 5: Set Up Custom Domain** (Optional)

1. In Firebase Console → Hosting
2. Click "Add custom domain"
3. Enter: `pact.app` (or your domain)
4. Follow the DNS setup instructions
5. Firebase will handle SSL certificates automatically

---

## **Step 6: Configure Firestore Security**

Replace the content of `firestore.rules`:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow anyone to write to waitlist (for email signups)
    match /waitlist/{document} {
      allow create: if true;
      allow read, update, delete: if false;
    }
    
    // Deny all other access by default
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

Deploy the rules:
```bash
firebase deploy --only firestore:rules
```

---

## **Step 7: View Your Data**

1. Go to Firestore Database in Firebase Console
2. You'll see a "waitlist" collection
3. Each email signup creates a new document with:
   - `email`: User's email
   - `source`: Which CTA they used
   - `timestamp`: When they signed up
   - `userAgent`: Browser info
   - `referrer`: Where they came from
   - `utm`: Marketing campaign data

---

## **Step 8: Set Up Analytics** (Optional)

Your Firebase project already includes Google Analytics. To get the GA4 ID:

1. Go to Google Analytics (linked from Firebase)
2. Find your Measurement ID (starts with `G-`)
3. Replace `GA_MEASUREMENT_ID` in your HTML (lines 41 & 46)

---

## **Monthly Costs (Estimate)**

### **Free Tier Limits:**
- **Firestore**: 50k reads, 20k writes, 1GB storage
- **Hosting**: 10GB storage, 360MB/day transfer
- **Functions**: 125k invocations, 40k GB-seconds

### **Expected Usage (1000 signups/month):**
- Firestore writes: ~1,000 (well within free tier)
- Hosting: Minimal (static files)
- **Total cost: $0/month** for first 6+ months

---

## **Future Benefits**

When you build the actual Pact app, you'll already have:
- ✅ User database set up
- ✅ Authentication configured  
- ✅ Backend infrastructure ready
- ✅ Analytics tracking
- ✅ Hosting platform
- ✅ Domain connected

**Firebase scales with you from 0 to millions of users.**

---

## **Troubleshooting**

### **"Firebase is not defined" error:**
- Make sure Firebase SDK scripts load before `script.js`
- Check browser console for network errors

### **Permission denied:**
- Check Firestore security rules
- Make sure you're writing to the `waitlist` collection

### **Deployment fails:**
- Run `firebase login` again
- Check you're in the right directory
- Ensure `firebase.json` exists

---

## **Next Steps After Setup**

1. **Test email signup** on your deployed site
2. **Check Firestore** to see emails coming in  
3. **Set up email notifications** (optional Cloud Function)
4. **Add custom domain** if you have one
5. **Monitor analytics** for conversion tracking

**Your landing page will be production-ready with enterprise-grade backend!**
