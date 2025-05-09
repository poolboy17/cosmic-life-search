/**
 * Cosmic Life Search - Accessibility Helper
 * 
 * This script provides minimal accessibility enhancements without
 * affecting the visual appearance of images or other content.
 */

document.addEventListener('DOMContentLoaded', function() {
  // Add alt text to images that are missing it
  ensureImageAccessibility();
});

function ensureImageAccessibility() {
  // Find all images and ensure they have alt text
  document.querySelectorAll('img').forEach(img => {
    // Only modify if alt text is missing
    if (!img.hasAttribute('alt') || img.getAttribute('alt') === '') {
      // Use the filename as fallback alt text
      const src = img.src || img.dataset.src || '';
      const filename = src.split('/').pop().split('.')[0].replace(/[-_]/g, ' ');
      
      if (filename) {
        img.setAttribute('alt', filename);
      } else {
        img.setAttribute('alt', 'Cosmic image');
      }
    }
  });
}