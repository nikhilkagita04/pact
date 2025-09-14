# 🤝 Pact Landing Page

> Be the person everyone can count on. Keep your commitments.

A modern, responsive landing page for Pact - an app for tracking commitments and requests between you and the people in your life.

## 🌐 Live Site

**Production**: https://pact-7331b.web.app

## 📁 Project Structure

```
pact/
├── assets/                 # Static assets
│   ├── founder.jpg        # Founder photo
│   ├── og-image.svg       # Open Graph image for social sharing
│   ├── twitter-card.svg   # Twitter card image
│   └── site.webmanifest   # PWA manifest
├── docs/                  # Documentation
│   ├── FIREBASE_SETUP.md  # Firebase setup guide
│   └── POST_LAUNCH_REFINEMENTS.md # Post-launch improvements
├── src/                   # Source files
│   ├── script.js          # JavaScript functionality
│   └── styles.css         # CSS styles
├── index.html             # Main landing page
├── privacy-policy.html    # Privacy policy page
├── terms-of-service.html  # Terms of service page
├── firebase.json          # Firebase configuration
├── firestore.rules        # Firestore security rules
├── firestore.indexes.json # Firestore indexes
└── package.json           # Node.js dependencies
```

## 🚀 Quick Start

### Prerequisites

- Node.js (v18 or higher)
- Firebase CLI
- Git

### Installation

#### **Quick Setup (Recommended)**
```bash
git clone <repository-url>
cd pact
./scripts/setup.sh
```

#### **Manual Setup**

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd pact
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Configure environment**
   ```bash
   cp env.example .env
   # Edit .env with your Firebase configuration
   ```

4. **Login to Firebase**
   ```bash
   firebase login
   firebase use <your-project-id>
   ```

5. **Start development server**
   ```bash
   npm run dev
   ```

   The site will be available at `http://localhost:5000`

## 🔧 Development

### Available Scripts

```bash
# Development
npm run dev          # Start local development server
npm start            # Alias for npm run dev

# Deployment  
npm run deploy       # Deploy everything to production
npm run deploy:hosting    # Deploy only frontend (faster)
npm run deploy:firestore  # Deploy only database rules
npm run deploy:rules      # Deploy only Firestore rules

# Maintenance
npm run setup        # Set up Firebase project
npm run status       # Check Firebase project status  
npm run validate     # Validate deployment (dry run)
npm run preview      # Deploy to preview channel
npm run clean        # Clean up preview channels
npm run logs         # View function logs
```

### Maintenance Scripts

```bash
# Interactive setup (recommended for new developers)
./scripts/setup.sh

# Interactive maintenance menu
./scripts/maintenance.sh
```

### Local Development

1. **Start the development server**:
   ```bash
   firebase serve --host 0.0.0.0 --port 5000
   ```

2. **Make your changes** to HTML, CSS, or JavaScript files

3. **Test your changes** in the browser at `http://localhost:5000`

4. **Deploy when ready**:
   ```bash
   firebase deploy --only hosting
   ```

## 🔥 Firebase Configuration

### Initial Setup

If you're setting up Firebase for the first time, follow the detailed guide in [`docs/FIREBASE_SETUP.md`](docs/FIREBASE_SETUP.md).

### Quick Configuration

1. **Update Firebase config** in `index.html` (lines 681-689):
   ```javascript
   const firebaseConfig = {
     apiKey: "your-api-key",
     authDomain: "your-project.firebaseapp.com",
     projectId: "your-project-id",
     // ... other config
   };
   ```

2. **Deploy Firestore rules**:
   ```bash
   firebase deploy --only firestore
   ```

### Email Signup Flow

The landing page captures email signups with the following flow:

1. **User enters email** → Frontend validation
2. **Submits to Firestore** → Creates document in `waitlist` collection
3. **Tracks with Analytics** → Firebase Analytics event
4. **Shows success message** → User feedback

Data captured for each signup:
- `email` - User's email address
- `source` - Which CTA was used (hero vs final)
- `timestamp` - Server timestamp
- `userAgent` - Browser/device info
- `referrer` - Referring website
- `utm` - Marketing campaign parameters

## 🛡️ Security

### Firestore Rules

The database is secured with rules that:
- ✅ Allow anyone to create waitlist entries (email signups)
- ✅ Validate email format and required fields
- ❌ Prevent unauthorized reading/updating/deleting
- ❌ Block all other database access

### Content Security

- Email validation on both frontend and backend
- XSS protection through proper escaping
- HTTPS enforced through Firebase Hosting
- Secure headers configured in `firebase.json`

## 📊 Analytics & Tracking

### Firebase Analytics

Automatically tracks:
- Page views
- Email signups (`sign_up` event)
- User engagement metrics
- Conversion funnel

### Google Analytics (Optional)

To enable Google Analytics:
1. Uncomment the GA code in `index.html` (lines 41-47)
2. Replace `GA_MEASUREMENT_ID` with your tracking ID
3. Deploy the changes

## 🎨 Customization

### Styling

- **CSS Variables**: Defined in `:root` for easy theming
- **Responsive Design**: Mobile-first approach with breakpoints
- **Dark Theme**: Built-in dark color scheme
- **Material Design**: Following Material 3 principles

### Content Updates

1. **Hero Section**: Update messaging in `index.html`
2. **Founder Section**: Replace photo and bio
3. **FAQ Section**: Add/modify questions and answers
4. **Legal Pages**: Update privacy policy and terms

### Assets

- **Images**: Place in `assets/` directory
- **Icons**: Update favicon and social sharing images
- **Manifest**: Modify `assets/site.webmanifest` for PWA settings

## 🚀 Deployment

### Production Deployment

```bash
# Deploy everything
firebase deploy

# Deploy only specific services
firebase deploy --only hosting
firebase deploy --only firestore
```

### Custom Domain

1. **In Firebase Console**: Hosting → Add custom domain
2. **Follow DNS setup**: Add required DNS records
3. **SSL Certificate**: Automatically provisioned by Firebase

### Environment Variables

For different environments, update the Firebase config:
- **Development**: Use Firebase emulators
- **Staging**: Separate Firebase project
- **Production**: Main Firebase project

## 📈 Performance

### Optimization Features

- ✅ **Lazy Loading**: Images load when needed
- ✅ **Font Optimization**: Preloaded with fallbacks
- ✅ **Caching**: Aggressive caching for static assets
- ✅ **Minification**: CSS and JS optimized
- ✅ **CDN**: Global distribution via Firebase

### Performance Monitoring

Monitor performance through:
- Firebase Performance Monitoring
- Google PageSpeed Insights
- Firebase Analytics

## 🐛 Troubleshooting

### Common Issues

1. **"Firebase not configured"**
   - Check Firebase config in `index.html`
   - Ensure project ID matches your Firebase project

2. **Email signup not working**
   - Check browser console for errors
   - Verify Firestore rules are deployed
   - Test with the Firebase Console

3. **Local server 403 error**
   - Stop existing server: `Ctrl+C`
   - Restart: `firebase serve --host 0.0.0.0 --port 5000`

4. **Deploy fails**
   - Check `firebase.json` syntax
   - Ensure you're logged in: `firebase login`
   - Verify project selection: `firebase use --list`

### Debug Mode

Enable debug logging:
```javascript
// Add to browser console
localStorage.debug = 'firebase:*';
```

## 📞 Support

- **Documentation**: See `docs/` directory
- **Firebase Console**: https://console.firebase.google.com
- **Issues**: Create GitHub issues for bugs
- **Contact**: nikhilkagita97@gmail.com

## 📄 License

MIT License - see LICENSE file for details.

---

**Built with ❤️ for meaningful connections**
