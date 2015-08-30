(($) ->
  $.fn.listHeader = (opts = {}) ->
    return if this.hasClass('dynamic-reload')
    this.addClass 'dynamic-reload'

    initPath = ()->
      $.address.path(document.location.pathname) if $.address.path() == '/'

    request = ()->
      $.getScript($.address.value());

    $('.scope-switch a').click (e) ->
      e.preventDefault()
      initPath()

      $('.scope-switch a').removeClass('on')
      $target = $(e.currentTarget)
      $target.addClass('on')

      scope = if $target.hasClass('scope-my') then 'true' else ''
      $.address.parameter( 'unprocessed', scope )
      request()

    $('.sort-order').click (e) ->
      e.preventDefault()
      initPath()
      $arrow = $('.sort-order i')

      direction = if $arrow.hasClass('fa-arrow-down') then 'asc' else 'desc'
      $.address.parameter( 'direction', direction )
      $arrow.toggleClass("fa-arrow-up fa-arrow-down");
      request()

    $('.sort-control .dropdown-menu a').click (e) ->
      e.preventDefault()
      initPath()
      $target = $(e.target)

      $.address.parameter( 'sort_by', $target.attr('data-sort-by') )
      $('.sort-control .dropdown-toggle .text').text($target.html())
      request()

    $('.area-link').click (e) ->
      if document.location.pathname != '/articles/garbage'
        e.preventDefault()
        initPath()
        item = $(this)
        area = item.data('area')
        $.address.parameter( 'article_area', area )
        $('.all-articles li a').removeClass('active')
        item.find('a').addClass('active')
        request()

    $('#models_search').submit () ->
      initPath()
      form = $(@)
      search = form.find('#search').val();
      $.address.parameter( 'search', search )
      request()
      false

)(jQuery)