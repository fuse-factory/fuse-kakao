using Uno;
using Uno.UX;
using Uno.Compiler.ExportTargetInterop;

using Fuse;
using Fuse.Controls;
using Fuse.Controls.Native;
using Fuse.Controls.Native.iOS;

extern(!iOS) class KakaoLoginButtonView
{
	//[UXConstructor]
	//public KakaoLoginButtonView([UXParameter("Host")]IDatePickerHost host) { }
}

[Require("Source.Include", "UIKit/UIKit.h")]
[Require("Xcode.FrameworkDirectory", "@('kakao-ios-sdk-1.5.1':Path)")]
[Require("Xcode.Framework", "@('kakao-ios-sdk-1.5.1/KakaoOpenSDK.framework':Path)")]
[Require("Source.Include", "KakaoOpenSDK/KakaoOpenSDK.h")]
extern(iOS) class KakaoLoginButtonView : LeafView
{
	public KakaoLoginButtonView() : base(Create()) {}
	
	[Foreign(Language.ObjC)]
	static ObjC.Object Create()
		@{
		int xMargin = 30;
		int marginBottom = 25;
		CGFloat btnWidth = self.view.frame.size.width - xMargin * 2;
		int btnHeight = 42;

		UIButton* kakaoLoginButton
			= [[KOLoginButton alloc] initWithFrame:CGRectMake(xMargin, self.view.frame.size.height-btnHeight-marginBottom, btnWidth, btnHeight)];
		kakaoLoginButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;

		return kakaoLoginButton;
		@}

	public void OnRooted()
	{
		// Do nothing
	}

	public void OnUnrooted()
	{
		// Do nothing
	}
}

