#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$SCRIPT_DIR/Books"
SAFARI_SCRIPT="$SCRIPT_DIR/safaribooks.py"

# Find ebook-convert from PATH, then fall back to common Calibre install locations
EBOOK_CONVERT=$(command -v ebook-convert 2>/dev/null)
if [ -z "$EBOOK_CONVERT" ]; then
    for candidate in \
        "/Applications/calibre.app/Contents/MacOS/ebook-convert" \
        "/opt/homebrew/bin/ebook-convert" \
        "/usr/bin/ebook-convert"; do
        if [ -x "$candidate" ]; then
            EBOOK_CONVERT="$candidate"
            break
        fi
    done
fi

if [ -z "$EBOOK_CONVERT" ]; then
    echo "Error: ebook-convert not found. Please install Calibre: https://calibre-ebook.com/"
    exit 1
fi

BOOK_ID="$1"
if [ -z "$BOOK_ID" ]; then
    echo "Usage: $0 <BOOK_ID>"
    exit 1
fi

echo "--- Downloading book $BOOK_ID ---"
python3 "$SAFARI_SCRIPT" "$BOOK_ID"

if [ $? -ne 0 ]; then
    echo "Error: download failed."
    exit 1
fi

echo "--- Finding downloaded directory ---"
BOOK_DIR=$(find "$BASE_DIR" -maxdepth 1 -type d -name "*($BOOK_ID)" | head -n 1)

if [ -z "$BOOK_DIR" ]; then
    echo "Error: could not find book directory for ID $BOOK_ID in $BASE_DIR."
    exit 1
fi

SOURCE_PATH="$BOOK_DIR/$BOOK_ID.epub"
DEST_PATH="$BASE_DIR/$(basename "$BOOK_DIR").epub"

if [ ! -f "$SOURCE_PATH" ]; then
    echo "Error: EPUB not found at $SOURCE_PATH."
    exit 1
fi

echo "--- Converting to clean EPUB ---"
echo "Source:      $SOURCE_PATH"
echo "Destination: $DEST_PATH"

"$EBOOK_CONVERT" "$SOURCE_PATH" "$DEST_PATH"

if [ $? -eq 0 ]; then
    echo "--- Done! Saved as: $DEST_PATH ---"
else
    echo "Error: ebook-convert failed."
    exit 1
fi
