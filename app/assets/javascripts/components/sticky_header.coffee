# Add ability to stick to the top for list-header
(($) ->
  $.fn.stickyHeader = (opts = {}) ->
    topElementSelector = opts.topElementSelector || '.o-item'
    cloneOffset = opts.cloneOffset || 20

    $header = $(this)

    unless $('.header-dummy').length > 0
      $header.before($('<div/>').addClass('header-dummy').css({ height: $header.outerHeight(), width: $header.outerWidth()}))

    boundaryElement = if $(topElementSelector).length > 0 then $(topElementSelector).first().offset().top else 0
    stickyEdge = boundaryElement - cloneOffset

    $(window).on "scroll", ->
      fromTop = $(window).scrollTop()
      $('body').toggleClass "down", fromTop > stickyEdge

)(jQuery)