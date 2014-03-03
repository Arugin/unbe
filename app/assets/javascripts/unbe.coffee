class @Unbe
  Init: class Init
    initHome: (spinner)->
      jQuery.ajaxSetup({ cache: false });
      $(".select2tags").select2({width: "380px", tags: $(".select2tags").data("tags"), tokenSeparators: [","]})
      $(".select2tags_short").select2({width: '100%', tags: $(".select2tags_short").data("tags"), tokenSeparators: [","]})
      $(".select2").select2({width: '620px'})
      spinner.hide();

  Search: class Search

    bindSearch: (projectFormElem) ->

      search_input = $("##{projectFormElem} input")
      search_clear =
        formElem: projectFormElem
        element: ->
          $("##{@formElem} #clear-search")

        show: ->
          @element().css "display", "inline-block"

        hide: ->
          @element().css "display", "none"

      check_search_content = (content) ->
        if content is ""
          search_clear.hide()
        else
          search_clear.show()

      search_input.keyup (e) ->
        self = this
        setTimeout (->
          request = "search=#{$(self).val()}"
          $.address.value "#{location.pathname}?#{request}"
          check_search_content $(self).val()
        ), 100

        console.log 'd', search_clear.element()

      (search_clear.element()).click (e) ->
        $.address.value location.pathname
        search_input.val ''
        search_clear.hide()
        return

unless @unbe?
  @unbe = new Unbe()

