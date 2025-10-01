# Design Tokens Quick Reference

## 🎨 Colors

### Background
```css
--background-primary: #FDFCFB      /* Main background */
--background-secondary: #F5F3F1    /* Alternate sections */
--background-tertiary: #EAE8E6     /* Subtle backgrounds */
```

### Text
```css
--text-primary: #3A3532            /* Headlines, important text */
--text-secondary: #6B6663          /* Body text, descriptions */
--text-tertiary: #9A9591           /* Supporting text, captions */
```

### Accent
```css
--accent-primary: #1A746B          /* Primary buttons, links */
--accent-secondary: #12544E        /* Hover states */
--accent-tertiary: #E8F1F0         /* Light backgrounds */
--accent-warm: #E57A5D             /* Warm accents, badges */
```

## 📐 Spacing

```css
--space-xs: 8px       /* Tiny gaps */
--space-sm: 12px      /* Small gaps */
--space-md: 16px      /* Default spacing */
--space-lg: 24px      /* Component gaps */
--space-xl: 32px      /* Section elements */
--space-2xl: 48px     /* Large gaps */
--space-3xl: 64px     /* Section headers */
--space-4xl: 80px     /* Large sections */
--space-5xl: 96px     /* Section padding */
```

## 📝 Typography

### Font Sizes
```css
/* Responsive Sizes */
--font-size-display-large: clamp(2.75rem, 7vw, 4.25rem)    /* 44-68px Hero */
--font-size-display-medium: clamp(2rem, 5vw, 3rem)         /* 32-48px Sections */
--font-size-headline-large: clamp(1.75rem, 4vw, 2.5rem)    /* 28-40px */
--font-size-headline-medium: clamp(1.5rem, 3vw, 2rem)      /* 24-32px */
--font-size-headline-small: clamp(1.25rem, 2.5vw, 1.5rem)  /* 20-24px Features */

/* Fixed Sizes */
--font-size-title-large: 1.5rem       /* 24px */
--font-size-title-medium: 1.25rem     /* 20px */
--font-size-body-large: 1.125rem      /* 18px Main content */
--font-size-body-medium: 1rem         /* 16px Secondary */
--font-size-label-large: 0.875rem     /* 14px Small text */
```

### Font Weights
```css
--font-weight-regular: 400     /* Body text */
--font-weight-medium: 500      /* Emphasis */
--font-weight-semibold: 600    /* Headings */
--font-weight-bold: 700        /* Strong emphasis */
```

### Line Heights
```css
--line-height-tight: 1.2       /* Headings */
--line-height-normal: 1.5      /* UI elements */
--line-height-relaxed: 1.7     /* Body text */
```

## 🔘 Border Radius

```css
--radius-xs: 0.375rem          /* 6px Subtle */
--radius-sm: 0.75rem           /* 12px Small */
--radius-md: 1rem              /* 16px Medium */
--radius-lg: 1.5rem            /* 24px Buttons */
--radius-xl: 2rem              /* 32px Cards */
--radius-2xl: 2.5rem           /* 40px Large */
--radius-pill: 9999px          /* Full round */
```

## 🌒 Shadows

```css
--shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05)
--shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)
--shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05)
--shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)
```

## ⚡ Animation

### Easing
```css
--easing-standard: cubic-bezier(0.2, 0, 0, 1)       /* Most interactions */
--easing-emphasized: cubic-bezier(0.05, 0.7, 0.1, 1) /* Entrances */
--easing-decelerated: cubic-bezier(0, 0, 0, 1)      /* Exits */
--easing-accelerated: cubic-bezier(0.3, 0, 1, 1)    /* Quick actions */
```

### Duration
```css
--duration-short2: 100ms       /* Instant feedback */
--duration-medium2: 300ms      /* Standard transitions */
--duration-long2: 500ms        /* Emphasized animations */
```

## 📱 Breakpoints

```css
@media (max-width: 1024px)  /* Tablet */
@media (max-width: 768px)   /* Mobile */
@media (max-width: 480px)   /* Small mobile */
```

## 🎯 Common Patterns

### Section Padding
```css
padding: var(--space-5xl) 0;  /* Desktop: 96px */
padding: var(--space-4xl) 0;  /* Tablet: 80px */
padding: var(--space-3xl) 0;  /* Mobile: 64px */
```

### Card Styling
```css
padding: var(--space-2xl);
background-color: white;
border-radius: var(--radius-xl);
box-shadow: var(--shadow-md);
```

### Button Styling
```css
padding: var(--space-md) var(--space-xl);
background-color: var(--accent-primary);
border-radius: var(--radius-lg);
font-weight: var(--font-weight-semibold);
```

### Gap Spacing
```css
gap: var(--space-4xl);  /* Between major sections */
gap: var(--space-2xl);  /* Between components */
gap: var(--space-xl);   /* Between related elements */
gap: var(--space-lg);   /* Within components */
```

## 🏗️ Usage Examples

### Hero Headline
```css
.hero-headline {
  font-size: var(--font-size-display-large);
  font-weight: var(--font-weight-regular);
  line-height: var(--line-height-tight);
  color: var(--text-primary);
  margin-bottom: var(--space-xl);
}
```

### Section Headline
```css
.section-headline {
  font-size: var(--font-size-display-medium);
  font-weight: var(--font-weight-semibold);
  line-height: var(--line-height-tight);
  color: var(--text-primary);
  margin-bottom: var(--space-lg);
}
```

### Body Text
```css
p {
  font-size: var(--font-size-body-large);
  line-height: var(--line-height-relaxed);
  color: var(--text-secondary);
}
```

### CTA Button
```css
.cta-button {
  padding: var(--space-md) var(--space-xl);
  font-size: var(--font-size-body-medium);
  font-weight: var(--font-weight-semibold);
  background-color: var(--accent-primary);
  color: white;
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-md);
  transition: all var(--duration-medium2) var(--easing-standard);
}
```

---

**Pro Tip**: Use variables for ALL styling. Never use hard-coded values like `24px` or `#1A746B`. This ensures consistency and makes global changes easy.

**File Location**: `/src/styles/abstracts/_variables.css`

**Last Updated**: October 1, 2025

