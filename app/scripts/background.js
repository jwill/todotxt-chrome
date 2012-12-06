chrome.app.runtime.onLaunched.addListener(function() {
  chrome.app.window.create('app/index.html', {
    'width': 640,
    'height': 480
  }, function(id) {
    window.application = new Application();
	
  });
  
});
