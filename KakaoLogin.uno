using Uno;
using Uno.UX;
using Uno.Compiler.ExportTargetInterop;

using Fuse;
using Fuse.Controls.Native;
using Fuse.Scripting;
using Fuse.Controls.Panel;

public class KakaoLoginButtonBase : Fuse.Controls.Panel
{
	KakaoLoginButtonView LoginView 
	{
		get { return (KakaoLoginButtonView)NativeView; }
	}
	
	protected override void OnRooted()
	{
		base.OnRooted();

		var lv = LoginView;
		if (lv != null)
			lv.OnRooted();
	}

	protected override void OnUnrooted()
	{
		var lv = LoginView;
		if (lv != null)
			lv.OnUnrooted();

		base.OnUnrooted();
	}
}
