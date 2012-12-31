class Modals
  constructor: () ->
    @modalStyles = {
      color: '#169'
      opacity: 0.85
    }

  createRemoveModal: (@task, handler) ->
    modal = picoModal({
      content: """
      Delete '#{task.raw()}' ?<br/><br/>
      <button id="yes">Yes</button>
      <button id="no">No</button>
        """,
      closeButton: true
      modalStyles: @modalStyles
    })
    document.querySelector('#yes').onclick = (evt) ->
      handler(true)
      modal.close()
    
    document.querySelector('#no').onclick = (evt) ->
      handler(false)
      modal.close()

    return modal

window.Modals = Modals
