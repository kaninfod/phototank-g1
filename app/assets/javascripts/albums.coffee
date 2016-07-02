s = undefined
App.Albums = do ->


  init: (@el) ->
    @wp = null
    s =
      controlSidebar: '.control-sidebar'

    $(s.controlSidebar).removeClass('control-sidebar-open')
    @bindUIActions()

  bindUIActions: ->
    _this = this
    $('#search-albums').change -> _this.albumSearch(this)

  albumSearch: (element) ->
    q=$('#search-albums').val()
    if q == ''
      window.location = 'albums'
    else
      window.location = 'albums?q=' + q
    return


$(document).on "page:change", ->
  App.Albums.init()
