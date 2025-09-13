// Pact Landing Page JavaScript

// Email signup functionality
function handleEmailSignup(inputId) {
  const emailInput = document.getElementById(inputId);
  const email = emailInput.value.trim();
  
  // Basic email validation
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  
  if (!email) {
    showNotification('Please enter your email address', 'error');
    return;
  }
  
  if (!emailRegex.test(email)) {
    showNotification('Please enter a valid email address', 'error');
    return;
  }
  
  // Simulate API call
  const button = emailInput.parentElement.querySelector('.primary-button');
  const originalText = button.textContent;
  
  button.textContent = 'Joining...';
  button.disabled = true;
  
  // Simulate network delay
  setTimeout(() => {
    // Store email (in real app, this would be sent to backend)
    localStorage.setItem('pactBetaEmail', email);
    
    showNotification('🎉 Welcome to the Pact beta! We\'ll be in touch soon.', 'success');
    
    // Reset form
    emailInput.value = '';
    button.textContent = originalText;
    button.disabled = false;
    
    // Track conversion (in real app, this would be analytics)
    console.log('Beta signup:', email);
  }, 1500);
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
  const animatedElements = document.querySelectorAll('.problem-card, .solution-card, .mission-content');
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
    banner.addEventListener('click', () => {
      banner.style.transform = 'scale(0.98)';
      setTimeout(() => {
        banner.style.transform = 'scale(1)';
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

// Parallax scrolling effect for hero section
function initParallaxEffect() {
  const heroPhone = document.querySelector('.hero-phone-mockup');
  if (!heroPhone) return;

  window.addEventListener('scroll', () => {
    const scrolled = window.pageYOffset;
    const rate = scrolled * -0.5;
    heroPhone.style.transform = `perspective(1000px) rotateY(-5deg) rotateX(5deg) translateY(${rate}px)`;
  });
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
  addScrollAnimationStyles();
  initScrollAnimations();
  initDemoAnimation();
  initSmoothScrolling();
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

  // Phone mockup entrance animation
  const phoneMockup = document.querySelector('.hero-phone-mockup');
  if (phoneMockup) {
    phoneMockup.style.opacity = '0';
    phoneMockup.style.transform = 'translateX(50px) rotateY(15deg)';
    
    setTimeout(() => {
      phoneMockup.style.transition = 'all 1.2s cubic-bezier(0.05, 0.7, 0.1, 1)';
      phoneMockup.style.opacity = '1';
      phoneMockup.style.transform = 'translateX(0) rotateY(-3deg)';
    }, 600);
  }

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

// Export functions for potential external use
window.PactLanding = {
  handleEmailSignup,
  showNotification
};
