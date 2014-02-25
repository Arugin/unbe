# Jquery plugin for creating checkbox with advanced logic
# Include tristate checkbox and dropdown menu to check all or none checkboxes from list
#
# Can be configured by
#   passing mainCheckBox function-selector of main checkbox, which became tristate
#   passing list_check_box_selector string-selector of list checkboxes
#   passing parent_selector string-selector of parent block (to add a 'selected' class)
#
# Fire 'changed' event if list of selected id changes
# Store list of selected ids in data-attribute 'selected_ids'
#
# Expected markup (in haml)
#  .dropdown.select-control
#    %a.dropdown-toggle.btn.btn-small{"data-toggle" => "dropdown", href: "#"}
#      = check_box_tag 'select'
#      %b.caret
#    %ul.dropdown-menu{role: "menu"}
#      %li.select-all Select all
#      %li.select-none Select none

(($) ->
  $ ->
    $('.select-control').selectControl()

  $.fn.selectControl = (opts = {}) ->
    main_checkbox = () ->
      $('.select-control input[type="checkbox"]')

    main_checkbox = opts.mainCheckBox || main_checkbox
    list_check_box_selector = opts.listCheckBoxSelector || '.item-select input[type="checkbox"]'
    parent_selector = opts.parentSelector || '.block'

    get_selected_ids = () ->
      ids = []
      $(list_check_box_selector).each ()->
        ids.push $(this).val() if $(this).is(':checked')
      ids

    $.each this, () ->
      $control = $(this)
      $control.data('selected_ids', get_selected_ids)

      trigger_changed_event = () =>
        event = jQuery.Event( "changed" );
        event.selected = get_selected_ids();
        $control.trigger( event );

      check_main_checkox = (state)->
        main_checkbox().prop("indeterminate", false)
        main_checkbox().prop('checked', state)

      check_list_checkboxes = (state)->
        $(list_check_box_selector).each ()->
          $(this).prop('checked', state)
          $(this).closest(parent_selector).toggleClass('selected', $(this).is(':checked'))
        trigger_changed_event()

      resetState = () ->
        check_main_checkox false
        check_list_checkboxes false
        trigger_changed_event()

      main_checkbox().click (e)->
        e.stopPropagation()
        $target = $(e.target)
        if !$target.is(':checked')
          check_main_checkox false
          check_list_checkboxes false
        else
          check_main_checkox true
          check_list_checkboxes true

      $control.find('.select-all').click (e)->
        e.preventDefault()
        check_main_checkox true
        check_list_checkboxes true

      $control.find('.select-none').click (e)->
        e.preventDefault()
        check_main_checkox false
        check_list_checkboxes false

      $('.content').on 'click', list_check_box_selector, () ->
        $(this).closest(parent_selector).toggleClass('selected', $(this).is(':checked'))
        trigger_changed_event()

        $inputs = $(list_check_box_selector)

        $checked_inputs = jQuery.grep $inputs, (input) ->
          $(input).is(':checked')

        if $checked_inputs.length == 0
          check_main_checkox false
        else if $checked_inputs.length == $inputs.length
          check_main_checkox true
        else
          main_checkbox().prop("indeterminate", true)

      #Checkboxes state should be reseted on page change
      $('.content').on 'click', '.pagination li a[data-remote]', (e) ->
        resetState() unless $(e.target).parent().hasClass('active')

      $('#search').on 'input', () ->
        resetState()

)(jQuery)