using Uno;
using Uno.UX;
using Fuse;
using Fuse.Scripting;
using Uno.Collections;
using Uno.Threading;
using Uno.Permissions;

[UXGlobalModule]
public class KakaoTalkJavaScript : NativeModule
{

	class KakaoLoginPromise : Promise<string>
	{

		public KakaoLoginPromise()
		{
			if defined(Android)
			{
				Permissions.Request(Permissions.Android.INTERNET).Then(
					OnPermissionsPermitted,
					OnPermissionsRejected);
			}
			else
			{
				Fuse.UpdateManager.AddOnceAction(Login);
			}
		}

		void Login()
		{
			if defined(iOS || Android)
				KakaoTalkAPI.Login(this.Resolve, OnError);
			else
				throw new NotImplementedException();
		}

		void OnError(string error)
		{
			Reject(new Exception(error));
		}

		extern(Android) void OnPermissionsPermitted(PlatformPermission p)
		{
			Fuse.UpdateManager.AddOnceAction(Login);
		}

		extern(Android) void OnPermissionsRejected(Exception e)
		{
			Reject(e);
		}
	}

	static KakaoTalkJavaScript _instance;
	
	public KakaoTalkJavaScript()
	{
		if(_instance != null) return;
		Resource.SetGlobalKey(_instance = this, "KakaoTalk");
		AddMember(new NativePromise<string,object>("doLogin", DoLogin));

	}

	Future<string> DoLogin(object[] args)
	{
		return new KakaoLoginPromise();
	}
}
