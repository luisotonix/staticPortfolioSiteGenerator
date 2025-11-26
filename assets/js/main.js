/**
 * Portfolio System Admin - Main JavaScript
 * Handles theme switching, language selection, navigation, and other interactive features
 */

// ============================================================================
// Theme Management
// ============================================================================

class ThemeManager {
    constructor() {
        this.currentTheme = this.getStoredTheme() || 'auto';
        this.themeToggle = document.getElementById('themeToggle');

        this.init();
    }

    init() {
        this.applyTheme(this.currentTheme);

        if (this.themeToggle) {
            this.themeToggle.addEventListener('click', () => this.toggleTheme());
        }
    }

    getStoredTheme() {
        return localStorage.getItem('theme');
    }

    storeTheme(theme) {
        localStorage.setItem('theme', theme);
    }

    applyTheme(theme) {
        document.documentElement.setAttribute('data-theme', theme);
        this.currentTheme = theme;
        this.storeTheme(theme);
    }

    toggleTheme() {
        const themes = ['light', 'dark', 'auto'];
        const currentIndex = themes.indexOf(this.currentTheme);
        const nextIndex = (currentIndex + 1) % themes.length;
        this.applyTheme(themes[nextIndex]);
    }

    getEffectiveTheme() {
        if (this.currentTheme === 'auto') {
            return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
        }
        return this.currentTheme;
    }
}

// ============================================================================
// Language Management
// ============================================================================

class LanguageManager {
    constructor() {
        this.languageSelector = document.getElementById('languageSelector');
        this.init();
    }

    init() {
        if (this.languageSelector) {
            this.languageSelector.addEventListener('change', (e) => {
                this.switchLanguage(e.target.value);
            });
        }
    }

    switchLanguage(lang) {
        // Store the selected language
        localStorage.setItem('language', lang);

        // In a static site, we would redirect to the language-specific page
        // For now, we'll just reload the page (in a real implementation,
        // you would redirect to the appropriate language version)
        console.log(`Switching to language: ${lang}`);

        // Example: window.location.href = `/${lang}/index.html`;
    }

    getStoredLanguage() {
        return localStorage.getItem('language');
    }

    getBrowserLanguage() {
        const lang = navigator.language || navigator.userLanguage;
        return lang.split('-')[0]; // Get 'pt' from 'pt-BR'
    }
}

// ============================================================================
// Mobile Navigation
// ============================================================================

class MobileNavigation {
    constructor() {
        this.menuToggle = document.getElementById('mobileMenuToggle');
        this.mainNav = document.getElementById('mainNav');
        this.init();
    }

    init() {
        if (this.menuToggle && this.mainNav) {
            this.menuToggle.addEventListener('click', () => this.toggleMenu());

            // Close menu when clicking outside
            document.addEventListener('click', (e) => {
                if (!this.menuToggle.contains(e.target) && !this.mainNav.contains(e.target)) {
                    this.closeMenu();
                }
            });

            // Close menu when clicking a link
            const navLinks = this.mainNav.querySelectorAll('a');
            navLinks.forEach(link => {
                link.addEventListener('click', () => this.closeMenu());
            });
        }
    }

    toggleMenu() {
        this.mainNav.classList.toggle('active');
        this.menuToggle.classList.toggle('active');
    }

    closeMenu() {
        this.mainNav.classList.remove('active');
        this.menuToggle.classList.remove('active');
    }
}

// ============================================================================
// Portfolio Filter
// ============================================================================

class PortfolioFilter {
    constructor() {
        this.filterButtons = document.querySelectorAll('#portfolioFilter .filter-btn');
        this.portfolioGrid = document.getElementById('portfolioGrid');
        this.init();
    }

    init() {
        if (this.filterButtons.length > 0 && this.portfolioGrid) {
            this.filterButtons.forEach(button => {
                button.addEventListener('click', (e) => {
                    this.filter(e.target.dataset.category);
                    this.setActiveButton(e.target);
                });
            });
        }
    }

    filter(category) {
        const items = this.portfolioGrid.querySelectorAll('.project-card');

        items.forEach(item => {
            if (category === 'all' || item.dataset.category === category) {
                item.style.display = 'block';
                setTimeout(() => {
                    item.style.opacity = '1';
                    item.style.transform = 'scale(1)';
                }, 10);
            } else {
                item.style.opacity = '0';
                item.style.transform = 'scale(0.9)';
                setTimeout(() => {
                    item.style.display = 'none';
                }, 300);
            }
        });
    }

    setActiveButton(activeButton) {
        this.filterButtons.forEach(button => {
            button.classList.remove('active');
        });
        activeButton.classList.add('active');
    }
}

// ============================================================================
// Blog Filter
// ============================================================================

class BlogFilter {
    constructor() {
        this.categoryButtons = document.querySelectorAll('#categoryFilter .filter-btn');
        this.tagButtons = document.querySelectorAll('#tagFilter .tag');
        this.blogGrid = document.getElementById('blogGrid');
        this.activeCategory = 'all';
        this.activeTags = new Set();
        this.init();
    }

    init() {
        if (this.blogGrid) {
            // Category filter
            this.categoryButtons.forEach(button => {
                button.addEventListener('click', (e) => {
                    this.activeCategory = e.target.dataset.category;
                    this.applyFilters();
                    this.setActiveButton(this.categoryButtons, e.target);
                });
            });

            // Tag filter
            this.tagButtons.forEach(button => {
                button.addEventListener('click', (e) => {
                    const tag = e.target.dataset.tag;
                    if (this.activeTags.has(tag)) {
                        this.activeTags.delete(tag);
                        e.target.classList.remove('active');
                    } else {
                        this.activeTags.add(tag);
                        e.target.classList.add('active');
                    }
                    this.applyFilters();
                });
            });
        }
    }

    applyFilters() {
        const items = this.blogGrid.querySelectorAll('.blog-card');

        items.forEach(item => {
            const categories = (item.dataset.categories || '').split(',');
            const tags = (item.dataset.tags || '').split(',');

            const categoryMatch = this.activeCategory === 'all' || categories.includes(this.activeCategory);
            const tagMatch = this.activeTags.size === 0 ||
                            Array.from(this.activeTags).some(tag => tags.includes(tag));

            if (categoryMatch && tagMatch) {
                item.style.display = 'block';
                setTimeout(() => {
                    item.style.opacity = '1';
                    item.style.transform = 'scale(1)';
                }, 10);
            } else {
                item.style.opacity = '0';
                item.style.transform = 'scale(0.9)';
                setTimeout(() => {
                    item.style.display = 'none';
                }, 300);
            }
        });
    }

    setActiveButton(buttons, activeButton) {
        buttons.forEach(button => {
            button.classList.remove('active');
        });
        activeButton.classList.add('active');
    }
}

// ============================================================================
// Smooth Scroll
// ============================================================================

class SmoothScroll {
    constructor() {
        this.init();
    }

    init() {
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', (e) => {
                const targetId = anchor.getAttribute('href');
                if (targetId === '#') return;

                const target = document.querySelector(targetId);
                if (target) {
                    e.preventDefault();
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
    }
}

// ============================================================================
// Form Validation & Submission
// ============================================================================

class FormHandler {
    constructor() {
        this.contactForm = document.getElementById('contactForm');
        this.init();
    }

    init() {
        if (this.contactForm) {
            this.contactForm.addEventListener('submit', (e) => {
                if (!this.validate()) {
                    e.preventDefault();
                    return false;
                }
                // Form will be submitted normally to formspree or your backend
            });
        }
    }

    validate() {
        const name = document.getElementById('name');
        const email = document.getElementById('email');
        const subject = document.getElementById('subject');
        const message = document.getElementById('message');

        let isValid = true;

        // Basic validation
        if (!name.value.trim()) {
            this.showError(name, 'Name is required');
            isValid = false;
        } else {
            this.clearError(name);
        }

        if (!email.value.trim() || !this.isValidEmail(email.value)) {
            this.showError(email, 'Valid email is required');
            isValid = false;
        } else {
            this.clearError(email);
        }

        if (!subject.value.trim()) {
            this.showError(subject, 'Subject is required');
            isValid = false;
        } else {
            this.clearError(subject);
        }

        if (!message.value.trim()) {
            this.showError(message, 'Message is required');
            isValid = false;
        } else {
            this.clearError(message);
        }

        return isValid;
    }

    isValidEmail(email) {
        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(email);
    }

    showError(input, message) {
        input.classList.add('error');
        let errorDiv = input.parentElement.querySelector('.error-message');
        if (!errorDiv) {
            errorDiv = document.createElement('div');
            errorDiv.className = 'error-message';
            input.parentElement.appendChild(errorDiv);
        }
        errorDiv.textContent = message;
    }

    clearError(input) {
        input.classList.remove('error');
        const errorDiv = input.parentElement.querySelector('.error-message');
        if (errorDiv) {
            errorDiv.remove();
        }
    }
}

// ============================================================================
// Lazy Loading Images
// ============================================================================

class LazyLoader {
    constructor() {
        this.images = document.querySelectorAll('img[data-src]');
        this.init();
    }

    init() {
        if ('IntersectionObserver' in window) {
            const imageObserver = new IntersectionObserver((entries, observer) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const img = entry.target;
                        img.src = img.dataset.src;
                        img.removeAttribute('data-src');
                        observer.unobserve(img);
                    }
                });
            });

            this.images.forEach(img => imageObserver.observe(img));
        } else {
            // Fallback for browsers that don't support IntersectionObserver
            this.images.forEach(img => {
                img.src = img.dataset.src;
                img.removeAttribute('data-src');
            });
        }
    }
}

// ============================================================================
// Scroll-to-Top Button
// ============================================================================

class ScrollToTop {
    constructor() {
        this.button = this.createButton();
        this.init();
    }

    createButton() {
        const button = document.createElement('button');
        button.innerHTML = '↑';
        button.className = 'scroll-to-top';
        button.setAttribute('aria-label', 'Scroll to top');
        button.style.cssText = `
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background-color: var(--color-primary);
            color: white;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
            z-index: 999;
            box-shadow: 0 4px 8px var(--color-shadow);
        `;
        document.body.appendChild(button);
        return button;
    }

    init() {
        window.addEventListener('scroll', () => {
            if (window.pageYOffset > 300) {
                this.button.style.opacity = '1';
                this.button.style.visibility = 'visible';
            } else {
                this.button.style.opacity = '0';
                this.button.style.visibility = 'hidden';
            }
        });

        this.button.addEventListener('click', () => {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    }
}

// ============================================================================
// Animation on Scroll
// ============================================================================

class ScrollAnimation {
    constructor() {
        this.elements = document.querySelectorAll('.animate-on-scroll');
        this.init();
    }

    init() {
        if ('IntersectionObserver' in window) {
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('animated');
                        observer.unobserve(entry.target);
                    }
                });
            }, {
                threshold: 0.1
            });

            this.elements.forEach(el => observer.observe(el));
        }
    }
}

// ============================================================================
// Initialize All Components
// ============================================================================

document.addEventListener('DOMContentLoaded', () => {
    // Initialize theme
    const themeManager = new ThemeManager();

    // Initialize language
    const languageManager = new LanguageManager();

    // Initialize mobile navigation
    const mobileNav = new MobileNavigation();

    // Initialize portfolio filter
    const portfolioFilter = new PortfolioFilter();

    // Initialize blog filter
    const blogFilter = new BlogFilter();

    // Initialize smooth scroll
    const smoothScroll = new SmoothScroll();

    // Initialize form handler
    const formHandler = new FormHandler();

    // Initialize lazy loading
    const lazyLoader = new LazyLoader();

    // Initialize scroll to top
    const scrollToTop = new ScrollToTop();

    // Initialize scroll animations
    const scrollAnimation = new ScrollAnimation();

    console.log('Portfolio site initialized successfully!');
});

// ============================================================================
// Utility Functions
// ============================================================================

// Debounce function for performance
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Format date
function formatDate(dateString, lang = 'pt') {
    const date = new Date(dateString);
    const options = { year: 'numeric', month: 'long', day: 'numeric' };
    return date.toLocaleDateString(lang, options);
}

// Truncate text
function truncateText(text, maxLength) {
    if (text.length <= maxLength) return text;
    return text.substr(0, maxLength) + '...';
}

// Export for use in other scripts
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        ThemeManager,
        LanguageManager,
        MobileNavigation,
        PortfolioFilter,
        BlogFilter,
        debounce,
        formatDate,
        truncateText
    };
}
