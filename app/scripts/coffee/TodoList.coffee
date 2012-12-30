class TodoList
  constructor: (args) ->
    @list = []
    
    if args instanceof Array
      i = 0
      for item in args
        if (item.constructor.name is 'String' && item isnt "")
          @list.push(new Task(item, ++i))
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
  doneTasks: () ->
    _.filter(@list, (task) -> task.isDone() is true)

  removeDone: () ->
    @list = _.filter(@list, (task) -> task.isDone() is false)


  sort: () ->

  getList: () ->
    @list

window.TodoList = TodoList
