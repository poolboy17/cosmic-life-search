#!/bin/bash

# Deploy to Render Blueprint Script
# This script pushes the latest changes to GitHub which triggers Render Blueprint deployment

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Cosmic Life Search - Render Blueprint Deployment ===${NC}"
echo -e "${YELLOW}Starting deployment process...${NC}"

# Check if GITHUB_TOKEN exists
if [ -z "$GITHUB_TOKEN" ]; then
  echo -e "${RED}Error: GITHUB_TOKEN environment variable not set${NC}"
  echo "Please set the GITHUB_TOKEN environment variable with a valid GitHub personal access token"
  exit 1
fi

# Repository information
REPO_NAME="cosmic-life-search"
GITHUB_USERNAME="poolboy17"
REPO_URL="https://$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$REPO_NAME.git"

# Verify blueprint configuration
if [ ! -f "render.yaml" ]; then
  echo -e "${RED}Error: render.yaml not found${NC}"
  echo "Blueprint configuration file is required for Render deployment"
  exit 1
fi

echo -e "${YELLOW}Verifying blueprint configuration in render.yaml...${NC}"
# Enhanced validation of the render.yaml file
if grep -q "cosmic-life-search" render.yaml && grep -q "buildCommand" render.yaml; then
  if grep -q "staticPublishDir" render.yaml; then
    echo -e "${GREEN}Blueprint configuration looks valid with proper static site configuration${NC}"
  elif grep -q "publishDir" render.yaml; then
    echo -e "${RED}Warning: Found 'publishDir' instead of 'staticPublishDir' which is required for static sites${NC}"
    echo "Continuing anyway, but deployment might fail"
  else
    echo -e "${RED}Warning: Missing publish directory configuration${NC}"
    echo "Continuing anyway, but deployment might fail"
  fi
else
  echo -e "${RED}Warning: Blueprint configuration may be incomplete${NC}"
  echo "Continuing anyway, but deployment might fail"
fi

# Run the sync script to update GitHub
echo -e "${YELLOW}Syncing latest changes to GitHub...${NC}"
./sync_hugo_to_github.sh

# Check if the sync was successful
if [ $? -ne 0 ]; then
  echo -e "${RED}GitHub sync failed. Please check the logs.${NC}"
  exit 1
fi

# Display deployment information
echo -e "\n${GREEN}Deployment triggered successfully!${NC}"
echo -e "${GREEN}Changes have been pushed to GitHub which will trigger Render Blueprint deployment.${NC}"
echo -e "\n${YELLOW}== Deployment Information ==${NC}"
echo -e "${YELLOW}Blueprint Configuration:${NC} render.yaml"
echo -e "${YELLOW}Repository:${NC} github.com/$GITHUB_USERNAME/$REPO_NAME"
echo -e "${YELLOW}Build Script:${NC} build.sh"
echo -e "\n${YELLOW}== Expected Services ==${NC}"
echo -e "${BLUE}Production Site:${NC} https://cosmic-life-search.onrender.com"
echo -e "${BLUE}Custom Domain:${NC} https://cosmiclifesearch.com"
echo -e "${BLUE}Preview Site:${NC} https://cosmic-life-search-preview.onrender.com (if enabled)"

echo -e "\n${YELLOW}== Deployment Timeline ==${NC}"
echo -e "- GitHub sync: ${GREEN}Completed${NC}"
echo -e "- Render webhook triggered: ${GREEN}Completed${NC}"
echo -e "- Render build: ${YELLOW}In Progress${NC} (typically takes 2-5 minutes)"
echo -e "- Site availability: ${YELLOW}Pending${NC} (check Render dashboard for status)"

echo -e "\n${YELLOW}Note: It may take a few minutes for changes to propagate through Render's build process.${NC}"
echo -e "${YELLOW}You can monitor the build progress in the Render dashboard: https://dashboard.render.com/${NC}"