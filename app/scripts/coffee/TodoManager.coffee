class TodoManager
  constructor: (@outputContainer) ->
    filepicker.setKey ("")

    # TODO Load from DB
    @todoURL = ""
    @doneURL = ""
    @modals = new Modals()

    @addedTasks = []
    @doneTasks = []
    @result = {}

    @initFiles()
    @commands = [
      'a', 'add', 'addx', 'archive', 'do', 'ls', 'list'
      'rm'

      'lately'
    ]

  handleCommand: (cmd, args) ->
    switch cmd
      when 'a', 'add'   then @addTask(args)
      #when 'addx'      then
      when 'archive'   then @archive()
      when 'do'         then @doTask(args)
      when 'ls','list'  then @ls(args)
      when 'del','rm'   then @rm(args)
      #when 'depri','dp' then
      #when 'pri', 'p'   then
      when 'lately'    then new Lately(@done, args)
      #when 'nav'       then
      else @output(cmd + ': command not found')


  output: (html) ->
    @outputContainer.insertAdjacentHTML('beforeEnd', html)

  addTask: (args) ->
    task = new Task(args.join(' '), @todos.getList().length+1)
    todoFileText = "#{@prepareFile()}\n#{task.raw()}"
    # TODO Check for offline
    self = this
    @writeFile(@todoURL, todoFileText, (file) ->
      console.log("Wrote to "+file.filename)
      self.todos.list.push(task)
      self.output(self.todos.list.length+' '+task.raw()+'<br/>')
      self.output('TODO: '+self.todos.list.length+' added.<br/>')

    )

    #app.todos.list.push(task)
    #@output(@todos.list.length+' '+task.raw()+'<br/>')
    #@output('TODO: '+@todos.list.length+' added.<br/>')
    
  archive: () ->
    self = this
    # Get the finished tasks in the list
    doneTasks = @todos.doneTasks()
    doneText = ""
    doneText += task.raw() for task in doneTasks
    doneText = "#{self.result['done.txt']}\n#{doneText}"
    @writeFile(@doneURL, doneText.trim(), (file) ->
      
      #remove tasks
      self.todos.removeDone()
      self.output('TODO: '+file.filename+' archived.<br/>')

    )

  rm: (args) ->
    self = this
    console.log(args)
    num = args[0]
    task = _.find(@todos.getList(), (item) -> 
      return new Number(item.index).toFixed() is new Number(num).toFixed()
    )

    handler = (result) ->
      if result 
        self._rm(task.index) 
      else self.output("TODO: No tasks were deleted.")

    @modals.createRemoveModal(task, handler) if task isnt undefined

  _rm: (index) ->
    self = this
    task = _.find(@todos.getList(), (item) -> 
      return new Number(item.index).toFixed() is new Number(index).toFixed()
    )
    @todos.list = _.filter(@todos.getList(), (item) ->
      return new Number(item.index).toFixed() isnt new Number(index).toFixed()
    )

    todoFileText = @prepareFile()
    # TODO Check for offline
    @writeFile(@todoURL, todoFileText, (file) ->
      console.log("Wrote to "+file.filename)
      
      self.output("#{task.index} #{task.raw()}<br/>")
      self.output("TODO: #{task.index} deleted.")
    )

    console.log("removed")
    # save new list to file


  doTask: (args) ->
    num = args[0]
    
    task = @todos.list[num-1]

    task.markAsDone()
    @output("#{num} #{task.toString()}<br/>")
    @output("TODO: #{num} marked as done.<br/>")
    @output(task+'<br/>')
    console.log(task)
    # Archive task if online
    @archive()
  
  ls: (args) ->
    # TODO Make DRY and make numbers persistent
    console.log('args:'+args)
    self = this
    if (args.length == 0) 
      self = this
      count = 0
      _.each(@todos.list, (it) ->
        count++
        i = it.index
        # pad zeros
        ii = if (i < 10) then '0'+i else ""+i
        self.output(ii + ' '+it.raw() + '<br/>')
      )
      @output('-- <br/>')
      @output("TODO: #{count} of #{@todos.list.length} tasks shown<br/>")
    else if (args[0].indexOf('+')==0) 
      console.log(@todos.byProject(args[0]))
      tasks = @todos.byProject(args[0])
      count = 0
      _.each(tasks, (it) ->
        count++
        i = it.index
        # pad zeros
        ii = if (i < 10) then '0'+i else ""+i
        self.output(ii + ' '+it.raw() + '<br/>')
      )
      @output('-- <br/>')
      @output("TODO: #{count} of #{@todos.list.length} tasks shown<br/>")

    else if (args[0].indexOf('@')==0) 
      console.log(@todos.byContext(args[0]))
      tasks = @todos.byContext(args[0])
      i = 0
      _.each(tasks, (it) ->
        i++
        # pad zeros
        ii = if (i < 10) then '0'+i else ""+i
        self.output(ii + ' '+it.raw() + '<br/>')
      )
      @output('-- <br/>')
      @output("TODO: #{i} of #{@todos.list.length} tasks shown<br/>")

  initFiles: () ->
    @downloadFile({filename:'todo.txt', url:@todoURL})
    @downloadFile({filename:'done.txt', url:@doneURL})

  downloadFile: (params) ->
    console.log ('Loading ' + params['filename'] + ' ...')
    self = this
    file = {url:params.url, asText:true}
    #console.log(file)
    filepicker.read(file, (data) -> 
      #console.log(data)
      self.result[params['filename']] = data
      lines = data.split('\n')
      if params.filename is 'todo.txt'
        self.todos = new TodoList(lines)
      if params.filename is 'done.txt'
        self.done = new TodoList(lines)
    )

  prepareFile: () ->
    @todos.list.join("\n")

  writeFile: (fileURL, data, callback) ->
    fpfile = {url: fileURL, mimetype: 'text/plain', isWriteable: true}
    filepicker.write(fpfile,
      data,
      callback
      (error) ->
        console.log("Error: "+error.toString())
    )

  
window.TodoManager = TodoManager
