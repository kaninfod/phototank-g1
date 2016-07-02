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


  refresh: ->
    _this = this

  openMenu: ->
    $(s.controlSidebar).addClass('control-sidebar-open')
    @setMenuStatus()

  closeMenu: ->
    $(s.controlSidebar).removeClass('control-sidebar-open')
    @setMenuStatus()


  setMenuStatus: (elm) ->
    if $(s.controlSidebar).hasClass('control-sidebar-open')
      localStorage.controlSidebarStatus = 'open'
    else
      localStorage.controlSidebarStatus = 'close'

  toggleMenu: ->
    if localStorage.controlSidebarStatus == 'open'
      $(s.controlSidebar).addClass('control-sidebar-open')

  initControlSidebar: ->
    if $._data($('[data-toggle=\'control-sidebar\']')[0]).events == undefined
      $.AdminLTE.controlSidebar.activate()

$(document).on "page:change", ->
  return unless $(".photos.index, .catalogs.show, .albums.show").length > 0
  App.ControlSidebar.init()
