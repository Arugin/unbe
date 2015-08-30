class @Unbe
  Init: class Init
    initHome: (spinner)->
      jQuery.ajaxSetup({ cache: false });
      $(".select2tags").select2(width: "380px", tags: $(".select2tags").data("tags"), tokenSeparators: [","])
      $(".select2tags_short").select2(width: '100%', tags: $(".select2tags_short").data("tags"), tokenSeparators: [","])
      $(".select2").select2(width: '66%')
      spinner.hide();

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

