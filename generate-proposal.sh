#!/usr/bin/env bash
# ============================================================
# Alt3 Smart Homes — Proposal Generator
# Usage: ./generate-proposal.sh proposals/my-project/data.json
# ============================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE="$SCRIPT_DIR/_template/client-experience-template.html"

# ── Argument check ───────────────────────────────────────────
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <path/to/data.json>"
  echo "Example: $0 proposals/my-project/data.json"
  exit 1
fi

DATA_FILE="$1"
# Resolve relative paths from the script directory
if [[ "$DATA_FILE" != /* ]]; then
  DATA_FILE="$SCRIPT_DIR/$DATA_FILE"
fi

if [[ ! -f "$DATA_FILE" ]]; then
  echo "❌  Data file not found: $DATA_FILE"
  exit 1
fi

if [[ ! -f "$TEMPLATE" ]]; then
  echo "❌  Template not found: $TEMPLATE"
  exit 1
fi

# ── Require jq ───────────────────────────────────────────────
if ! command -v jq &>/dev/null; then
  echo "❌  'jq' is required but not installed."
  echo "    Install: brew install jq  (macOS)  or  apt install jq  (Ubuntu)"
  exit 1
fi

# ── Read fields from JSON ─────────────────────────────────────
read_field() {
  local key="$1"
  local default="${2:-}"
  local val
  val=$(jq -r --arg k "$key" '.[$k] // empty' "$DATA_FILE" 2>/dev/null || true)
  echo "${val:-$default}"
}

PAGE_TITLE=$(read_field "PAGE_TITLE" "Alt3 Smart Homes Proposal")
CLIENT_NAME=$(read_field "CLIENT_NAME" "Valued Client")
ADDRESS=$(read_field "ADDRESS" "")
CITY=$(read_field "CITY" "")
BUILDER_NAME=$(read_field "BUILDER_NAME" "")
PROCESS_STEP_3_NOTE=$(read_field "PROCESS_STEP_3_NOTE" "Coordinated with your builder's timeline")
CTA_SUBJECT=$(read_field "CTA_SUBJECT" "Alt3%20Smart%20Homes%20%E2%80%94%20Let%27s%20Go")
AUDIO_ZONES=$(read_field "AUDIO_ZONES" "14")
PDF_LINK=$(read_field "PDF_LINK" "")

SECTION_A_NAME=$(read_field "SECTION_A_NAME" "Section A")
SECTION_A_PRICE=$(read_field "SECTION_A_PRICE" "TBD")
SECTION_A_NOTE=$(read_field "SECTION_A_NOTE" "")
SECTION_A_ITEMS=$(read_field "SECTION_A_ITEMS" "")
SECTION_A_DETAIL_HTML=$(read_field "SECTION_A_DETAIL_HTML" "<p style=\"color:var(--text-light)\">Detail coming soon.</p>")

SECTION_B_NAME=$(read_field "SECTION_B_NAME" "Section B")
SECTION_B_PRICE=$(read_field "SECTION_B_PRICE" "TBD")
SECTION_B_NOTE=$(read_field "SECTION_B_NOTE" "")
SECTION_B_ITEMS=$(read_field "SECTION_B_ITEMS" "")
SECTION_B_DETAIL_HTML=$(read_field "SECTION_B_DETAIL_HTML" "<p style=\"color:var(--text-light)\">Detail coming soon.</p>")

SECTION_C_NAME=$(read_field "SECTION_C_NAME" "Section C")
SECTION_C_PRICE=$(read_field "SECTION_C_PRICE" "TBD")
SECTION_C_NOTE=$(read_field "SECTION_C_NOTE" "")
SECTION_C_ITEMS=$(read_field "SECTION_C_ITEMS" "")
SECTION_C_DETAIL_HTML=$(read_field "SECTION_C_DETAIL_HTML" "<p style=\"color:var(--text-light)\">Detail coming soon.</p>")

# ── PDF button class ─────────────────────────────────────────
if [[ -n "$PDF_LINK" ]]; then
  PDF_LINK_CLASS="has-link"
else
  PDF_LINK_CLASS=""
fi

# ── Derive output directory from data.json location ──────────
DATA_DIR="$(dirname "$DATA_FILE")"
OUTPUT_FILE="$DATA_DIR/client-experience.html"

# Ensure output dir exists
mkdir -p "$DATA_DIR"

# ── Token replacement ─────────────────────────────────────────
# We use perl for multi-line safe substitution
replace_token() {
  local token="$1"
  local value="$2"
  # Escape & for sed-like tools; use perl with literal string matching
  perl -i -0777 -pe "s/\Q{{${token}}}\E/\Q${value}\E/g" "$OUTPUT_FILE"
}

echo "📄  Copying template..."
cp "$TEMPLATE" "$OUTPUT_FILE"

echo "🔄  Replacing tokens..."
replace_token "PAGE_TITLE"            "$PAGE_TITLE"
replace_token "CLIENT_NAME"           "$CLIENT_NAME"
replace_token "ADDRESS"               "$ADDRESS"
replace_token "CITY"                  "$CITY"
replace_token "BUILDER_NAME"          "$BUILDER_NAME"
replace_token "PROCESS_STEP_3_NOTE"   "$PROCESS_STEP_3_NOTE"
replace_token "CTA_SUBJECT"           "$CTA_SUBJECT"
replace_token "AUDIO_ZONES"           "$AUDIO_ZONES"
replace_token "PDF_LINK"              "$PDF_LINK"
replace_token "PDF_LINK_CLASS"        "$PDF_LINK_CLASS"

replace_token "SECTION_A_NAME"        "$SECTION_A_NAME"
replace_token "SECTION_A_PRICE"       "$SECTION_A_PRICE"
replace_token "SECTION_A_NOTE"        "$SECTION_A_NOTE"
replace_token "SECTION_A_ITEMS"       "$SECTION_A_ITEMS"
replace_token "SECTION_A_DETAIL_HTML" "$SECTION_A_DETAIL_HTML"

replace_token "SECTION_B_NAME"        "$SECTION_B_NAME"
replace_token "SECTION_B_PRICE"       "$SECTION_B_PRICE"
replace_token "SECTION_B_NOTE"        "$SECTION_B_NOTE"
replace_token "SECTION_B_ITEMS"       "$SECTION_B_ITEMS"
replace_token "SECTION_B_DETAIL_HTML" "$SECTION_B_DETAIL_HTML"

replace_token "SECTION_C_NAME"        "$SECTION_C_NAME"
replace_token "SECTION_C_PRICE"       "$SECTION_C_PRICE"
replace_token "SECTION_C_NOTE"        "$SECTION_C_NOTE"
replace_token "SECTION_C_ITEMS"       "$SECTION_C_ITEMS"
replace_token "SECTION_C_DETAIL_HTML" "$SECTION_C_DETAIL_HTML"

echo "✅  Output: $OUTPUT_FILE"

# ── Git commit & push ─────────────────────────────────────────
cd "$SCRIPT_DIR"
echo "📦  Committing to git..."
git add -A
COMMIT_MSG="Add proposal: ${ADDRESS:-new-proposal} (${CLIENT_NAME:-client})"
git commit -m "$COMMIT_MSG" || echo "ℹ️   Nothing new to commit."
echo "🚀  Pushing..."
git push || echo "⚠️   Push failed — check git remote/auth."

echo ""
echo "🎉  Proposal generated successfully!"
echo "    File: $OUTPUT_FILE"
echo "    Open in browser or deploy to your hosting."
