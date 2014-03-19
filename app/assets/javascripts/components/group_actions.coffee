$ ->
  $('.delete-selected, .archive-selected').attr('disabled', true)
  $('.delete-selected').click (e) ->
    e.preventDefault()
    selected = $('.select-control').data('selected_ids')()
    if selected.length
      message = " #{selected.length} item#{ if selected.length > 1 then 's' else '' } will be removed.\nAre you sure?"
      return unless confirm message

      action_path = $(this).attr('href')
      $.ajax(
        url: action_path
        data: { ids: selected }
        dataType: 'json'
        type: 'GET'
      ).done () ->
        location.reload();
    else
      false

  $('.select-control').on "changed", (e) =>
    $('.delete-selected, .archive-selected').attr('disabled', e.selected.length <= 0)

  $('.archive-selected').click (e) ->
    e.preventDefault()
    selected = $('.select-control').data('selected_ids')()
    window.location = $(this).attr('href') + "?" + $.param({ ids: selected }) if selected.length