

chrome.app.runtime.onLaunched.addListener(function() {
  chrome.app.window.create('app/index.html', {
    'width': 640,
    'height': 480
  }, function(id) {
    window.application = new Application();
	
  });
  
});

var setupOAuth = function () {
	window.application.oauth = ChromeExOAuth.initBackgroundPage({
  'request_url': 'https://www.google.com/accounts/OAuthGetRequestToken',
  'authorize_url': 'https://www.google.com/accounts/OAuthAuthorizeToken',
  'access_url': 'https://www.google.com/accounts/OAuthGetAccessToken',
  'consumer_key': 'anonymous',
  'consumer_secret': 'anonymous',
  'scope': 'https://docs.google.com/feeds/',
  'app_name': 'My Google Docs Extension'
});   

}
