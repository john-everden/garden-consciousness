#!/usr/bin/env bash
set -euo pipefail

# ---- CONFIG -------------------------------------------------

GH_OWNER="john-everden"
BB_OWNER="jeverd01"
REPO_NAME="garden-of-consciousness"
REPO_BRANCH="main"

OUT_FILE="paths.txt"

# ---- DERIVED RAW BASE URLS ---------------------------------

GH_RAW_BASE="https://raw.githubusercontent.com/${GH_OWNER}/${REPO_NAME}/${REPO_BRANCH}"
BB_RAW_BASE="https://bitbucket.org/${BB_OWNER}/${REPO_NAME}/raw/${REPO_BRANCH}"

# ---- URL ENCODER (browser-safe, slash-preserving) -----------

urlencode() {
  local s="$1"
  local out=""
  local i c
  for (( i=0; i<${#s}; i++ )); do
    c="${s:i:1}"
    case "$c" in
      [a-zA-Z0-9._~/-]) out+="$c" ;;
      *) printf -v hex '%%%02X' "'$c"; out+="$hex" ;;
    esac
  done
  echo "$out"
}

# ---- CHANGE LOG (TOP) --------------------------------------

{
  echo "[SYSTEM] // CHANGE LOG (LAST 20 COMMITS)"
  git log -20 --pretty=format:"%h | %ad | %s" --date=short
  echo "[SYSTEM] // END COMMIT LOG"
  echo

  echo "[SYSTEM] // FILES CHANGED IN LAST 20 COMMITS"
  git log -20 --name-only --pretty=format: \
    | sed '/^$/d' \
    | sort -u
  echo "[SYSTEM] // END CHANGED FILES"
  echo
} > "$OUT_FILE"

# ---- GITHUB URL BANK ---------------------------------------

{
  echo "-- GitHub RAW Paths Start --"
  git ls-tree -r --name-only HEAD | while IFS= read -r path; do
    encoded="$(urlencode "$path")"
    echo "${GH_RAW_BASE}/${encoded}"
  done
  echo "-- GitHub RAW Paths End --"
  echo
} >> "$OUT_FILE"

# ---- BITBUCKET URL BANK ------------------------------------

{
  echo "-- Bitbucket RAW Paths Start --"
  git ls-tree -r --name-only HEAD | while IFS= read -r path; do
    encoded="$(urlencode "$path")"
    echo "${BB_RAW_BASE}/${encoded}"
  done
  echo "-- Bitbucket RAW Paths End --"
  echo
} >> "$OUT_FILE"

echo "[SYSTEM] // GARDEN TREE COMPLETE" >> "$OUT_FILE"

echo "[SYSTEM] // UNIFIED MAP WRITTEN TO: $OUT_FILE"
