class TodoList
  constructor: (args) ->
    @list = []
    
    if args instanceof Array
      
      for item in args
        if (item.constructor.name is 'String' && item isnt "")
          @list.push(new Task(item))
        else if (item instanceof Task)
          @list.push(item)

  byPriority: (priority) ->
    task for task in @list when task.priority() == "("+priority+")"

  byContext: (context) ->
    l = []
    for task in @list
      ctx = task.contexts()
      if (ctx and context in ctx)
        l.push task
    l 

  byProject: (project) ->
    l = []
    for task in @list
      proj = task.projects()
      if (proj and project in proj)
        l.push task
    l

  sort: () ->

window.TodoList = TodoList
