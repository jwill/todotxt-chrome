class TodoManager
  constructor: (@outputContainer) ->
    

  handleCommand: (cmd, args) ->
    switch cmd
      when 'a', 'add'   then @addTask(args)
      #when 'addx'      then
      #when 'archive'   then
      when 'do'         then @doTask(args)
      when 'ls','list'  then @ls(args)
      when 'del','rm'   then @rm(args)
      #when 'depri','dp' then
      #when 'pri', 'p'   then
      #when 'lately'    then
      #when 'nav'       then
      else @output(cmd + ': command not found')


  output: (html) ->
    @outputContainer.insertAdjacentHTML('beforeEnd', html)

  addTask: (args) ->
    task = new Task(args.join(' '))
    app.todos.list.push(task)
    @output(app.todos.list.length+' '+task.raw()+'<br/>')
    @output('TODO: '+app.todos.list.length+' added.<br/>')

  rm: (args) ->
    num = args[0]
    task = app.todos.list[num-1]
    console.log(task)

  doTask: (args) ->
    num = args[0]
    task = app.todos.list[num-1]
    task.markAsDone()
    @output("#{num} #{task.toString()}<br/>")
    @output("TODO: #{num} marked as done.<br/>")
    @output(task+'<br/>')
    console.log(task)
    # Archive task
    
  ls: (args) ->
    console.log('args:'+args)
    self = this
    if (args.length == 0) 
      self = this
      i = 0
      _.each(app.todos.list, (it) ->
        i++
        # pad zeros
        ii = if (i < 10) then '0'+i else ""+i
        self.output(ii + ' '+it.raw() + '<br/>')
      )
      @output('-- <br/>')
      @output("TODO: #{i} of #{app.todos.list.length} tasks shown<br/>")
    else if (args[0].indexOf('+')==0) 
      console.log(app.todos.byProject(args[0]))
    else if (args[0].indexOf('@')==0) 
      console.log(app.todo.byContext(args[0]))


window.TodoManager = TodoManager
