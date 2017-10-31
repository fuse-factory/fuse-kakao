using Uno;
using Uno.UX;
using Uno.Compiler.ExportTargetInterop;

using Fuse;

[Require("Source.Include", "KakaoOpenSDK/KakaoOpenSDK.h")]
[Require("Cocoapods.Podfile.Target", "pod 'KakaoOpenSDK', '1.5.1'")]
extern(iOS) static class KakaoTalkAPI
{
	[Foreign(Language.ObjC)]
	public static void Login(Action successCallback, Action<string> errorCallback)
	@{
		[[KOSession sharedSession] close];
		[[KOSession sharedSession] openWithCompletionHandler:^(NSError *error) {
			if ([[KOSession sharedSession] isOpen]) {
				successCallback();
			} else {
				errorCallback([NSString stringWithFormat:@"Failed to login: %@", error]);
			}
		} authType:(KOAuthType)KOAuthTypeTalk, nil];
	@}
}