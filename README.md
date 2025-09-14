# 🤝 Pact Landing Page

Landing page for Pact - an app for tracking commitments between you and the people in your life.

**Live Site**: https://pact-7331b.web.app

## 🚀 Quick Start

```bash
git clone <repository-url>
cd pact
./scripts/setup.sh  # Interactive setup
```

Or manually:
```bash
npm install
firebase login
firebase use <your-project-id>
npm run dev
```

## 📁 Project Structure

```
├── assets/          # Images, icons, manifest
├── src/             # JavaScript and CSS
├── scripts/         # Setup and maintenance tools
├── docs/            # Documentation
├── index.html       # Main landing page
└── firebase.json    # Firebase configuration
```

## 🔧 Development

```bash
npm run dev          # Start development server
npm run deploy       # Deploy to production
npm run preview      # Deploy to preview channel
./scripts/maintenance.sh  # Interactive maintenance menu
```

## ⚙️ Configuration

1. **Firebase Config**: Update `index.html` lines 681-689 with your Firebase project config
2. **Environment**: Copy `env.example` to `.env` and fill in values
3. **Deploy Rules**: `firebase deploy --only firestore`

## 📊 Features

- **Email Signup**: Captures emails to Firestore `waitlist` collection
- **Analytics**: Firebase Analytics tracking
- **Security**: Validated email-only database writes
- **Performance**: Optimized loading and caching
- **Responsive**: Mobile-first design

## 🐛 Troubleshooting

- **Firebase not configured**: Check config in `index.html`
- **Email signup fails**: Check browser console and Firestore rules
- **Deploy fails**: Ensure `firebase login` and correct project selection

**Documentation**: See `docs/FIREBASE_SETUP.md` for detailed setup

---

Built with ❤️ for meaningful connections
