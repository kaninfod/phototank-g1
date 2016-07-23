s = undefined
App.Catalogs = do ->

  init: (@el) ->
    @wp = null
    s =
      controlSidebar: '.control-sidebar'
    $(s.controlSidebar).removeClass('control-sidebar-open')
    @initSyncType()
    @bindUIActions()

  bindUIActions: ->
    _this = this
    $('#add-item').click -> _this.addWatchpath()
    $('#sync_from').change (val) -> _this.toggleSyncType(val)

  addWatchpath: ->
    id = $('#watch-path-group').children().length + 1
    $('#watch-path-group').append '<input style="margin-top: 4px;" id=wp_"' + id + '" name=wp_"' + id + '" type="text" class="form-control" placeholder="New path...">'

  toggleSyncType: (val) ->
    $('#album-list').toggleClass 'hidden'
    $('#catalog-list').toggleClass 'hidden'

  initSyncType: ->
    sync_from = $('#sync_from').val()
    if sync_from == 'album'
      $('#catalog-list').toggleClass 'hidden'
    else
      $('#album-list').toggleClass 'hidden'
    return

$(document).on "page:change", ->
  App.Catalogs.init()
