s = undefined
class App.ControlSidebar

  #Singleton implementation
  instance = null
  class PrivateClass
    constructor: () ->

  @get: (message) ->
    if not instance?
      instance = new @
      instance.init()
    else
      instance.bindUIActions()

    instance

  init: (@el) ->
    # s =
    #   modalElement: $('#myModal')
    #   likeButtonId: '#like'
    #   numberOfLikes: $('#likes_num')
    @bindUIActions()

  bindUIActions: ->
    _this = this
    $('.context-menu').hover (event) -> _this.openControlSidebar(event)
    $('.control-sidebar').hover (event) -> _this.closeControlSidebar(event)
    $('#pin').on 'click', -> _this.pinControlSidebar(this)


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
