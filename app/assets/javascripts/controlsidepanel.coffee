s = undefined
_this = undefined
App.ControlSidebar = do ->


  init: (@el) ->
    s =
      controlSidebarBtn: "[data-toggle=control-sidebar]"
      eventNamespace: 'photo'
      controlSidebar: '.control-sidebar'

    _this = this
    @toggleMenu()
    @bindUIActions()

  bindUIActions: ->
    $('body').on 'click.' + s.eventNamespace, s.controlSidebarBtn, -> _this.setMenuStatus(this)


  openMenu: ->
    $('body').addClass('control-sidebar-open')
    @setMenuStatus()

  closeMenu: ->
    $('body').removeClass('control-sidebar-open')
    @setMenuStatus()


  setMenuStatus: (elm) ->
    if $('body').hasClass('control-sidebar-open')
      localStorage.controlSidebarStatus = 'open'
    else
      localStorage.controlSidebarStatus = 'close'


  toggleMenu: ->
    if localStorage.controlSidebarStatus == 'open'
      $.AdminLTE.controlSidebar.open()

  initControlSidebar: ->
    if $._data($('[data-toggle=\'control-sidebar\']')[0]).events == undefined
      $.AdminLTE.controlSidebar.activate()

$(document).on "page:change", ->
  return unless $(".photos.index, .catalogs.show, .albums.show").length > 0
  App.ControlSidebar.init()
