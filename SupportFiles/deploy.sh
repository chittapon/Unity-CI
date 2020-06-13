JENKINS_PIPELINE_NAME="Unity CI"
PROJECT_PATH="$(dirname "$(PWD)")""/$JENKINS_PIPELINE_NAME"
IOS_RELEASE=$PROJECT_PATH'/Builds/iOS/build/release'
LOGS_PATH=$PROJECT_PATH'/Logs'

echo ''
echo 'export ipa...' 
echo '' 
xcodebuild -exportArchive -archivePath "$IOS_RELEASE/Unity-iPhone.xcarchive" -exportOptionsPlist "SupportFiles/release/options.plist" -exportPath "$IOS_RELEASE" -quiet > "$LOGS_PATH/ios_export_release.log" 2>&1
echo ''
echo 'validating...' 
echo ''
xcrun altool --validate-app -f "$IOS_RELEASE/Unity-iPhone.ipa" --apiKey Z23NQ47D86 --apiIssuer 47c78144-ee93-4eec-8f89-278d395255a5 —verbose
echo ''
echo 'uploading...' 
echo ''
xcrun altool --upload-app --file "$IOS_RELEASE/Unity-iPhone.ipa" --apiKey Z23NQ47D86 --apiIssuer 47c78144-ee93-4eec-8f89-278d395255a5 —verbose