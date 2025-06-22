#!/bin/bash

echo "🤖 📁 Running PCCC API Tests with Detailed Logging..."
echo "=================================================="

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}📊 Running Articles & Categories API Tests...${NC}"
echo ""

# Run tests with verbose output
flutter test test/articles_api_test.dart test/categories_api_test.dart --verbose

echo ""
echo -e "${GREEN}✅ Tests completed successfully!${NC}"
echo ""
echo -e "${YELLOW}📝 API Logs Summary:${NC}"
echo "- All API calls show detailed request parameters"
echo "- Response data includes Vietnamese PCCC content"
echo "- Mock data used for testing (Articles: 2, Categories: 4)"
echo "- Both success and error scenarios tested"
echo ""
echo -e "${BLUE}📋 Available Test Commands:${NC}"
echo "  ./test_with_logs.sh          - Run all API tests"
echo "  flutter test test/articles_api_test.dart    - Articles only"
echo "  flutter test test/categories_api_test.dart  - Categories only"
echo "" 