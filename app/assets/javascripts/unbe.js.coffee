class @Unbe
  Init: class Init
    initHome: (spinner)->
      jQuery.ajaxSetup({ cache: false });
      $(".select2tags").select2({width: "380px", tags: $(".select2tags").data("tags"), tokenSeparators: [","]})
      $(".select2tags_short").select2({width: '100%', tags: $(".select2tags_short").data("tags"), tokenSeparators: [","]})
      $(".select2").select2({width: '620px'})
      spinner.hide();

  Search: class Search

    queryParams: ['article_area','scope']

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

