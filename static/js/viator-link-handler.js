/**
 * Viator Link Handler
 * This script helps ensure Viator affiliate links work correctly
 */

document.addEventListener('DOMContentLoaded', function() {
  // Handle viator buttons in shortcodes
  const viatorButtons = document.querySelectorAll('.viator-button');
  
  // Handle inline links to Viator separately (don't apply button styling to these)
  const inlineViatorLinks = Array.from(document.querySelectorAll('p a[href*="viator.com"]')).filter(
    link => !link.classList.contains('viator-button')
  );
  
  // Add click event handler to each dedicated button
  viatorButtons.forEach(function(button) {
    button.addEventListener('click', function(e) {
      // Get the URL from the href attribute
      const url = this.getAttribute('href');
      
      // Only handle viator URLs
      if (url && url.includes('viator.com')) {
        // Open the URL in a new tab
        window.open(url, '_blank', 'noopener,noreferrer');
        
        // Prevent the default action
        e.preventDefault();
        
        // Log success for debugging
        console.log('Viator link handled successfully:', url);
      }
    });
  });
  
  // Handle the inline links differently - let them use default styling
  inlineViatorLinks.forEach(function(link) {
    link.setAttribute('target', '_blank');
    link.setAttribute('rel', 'noreferrer noopener');
    
    // Ensure they open correctly
    link.addEventListener('click', function(e) {
      const url = this.getAttribute('href');
      if (url && url.includes('viator.com')) {
        window.open(url, '_blank', 'noopener,noreferrer');
        e.preventDefault();
        console.log('Inline Viator link handled:', url);
      }
    });
  });
  
  console.log('Viator link handler initialized');
});