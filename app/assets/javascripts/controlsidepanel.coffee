s = undefined
App.ControlSidebar = do ->


  init: (@el) ->
    # s =
    #   modalElement: $('#myModal')
    #   likeButtonId: '#like'
    #   numberOfLikes: $('#likes_num')
    @bindUIActions()

  bindUIActions: ->
    _this = this



  refresh: ->
    _this = this


  openControlSidebar: (event) ->
    if event.type == 'mouseenter'
      $.AdminLTE.controlSidebar.open()

  closeControlSidebar: (event) ->
    if event.type == 'mouseleave' and !$('#pin').hasClass('active')
      $.AdminLTE.controlSidebar.close()

  pinControlSidebar: (pin) ->
    $(pin).toggleClass 'active'

$(document).on "page:change", ->
  App.ControlSidebar.get()
