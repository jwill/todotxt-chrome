class Task
    constructor: (@task) ->

    # Returns the priority, if any.
    priority: () ->
      @task.match(Task.priority_regex)?.toString()?.trim()

    # Retrieves an array of all the @context annotations.
    contexts: () ->
      ctx = @task.match(Task.contexts_regex)
      if ctx
        c.trim() for c in ctx

    # Retrieves an array of all the +project annotations.
    projects: () ->
      proj = @task.match(Task.projects_regex)
      if proj
        p.trim() for p in proj

    # returns properties
    properties: () ->
      propsList = {}
      props = @task.match(Task.props_regex)
      for p in props
        [key, value] = p.split(':')
        propsList[key] = value

      return propsList

    # Retrieves the date.
    date: () ->
      try 
        @task.match(Task.date_regex)[1]
      catch err
        return
    
    # Returns text of task
    raw: ->
      @task
    
    overdue: () ->
      if @date is undefined
        return
      else if @date < new Date()
        true
      else false

    # Gets text of todo without priorities, contexts, projects, or dates
    text: () ->
      @task.replace(Task.priority_regex, "").
        replace(Task.contexts_regex, "").
        replace(Task.date_regex, "").
        replace(Task.projects_regex, "").
        replace(Task.property_regex, "")

    # TODO Compare to other task priority

    # The regular expression used to match contexts.
    @contexts_regex = /(?:\s+|^)@\w+/g

    # The regex used to match projects.
    @projects_regex = /(?:\s+|^)\+\w+/g

    # The regex used to match priorities.
    @priority_regex = /^\([A-Za-z]\)\s+/

    # The regex used to match dates.
    @date_regex = /([0-9]{4}-[0-9]{2}-[0-9]{2})/

    # The regex used to match properties.
    @props_regex = /\w+:\w+/g

    toString: () ->
      @raw()
    

window.Task = Task

