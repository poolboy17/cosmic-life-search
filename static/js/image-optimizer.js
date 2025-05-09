/**
 * Cosmic Life Search - Image Optimizer
 * 
 * This script adds basic lazy loading for images without
 * applying excessive effects or modifications.
 */

document.addEventListener('DOMContentLoaded', function() {
  // Add native lazy loading to images
  addLazyLoading();
  
  // Ensure alt text for accessibility
  ensureAltText();
});

/**
 * Add native lazy loading to images
 */
function addLazyLoading() {
  document.querySelectorAll('img').forEach(img => {
    // Add loading attribute if not already present
    if (!img.hasAttribute('loading')) {
      img.setAttribute('loading', 'lazy');
    }
    
    // Add basic classes for styling without modifying appearance
    if (img.closest('.post-thumbnail')) {
      img.classList.add('card-img');
    } else if (img.closest('.post-featured-image')) {
      img.classList.add('featured-image');
    }
  });
}

/**
 * Ensure all images have alt text for accessibility
 */
function ensureAltText() {
  document.querySelectorAll('img').forEach(img => {
    if (!img.hasAttribute('alt') || img.getAttribute('alt') === '') {
      // Use the filename as fallback alt text
      const src = img.src || '';
      const filename = src.split('/').pop().split('.')[0].replace(/[-_]/g, ' ');
      
      if (filename) {
        img.setAttribute('alt', filename);
      } else {
        img.setAttribute('alt', 'Cosmic image');
      }
    }
  });
}