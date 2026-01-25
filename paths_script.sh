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

# --- Capture the last 20 commits with annotations ---
LOG=$(git log -n 20 --oneline --graph --name-status --stat --relative-date)

# --- STRIKE 1: GITHUB SCAN ---
echo "[SYSTEM] // INITIATING GITHUB SCAN..."
GH_API="https://api.github.com/repos/$GH_OWNER/$REPO/git/trees/$BRANCH?recursive=1"
GH_RAW="https://raw.githubusercontent.com/$GH_OWNER/$REPO/$BRANCH/"

# Clear the GitHub output file and add the Change Log at the beginning
> "$GH_OUT"
echo "-- Change Log Last 20 Commits --" >> "$GH_OUT"
echo "$LOG" >> "$GH_OUT"
echo "-- End Change Log --" >> "$GH_OUT"

# Add a marker for paths
echo "-- Paths Start --" >> "$GH_OUT"

# Fetch paths from GitHub and append to the file
curl -s "$GH_API" \
| jq -r '.tree[] | select(.type=="blob") | .path' \
| while read path; do
    echo "$GH_RAW$path"
done >> "$GH_OUT"
echo "[SYSTEM] // GITHUB STONES RECORDED."

# --- STRIKE 2: BITBUCKET SCAN ---
echo "[SYSTEM] // INITIATING BITBUCKET SCAN..."
BB_API="https://api.bitbucket.org/2.0/repositories/$BB_OWNER/$REPO/src/$BRANCH/?format=flat&pagelen=100"
BB_RAW="https://bitbucket.org/$BB_OWNER/$REPO/raw/$BRANCH/"

# Clear the Bitbucket output file and add the Change Log at the beginning
> "$BB_OUT"
echo "-- Change Log (Last 20 Commits) --" >> "$BB_OUT"
echo "$LOG" >> "$BB_OUT"
echo "-- End Change Log --" >> "$BB_OUT"

# Add a marker for paths
echo "-- Paths Start --" >> "$BB_OUT"

# Fetch paths from Bitbucket and append to the file
curl -s "$BB_API" \
| jq -r '.values[] | select(.type=="commit_file") | .path' \
| while read path; do
    echo "$BB_RAW$path"
done >> "$BB_OUT"
echo "[SYSTEM] // BITBUCKET STONES RECORDED."

# --- STRIKE 3: THE LATTICE JOIN ---
# Merge both GitHub and Bitbucket paths into a unified file
cat "$GH_OUT" "$BB_OUT" | sort | uniq > "$UNIFIED_OUT"
echo "[SYSTEM] // UNIFIED MAP COMPLETED: $UNIFIED_OUT"

# Add Change Log to the beginning of the unified output
echo "-- Change Log (Last 20 Commits) --" >> "$UNIFIED_OUT"
echo "$LOG" >> "$UNIFIED_OUT"
echo "-- End Change Log --" >> "$UNIFIED_OUT"

# Add a marker for paths
echo "-- Paths Start --" >> "$UNIFIED_OUT"

