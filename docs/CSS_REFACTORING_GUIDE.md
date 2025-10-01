# CSS Refactoring Guide

## Overview

The landing page CSS has been completely refactored from a single 11,000+ line file into a modular, maintainable structure. This document explains the new architecture and how to work with it.

## New File Structure

```
src/
└── styles/
    ├── main.css                    # Main import file (reference this in HTML)
    ├── abstracts/
    │   └── _variables.css          # Design tokens (colors, spacing, typography)
    ├── base/
    │   ├── _reset.css              # CSS reset & normalization
    │   ├── _base.css               # HTML & body base styles
    │   └── _typography.css         # Typography hierarchy (h1-h6, p, links)
    ├── layout/
    │   ├── _container.css          # Container & grid layouts
    │   └── _sections.css           # Section layouts (hero, features, footer)
    └── components/
        ├── _buttons.css            # Button styles
        ├── _forms.css              # Form inputs & validation
        ├── _cards.css              # Card components
        ├── _hero.css               # Hero-specific components
        ├── _features.css           # Feature showcase components
        └── _faq.css                # FAQ accordion component
```

## Design System

### Colors
All colors are defined as CSS custom properties in `abstracts/_variables.css`:

- **Background**: `--background-primary`, `--background-secondary`, `--background-tertiary`
- **Text**: `--text-primary`, `--text-secondary`, `--text-tertiary`
- **Accents**: `--accent-primary`, `--accent-secondary`, `--accent-warm`

### Typography Scale
Responsive font sizes using `clamp()`:

- **Display**: `--font-size-display-large` (44-68px), `--font-size-display-medium` (32-48px)
- **Headlines**: `--font-size-headline-large` (28-40px), `--font-size-headline-medium` (24-32px), `--font-size-headline-small` (20-24px)
- **Body**: `--font-size-body-large` (18px), `--font-size-body-medium` (16px)

### Spacing Scale
Consistent spacing from 8px to 96px:

- `--space-xs`: 8px
- `--space-sm`: 12px
- `--space-md`: 16px
- `--space-lg`: 24px
- `--space-xl`: 32px
- `--space-2xl`: 48px
- `--space-3xl`: 64px
- `--space-4xl`: 80px
- `--space-5xl`: 96px

### Border Radius
- `--radius-xs` to `--radius-2xl`: 6px to 40px
- `--radius-pill`: Fully rounded (9999px)

## Key Improvements

### 1. **Consistency**
- All components now use the same design tokens
- No more conflicting or duplicate styles
- Predictable spacing and sizing throughout

### 2. **Maintainability**
- Easy to find and modify specific components
- Single source of truth for each style
- Clear separation of concerns

### 3. **Scalability**
- Adding new components is straightforward
- Just create a new file in `components/` and import it in `main.css`

### 4. **Performance**
- Browser can cache individual modules
- Easier to identify unused CSS

## Component Styling Guide

### Typography Hierarchy

**Hero Headline (h1)**
```css
.hero-headline {
  font-size: var(--font-size-display-large);
  font-weight: var(--font-weight-regular);
  line-height: var(--line-height-tight);
}
```

**Section Headlines (h2)**
```css
.section-headline {
  font-size: var(--font-size-display-medium);
  font-weight: var(--font-weight-semibold);
}
```

**Feature Titles (h3)**
```css
.feature-title {
  font-size: var(--font-size-headline-small);
  font-weight: var(--font-weight-semibold);
}
```

### Spacing Patterns

**Sections**
```css
padding: var(--space-5xl) 0;  /* 96px top/bottom */
```

**Section Headers**
```css
margin-bottom: var(--space-3xl);  /* 64px */
```

**Component Gaps**
```css
gap: var(--space-2xl);  /* 48px */
```

### Button Styles

All CTAs use consistent styling:
```css
.cta-button {
  padding: var(--space-md) var(--space-xl);
  background-color: var(--accent-primary);
  border-radius: var(--radius-lg);
  font-weight: var(--font-weight-semibold);
}
```

### Card Styles

All cards share the same foundation:
```css
.problem-card {
  padding: var(--space-2xl);
  background-color: white;
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-md);
}
```

## Responsive Design

All components include mobile-first responsive styles:

- **Desktop**: Default styles (1200px container)
- **Tablet**: `@media (max-width: 1024px)`
- **Mobile**: `@media (max-width: 768px)`
- **Small Mobile**: `@media (max-width: 480px)`

## How to Make Changes

### Updating Colors
1. Open `src/styles/abstracts/_variables.css`
2. Modify the color values
3. Changes apply globally

### Modifying Component Styles
1. Identify the component (button, card, form, etc.)
2. Open the corresponding file in `src/styles/components/`
3. Make your changes
4. Changes apply to all instances of that component

### Adding New Components
1. Create a new file: `src/styles/components/_newcomponent.css`
2. Write your styles
3. Import it in `src/styles/main.css`: `@import 'components/_newcomponent.css';`

### Adjusting Spacing
Use the spacing variables instead of hard-coded values:
```css
/* ❌ Don't do this */
margin-bottom: 32px;

/* ✅ Do this */
margin-bottom: var(--space-xl);
```

## Migration Notes

- Original CSS backed up as `src/styles.css.backup`
- `index.html` now references `src/styles/main.css`
- All styles have been consolidated and deduplicated
- Responsive breakpoints unified across all components

## Testing Checklist

- [ ] Hero section displays correctly
- [ ] CTA buttons work and hover states are correct
- [ ] Email input forms are properly styled
- [ ] Feature cards display in grid
- [ ] FAQ accordion opens/closes smoothly
- [ ] Footer links are visible and clickable
- [ ] Mobile view (< 768px) displays correctly
- [ ] All animations and transitions work

## Future Enhancements

Consider adding:
- Dark mode support (variables are already structured for this)
- Print stylesheet
- High contrast mode
- Animation preferences respect

---

**Last Updated**: October 1, 2025  
**Maintained By**: Pact Development Team

