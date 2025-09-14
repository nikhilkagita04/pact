// Pact Landing Page JavaScript

// Firebase Configuration
let db;

// Initialize Firebase (replace with your config)
function initFirebase() {
  // Firebase config will be added here
  const firebaseConfig = {
    // Add your Firebase config here
    apiKey: "YOUR_API_KEY",
    authDomain: "YOUR_PROJECT.firebaseapp.com",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_PROJECT.appspot.com",
    messagingSenderId: "YOUR_SENDER_ID",
    appId: "YOUR_APP_ID"
  };

  // Initialize Firebase only if config is provided
  if (typeof firebase !== 'undefined' && firebaseConfig.apiKey !== "YOUR_API_KEY") {
    firebase.initializeApp(firebaseConfig);
    db = firebase.firestore();
  }
}

// Submit email to Firebase Firestore
async function submitToFirebase(email, source) {
  if (!db) {
    // Fallback if Firebase not configured
    console.log('Firebase not configured, using localStorage fallback');
    return Promise.resolve();
  }

  try {
    await db.collection('waitlist').add({
      email: email,
      source: source,
      timestamp: firebase.firestore.FieldValue.serverTimestamp(),
      userAgent: navigator.userAgent,
      referrer: document.referrer,
      utm: {
        source: new URLSearchParams(window.location.search).get('utm_source'),
        medium: new URLSearchParams(window.location.search).get('utm_medium'),
        campaign: new URLSearchParams(window.location.search).get('utm_campaign')
      }
    });
    
    console.log('Email successfully added to waitlist');
  } catch (error) {
    console.error('Error adding email to waitlist:', error);
    throw error;
  }
}

// Email signup functionality
function handleEmailSignup(inputId) {
  const emailInput = document.getElementById(inputId);
  const email = emailInput.value.trim();
  
  // Enhanced email validation
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/;
  
  if (!email) {
    showNotification('Please enter your email address', 'error');
    emailInput.focus();
    return;
  }
  
  if (!emailRegex.test(email)) {
    showNotification('Please enter a valid email address (e.g., you@example.com)', 'error');
    emailInput.focus();
    emailInput.select();
    return;
  }
  
  // Check for common typos in email domains
  if (hasCommonEmailTypos(email)) {
    showNotification('Please check your email address for typos', 'error');
    emailInput.focus();
    emailInput.select();
    return;
  }
  
  // Submit to Firebase Firestore
  const button = emailInput.parentElement.querySelector('.primary-button');
  const originalText = button.innerHTML;
  
  button.innerHTML = '<span class="button-text">Joining...</span>';
  button.disabled = true;
  button.setAttribute('aria-busy', 'true');
  
  // Submit to Firebase
  submitToFirebase(email, inputId)
    .then(() => {
      // Store email locally for return visitor detection
      localStorage.setItem('pactBetaEmail', email);
      
      // Track with Google Analytics if available
      if (typeof gtag !== 'undefined') {
        gtag('event', 'signup', {
          event_category: 'engagement',
          event_label: inputId,
          value: 1
        });
      }
      
      showNotification('🎉 Welcome to Pact Insiders! You\'re in line for lifetime premium access.', 'success');
      
      // Reset form
      emailInput.value = '';
      button.innerHTML = originalText;
      button.disabled = false;
      button.removeAttribute('aria-busy');
    })
    .catch(error => {
      console.error('Signup error:', error);
      // Fallback to localStorage
      localStorage.setItem('pactBetaEmail', email);
      showNotification('Thanks for joining! We\'ve saved your email and will be in touch soon.', 'success');
      
      // Reset form
      emailInput.value = '';
      button.innerHTML = originalText;
      button.disabled = false;
      button.removeAttribute('aria-busy');
    });
}

// Notification system
function showNotification(message, type = 'info') {
  // Remove existing notifications
  const existingNotifications = document.querySelectorAll('.notification-toast');
  existingNotifications.forEach(notification => notification.remove());
  
  // Create notification element
  const notification = document.createElement('div');
  notification.className = `notification-toast notification-${type}`;
  notification.textContent = message;
  
  // Add styles
  Object.assign(notification.style, {
    position: 'fixed',
    top: '20px',
    right: '20px',
    padding: '16px 24px',
    borderRadius: '12px',
    color: 'white',
    fontWeight: '600',
    fontSize: '14px',
    zIndex: '10000',
    maxWidth: '400px',
    boxShadow: '0 10px 25px rgba(0, 0, 0, 0.3)',
    transform: 'translateX(100%)',
    transition: 'transform 0.3s cubic-bezier(0.05, 0.7, 0.1, 1)',
    fontFamily: 'var(--font-family)'
  });
  
  // Set background color based on type
  const colors = {
    success: 'linear-gradient(135deg, #22c55e, #16a34a)',
    error: 'linear-gradient(135deg, #ef4444, #dc2626)',
    info: 'linear-gradient(135deg, #3b82f6, #2563eb)'
  };
  
  notification.style.background = colors[type] || colors.info;
  
  // Add to DOM
  document.body.appendChild(notification);
  
  // Animate in
  requestAnimationFrame(() => {
    notification.style.transform = 'translateX(0)';
  });
  
  // Auto remove after 5 seconds
  setTimeout(() => {
    notification.style.transform = 'translateX(100%)';
    setTimeout(() => {
      if (notification.parentNode) {
        notification.parentNode.removeChild(notification);
      }
    }, 300);
  }, 5000);
}

// Intersection Observer for scroll animations
function initScrollAnimations() {
  const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
  };
  
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('animate-in');
      }
    });
  }, observerOptions);
  
  // Observe elements for animation
  const animatedElements = document.querySelectorAll('.problem-card, .feature-step, .mission-content, .founder-card, .faq-item');
  animatedElements.forEach(el => {
    observer.observe(el);
  });
}

// Enhanced demo animation
function initDemoAnimation() {
  const proposeScreen = document.querySelector('.propose-screen');
  const notificationScreen = document.querySelector('.notification-screen');
  const proposeButton = document.querySelector('.propose-button');
  const acceptButton = document.querySelector('.accept-button');
  
  if (!proposeScreen || !notificationScreen) return;
  
  // Add click handlers for interactive demo
  if (proposeButton) {
    proposeButton.addEventListener('click', () => {
      // Add ripple effect
      createRippleEffect(proposeButton);
      
      // Trigger transition after short delay
      setTimeout(() => {
        proposeScreen.style.opacity = '0';
        proposeScreen.style.transform = 'scale(0.95)';
        
        setTimeout(() => {
          notificationScreen.style.opacity = '1';
          notificationScreen.style.transform = 'scale(1)';
        }, 300);
      }, 200);
    });
  }
  
  if (acceptButton) {
    acceptButton.addEventListener('click', () => {
      createRippleEffect(acceptButton);
      
      // Show success state
      setTimeout(() => {
        acceptButton.textContent = '✓ Accepted';
        acceptButton.style.background = '#22c55e';
        
        // Reset after delay
        setTimeout(() => {
          resetDemoAnimation();
        }, 2000);
      }, 200);
    });
  }
  
  // Initialize solution mockup interactions
  initSolutionMockupInteractions();
}

// Solution mockup interactions
function initSolutionMockupInteractions() {
  // Propose Pact Button interaction
  const proposePactButtons = document.querySelectorAll('.propose-pact-button');
  proposePactButtons.forEach(button => {
    button.addEventListener('click', () => {
      createRippleEffect(button);
      
      // Animate button state
      const originalText = button.innerHTML;
      button.innerHTML = '<span class="material-icons-round">check</span>Pact Proposed!';
      button.style.background = '#22c55e';
      
      // Reset after delay
      setTimeout(() => {
        button.innerHTML = originalText;
        button.style.background = '';
      }, 2000);
    });
  });
  
  // Pact items hover effects
  const pactItems = document.querySelectorAll('.pact-item');
  pactItems.forEach(item => {
    item.addEventListener('mouseenter', () => {
      item.style.transform = 'translateX(4px)';
    });
    
    item.addEventListener('mouseleave', () => {
      item.style.transform = 'translateX(0)';
    });
  });
  
  // Notification banner interaction
  const notificationBanners = document.querySelectorAll('.notification-banner');
  notificationBanners.forEach(banner => {
    banner.addEventListener('mouseenter', () => {
      banner.style.transform = 'scale(1.01)';
    });
    
    banner.addEventListener('mouseleave', () => {
      banner.style.transform = 'scale(1)';
    });
    
    banner.addEventListener('click', () => {
      banner.style.transform = 'scale(0.98)';
      setTimeout(() => {
        banner.style.transform = 'scale(1)';
      }, 150);
    });
  });
  
  // Dynamic Island interactions
  const dynamicIslands = document.querySelectorAll('.dynamic-island');
  dynamicIslands.forEach(island => {
    island.addEventListener('mouseenter', () => {
      island.style.transform = 'translateX(-50%) scale(1.02)';
    });
    
    island.addEventListener('mouseleave', () => {
      island.style.transform = 'translateX(-50%) scale(1)';
    });
    
    island.addEventListener('click', () => {
      island.style.transform = 'translateX(-50%) scale(0.98)';
      setTimeout(() => {
        island.style.transform = 'translateX(-50%) scale(1)';
      }, 150);
    });
  });
  
  // Celebration screen interaction
  const celebrationScreens = document.querySelectorAll('.celebration-screen');
  celebrationScreens.forEach(screen => {
    screen.addEventListener('click', () => {
      // Trigger extra celebration animation
      const decorations = screen.querySelectorAll('.decoration-item');
      decorations.forEach((decoration, index) => {
        setTimeout(() => {
          decoration.style.transform = 'scale(1.5) translateY(-20px)';
          setTimeout(() => {
            decoration.style.transform = '';
          }, 500);
        }, index * 100);
      });
    });
  });
}

// Create ripple effect for buttons
function createRippleEffect(button) {
  const ripple = document.createElement('span');
  const rect = button.getBoundingClientRect();
  const size = Math.max(rect.width, rect.height);
  
  ripple.style.width = ripple.style.height = size + 'px';
  ripple.style.left = '50%';
  ripple.style.top = '50%';
  ripple.style.transform = 'translate(-50%, -50%) scale(0)';
  ripple.style.borderRadius = '50%';
  ripple.style.background = 'rgba(255, 255, 255, 0.3)';
  ripple.style.position = 'absolute';
  ripple.style.pointerEvents = 'none';
  ripple.style.animation = 'ripple 0.6s ease-out';
  
  button.style.position = 'relative';
  button.style.overflow = 'hidden';
  button.appendChild(ripple);
  
  setTimeout(() => {
    ripple.remove();
  }, 600);
}

// Reset demo animation
function resetDemoAnimation() {
  const proposeScreen = document.querySelector('.propose-screen');
  const notificationScreen = document.querySelector('.notification-screen');
  const acceptButton = document.querySelector('.accept-button');
  
  if (proposeScreen && notificationScreen && acceptButton) {
    notificationScreen.style.opacity = '0';
    notificationScreen.style.transform = 'scale(0.9)';
    
    setTimeout(() => {
      proposeScreen.style.opacity = '1';
      proposeScreen.style.transform = 'scale(1)';
      acceptButton.textContent = 'Accept';
      acceptButton.style.background = '#4ade80';
    }, 300);
  }
}

// Smooth scrolling for anchor links
function initSmoothScrolling() {
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      e.preventDefault();
      const target = document.querySelector(this.getAttribute('href'));
      if (target) {
        target.scrollIntoView({
          behavior: 'smooth',
          block: 'start'
        });
      }
    });
  });
}

// Performance optimization: Lazy load images
function initLazyLoading() {
  if ('IntersectionObserver' in window) {
    const imageObserver = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const img = entry.target;
          img.src = img.dataset.src;
          img.classList.remove('lazy');
          imageObserver.unobserve(img);
        }
      });
    });
    
    document.querySelectorAll('img[data-src]').forEach(img => {
      imageObserver.observe(img);
    });
  }
}

// Add CSS for scroll animations
function addScrollAnimationStyles() {
  const style = document.createElement('style');
  style.textContent = `
    @keyframes ripple {
      to {
        transform: translate(-50%, -50%) scale(2);
        opacity: 0;
      }
    }
    
    .problem-card,
    .solution-card,
    .mission-content {
      opacity: 0;
      transform: translateY(30px);
      transition: all 0.6s cubic-bezier(0.05, 0.7, 0.1, 1);
    }
    
    .problem-card.animate-in,
    .solution-card.animate-in,
    .mission-content.animate-in {
      opacity: 1;
      transform: translateY(0);
    }
    
    .lazy {
      opacity: 0;
      transition: opacity 0.3s;
    }
    
    .lazy.loaded {
      opacity: 1;
    }
  `;
  document.head.appendChild(style);
}

// Handle form submission with Enter key
function initKeyboardHandlers() {
  document.querySelectorAll('.email-input').forEach(input => {
    input.addEventListener('keypress', (e) => {
      if (e.key === 'Enter') {
        const button = input.parentElement.querySelector('.primary-button');
        if (button) {
          button.click();
        }
      }
    });
  });
}

// Enhanced Micro-interactions
function initMicroInteractions() {
  // Phone mockup hover effects
  const phoneMockups = document.querySelectorAll('.phone-mockup');
  phoneMockups.forEach(mockup => {
    const phoneFrame = mockup.querySelector('.phone-frame');
    
    mockup.addEventListener('mouseenter', () => {
      if (phoneFrame) {
        phoneFrame.style.transform = 'rotateX(0deg) rotateY(0deg) scale(1.02)';
      }
    });
    
    mockup.addEventListener('mouseleave', () => {
      if (phoneFrame) {
        phoneFrame.style.transform = 'rotateX(2deg) rotateY(-1deg) scale(1)';
      }
    });
  });

  // Pact card hover effects
  const pactCards = document.querySelectorAll('.pact-card');
  pactCards.forEach(card => {
    card.addEventListener('mouseenter', () => {
      card.style.transform = 'translateY(-4px) scale(1.02)';
      card.style.boxShadow = '0 12px 32px rgba(74, 222, 128, 0.2)';
    });
    
    card.addEventListener('mouseleave', () => {
      card.style.transform = 'translateY(0) scale(1)';
      card.style.boxShadow = '';
    });

    // Add click animation
    card.addEventListener('click', (e) => {
      createRippleEffect(card, e);
    });
  });

  // Hero badge animation
  const heroBadge = document.querySelector('.hero-badge');
  if (heroBadge) {
    heroBadge.addEventListener('mouseenter', () => {
      heroBadge.style.transform = 'scale(1.05)';
      heroBadge.style.boxShadow = '0 8px 24px rgba(74, 222, 128, 0.3)';
    });
    
    heroBadge.addEventListener('mouseleave', () => {
      heroBadge.style.transform = 'scale(1)';
      heroBadge.style.boxShadow = '';
    });
  }

  // Feature items animation
  const featureItems = document.querySelectorAll('.feature-item');
  featureItems.forEach((item, index) => {
    item.addEventListener('mouseenter', () => {
      item.style.transform = 'translateX(8px)';
      item.style.color = 'var(--accent-primary)';
    });
    
    item.addEventListener('mouseleave', () => {
      item.style.transform = 'translateX(0)';
      item.style.color = '';
    });
  });

  // Stat cards animation
  const statCards = document.querySelectorAll('.stat-card');
  statCards.forEach(card => {
    card.addEventListener('mouseenter', () => {
      card.style.transform = 'translateY(-4px) scale(1.02)';
      card.style.boxShadow = '0 12px 32px rgba(74, 222, 128, 0.2)';
    });
    
    card.addEventListener('mouseleave', () => {
      card.style.transform = 'translateY(0) scale(1)';
      card.style.boxShadow = '';
    });
  });

  // Action button ripple effects
  const actionButtons = document.querySelectorAll('.action-btn, .propose-btn, .draft-btn');
  actionButtons.forEach(button => {
    button.addEventListener('click', (e) => {
      createRippleEffect(button, e);
    });
  });

  // Priority selector interactions
  const priorityOptions = document.querySelectorAll('.priority-option');
  priorityOptions.forEach(option => {
    option.addEventListener('click', () => {
      priorityOptions.forEach(opt => opt.classList.remove('active'));
      option.classList.add('active');
      
      // Add haptic feedback simulation
      if (navigator.vibrate) {
        navigator.vibrate(50);
      }
    });
  });

  // Suggestion chip interactions
  const suggestionChips = document.querySelectorAll('.suggestion-chip');
  suggestionChips.forEach(chip => {
    chip.addEventListener('click', () => {
      chip.style.transform = 'scale(0.95)';
      chip.style.background = 'var(--accent-primary)';
      chip.style.color = 'var(--background-primary)';
      
      setTimeout(() => {
        chip.style.transform = 'scale(1)';
      }, 150);
    });
  });

  // Notification card interactions
  const notificationCards = document.querySelectorAll('.notification-card');
  notificationCards.forEach(card => {
    card.addEventListener('click', () => {
      card.style.transform = 'scale(0.98)';
      setTimeout(() => {
        card.style.transform = 'scale(1)';
      }, 150);
    });
  });

  // Celebration screen interactions
  const celebrationElements = document.querySelectorAll('.celebration-pact-card, .action-btn');
  celebrationElements.forEach(element => {
    element.addEventListener('click', () => {
      element.style.transform = 'scale(0.95)';
      setTimeout(() => {
        element.style.transform = 'scale(1)';
      }, 150);
    });
  });

  // Floating action button interactions
  const fabButtons = document.querySelectorAll('.fab');
  fabButtons.forEach(fab => {
    fab.addEventListener('click', () => {
      fab.style.transform = 'scale(0.9)';
      setTimeout(() => {
        fab.style.transform = 'scale(1.1)';
        setTimeout(() => {
          fab.style.transform = 'scale(1)';
        }, 150);
      }, 100);
    });
  });
}

// Enhanced ripple effect with better positioning
function createRippleEffect(button, event) {
  const ripple = document.createElement('span');
  const rect = button.getBoundingClientRect();
  const size = Math.max(rect.width, rect.height);
  const x = event.clientX - rect.left - size / 2;
  const y = event.clientY - rect.top - size / 2;
  
  ripple.style.width = ripple.style.height = size + 'px';
  ripple.style.left = x + 'px';
  ripple.style.top = y + 'px';
  ripple.style.position = 'absolute';
  ripple.style.borderRadius = '50%';
  ripple.style.background = 'rgba(255, 255, 255, 0.3)';
  ripple.style.pointerEvents = 'none';
  ripple.style.animation = 'ripple 0.6s ease-out';
  ripple.style.zIndex = '1000';
  
  button.style.position = 'relative';
  button.style.overflow = 'hidden';
  button.appendChild(ripple);
  
  setTimeout(() => {
    ripple.remove();
  }, 600);
}

// Parallax effect removed - keep phone straight
function initParallaxEffect() {
  // No parallax effect to keep phone straight and focused
  return;
}

// Staggered animation for pact cards
function initStaggeredAnimations() {
  const pactCards = document.querySelectorAll('.pact-card');
  pactCards.forEach((card, index) => {
    card.style.opacity = '0';
    card.style.transform = 'translateY(20px)';
    
    setTimeout(() => {
      card.style.transition = 'all 0.6s cubic-bezier(0.05, 0.7, 0.1, 1)';
      card.style.opacity = '1';
      card.style.transform = 'translateY(0)';
    }, index * 100);
  });
}

// Enhanced notification animations
function initNotificationAnimations() {
  const notificationCards = document.querySelectorAll('.notification-card');
  notificationCards.forEach((card, index) => {
    card.style.opacity = '0';
    card.style.transform = 'translateX(100px)';
    
    setTimeout(() => {
      card.style.transition = 'all 0.5s cubic-bezier(0.05, 0.7, 0.1, 1)';
      card.style.opacity = '1';
      card.style.transform = 'translateX(0)';
    }, index * 200);
  });
}

// Celebration screen entrance animation
function initCelebrationAnimations() {
  const celebrationElements = document.querySelectorAll('.success-icon, .celebration-title, .celebration-pact-card, .celebration-stats');
  celebrationElements.forEach((element, index) => {
    element.style.opacity = '0';
    element.style.transform = 'translateY(30px)';
    
    setTimeout(() => {
      element.style.transition = 'all 0.8s cubic-bezier(0.05, 0.7, 0.1, 1)';
      element.style.opacity = '1';
      element.style.transform = 'translateY(0)';
    }, index * 150);
  });
}

// Initialize everything when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
  // Initialize Firebase first
  initFirebase();
  
  addScrollAnimationStyles();
  initScrollAnimations();
  initSmoothScrolling();
  initFaqAccordion();
  initLazyLoading();
  initKeyboardHandlers();
  initMicroInteractions();
  initParallaxEffect();
  initStaggeredAnimations();
  initNotificationAnimations();
  initCelebrationAnimations();
  initAdvancedAnimations();
  
  // Add some visual feedback for loaded state
  document.body.classList.add('loaded');
  
  // Check if user has already signed up
  const existingEmail = localStorage.getItem('pactBetaEmail');
  if (existingEmail) {
    console.log('Returning beta user:', existingEmail);
  }
});

// Advanced animations and interactions
function initAdvancedAnimations() {
  // Hero section entrance animation
  const heroElements = document.querySelectorAll('.hero-badge, .hero-headline, .hero-subheadline, .hero-features, .cta-form');
  heroElements.forEach((element, index) => {
    element.style.opacity = '0';
    element.style.transform = 'translateY(30px)';
    
    setTimeout(() => {
      element.style.transition = 'all 0.8s cubic-bezier(0.05, 0.7, 0.1, 1)';
      element.style.opacity = '1';
      element.style.transform = 'translateY(0)';
    }, index * 200);
  });

  // Problem cards staggered animation
  const problemCards = document.querySelectorAll('.problem-card');
  problemCards.forEach((card, index) => {
    card.style.opacity = '0';
    card.style.transform = 'translateY(40px)';
    
    setTimeout(() => {
      card.style.transition = 'all 0.8s cubic-bezier(0.05, 0.7, 0.1, 1)';
      card.style.opacity = '1';
      card.style.transform = 'translateY(0)';
    }, 1000 + (index * 200));
  });

  // Solution cards animation
  const solutionCards = document.querySelectorAll('.solution-card');
  solutionCards.forEach((card, index) => {
    card.style.opacity = '0';
    card.style.transform = 'translateY(40px)';
    
    setTimeout(() => {
      card.style.transition = 'all 0.8s cubic-bezier(0.05, 0.7, 0.1, 1)';
      card.style.opacity = '1';
      card.style.transform = 'translateY(0)';
    }, 2000 + (index * 300));
  });

  // Mission stats counter animation
  const statNumbers = document.querySelectorAll('.stat-card .stat-number');
  statNumbers.forEach(stat => {
    const finalNumber = stat.textContent;
    const isPercentage = finalNumber.includes('%');
    const isComma = finalNumber.includes(',');
    const numericValue = parseInt(finalNumber.replace(/[^\d]/g, ''));
    
    if (numericValue) {
      stat.textContent = '0' + (isPercentage ? '%' : '') + (isComma ? ',' : '');
      
      setTimeout(() => {
        animateCounter(stat, 0, numericValue, 2000, isPercentage, isComma);
      }, 3000);
    }
  });
}

// Counter animation function
function animateCounter(element, start, end, duration, isPercentage, isComma) {
  const startTime = performance.now();
  
  function updateCounter(currentTime) {
    const elapsed = currentTime - startTime;
    const progress = Math.min(elapsed / duration, 1);
    
    const current = Math.floor(start + (end - start) * progress);
    const displayValue = current.toLocaleString() + (isPercentage ? '%' : '');
    
    element.textContent = displayValue;
    
    if (progress < 1) {
      requestAnimationFrame(updateCounter);
    }
  }
  
  requestAnimationFrame(updateCounter);
}

// Handle page visibility changes for performance
document.addEventListener('visibilitychange', () => {
  if (document.hidden) {
    // Pause animations when page is not visible
    document.body.classList.add('paused');
  } else {
    // Resume animations when page becomes visible
    document.body.classList.remove('paused');
  }
});

// Helper function to check for common email typos
function hasCommonEmailTypos(email) {
  const commonTypos = {
    'gmial.com': 'gmail.com',
    'gmai.com': 'gmail.com',
    'yahooo.com': 'yahoo.com',
    'hotmial.com': 'hotmail.com',
    'outlok.com': 'outlook.com'
  };
  
  const domain = email.split('@')[1];
  return Object.keys(commonTypos).includes(domain);
}

// Enhanced notification with better accessibility
function showAccessibleNotification(message, type = 'info') {
  showNotification(message, type);
  
  // Announce to screen readers
  const announcement = document.createElement('div');
  announcement.setAttribute('aria-live', 'polite');
  announcement.setAttribute('aria-atomic', 'true');
  announcement.className = 'sr-only';
  announcement.textContent = message;
  document.body.appendChild(announcement);
  
  setTimeout(() => {
    document.body.removeChild(announcement);
  }, 1000);
}

// Sharing functionality
async function handleNativeShare() {
  const shareData = {
    title: 'Pact - Be the person everyone can count on',
    text: 'Check out Pact - a simple app for tracking commitments and requests between you and the people in your life. Join the waitlist!',
    url: window.location.href
  };

  try {
    if (navigator.share && navigator.canShare && navigator.canShare(shareData)) {
      await navigator.share(shareData);
      showNotification('Thanks for sharing Pact! 🎉', 'success');
    } else {
      // Fallback to copy to clipboard
      await copyToClipboard();
    }
  } catch (error) {
    if (error.name !== 'AbortError') {
      console.error('Error sharing:', error);
      await copyToClipboard();
    }
  }
}

function shareToTwitter() {
  const text = encodeURIComponent('Check out Pact - be the person everyone can count on! A simple app for tracking commitments between you and the people in your life. Join the waitlist:');
  const url = encodeURIComponent(window.location.href);
  const twitterUrl = `https://twitter.com/intent/tweet?text=${text}&url=${url}`;
  
  window.open(twitterUrl, '_blank', 'width=550,height=420');
  showNotification('Opening Twitter to share...', 'info');
}

async function copyToClipboard() {
  const shareText = `Check out Pact - be the person everyone can count on! A simple app for tracking commitments between you and the people in your life. Join the waitlist: ${window.location.href}`;
  
  try {
    if (navigator.clipboard && navigator.clipboard.writeText) {
      await navigator.clipboard.writeText(shareText);
      showNotification('Link copied to clipboard! 📋', 'success');
    } else {
      // Fallback for older browsers
      const textArea = document.createElement('textarea');
      textArea.value = shareText;
      textArea.style.position = 'fixed';
      textArea.style.left = '-999999px';
      textArea.style.top = '-999999px';
      document.body.appendChild(textArea);
      textArea.focus();
      textArea.select();
      
      try {
        document.execCommand('copy');
        showNotification('Link copied to clipboard! 📋', 'success');
      } catch (err) {
        showNotification('Unable to copy link. Please copy manually.', 'error');
      }
      
      document.body.removeChild(textArea);
    }
  } catch (error) {
    console.error('Failed to copy to clipboard:', error);
    showNotification('Unable to copy link. Please copy manually.', 'error');
  }
}

function shareViaEmail() {
  const subject = encodeURIComponent('Check out Pact - Be the person everyone can count on');
  const body = encodeURIComponent(`Hi there!

I wanted to share something interesting with you - it's called Pact, and it's a simple app for tracking commitments and requests between you and the people in your life.

Whether you're coordinating with roommates, family members, or friends, Pact helps turn good intentions into meaningful connections by making it easy to follow through on the small commitments that matter.

They're currently building it and looking for diverse perspectives from couples, roommates, families, and friend groups. If this sounds useful to you, you can join the waitlist here:

${window.location.href}

Hope you find it as interesting as I did!

Best regards`);
  
  const emailUrl = `mailto:?subject=${subject}&body=${body}`;
  window.location.href = emailUrl;
  showNotification('Opening your email app...', 'info');
}

// Export functions for potential external use
window.PactLanding = {
  handleEmailSignup,
  showNotification,
  showAccessibleNotification,
  handleNativeShare,
  shareToTwitter,
  copyToClipboard,
  shareViaEmail
};

function initFaqAccordion() {
  const faqItems = document.querySelectorAll('.faq-item');

  faqItems.forEach(item => {
    const question = item.querySelector('.faq-question');
    const answer = item.querySelector('.faq-answer');

    question.addEventListener('click', () => {
      const isExpanded = question.getAttribute('aria-expanded') === 'true';

      // Close all other items before opening the new one
      faqItems.forEach(otherItem => {
        if (otherItem !== item) {
          const otherQuestion = otherItem.querySelector('.faq-question');
          const otherAnswer = otherItem.querySelector('.faq-answer');
          otherQuestion.setAttribute('aria-expanded', 'false');
          otherAnswer.style.maxHeight = null;
        }
      });

      // Toggle the current item
      if (isExpanded) {
        question.setAttribute('aria-expanded', 'false');
        answer.style.maxHeight = null;
      } else {
        question.setAttribute('aria-expanded', 'true');
        // Set max-height to the scrollHeight to animate opening
        answer.style.maxHeight = answer.scrollHeight + 'px';
      }
    });
  });
}
