import re

# Read the file
with open('ios/Runner/Info.plist', 'r') as f:
    content = f.read()

# Find and replace the CFBundleDocumentTypes section
start_pattern = r'(\s*<!-- Document types support -->\s*)'
end_pattern = r'(\s*</array>\s*</dict>\s*</plist>)'

# Find the CFBundleDocumentTypes section
bundle_pattern = r'(\s*<!-- Document types support -->\s*<key>CFBundleDocumentTypes</key>\s*<array>.*?</array>)'

# Replace with comment only
replacement = r'\t<!-- Document types support - Removed PDF handler to allow Quick Look preview -->'

# Use DOTALL flag to match across newlines
new_content = re.sub(bundle_pattern, replacement, content, flags=re.DOTALL)

# Write back
with open('ios/Runner/Info.plist', 'w') as f:
    f.write(new_content)

print('✅ Successfully removed PDF document type handler from Info.plist')
