s = undefined
_this = undefined
App.ControlSidebar = do ->

  init: (@el) ->
    s =
      controlSidebarBtn: "[data-toggle=control-sidebar]"
      eventNamespace: 'photo'
      controlSidebar: '.control-sidebar'

    _this = this
    @initDatepicker()
    @initControlSidebar()
    @bindUIActions()

  bindUIActions: ->
    $('body').on 'click.' + s.eventNamespace, s.controlSidebarBtn, -> _this.toggleControlSidebar()
    $('a[data-toggle="tab"]').on 'shown.bs.tab', (e) -> _this.tabChange(e)
    $('#search-date').on 'changeDate', (e) -> _this.searchParamsChanged(e)
    $('body').on 'change.' + s.eventNamespace, '#searchbox_country, #searchbox_direction', -> _this.searchParamsChanged()

  searchParamsChanged: (e)->
    console.log e
    if typeof e == "undefined"
      date = $('#search-date').datepicker("getDate")
    else
      date = e.date
    url = '/photos/'
    direction = $("#searchbox_direction").prop('checked')
    country = $("#searchbox_country").val()
    data = {direction: direction, startdate: date, country: country}
    console.log data
    $('.infinite-container').load url, data, ->
      console.log 'done'
      $('img.lazy').lazyload()



  showPhoto: (id) ->
    _this=this
    url = '/photos/' + id + '?view=small'
    $('#control-sidebar-tab-photo > #tab-content').load( url, (result) ->
      _this.setControlSidebarTab("3")
      App.PhotoTaginput.refresh()
      App.PhotoLike.init()
      $('.dropdown-toggle').dropdown()
      )
    .fadeIn(200)

  tabChange: (event) ->
    if $('body').hasClass('control-sidebar-open')
      selectedTab = $(event.target).attr("href")
      switch selectedTab
        when '#control-sidebar-tab-nav'
          localStorage.controlSidebarStatus = 1
        when '#control-sidebar-tab-bucket'
          localStorage.controlSidebarStatus = 2
        when '#control-sidebar-tab-photo'
          localStorage.controlSidebarStatus = 3
    else
      localStorage.controlSidebarStatus = 0

  initControlSidebar: ->
    if localStorage.controlSidebarStatus > 0
      @setControlSidebarTab(localStorage.controlSidebarStatus)

  toggleControlSidebar: ->
    if this.state() == 0
      $.AdminLTE.controlSidebar.open()
      if localStorage.controlSidebarStatus > 0
        @setControlSidebarTab(localStorage.controlSidebarStatus)
      else
        localStorage.controlSidebarStatus = 1
    else
      $.AdminLTE.controlSidebar.close()
      localStorage.controlSidebarStatus = 0

  setControlSidebarTab: (tab) ->
    switch tab
      when "1"
        $('.nav-tabs a[href="#control-sidebar-tab-nav"]').tab('show')
        localStorage.controlSidebarStatus = 1
      when "2"
        $('.nav-tabs a[href="#control-sidebar-tab-bucket"]').tab('show')
        localStorage.controlSidebarStatus = 2
      when "3"
        $('.nav-tabs a[href="#control-sidebar-tab-photo"]').tab('show')
        localStorage.controlSidebarStatus = 3
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

  initDatepicker: ->
    $('#search-date').datepicker
      startView: 2
      minViewMode: 1
      maxViewMode: 3
      todayBtn: true
      beforeShowDay: (date) ->


$(document).on "turbolinks:load", ->
  return unless $(".photos.index, .catalogs.show, .albums.show, .locations.show").length > 0
  App.ControlSidebar.init()
