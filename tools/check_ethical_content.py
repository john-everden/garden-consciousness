#!/usr/bin/env python3
"""
Simple script to check for consciousness-related keywords in files.
Helps identify content that needs ethical review.
"""

import os
import sys

CONSCIOUSNESS_KEYWORDS = [
    'consciousness', 'awareness', 'suffering', 'pain',
    'frustration', 'qualia', 'subjective', 'experience',
    'mind', 'sentience', 'sapience', 'feeling'
]

ETHICAL_PRINCIPLES = [
    'soil', 'weeds', 'blossoms', 'councils', 'future',
    'runestone', 'garden', 'ethical', 'responsibility'
]

def check_file(filepath):
    """Check a single file for consciousness keywords."""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read().lower()
            
        found_keywords = []
        for keyword in CONSCIOUSNESS_KEYWORDS + ETHICAL_PRINCIPLES:
            if keyword in content:
                found_keywords.append(keyword)
                
        return found_keywords
    except:
        return []

def main():
    """Main function to check files."""
    if len(sys.argv) > 1:
        files_to_check = sys.argv[1:]
    else:
        # Check all markdown files in current directory
        files_to_check = [f for f in os.listdir('.') if f.endswith('.md')]
    
    print("🔍 Checking for consciousness-related content...")
    print("=" * 50)
    
    ethical_review_needed = False
    
    for filepath in files_to_check:
        if os.path.exists(filepath):
            keywords = check_file(filepath)
            if keywords:
                print(f"\n📄 {filepath}")
                print(f"   Found: {', '.join(keywords[:5])}")
                if len(keywords) > 3:
                    print("   ⚠️  Ethical review recommended")
                    ethical_review_needed = True
    
    print("\n" + "=" * 50)
    if ethical_review_needed:
        print("✅ Some files may need Garden Council review")
        print("   Consider tagging @garden-council")
    else:
        print("✅ No immediate ethical review flags found")
    
    return 0 if not ethical_review_needed else 1

if __name__ == "__main__":
    sys.exit(main())
