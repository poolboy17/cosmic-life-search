#!/bin/bash

# Enhanced build script for Render Blueprint deployment

# Set colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting Cosmic Life Search build process...${NC}"

# Use HUGO_VERSION from environment variable or default to 0.126.1
HUGO_VERSION=${HUGO_VERSION:-"0.126.1"}
HUGO_ENV=${HUGO_ENV:-"production"}

echo -e "${YELLOW}Using Hugo version: ${HUGO_VERSION} in ${HUGO_ENV} environment${NC}"

# Download and install Hugo extended version
echo -e "${YELLOW}Downloading Hugo v${HUGO_VERSION}...${NC}"
curl -L https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz | tar -xz
chmod +x hugo
mv hugo /usr/bin/

# Verify Hugo installation
echo -e "${YELLOW}Verifying Hugo installation:${NC}"
hugo version

# Build the static site
echo -e "${YELLOW}Building site with Hugo...${NC}"
if [ "$HUGO_ENV" = "production" ]; then
  # Production build with optimizations
  hugo --gc --minify
else
  # Development/Preview build with drafts
  hugo --gc --minify --buildDrafts --buildFuture
fi

# Copy video sitemap to public directory
echo -e "${YELLOW}Copying video sitemap...${NC}"
if [ -f "static/video-sitemap.xml" ]; then
  cp static/video-sitemap.xml public/
  echo -e "${GREEN}Video sitemap copied to public directory${NC}"
else
  echo -e "${RED}Warning: video-sitemap.xml not found in static directory${NC}"
fi

# Create _redirects file for URL handling
echo -e "${YELLOW}Creating redirect rules...${NC}"
cat > public/_redirects << EOL
# Redirect default Render subdomain to primary domain
https://cosmic-life-search.onrender.com/* https://cosmiclifesearch.com/:splat 301!
https://cosmic-life-search-preview.onrender.com/* https://preview.cosmiclifesearch.com/:splat 301!

# Handle custom 404
/* /404.html 404
EOL

# Create robots.txt according to environment
echo -e "${YELLOW}Creating robots.txt for ${HUGO_ENV} environment...${NC}"
if [ "$HUGO_ENV" = "production" ]; then
  # Production robots.txt - allow indexing
  cat > public/robots.txt << EOL
User-agent: *
Allow: /

# Sitemap declarations
Sitemap: https://cosmiclifesearch.com/sitemap.xml
Sitemap: https://cosmiclifesearch.com/video-sitemap.xml
EOL
else
  # Non-production robots.txt - prevent indexing
  cat > public/robots.txt << EOL
User-agent: *
Disallow: /
EOL
fi

# Create version.json with build info for debugging
echo -e "${YELLOW}Creating version information...${NC}"
BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
COMMIT_HASH=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")

cat > public/version.json << EOL
{
  "version": "1.0.0",
  "buildDate": "${BUILD_DATE}",
  "commit": "${COMMIT_HASH}",
  "environment": "${HUGO_ENV}",
  "hugoVersion": "${HUGO_VERSION}"
}
EOL

# Final message
echo -e "${GREEN}Build completed successfully!${NC}"
echo -e "${GREEN}Environment: ${HUGO_ENV}${NC}"
echo -e "${GREEN}Build Date: ${BUILD_DATE}${NC}"