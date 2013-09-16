class @Unbe
  Init: class Init
    initHome: ()->
      jQuery.ajaxSetup({ cache: true });
  Search: class Search
    bindSearch: (projectFormElem) ->
      $("##{projectFormElem} input").keyup (e) ->
        request = "search=" + $(@).val()
        $.address.value "#{location.pathname}?#{request}"

unless @.unbe?
  @.unbe = new Unbe()