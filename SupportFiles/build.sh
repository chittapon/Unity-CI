#!/bin/bash

JENKINS_PIPELINE_NAME="Unity CI"
PROJECT_PATH="$(dirname "$(PWD)")""/$JENKINS_PIPELINE_NAME"

UNITY='/Applications/Unity/Hub/Editor/2020.1.0b12/Unity.app/Contents/MacOS/Unity'

LOGS_PATH=$PROJECT_PATH'/Logs'
ANDROID_PATH=$PROJECT_PATH'/Builds/Android'
BUILDS_PATH=$PROJECT_PATH'/Builds'
IOS_PATH=$PROJECT_PATH'/Builds/iOS'
IOS_BUILD_PATH=$PROJECT_PATH'/Builds/iOS/build'
IOS_DEVELOPMENT=$PROJECT_PATH'/Builds/iOS/build/development'
IOS_RELEASE=$PROJECT_PATH'/Builds/iOS/build/release'
INFOPLIST_FILE='Info.plist'

SIGNING_IDENTITY="Apple Distribution: Chittapon Thongchim"
PROVISIONING_PROFILE="4233980a-acb6-41b4-bf69-f724f5c90f2d"
BUILD_NUMBER="1"

echo 'project path: '"$PROJECT_PATH"
echo ''
if [ -d "$IOS_PATH" ]; then
echo ''
echo 'clean ios directory...' 
echo ''

BUILD_NUMBER=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$IOS_PATH/$INFOPLIST_FILE")
BUILD_NUMBER=$(($BUILD_NUMBER + 1))
rm -r "$IOS_PATH"
fi
echo ''
echo 'build unity...' 
echo '' 
$UNITY -batchmode -quit -projectPath "$PROJECT_PATH" -executeMethod BuildScript.iOSRelease -buildTarget ios -logFile "$LOGS_PATH/ios_release.log"
if [ $? -ne 0 ]; then
echo ''
echo 'Operation failed!'
echo '' 
exit 1
fi
echo ''
echo 'build version: '"$BUILD_NUMBER" 
echo '' 
echo ''
echo 'archive xcode...' 
echo ''
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BUILD_NUMBER" "$IOS_PATH/$INFOPLIST_FILE"
xcodebuild -project "$IOS_PATH/Unity-iPhone.xcodeproj" -scheme "Unity-iPhone" archive -archivePath "$IOS_RELEASE/Unity-iPhone.xcarchive" PROVISIONING_PROFILE_SPECIFIER="$PROVISIONING_PROFILE" CODE_SIGN_IDENTITY="$SIGNING_IDENTITY" -quiet > "$LOGS_PATH/ios_archive_release.log" 2>&1