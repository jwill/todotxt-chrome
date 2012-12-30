class Application
  constructor: () ->
    

    @initDatabase()
    @result = {}
    @term = new Terminal('#input-line .cmdline','.container output')
        
  
  initDatabase: () ->
    self = this
    @db = Lawnchair({name:'tododb'},(tododb) ->
      # Load URLs to files token if available
      # also last update time
      
    )

  error: (err) ->
    console.log err



   
  logOut: () ->
    @isAuthenticated = false
    @db.remove('accessToken', (token) -> 
      console.log 'Removing access token'

    )




$((ready) -> window.app = new Application())
