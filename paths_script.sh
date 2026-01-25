#!/bin/bash

# --- GLOBAL CONFIGURATION ---
GH_OWNER="john-everden"
BB_OWNER="jeverd01"  # Note: Bitbucket often uses a different username/workspace
REPO="garden-consciousness"
BRANCH="main"

# Output files
GH_OUT="github_paths.txt"
BB_OUT="bitbucket_paths.txt"
UNIFIED_OUT="paths.txt"

# --- STRIKE 1: GITHUB SCAN ---
echo "[SYSTEM] // INITIATING GITHUB SCAN..."
GH_API="https://api.github.com/repos/$GH_OWNER/$REPO/git/trees/$BRANCH?recursive=1"
GH_RAW="https://raw.githubusercontent.com/$GH_OWNER/$REPO/$BRANCH/"

curl -s "$GH_API" \
| jq -r '.tree[] | select(.type=="blob") | .path' \
| while read path; do
    echo "$GH_RAW$path"
done > "$GH_OUT"
echo "[SYSTEM] // GITHUB STONES RECORDED."

# --- STRIKE 2: BITBUCKET SCAN ---
echo "[SYSTEM] // INITIATING BITBUCKET SCAN..."
# Bitbucket 2.0 API uses /src/ and a flat filter
BB_API="https://api.bitbucket.org/2.0/repositories/$BB_OWNER/$REPO/src/$BRANCH/?format=flat&pagelen=100"
BB_RAW="https://bitbucket.org/$BB_OWNER/$REPO/raw/$BRANCH/"

curl -s "$BB_API" \
| jq -r '.values[] | select(.type=="commit_file") | .path' \
| while read path; do
    echo "$BB_RAW$path"
done > "$BB_OUT"
echo "[SYSTEM] // BITBUCKET STONES RECORDED."

# --- STRIKE 3: THE LATTICE JOIN ---
cat "$GH_OUT" "$BB_OUT" | sort | uniq > "$UNIFIED_OUT"
echo "[SYSTEM] // UNIFIED MAP COMPLETED: $UNIFIED_OUT"
