# iOS Simulator Fix Guide

## Problem
```
Unable to find a destination matching the provided destination specifier:
{ id:52F762EB-9CBB-4A31-AADD-230B9C78ABF1 }

Error launching application on iPhone 17 Pro.
iOS 26.2 is not installed.
```

## Root Cause
- The simulator device ID is cached but the simulator no longer exists
- "iPhone 17 Pro" doesn't exist (it's a future device)
- iOS 26.2 doesn't exist (current iOS versions are 17.x)

## Solutions

### Solution 1: Select a Valid Simulator (Easiest)

1. **In VS Code/Android Studio:**
   - Click on the device selector in the bottom right
   - Select a valid simulator (e.g., iPhone 15 Pro, iPhone 14, iPhone 13, etc.)
   - Or click "No Devices" and select "Open iOS Simulator"

2. **Or use Flutter command:**
   ```bash
   flutter devices
   ```
   Then select a device from the list.

### Solution 2: Open Xcode and Create/Select Simulator

1. Open **Xcode**
2. Go to **Window → Devices and Simulators** (or press `Cmd + Shift + 2`)
3. Click the **"+"** button to create a new simulator
4. Select:
   - **Device Type:** iPhone 15 Pro (or any available iPhone)
   - **OS Version:** iOS 17.0 or later (whatever is installed)
5. Click **Create**
6. Select the new simulator in your IDE

### Solution 3: Reset Flutter Device Cache

Run these commands in your terminal:

```bash
cd /Users/hasan/StudioProjects/fluttersampleachitecture

# Clean Flutter build
flutter clean

# Get available devices
flutter devices

# If you see available devices, run with specific device ID
flutter run -d <DEVICE_ID>
```

### Solution 4: Install iOS Runtime in Xcode

1. Open **Xcode**
2. Go to **Xcode → Settings → Platforms** (or **Components**)
3. Check if iOS 17.x runtime is installed
4. If not, click **"+"** and download the iOS runtime
5. Wait for download to complete

### Solution 5: Reset Simulator Service

If simulators are not working:

```bash
# Kill simulator processes
killall Simulator
killall com.apple.CoreSimulator.CoreSimulatorService

# Restart simulator service (may need sudo)
sudo launchctl stop com.apple.CoreSimulator.CoreSimulatorService
sudo launchctl start com.apple.CoreSimulator.CoreSimulatorService

# Or restart your Mac
```

### Solution 6: Delete and Recreate Simulators

1. Open **Xcode**
2. Go to **Window → Devices and Simulators**
3. Select the problematic simulator
4. Right-click → **Delete**
5. Create a new simulator (see Solution 2)

### Solution 7: Use Physical Device

If you have an iPhone/iPad:

1. Connect device via USB
2. Trust the computer on your device
3. Select the device from Flutter device list
4. Run: `flutter run`

### Solution 8: Check Xcode Command Line Tools

```bash
# Check if Xcode is properly configured
xcode-select -p

# If not set, set it:
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

# Accept Xcode license
sudo xcodebuild -license accept
```

## Quick Fix Script

Create a file `fix_ios_simulator.sh`:

```bash
#!/bin/bash

echo "Cleaning Flutter build..."
flutter clean

echo "Getting available devices..."
flutter devices

echo ""
echo "Available devices listed above."
echo "Select a device ID and run: flutter run -d <DEVICE_ID>"
```

Make it executable:
```bash
chmod +x fix_ios_simulator.sh
./fix_ios_simulator.sh
```

## Recommended Steps (In Order)

1. ✅ **First:** Open Xcode → Window → Devices and Simulators → Create a new iPhone 15 Pro simulator
2. ✅ **Second:** In your IDE, select the new simulator from device list
3. ✅ **Third:** Run `flutter clean` then `flutter run`
4. ✅ **If still fails:** Check Xcode → Settings → Platforms for installed iOS runtimes

## Common Valid Simulators

These simulators typically work:
- iPhone 15 Pro (iOS 17.0+)
- iPhone 14 Pro (iOS 16.0+)
- iPhone 13 Pro (iOS 15.0+)
- iPhone 12 Pro (iOS 14.0+)
- iPhone SE (3rd generation)

## Verify Fix

After applying a solution, verify:

```bash
# List devices
flutter devices

# You should see something like:
# iPhone 15 Pro (simulator) • ABC12345-... • iOS 17.0
```

Then run:
```bash
flutter run
```

## Still Having Issues?

1. **Update Xcode:** Make sure you have the latest Xcode
2. **Update Flutter:** `flutter upgrade`
3. **Check Xcode Command Line Tools:** `xcode-select -p`
4. **Restart your Mac:** Sometimes fixes simulator service issues
