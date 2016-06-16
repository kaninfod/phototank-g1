s = undefined
App.Bucket = do ->

  init: (@el) ->
    s =
      overlayClass: 'photo-widget-overlay'
      bucketClass: 'bucket_overlay'
      eventNamespace: 'photo'
      photoGrid: '#photogrid'
    @update_bucket_count()
    @bindUIActions()


  bindUIActions: ->
    _this = this
    $('.bucket').slimScroll height: $(window).height() - 350
    #$(s.photoGrid).on 'click.' + s.eventNamespace,'#photo_bucket_panel', -> _this.showBucketDropdown(this)
    $(s.photoGrid).on 'click.' + s.eventNamespace, '.photo-widget-overlay', -> _this.toggleBucket(this)
    $('.bucket').on 'bucket:update', -> _this.loadBucket()
    $('body').on 'click.' + s.eventNamespace, '#like', -> _this.likePhotos()
    $('body').on 'click.' + s.eventNamespace,'#unlike', -> _this.unlikePhotos()
    $('#comment-input-bucket').keypress (e) -> _this.addComment(this, e)
    $('a#clear-bucket').on 'click', -> _this.clearBucket()
    @loadBucket()

  showBucketDropdown: (button) ->
    if $(button).closest(".dropdown").hasClass("open")
      $.get '/bucket/list', (data) ->
        $('#photos_in_bucket').html data

  loadBucket: ->
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

  clearBucket: ->
    _this=this
    $.get '/bucket/clear', (data) ->
      _this.loadBucket()
    $('.' + s.overlayClass).removeClass(s.bucketClass)
    false

$(document).on "page:change", ->
  App.Bucket.init()
