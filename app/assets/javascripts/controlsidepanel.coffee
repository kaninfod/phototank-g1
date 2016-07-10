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
    $('body').on 'click.' + s.eventNamespace, '.control-sidebar-toggle', -> _this.toggleControlSidebar()

  toggleControlSidebar: ->
    if this.state() == 0
      $.AdminLTE.controlSidebar.open()
    else
      $.AdminLTE.controlSidebar.close()

  setControlSidebarTab: (tab) ->
    switch tab
      when 1
        $('.nav-tabs a[href="#control-sidebar-tab-nav"]').tab('show')
      when 2
        $('.nav-tabs a[href="#control-sidebar-tab-bucket"]').tab('show')
      when 3
        $('.nav-tabs a[href="#control-sidebar-tab-photo"]').tab('show')
    $.AdminLTE.controlSidebar.open()

  state: ->
    if $('body').hasClass('control-sidebar-open')
      selectedTab = $('.control-sidebar-tabs > .active > a').attr('href')
      switch selectedTab
        when '#control-sidebar-tab-nav'
          return 1
        when '#control-sidebar-tab-bucket'
          return 2
        when '#control-sidebar-tab-photo'
          return 3
    else
      return 0

  # openMenu: ->
  #   $('body').addClass('control-sidebar-open')
  #   @setMenuStatus()
  #
  # closeMenu: ->
  #   $('body').removeClass('control-sidebar-open')
  #   @setMenuStatus()


  setMenuStatus: ->
    if this.state() == 1
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
