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
    $('body').on 'click.' + s.eventNamespace, s.likeButtonId, -> _this.likePhoto()



  likePhoto: ->
    url = @getUrl()
    $.get url, (data) ->
      $(s.numberOfLikes).html data['likes'] + ' likes'
      $(s.likeButtonId).toggleClass 'btn-success'

  getUrl: ->
    photo_id = $('#photo_id').data("photo_id")
    console.log photo_id
    #photo_id = $('.image_info').attr('photo_id')
    url = '/photos/' + photo_id + '/like'


$(document).on "page:change", ->
  return unless $(".photos.index, .catalogs.show, .albums.show").length > 0
  App.PhotoLike.init()
