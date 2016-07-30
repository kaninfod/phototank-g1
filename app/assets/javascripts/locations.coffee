s = undefined
App.Locations = do ->

  init: (@el) ->
    @wp = null
    s =
      controlSidebar: '.control-sidebar'
    $(s.controlSidebar).removeClass('control-sidebar-open')
    @bindUIActions()

  bindUIActions: ->
    _this = this
    $('#search-locations').change -> _this.locationSearch(this)

  locationSearch: (element) ->

    q=$('#search-locations').val()
    if q == ''
      window.location = 'locations'
    else
      window.location = 'locations?q=' + q
    return

$(document).on "turbolinks:load", ->
  App.Locations.init()
