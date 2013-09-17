class @Unbe
  Init: class Init
    initHome: (spinner)->
      jQuery.ajaxSetup({ cache: true });
      spinner.hide();

  Search: class Search

    queryParams: ['article_area']

    bindSearch: (projectFormElem) ->
      self = this
      $("##{projectFormElem} input").keyup (e) ->
        request = "search=" + $(@).val()
        $.address.value self.makeUrl(request)

    urlParam:(name)->
      results = new RegExp('[\\?&]' + name + '=([^&#]*)').exec(location.href)
      if results?
        results[1] || 0
      else
        null

    makeUrl: (request)->
      address = "#{location.pathname}?#{request}"
      for param in @queryParams
        if @urlParam(param)?
          address = "#{address}&#{param}=#{@urlParam(param)}"
      address

unless @unbe?
  @unbe = new Unbe()

