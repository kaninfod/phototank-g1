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

  setMenuStatus: (elm) ->

    if $(s.controlSidebar).hasClass('control-sidebar-open')
      localStorage.controlSidebarStatus = 'open'
    else
      localStorage.controlSidebarStatus = 'close'

  toggleMenu: ->
    if localStorage.controlSidebarStatus == 'open'
      $(s.controlSidebar).addClass('control-sidebar-open')



  openControlSidebar: (event) ->
    if event.type == 'mouseenter'
      $.AdminLTE.controlSidebar.open()

  closeControlSidebar: (event) ->
    if event.type == 'mouseleave' and !$('#pin').hasClass('active')
      $.AdminLTE.controlSidebar.close()

  pinControlSidebar: (pin) ->
    $(pin).toggleClass 'active'

$(document).on "page:change", ->
  App.ControlSidebar.init()
