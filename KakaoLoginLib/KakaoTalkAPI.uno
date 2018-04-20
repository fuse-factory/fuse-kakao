using Uno;
using Uno.UX;
using Uno.Compiler.ExportTargetInterop;

using Fuse;

[Require("Source.Include", "KakaoOpenSDK/KakaoOpenSDK.h")]
[Require("Cocoapods.Podfile.Target", "pod 'KakaoOpenSDK', '1.5.1'")]
extern(iOS) static class KakaoTalkAPI
{
	[Foreign(Language.ObjC)]
	public static void Login(Action<string> successCallback, Action<string> errorCallback)
	@{
		[[KOSession sharedSession] close];
		[[KOSession sharedSession] openWithCompletionHandler:^(NSError *error) {
			if ([[KOSession sharedSession] isOpen]) {
				successCallback(@"Succeeded to login");
			} else {
				errorCallback([NSString stringWithFormat:@"Failed to login: %@", error]);
			}
		} authType:(KOAuthType)KOAuthTypeTalk, nil];
	@}
}

[Require("Gradle.Repository", "maven { url 'http://devrepo.kakao.com:8088/nexus/content/groups/public/' }")]
[Require("Gradle.Dependency.Compile", "com.kakao.sdk:usermgmt:1.5.1@aar")]
extern (Android) static class KakaoTalkAPI
{
	[Foreign(Language.Java)]
	public static void Login(Action<string> successCallback, Action<string> errorCallback)
	@{
		//perform login here
	@}
}
