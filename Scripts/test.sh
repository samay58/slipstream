#!/bin/sh
set -eu
. "$(dirname "$0")/lib.sh"
ensure_simulator
./Scripts/test-source-fingerprint.sh
swift test --package-path Packages/SlipstreamKit
xcodebuild_serial test -scheme Slipstream -destination "$simulator_destination" -only-testing:SlipstreamTests
xcodebuild_interface_tests -scheme Slipstream -destination "$simulator_destination" -only-testing:SlipstreamUITests
