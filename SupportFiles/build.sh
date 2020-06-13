#!/bin/bash

PROJECT_PATH="$(dirname "$(PWD)")"

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
rm -r $IOS_PATH
fi
echo "$IOS_PATH"
echo ''
echo 'build unity...' 
echo '' 
$UNITY -batchmode -quit -executeMethod BuildScript.iOSDevelopment -buildTarget ios -logFile "$LOGS_PATH/ios_develop.log"
if [ $? -ne 0 ]; then
echo ''
echo 'Operation failed!'
echo '' 
exit 1
fi
echo ''
echo 'archive xcode...' 
echo '' 
xcodebuild -project "$IOS_PATH/Unity-iPhone.xcodeproj" -scheme "Unity-iPhone" archive -archivePath "$IOS_RELEASE/Unity-iPhone.xcarchive" PROVISIONING_PROFILE_SPECIFIER="$PROVISIONING_PROFILE" CODE_SIGN_IDENTITY="$SIGNING_IDENTITY" -quiet > "$LOGS_PATH/ios_archive_release.log" 2>&1
echo ''
echo 'export ipa...' 
echo '' 
xcodebuild -exportArchive -archivePath "$IOS_RELEASE/Unity-iPhone.xcarchive" -exportOptionsPlist "release/options.plist" -exportPath $IOS_RELEASE -quiet > "$LOGS_PATH/ios_export_release.log" 2>&1
echo ''
echo 'validating...' 
echo ''
xcrun altool --validate-app -f "$IOS_RELEASE/Unity-iPhone.ipa" --apiKey Z23NQ47D86 --apiIssuer 47c78144-ee93-4eec-8f89-278d395255a5 —verbose
echo ''
echo 'uploading...' 
echo ''
xcrun altool --upload-app --file "$IOS_RELEASE/Unity-iPhone.ipa" --apiKey Z23NQ47D86 --apiIssuer 47c78144-ee93-4eec-8f89-278d395255a5 —verbose