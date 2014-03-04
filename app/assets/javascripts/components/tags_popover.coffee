(($) ->
  $.fn.tagsPopover = (opts = {}) ->
    return $(this) if $(this).data('popover')
    $(this).customPopover({ placement: 'bottom', trigger: 'manual', show: false, content: opts.tags_input })
    $(this).attr('disabled', true)
    $(this).click (e)->
      selected = $('.select-control').data('selected_ids')()
      return unless selected.length

      $el = $(this)
      $el.popover('show');
      $popover = $el.data('popover').$tip
      old_width = $popover.css('width')

      changeSelectedCount = (count) ->
        $popover.find('.popover-title').html("Tag #{count} Selected Project#{ if count > 1 then 's' else '' }")

      $popover.addClass('tags-popover');
      changeSelectedCount(selected.length)
      $popover.find(".select2tags").select2( {width: "280px", tags: $(".select2tags").data("tags"), tokenSeparators: [","]})

      #Rendered popover will be slight shifted after modifications
      $popover.css('left', parseInt($popover.css('left')) - (parseInt($popover.css('width')) - parseInt(old_width))/2);

      $popover.find('.icon-remove-sign').add($popover.find('.cancel')).click () ->
        $el.popover('hide');

      $popover.find('.apply').click ()->
        tags = $popover.find(".select2tags").select2('data').map (d) ->
          d.text
        return if selected.length == 0 or tags.length == 0

        action_path = $el.attr('href')
        $.ajax(
          url: action_path
          data: { ids: selected, tags: tags }
          dataType: 'json'
          type: 'PUT'
        ).done () ->
          location.reload();

      # Close popover on off-click. Special conditions for IE
      $("body").on "click", (e) ->
        $el.popover "hide" if not $el.is(e.target) and
        $el.has(e.target).length is 0 and
        $(".popover").has(e.target).length is 0 and
        $(e.target).attr('class')?.indexOf("select2") != -1

      $(window).on "scroll", () ->
        $el.popover('hide');
        $popover.find(".select2tags").select2("close")

    $('.select-control').on "changed", (e) =>
      $(this).attr('disabled', e.selected.length <= 0)

)(jQuery)