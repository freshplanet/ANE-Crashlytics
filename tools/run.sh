#!/bin/sh
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ $# -lt 3 ]; then
	echo Usage: run.sh CRASHLYTICS_API_KEY PATH_TO_IPA PATH_TO_DSYM [-v]
	echo Option: -v verbose output
	exit 1
fi

# Export some variables to be used by the upload script
export CRASHLYTICS_FRAMEWORK_PATH=$SCRIPT_DIR/../ios/Crashlytics.framework
export CRASHLYTICS_API_KEY=$1
export IPA_PATH=$2
export DSYM_PATH=$3

# Run the Xcode project that contains a custom build phase that will run the
# Crashlytics upload script based on the variable previously exported
if [ $# -gt 3 ] && [ $4 = "-v" ]; then
	xcodebuild -project $SCRIPT_DIR/dsymupload.xcodeproj
else
	xcodebuild -project $SCRIPT_DIR/dsymupload.xcodeproj >/dev/null
fi

# Cleanup
rm -rf $SCRIPT_DIR/build