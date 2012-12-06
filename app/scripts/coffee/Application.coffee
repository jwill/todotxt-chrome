class Application
  constructor: () ->
    @options = {
      consumerKey:'ykh4hwrpts2nqze'
      consumerSecret:'d733tcrpmvc4s1r'
    }

    @oauth = OAuth(@options)
    @oauth.requestTokenUrl = 'https://api.dropbox.com/1/oauth/request_token'
    @oauth.authorizationUrl = 'https://www.dropbox.com/1/oauth/authorize'
    @oauth.accessTokenUrl = 'https://api.dropbox.com/1/oauth/access_token'

    @initDatabase()
    @result = {}
    @term = new Terminal('#input-line .cmdline','.container output')
    
  
  initDatabase: () ->
    self = this
    @db = Lawnchair({name:'tododb'},(tododb) ->
      # Load access token if available
      @get('accessToken', (token) ->
        
        self.oauth.setAccessToken(token.data) if token isnt undefined
        self.isAuthenticated = true if token?.data isnt undefined
        self.initAuthFlow() if self.isAuthenticated isnt true

        self.initFiles() if self.isAuthenticated is true
      )
    )
  error: (err) ->
    console.log err

  openAuthWindow: (url) ->
    window.open (url)
    # Put message on main page to click when done
  
  initAuthFlow: () ->
    self = this
    @oauth.fetchRequestToken (self.openAuthWindow)
    
  completeAuthFlow: () ->
    self = this
    @oauth.fetchAccessToken (
      (token) ->
        self.db.save({key:'accessToken', data:self.oauth.getAccessToken()}, (e) ->
          console.log('access token saved')
        )
    )

  initFiles: () ->
    @downloadFile('todo.txt')
    @downloadFile('done.txt')


  downloadFile: (filename) ->
    console.log ('Loading ' + filename + ' ...')
    self = this
    @oauth.get('https://api-content.dropbox.com/1/files/dropbox/todo/'+filename, (e) ->
      console.log(e)
      self.result[filename] = e
      text = e.text
      lines = text.split('\n')
      if filename is 'todo.txt'
        self.todos = new TodoList(lines)
    )

  logOut: () ->
    @isAuthenticated = false
    @oauth.setAccessToken(['',''])
    @db.remove('accessToken', (token) -> 
      console.log 'Removing access token'

    )


  writeFile: (filename, data) ->

$((ready) -> window.app = new Application())
