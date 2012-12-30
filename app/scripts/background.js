/*chrome.app.runtime.onLaunched.addListener(function() {
  chrome.app.window.create('app/index.html', {
    'width': 640,
    'height': 480
  }, function(id) {
    window.application = new Application();
	
  });
  
});*/


chrome.browserAction.onClicked.addListener(function(tab) {
  alert("here");
  // chrome.tabs.query({url:'app/index.html')
  chrome.tabs.create({url:'app/index.html'}, function(tab){
    window.application = new Application();
  });
});
