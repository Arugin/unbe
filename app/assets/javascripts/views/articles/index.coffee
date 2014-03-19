$(document).ready ()->

  initPath = ()->
    $.address.path(document.location.pathname) if $.address.path() == '/'

  $('.area-link').click (e) ->
    if document.location.pathname != '/articles/garbage'
      e.preventDefault()
      initPath()
      item = $(this)
      area = item.data('area')
      $.address.parameter( 'article_area', area )
      $('.all-articles li a').removeClass('active')
      item.find('a').addClass('active')