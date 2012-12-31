$(document).ready( () ->
  apiKey = document.querySelector('#apiKey')
  saveButton = document.querySelector('#saveApi')
  clearFilesButton = document.querySelector('#clearFiles')


  db = Lawnchair({name:'tododb'}, (tododb) ->
    db.get("apiKey", (item) ->
      if item is undefined then apiKey.value = "Please add an API key" else apiKey.value = item.value
    )

    saveButton.onclick = (evt) ->
      text = apiKey.value
      db.save({key:'apiKey', value:text})

    clearFilesButton.onclick = (evt) ->
      db.remove("todo.txt")
      db.remove("done.txt")
      console.log("Removed Files")

  ))
