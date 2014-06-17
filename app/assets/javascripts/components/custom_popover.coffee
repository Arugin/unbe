###
# customPopover
# bootstrap popover with added close button
# and asynchronous content loading
#
# Options:
# @remote     Boolean   set to true if you want to load content from
# element's href
# @parseTitle Function  function that extracts title from remote data
# @parseContent Function  function that extracts content from remote data
#
# all standart popover options are supported.
#
# How to use:
# $("a.link_to_remote_content").customPopover
#   remote: true
#   title: "Remote content"
#
###
(($) ->
  $.fn.customPopover = (opts) ->
    opts = {
      animation: true
    } unless opts

    opts.template ||= """
                      <div class="popover custom-popover">
                        <div class="arrow"></div>

                        <h3>
                          <span class="popover-title"></span>
                          <i class="glyphicon glyphicon-remove-sign"></i>
                        </h3>
                        <div class="popover-content"></div>
                      </div>
                      """

    opts.placement = "top" unless opts.placement

    opts.html = true unless opts.html

    initPopover = (elem, opts) ->
      elem.popover opts

      elem.on "click", (e) ->
        e.preventDefault()

      elem.trigger("click")

      if elem.data("popover").$tip
        elem.data("popover").$tip.on "click", ".glyphicon-remove-sign", () ->
          elem.popover("hide")
        $(document).mouseup (e) ->
          if elem.next('div.popover:visible').length
            unless elem.data("popover").$tip.is(e.target)
              if elem.data("popover").$tip.has(e.target).length == 0
                elem.popover("hide")

      elem.popover("hide") unless opts.show


    # handle remote content
    if opts.remote
      delete opts.remote
      $.each @, () ->
        elem = $(@)
        remote = elem.attr "href"
        $.get remote, (data) =>
          opts.content = data
          if opts.parseTitle
            opts.title = opts.parseTitle opts.content
            delete opts.parseTitle
          if opts.parseContent
            opts.content = opts.parseContent opts.content
            delete opts.parseContent

          initPopover elem, opts

    else
      $.each @, () ->
        elem = $(@)
        initPopover elem, opts

)(jQuery)