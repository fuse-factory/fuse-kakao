using Uno;
using Uno.UX;
using Uno.Compiler.ExportTargetInterop;

using Fuse;
using Fuse.Controls;
using Fuse.Controls.Native;
using Fuse.Controls.Native.Android;

[Require("Gradle.Repository", "maven { url 'http://devrepo.kakao.com:8088/nexus/content/groups/public/' }")]
[Require("Gradle.Dependency.Compile", "com.kakao.sdk:network:1.5.1@aar")]
[Require("Gradle.Dependency.Compile", "com.kakao.sdk:auth:1.5.1@aar")]
[Require("Gradle.Dependency.Compile", "com.kakao.sdk:util:1.5.1@aar")]
[Require("Gradle.Dependency.Compile", "com.kakao.sdk:usermgmt:1.5.1@aar")]
[ForeignInclude(Language.Java, "com.kakao.usermgmt.LoginButton")]
[ForeignInclude(Language.Java, "android.util.TypedValue")]
extern(Android) class KakaoLoginButtonView : LeafView
{
	public KakaoLoginButtonView() : base(Create()) {}

	[Foreign(Language.Java)]
	static Java.Object Create()
	@{
		com.kakao.auth.KakaoSDK.init(
			new com.kakao.sdk.customadapter.KakaoSDKAdapter(
				@(Activity.Package).@(Activity.Name).GetRootActivity()));

		// return android kakao login button here
		com.kakao.usermgmt.LoginButton loginButton
			= new com.kakao.usermgmt.LoginButton(
				@(Activity.Package).@(Activity.Name).GetRootActivity());

		loginButton.setLayoutParams(new android.widget.FrameLayout.LayoutParams(android.view.ViewGroup.LayoutParams.MATCH_PARENT, android.view.ViewGroup.LayoutParams.MATCH_PARENT));
		return loginButton;
	@}

}
