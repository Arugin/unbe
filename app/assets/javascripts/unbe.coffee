class @Unbe
  Init: class Init
    initHome: (spinner)->
      jQuery.ajaxSetup({ cache: false });
      $(".select2tags").select2(width: "380px", tags: $(".select2tags").data("tags"), tokenSeparators: [","])
      $(".select2tags_short").select2(width: '100%', tags: $(".select2tags_short").data("tags"), tokenSeparators: [","])
      $(".select2").select2(width: '66%')
      spinner.hide();

  Search: class Search

    queryParams: ['article_area', 'unprocessed', 'sort_by', 'direction']

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

    bindSearch: (projectFormElem) ->

      verySelf = this

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
          request = "search=" + $(self).val()
          $.address.value verySelf.makeUrl(request)
          check_search_content $(self).val()
        ), 100

      (search_clear.element()).click (e) ->
        $.address.value location.pathname
        search_input.val ''
        search_clear.hide()
        return

  isBreakpoint: ( alias ) ->
    $('.device-' + alias).is(':visible')

  shouldLogoDisplay: ()->
    if unbe.isBreakpoint('xs') or unbe.isBreakpoint('sm')
      $('#logo').css('display', 'none')
    else
      $('#logo').css('display', 'block')

  lockHeader: ()->
    $('body').addClass "locked-header"

  unlockHeader: ()->
    $('body').addClass "unlocked-header"

  settings: ()->
    gon.settings

  isDefaultSettings: ()->
    @settings().default?

  changeLinkBechaviour: ()->
    a = new RegExp('/' + window.location.host + '/')
    $('a').each ->
      unless a.test(@href)
        $(@).click (event) ->
          event.preventDefault()
          event.stopPropagation()
          window.open @href, '_blank'

  checkHeaderState: ()->
    if @isHeaderUnlocked()
      @unlockHeader()
    else
      @lockHeader()

  isHeaderUnlocked: ()->
    not @isDefaultSettings() and @settings().unlock_top_menu

  initTooltips: ()->
    $("body").tooltip({ selector: '[data-toggle=tooltip]' })

  resizeImgContainers: ()->
    $('.description p:has(img)').addClass('p-imagable')

unless @unbe?
  @unbe = new Unbe()

