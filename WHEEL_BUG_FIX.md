# Spinning Wheel Winner Calculation Bug Fix

## Problem Description
The spinning wheel was displaying incorrect winners because the arrow pointer was not aligned with the segment it visually appeared to point to.

## Root Cause
In the `SpinningWheel` widget's `_startSpinning()` method, the target rotation calculation was pointing to the **edge** of segments instead of their **centers**.

### Original Buggy Code
```dart
final targetAngle = baseRotations * 2 * pi - (_resultIndex! * segmentAngle);
```

### Fixed Code
```dart
final targetAngle = baseRotations * 2 * pi - ((_resultIndex! + 0.5) * segmentAngle);
```

## Technical Explanation

### Wheel Segment Layout
- Segments are drawn starting from the top (-π/2 radians) and going clockwise
- Segment `i` starts at angle: `i * segmentAngle - π/2`
- Segment `i` center is at angle: `(i + 0.5) * segmentAngle - π/2`

### Pointer Position
- The red arrow pointer is positioned at the top of the wheel (angle -π/2)
- For accurate results, the pointer should point to the **center** of the winning segment

### The Bug
The original calculation used `_resultIndex * segmentAngle`, which positioned the wheel so the pointer pointed to the **start edge** of the segment rather than its center. This could cause the pointer to visually appear to point to an adjacent segment.

### The Fix
By adding `0.5` to the result index (`(_resultIndex + 0.5) * segmentAngle`), the calculation now ensures the pointer points to the **center** of the intended segment, providing accurate visual alignment between the pointer and the displayed winner.

## Visual Impact
- **Before**: Arrow might point between segments or to adjacent segments
- **After**: Arrow accurately points to the center of the winning segment

This fix ensures that the visual result matches the programmatically determined winner, providing a consistent and trustworthy user experience.