$(document).ready () ->
  # disable disabled links
  $('body').on 'click', '*[disabled], .disabled', (e) ->
    e.preventDefault()
    e.stopPropagation()
  $('*[disabled]').addClass('disabled')