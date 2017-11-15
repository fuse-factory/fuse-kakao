using Uno;
using Uno.UX;
using Uno.Compiler.ExportTargetInterop;

using Fuse;
using Fuse.Controls.Native;
using Fuse.Scripting;
using Fuse.Controls.Panel;

public class KakaoLoginButtonBase : Fuse.Controls.Panel
{
	extern(iOS || Android) KakaoLoginButtonView LoginView
	{
		get { return (KakaoLoginButtonView)ViewHandle; }
	}
}
