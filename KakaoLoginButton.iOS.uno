using Uno;
using Uno.UX;
using Uno.Compiler.ExportTargetInterop;

using Fuse;
using Fuse.Controls;
using Fuse.Controls.Native;
using Fuse.Controls.Native.iOS;

extern(!iOS) class KakaoLoginButtonView
{
}

[Require("Source.Include", "UIKit/UIKit.h")]
[Require("Source.Include", "KakaoOpenSDK/KakaoOpenSDK.h")]
[Require("Cocoapods.Podfile.Target", "pod 'KakaoOpenSDK', '1.5.1'")]
extern(iOS) class KakaoLoginButtonView : LeafView
{
	public KakaoLoginButtonView() : base(Create()) {}

	[Foreign(Language.ObjC)]
	static ObjC.Object Create()
	@{
		UIButton* kakaoLoginButton = [[KOLoginButton alloc] init];
		return kakaoLoginButton;
	@}
}

