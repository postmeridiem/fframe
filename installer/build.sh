#!/bin/bash
# This script builds the final, self-contained install.sh for fframe.

set -e # Exit immediately if a command exits with a non-zero status.

info() {
    echo -e "\033[0;34mINFO: $1\033[0m"
}

success() {
    echo -e "\033[0;32mSUCCESS: $1\033[0m"
}

error() {
    echo -e "\033[0;31mERROR: $1\033[0m" >&2
}

# Define paths
TEMPLATE_FILE="installer/install.sh.tpl"
OUTPUT_FILE="install.sh" # Output to project root for easy access
SOURCE_DIR="example/firebase"

info "Starting build for $OUTPUT_FILE..."

# Check if template file exists
if [ ! -f "$TEMPLATE_FILE" ]; then
    error "Template file not found at $TEMPLATE_FILE"
    exit 1
fi

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    error "Source directory not found at $SOURCE_DIR"
    exit 1
fi

info "Creating tarball and base64 encoding the payload..."

# Create a tarball of the required files, then base64 encode it.
# We cd into the source dir to get clean paths in the archive. The tar command
# creates an archive containing only the specified files and directories.
PAYLOAD=$(cd "$SOURCE_DIR" && tar czf - \
    firebase.json \
    firestore.rules \
    firestore.indexes.json \
    functions/package.json \
    functions/tsconfig.json \
    functions/src \
    | base64)

# Check if payload was created
if [ -z "$PAYLOAD" ]; then
    error "Failed to create payload from $SOURCE_DIR"
    exit 1
fi

info "Payload created. Injecting into the template..."

# Use a temporary file for sed to ensure cross-platform compatibility (macOS vs Linux)
TMP_FILE=$(mktemp)
sed "s|__FFRAME_PAYLOAD__|${PAYLOAD}|" "$TEMPLATE_FILE" > "$TMP_FILE"
mv "$TMP_FILE" "$OUTPUT_FILE"

# Make the output script executable
chmod +x "$OUTPUT_FILE"

success "$OUTPUT_FILE has been built successfully in the project root."
info "You can now distribute this file or have users run it via:"
info "curl -sL https://raw.githubusercontent.com/postmeridiem/fframe/main/install.sh | bash" 