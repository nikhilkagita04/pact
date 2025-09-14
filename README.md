# 🤝 Pact Landing Page

Landing page for Pact - an app for tracking commitments between you and the people in your life.

**Live Site**: https://pact-7331b.web.app

## 💡 Our "Why": The Story Behind Pact

We are building Pact because we believe that the foundation of every great relationship—whether with a partner, a friend, a family member, or a colleague—is built on a simple, powerful idea: trust. And trust is built on kept promises.

In our busy, hyper-connected lives, we make dozens of small promises every day. "I'll send you that link." "I'll pick up the milk on my way home." "I'll look over that draft for you." These aren't just tasks; they are the small, essential threads that weave our relationships together. Each one is an opportunity to show someone that we care, that we're listening, and that they can count on us.

But our current tools are failing us. These important commitments get lost in endless text threads, forgotten after a quick conversation, or become a source of nagging and mental burden. The result is quiet friction. It's the small pang of disappointment when something is forgotten, the slow erosion of reliability, and the stress of trying to hold it all in our heads. We've all felt it.

We asked ourselves: What if there was a more beautiful, more intentional way?

What if we could create a space that wasn't about assigning tasks, but about sharing commitments? A tool that feels less like a to-do list and more like a digital handshake—a shared understanding that turns a casual promise into a delightful, collaborative action.

That is why we are building Pact.

We're not just building another productivity app. We are building a relationship app. Our mission is to create a positive, joyful experience around reliability. We want to eliminate the anxiety of forgetting and replace it with the quiet confidence of following through. We want to help people spend less energy tracking promises and more energy strengthening the connections that matter most.

We envision a world where our best intentions are effortlessly translated into actions, where "I promise" is always followed by "I did," and where technology helps us be more present, more reliable, and more connected to the people in our lives.

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
