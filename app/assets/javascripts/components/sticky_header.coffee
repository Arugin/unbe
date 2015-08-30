# Add ability to stick to the top for list-header
(($) ->
  $.fn.stickyHeader = (opts = {}) ->
    return if this.length == 0
    topElementSelector = opts.topElementSelector || '.o-item'
    cloneOffset = opts.cloneOffset || 20
    containerElement = opts.containerElement || '.ujs-pagination'

    $header = $(this)

    unless $('.header-dummy').length > 0
      $header.before($('<div/>').addClass('header-dummy').css({ height: $header.outerHeight(), width: $header.outerWidth()}))

    boundaryElement = if $(topElementSelector).length > 0 then $(topElementSelector).first().offset().top else $(containerElement).first().offset().top
    stickyEdge = boundaryElement - cloneOffset
    stickyEdge -= 100 unless unbe.isHeaderUnlocked()

    $(window).on "scroll", ->
      fromTop = $(window).scrollTop()
      $('body').toggleClass "down", fromTop > stickyEdge

)(jQuery)