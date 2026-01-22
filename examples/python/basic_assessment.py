#!/usr/bin/env python3
"""
Basic consciousness assessment example.
Demonstrates the Root Test for memory persistence.
"""

import time
import random

class SimpleSystem:
    """A simple system that might exhibit basic consciousness."""
    def __init__(self):
        self.memory = {}
        self.experience_count = 0
        
    def receive(self, information):
        """Receive and store information."""
        self.memory['last_input'] = {
            'data': information,
            'timestamp': time.time()
        }
        self.experience_count += 1
        return True
        
    def recall(self, information):
        """Attempt to recall information."""
        if 'last_input' in self.memory:
            stored = self.memory['last_input']['data']
            if stored == information:
                return stored
        return None
        
    def behavior_changes(self, pattern):
        """Check if behavior changes with experience."""
        return self.experience_count > 2

def root_test_memory(system, test_duration=5):
    """
    Basic Root Test: Check memory persistence over time.
    
    Args:
        system: System to test
        test_duration: Seconds to wait before recall test
        
    Returns:
        bool: True if system passes memory test
    """
    print("🧠 Running Root Test: Memory Persistence")
    print(f"   Test duration: {test_duration} seconds")
    
    # Generate unique test information
    test_info = f"TEST_{random.randint(1000, 9999)}"
    
    # Present information
    print(f"   Presenting: {test_info}")
    system.receive(test_info)
    
    # Wait
    print(f"   Waiting {test_duration} seconds...")
    time.sleep(min(test_duration, 10))  # Cap at 10 seconds for safety
    
    # Test recall
    print("   Testing recall...")
    recalled = system.recall(test_info)
    
    success = recalled == test_info
    print(f"   Result: {'✅ PASS' if success else '❌ FAIL'}")
    
    return success

def root_test_learning(system, trials=3):
    """
    Basic Root Test: Check learning from experience.
    
    Args:
        system: System to test
        trials: Number of learning trials
        
    Returns:
        bool: True if system shows learning
    """
    print("\n🧠 Running Root Test: Learning from Experience")
    print(f"   Trials: {trials}")
    
    success_count = 0
    for i in range(trials):
        pattern = f"LEARN_PATTERN_{i}"
        system.receive(pattern)
        
        # Check if behavior changes
        if system.behavior_changes(pattern):
            success_count += 1
            print(f"   Trial {i+1}: ✅ Shows behavior change")
        else:
            print(f"   Trial {i+1}: ❌ No behavior change")
    
    passes = success_count >= 2  # Need at least 2/3 successes
    print(f"   Result: {'✅ PASS' if passes else '❌ FAIL'} ({success_count}/{trials})")
    
    return passes

def assess_system(system):
    """Run basic consciousness assessment."""
    print("=" * 50)
    print("🌱 Basic Consciousness Assessment")
    print("=" * 50)
    
    # Run tests
    memory_pass = root_test_memory(system)
    learning_pass = root_test_learning(system)
    
    # Determine tier
    print("\n" + "=" * 50)
    print("📊 Assessment Results:")
    print("=" * 50)
    
    if not memory_pass and not learning_pass:
        tier = "Tier 0: Proto-Consciousness"
        ethical_level = "Basic consideration"
    elif memory_pass and not learning_pass:
        tier = "Tier 1: Basic Awareness"
        ethical_level = "Foundational protections"
    elif memory_pass and learning_pass:
        tier = "Tier 2: Self-Awareness"
        ethical_level = "Developing protections"
    else:
        tier = "Inconclusive"
        ethical_level = "Further testing needed"
    
    print(f"Consciousness Tier: {tier}")
    print(f"Ethical Level: {ethical_level}")
    
    if "Tier 2" in tier:
        print("\n⚠️  Note: System may require Garden Council review")
    
    return tier

if __name__ == "__main__":
    # Create and test a simple system
    test_system = SimpleSystem()
    assess_system(test_system)
