class Application
  constructor: () ->
    @term = new Terminal('#input-line .cmdline','.container output')
        
$((ready) -> window.app = new Application())
