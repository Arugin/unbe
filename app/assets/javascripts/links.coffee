$(document).ready () ->
  # disable disabled links
  $('body').on 'click', '*[disabled], .disabled, .inactive', (e) ->
    e.preventDefault()
    e.stopPropagation()
  $('*[disabled]').addClass('disabled')