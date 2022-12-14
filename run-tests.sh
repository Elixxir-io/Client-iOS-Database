#!/bin/sh
set -e

if [ "$1" = "macos" ]; then

  echo "\n\033[1;32m▶ Running package tests on macOS...\033[0m"
  set -o pipefail && swift test | ./xcbeautify

elif [ "$1" = "ios" ]; then

  echo "\n\033[1;32m▶ Running package tests on iOS Simulator...\033[0m"
  set -o pipefail && xcodebuild -scheme 'xx-client-ios-db-Package' -sdk iphonesimulator -destination 'platform=iOS Simulator,OS=16.0,name=iPhone 14' test | ./xcbeautify

else

  echo "\n\033[1;31m▶ Invalid option.\033[0m Usage:"
  echo "  run-tests.sh macos        - Run package tests on macOS"
  echo "  run-tests.sh ios          - Run package tests on iOS Simulator"
  exit 1

fi
