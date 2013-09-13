class @Unbe
  Search: class Search
    bindSearch: (projectFormElem) ->
      $("##{projectFormElem} input").keyup (e) ->
        request = "search=" + $(@).val()
        $.address.value "#{location.pathname}?#{request}"

unless @.unbe?
  @.unbe = new Unbe()