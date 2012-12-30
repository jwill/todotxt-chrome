class Lately
  constructor: (@done, args) ->
    @outputContainer = document.querySelector('.container output')

    console.log(args.length)
    if args.length is 0
      @days = 7
    else if args.length = 1 and args[0] isnt 'usage'
      @days = args[0]
    else 
      @usage()
      return
    if args.length = 2
      @project = args[1]
    today = moment().hours(0).minutes(0).seconds(0)
    @startDate = today.subtract('d',new Number(@days))

    header = "Closed tasks since #{@startDate.format('YYYY-MM-DD')}"
    header += " for Project #{@project}" if (@project isnt undefined)
    @output @color(header+'<br/><br/>', 'red')
    @printTasks()

  output: (html) ->
    @outputContainer.insertAdjacentHTML('beforeEnd', html)

  printTask: (d,r) ->
    @output( @color(d.format('YYYY-MM-DD'),'green') + @color(r,'yellow') + "<br/>")

  color: (html, c) ->
    "<span style='color:#{c}'>#{html}</span>"

  printTasks: () ->
	  if @project is undefined
		  for task in @done.list
			  date = moment(task.date().toString().trim())
			  restOfLine = task.raw().substr(12)
	
			  @printTask(date, restOfLine)	if @startDate <= date
	  else
			tasks = @done.byProject(@project)
			for t in tasks
				date = moment(t.date().toString().trim())
				restOfLine = t.raw().substr(12)
				@printTask(date, restOfLine) if @startDate <= date

  usage: () ->
    @output "Recently comlpeted tasks:<br/>"
    @output "lately+<br/>"
    @output "<br/>&nbsp;&nbsp;generates a list of completed tasks during the last 7 days.<br/><br/>"
    @output "&nbsp;&nbsp;Optional argument (integer) overrides number of days.<br/>"
    @output "&nbsp;&nbsp;Optional argument (String) project name.<br/>"

window.Lately = Lately
