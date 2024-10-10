#!/bin/zsh
# How It Works
# This script is designed to help keep your system secure and running smoothly by automatically cleaning up caches after it finishes important security checks. Here's what happens:
# Steps:
# Run Security Checks: The script first checks several key security features, including SIP (System Integrity Protection), FileVault, Firewall, Gatekeeper, and XProtect.
# Clean Caches: Once all the security checks are done, it automatically clears both user and system caches without needing any confirmation from you.

# Function to check System Integrity Protection (SIP) status
check_sip() {
  sip_status=$(csrutil status)
  if [[ $sip_status == "enabled" ]]; then
    echo "System Integrity Protection (SIP) is enabled."
  else
    echo "System Integrity Protection (SIP) is disabled."
  fi
}

# Function to check FileVault status
check_filevault() {
  filevault_status=$(fdesetup status)
  if [[ $filevault_status == "FileVault is On" ]]; then
    echo "FileVault is enabled."
  else
    echo "FileVault is disabled."
  fi
}

# Function to check Firewall status
check_firewall() {
  firewall_status=$(defaults read /Library/Preferences/com.apple.alf globalstate)
  if [[ $firewall_status -eq 1 ]]; then
    echo "Firewall is enabled."
  else
    echo "Firewall is disabled."
  fi
}

# Function to check Gatekeeper status
check_gatekeeper() {
  gatekeeper_status=$(spctl --status)
  if [[ $gatekeeper_status == "enabled" ]]; then
    echo "Gatekeeper is enabled."
  else
    echo "Gatekeeper is disabled."
  fi
}

# Function to check XProtect (malware protection) status
check_xprotect() {
  if /usr/libexec/PlistBuddy -c "Print :XProtectVersion" /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/XProtect.meta.plist &> /dev/null; then
    echo "XProtect (malware protection) is enabled."
  else
    echo "XProtect (malware protection) is disabled or not found."
  fi
}

# Function to clean user and system caches
clean_cache() {
  echo "Cleaning user cache..."
  rm -rf ~/Library/Caches/*

  echo "Cleaning system cache (requires sudo)..."
  sudo rm -rf /Library/Caches/*
  sudo rm -rf /System/Library/Caches/*

  echo "Caches cleaned."
}

# Run all checks and clean cache
echo "Checking macOS Security Settings..."
check_sip
check_filevault
check_firewall
check_gatekeeper
check_xprotect

echo ""
echo "Cleaning caches now..."
clean_cache
