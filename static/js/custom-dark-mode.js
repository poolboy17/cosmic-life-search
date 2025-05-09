// Force dark mode for space website
document.addEventListener("DOMContentLoaded", function() {
  // Always set to dark mode for cosmic experience
  localStorage["dark-mode-storage"] = "dark";
  
  // Add a small delay to ensure theme is applied
  setTimeout(function() {
    document.documentElement.setAttribute("data-theme", "dark");
    
    if (typeof updateTheme === "function") {
      updateTheme();
    }
  }, 50);
});