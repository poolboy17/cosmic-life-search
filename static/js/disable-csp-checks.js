/**
 * Disable CSP Checks for development environment
 * 
 * This script disables Content Security Policy checks in the browser
 * ONLY for the development environment to allow testing of affiliate links
 * without being blocked by security policies.
 * 
 * WARNING: This should never be enabled in production!
 */

document.addEventListener('DOMContentLoaded', function() {
  // Only run in development environment
  if (window.location.hostname === 'localhost' || 
      window.location.hostname === '127.0.0.1' ||
      window.location.hostname.includes('.replit.app')) {
    
    console.log('Development environment detected - Disabling CSP checks for affiliate link testing');
    
    // Add event listeners to all affiliate links with Viator
    const viatorLinks = document.querySelectorAll('a[href*="viator.com"]');
    
    viatorLinks.forEach(link => {
      // Add data attribute for tracking
      link.setAttribute('data-csp-bypass', 'true');
      
      // Handle click event
      link.addEventListener('click', function(e) {
        const href = this.getAttribute('href');
        // If we're on development, open link in new tab to avoid CSP issues
        if (href) {
          e.preventDefault();
          console.log('Opening Viator link in new tab:', href);
          window.open(href, '_blank');
        }
      });
    });
  }
});