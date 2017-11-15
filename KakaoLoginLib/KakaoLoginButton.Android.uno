using Uno;
using Uno.UX;
using Uno.Compiler.ExportTargetInterop;

using Fuse;
using Fuse.Controls;
using Fuse.Controls.Native;
using Fuse.Controls.Native.Android;

[Require("Gradle.Repository", "maven { url 'http://devrepo.kakao.com:8088/nexus/content/groups/public/' }")]
[Require("Gradle.Dependency.Compile", "com.kakao.sdk:usermgmt:1.5.1@aar")]
extern(Android) class KakaoLoginButtonView : LeafView
{
	public KakaoLoginButtonView() : base(Create()) {}

	[Foreign(Language.Java)]
	static Java.Object Create()
	@{
		// return android kakao login button here
		return null;
	@}
}

