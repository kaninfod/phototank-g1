s = undefined
App.Bucket = do ->

  init: (@el) ->
    s =
      overlayClass: 'photo-widget-overlay'
      eventNamespace: 'photo'
      photoGrid: '#photogrid'
    @update_bucket_count()
    @bindUIActions()

  bindUIActions: ->
    _this = this
    $('.bucket').slimScroll height: $(window).height() - 350
    $(s.photoGrid).on 'click.' + s.eventNamespace, '.photo-widget-overlay', -> _this.toggleBucket(this)
    $('#bucket').on 'bucket:update', -> _this.loadBucket()
    $('body').on 'click.' + s.eventNamespace, '#like-bucket', -> _this.likePhotos()
    $('body').on 'click.' + s.eventNamespace, '#unlike-bucket', -> _this.unlikePhotos()
    $('body').on 'click.' + s.eventNamespace, '#delete-bucket', -> _this.deletePhotos()
    $('body').on 'click.' + s.eventNamespace, '#rotate-bucket',  -> _this.rotatePhotos(this)
    $('body').on 'click.' + s.eventNamespace, '#clear-bucket', -> _this.clearBucket()
    $('body').on 'click.' + s.eventNamespace, '#tag-action', (e) => @tagAction(e)
    # $('body').on 'click.' + s.eventNamespace, '#show-add-to-album-modal-bucket', -> _this.showAddToAlbum()
    $('#add-to-album-bucket').on 'click' , (event) => @addToAlbum(event)
    $('#comment-input-bucket').keypress (e) -> _this.addComment(this, e)
    $('body').on 'click.' + s.eventNamespace, '#bucket-list img', -> _this.removeFromBucket(this)
    @loadBucket()

  tagAction: (element) ->
    modal = $(element.target).parents("#bucket-addtags")
    action = modal.find("ul:first *> input:checked").attr("id")


    console.log action
    modal.hide()


  bucketPhoto: (photoId) ->
    $.ajax
      method: 'POST'
      url: url = '/bucket/' + photoId + '/toggle'
      data: {}
      success: (response) ->
        $("#bucket").trigger('bucket:update')

  addPhotoToBucket: (photoId) ->
    element = $('.photo-widget[data-photoid=' + photoId + '] .overlay-select')
    $(element).toggleClass("selected")
    if $(element).hasClass('selected')
      url = '/bucket/' + photoId + '/add'
    else
      url = '/bucket/' + photoId + '/remove'
    $.ajax
      method: 'POST'
      url: url
      data: {}
      success: (response) ->
        console.log response
        $("#bucket").trigger('bucket:update')


  removeFromBucket: (element) ->
    _this=this
    photoId = $(element).data("photoid")
    url = '/bucket/' + photoId + '/remove'
    $.post url, ->
      $('.photo-widget[data-photoid=' + photoId + '] .overlay-select').removeClass('overlay-show selected')
      _this.loadBucket()

  loadBucket: ->
    $.get '/bucket/list', (data) ->
      $('#bucket').html data
    @update_bucket_count()

  update_bucket_count: ->
    $.get '/bucket/count', (data) ->
      $('#bucket_counter').html data['count'] + " Photos"

  likePhotos: ->
    $('.dropdown.open .dropdown-toggle').dropdown('toggle');
    photo_id = $('#photo_id').data("photo_id")#$('.image_info').attr('photo_id')
    url = '/bucket/like'
    $.get url
    return false

  unlikePhotos: ->
    $('.dropdown.open .dropdown-toggle').dropdown('toggle');
    photo_id = $('#photo_id').data("photo_id")#$('.image_info').attr('photo_id')
    url = '/bucket/unlike'
    $.get url
    return false

  addComment: (commentInput,key) ->
    if key.which == 13
      photo_id = $('#photo_id').data("photo_id")
      url = '/bucket/add_comment'
      $.get url, comment: $(commentInput).val()
      $(commentInput).val ''

  clearBucket: ->
    _this=this
    $.get '/bucket/clear', (data) ->
      $('.dropdown.open .dropdown-toggle').dropdown('toggle');
      _this.loadBucket()
      $('.overlay-button.overlay-select').removeClass('selected zoomOut overlay-show bounceIn')
    return false

  deletePhotos: ->
    _this = this
    if (confirm('Delete photos?'))
      $.get '/bucket/delete_photos.json', (data) ->
        for photoId in data.bucket
          photoWidget = $('.photo-widget[data-photoid=' + photoId + ']')
          photoWidget.fadeOut(700)
        _this.clearBucket()
        Materialize.toast("Photos in bucket are queued for deletion", 3000)

    false

  rotatePhotos: (element) ->
    $('.dropdown.open .dropdown-toggle').dropdown('toggle');
    degrees = $(element).data('degrees')
    $.get '/bucket/rotate/' + degrees + '.json', (data) ->
      for photoId in data.bucket
        processingButton = $('.photo-widget[data-photoid=' + photoId + '] .overlay-processing')
        processingButton.addClass('overlay-show')
      Materialize.toast("Photos in bucket are queued for rotation", 3000)
    return false

  addToAlbum: ->
    album_id = $('#album-list-bucket * #albums input:radio:checked').val()
    $.get '/bucket/save', {album_id: album_id}, ->
      Materialize.toast("Photos have been saved to album", 3000)

$(document).on "turbolinks:load", ->
  App.Bucket.init()
