(($) ->
  $.fn.messages = ->
    @.each ->
      container = $(this)
      messages = container.find(".message")
      if messages.length > 1
        container.addClass "pretty-messages-container"
        additionalMessagesContainer = $("<div class='additional-messages'></div>")

        for message in messages[1..]
          additionalMessagesContainer.append $(message).clone().addClass("additional-message")
          $(message).remove()

        additionalMessagesCount = messages.length - 1
        showAdditionMessageElement = $("<div class='additional-messages-link'>" + additionalMessagesCount + " more...</div>")
        showAdditionMessageElement.click ->
          additionalMessagesContainer.toggle $.fn.messages.defaults
          showAdditionMessageElement.remove()

        container.append showAdditionMessageElement
        container.append $("<div class='clear'></div>")
        container.append additionalMessagesContainer
        container.append $("<div class='clear'></div>")
        additionalMessagesContainer.hide()

  $.fn.messages.defaults =
    toggleState: "closed"
    effect: "blind"
)(window.jQuery)