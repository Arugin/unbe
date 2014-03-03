# Allow to change list items without page refresh. Depend on Jquery.address plugin.
(($) ->
  $.fn.listHeader = (opts = {}) ->
    return if this.hasClass('dynamic-reload')
    this.addClass 'dynamic-reload'

    initPath = ()->
      $.address.path(document.location.pathname) if $.address.path() == '/'

    # All/my scope
    $('.scope-switch a').click (e) ->
      e.preventDefault()
      initPath()

      $('.scope-switch a').removeClass('on')
      $target = $(e.currentTarget)
      $target.addClass('on')

      scope = if $target.hasClass('scope-my') then 'true' else ''
      $.address.parameter( 'unprocessed', scope )

    # Sort direction
    $('.sort-order').click (e) ->
      e.preventDefault()
      initPath()
      $arrow = $('.sort-order i')

      direction = if $arrow.hasClass('icon-arrow-down') then 'asc' else 'desc'
      $.address.parameter( 'direction', direction )
      $arrow.toggleClass("icon-arrow-up icon-arrow-down");

    # Sort by
    $('.sort-control .dropdown-menu a').click (e) ->
      e.preventDefault()
      initPath()
      $target = $(e.target)

      $.address.parameter( 'sort_by', $target.attr('data-sort-by') )
      $('.sort-control .dropdown-toggle .text').text($target.html())


)(jQuery)