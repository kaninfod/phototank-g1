s = undefined
class App.PhotoLike

  #Singleton implementation
  instance = null
  class PrivateClass
    constructor: () ->

  @get: (message) ->
    if not instance?
      instance = new @
      instance.init()
    instance

  init: (@el) ->
    s =
      modalElement: $('#myModal')
      likeButtonId: '#like'
      numberOfLikes: $('#likes_num')
    @bindUIActions()

  bindUIActions: ->
    _this = this
    s.modalElement.on 'click', s.likeButtonId, -> _this.likePhoto()

  likePhoto: ->
    url = @getUrl()
    $.get url, (data) ->
      s.numberOfLikes.html data['likes'] + ' likes'
      $(s.likeButtonId).toggleClass 'btn-success'

  getUrl: ->
    photo_id = $('.image_info').attr('photo_id')
    url = '/photos/' + photo_id + '/like'

$(document).on "page:change", ->
  return unless $(".photos.index").length > 0
  App.PhotoLike.get()
