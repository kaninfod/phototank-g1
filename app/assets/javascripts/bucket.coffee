s = undefined
class App.Bucket

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
    @update_bucket_count()

    #$('.bucket').slimScroll height: $(window).height() - 400
    @bindUIActions()

  bindUIActions: ->
    _this = this
    $('.bucket').slimScroll height: $(window).height() - 500
    $('#photo_bucket_panel').on 'click', -> _this.showBucketDropdown(this)
    $(document).on 'click', '.photo-widget-overlay', -> _this.toggleBucket(this)
    $('.bucket').on 'bucket:update', -> _this.loadBucket()
    $('#like').on 'click', -> _this.likePhotos()
    $('#unlike').on 'click', -> _this.unlikePhotos()
    $('#comment-input-bucket').keypress (e) -> _this.addComment(this, e)
    @loadBucket()

  showBucketDropdown: (button) ->
    if $(button).closest(".dropdown").hasClass("open")
      $.get '/bucket/list', (data) ->
        $('#photos_in_bucket').html data

  loadBucket: ->
    console.log 'dafuq!'
    $.get '/bucket/list', (data) ->
      $('.bucket').html data

  toggleBucket: (photoOverlay) ->
    $(photoOverlay).toggleClass("bucket_overlay")
    imgDiv = $(photoOverlay).next()

    if $(photoOverlay).hasClass('bucket_overlay')
      url = '/bucket/' + $(imgDiv).attr('photo_id') + '/add'
    else
      url = '/bucket/' + $(imgDiv).attr('photo_id') + '/remove'

    $.ajax
      method: 'POST'
      url: url
      data: {}
      success: (response) ->
        $('#bucket_counter').html response['count']
        $(".bucket").trigger('bucket:update')

  update_bucket_count: ->
    $.get '/bucket/count', (data) ->
      $('#bucket_counter').html data['count']

  likePhotos: ->
    photo_id = $('.image_info').attr('photo_id')
    url = '/bucket/like'
    $.get url

  unlikePhotos: ->
    photo_id = $('.image_info').attr('photo_id')
    url = '/bucket/unlike'
    $.get url

  addComment: (commentInput,key) ->
    if key.which == 13
      photo_id = $('.image_info').attr('photo_id')
      url = '/bucket/add_comment'
      $.get url, comment: $(commentInput).val()
      $(commentInput).val ''


$(document).on "page:change", ->
  App.Bucket.get()
