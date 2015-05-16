$(document).ready ()->
  init = new unbe.Init()
  init.initHome($('.spinner'))

  $(window).scroll ()->
    $('.header').css('left',-$(window).scrollLeft())

  waitForFinalEvent= (()->
    b = {}
    (c, d, a) ->
      a or (a = "I am a banana!")
      b[a] and clearTimeout(b[a])
      b[a] = setTimeout(c, d)
  )()
  fullDateString = new Date()

  unbe.shouldLogoDisplay()

  # 768px 992px 1200px
  $(window).resize ()->
    waitForFinalEvent ()->
      unbe.shouldLogoDisplay()
    , 100, fullDateString.getTime()

  unbe.checkHeaderState()

  $(document).on "ready page:change", ()->
    unbe.initTooltips()
    unbe.resizeImgContainers()

  $(document).on 'ujs:complete', ->
    unbe.changeLinkBechaviour()

