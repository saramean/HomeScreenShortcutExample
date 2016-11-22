#For using Static Quick Start, you need to add follows in info.plist file
<key>UIApplicationShortcutItems</key>
    <array>
        <dict>
            <key>UIApplicationShortcutItemIconType</key>
            <string>UIApplicationShortcutIconTypeAdd</string>
            <key>UIApplicationShortcutItemType</key>
            <string>goToImagePicker</string>
            <key>UIApplicationShortcutItemTitle</key>
            <string>ImagePicker</string>
        </dict>
        <dict>
            <key>UIApplicationShortcutItemIconType</key>
            <string>UIApplicationShortcutIconTypeHome</string>
            <key>UIApplicationShortcutItemType</key>
            <string>goToMain</string>
            <key>UIApplicationShortcutItemTitle</key>
            <string>Main</string>
        </dict>
    </array>

UIApplicationShortcutItemTitle and UIApplicationShortcutItemType are required field and the others are optional.


#Open another app in app
In callee info.plist
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>com.fantagram.HomeScreenShortCutExample</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>HomeScreenShortCutExample</string>
        </array>
    </dict>
</array>

In caller's function

BOOL isInstalled = [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"AppB://"];    
if (!isInstalled) {
    // 설치 되어 있지 않습니다! 앱스토어로 안내...
    //[[UIApplication sharedApplication] openURL: [NSURL URLWithString: appstoreurl]];
}

위와 같이 호출하면 호출이 됩니다.

그런데 정보를 넘기고 싶으시다고요? 그럼 또 방법이 있죠 ㅎㅎㅎㅎ

[[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"AppB://"];   
이렇게 호출을 해줄때 AppB:// 이 뒷부분에 넘기고 싶은 정보를 넘겨주시면됩니다.


[[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"AppB://넘기고 싶은정보"];

이렇게요,


그럼 AppB에서는


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
여기에서 메세지를 받을 수 있습니다.

간단하게 받는 메세지 전부를 Alert창으로 띄우는 예제를 보시면,


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // 어플 자신이 호출된 경우에 얼럿창 띄우기 
    NSString *strURL = [url absoluteString];

    UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"call message"
                                                    message:strURL
                                                    delegate:nil 
                                                    cancelButtonTitle:@"OK" otherButtonTitles:nil];

    [alertView  show];
    [alertView  release];

    return YES;
}
