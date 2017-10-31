using Uno;
using Fuse;

public partial class MainView
{

	public void LoginClicked(object sender, object args)
	{
		if defined(iOS)
		{
			KakaoTalkAPI.Login(OnLoginSuccess, OnLoginFailed);
		}
	}

	void OnLoginSuccess()
	{
		debug_log("OnLoginSuccess");
	}

	void OnLoginFailed(string errorMessage)
	{
		debug_log(errorMessage);
	}

}