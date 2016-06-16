s = undefined
App.PhotoLike = do ->

  init: (@el) ->
    s =
      photoGrid: '#photogrid'
      modalElement: $('#photoDetails')
      likeButtonId: '#like'
      numberOfLikes: '#likes_num'
      eventNamespace: 'photo'
    @bindUIActions()


  bindUIActions: ->
    _this = this
    $(s.photoGrid).on 'click.' + s.eventNamespace, s.likeButtonId, -> _this.likePhoto()

  likePhoto: ->
    url = @getUrl()
    $.get url, (data) ->

      $(s.numberOfLikes).html data['likes'] + ' likes'
      $(s.likeButtonId).toggleClass 'btn-success'

  getUrl: ->
    photo_id = $('.image_info').attr('photo_id')
    url = '/photos/' + photo_id + '/like'


$(document).on "page:change", ->
  return unless $(".photos.index").length > 0
  App.PhotoLike.init()
