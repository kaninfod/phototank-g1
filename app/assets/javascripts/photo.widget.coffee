s = undefined
App.PhotoWidget = do ->

  init: (@el) ->
    s =
      duration: 175
      photoGrid: '#photogrid'
      modalElement: $('#photoDetails')
      animationEnd: 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend';
    alertify.parent(document.body)
    alertify.logPosition("top left");
    @bindUIActions()


  bindUIActions: ->
    _this = this
    @modalInit()
    $(s.photoGrid).on 'click.' + s.eventNamespace, '.lazy', -> _this.showInControlSidebar(this)

    $(s.photoGrid).on 'click.' + s.eventNamespace, '.overlay-button.overlay-select', -> _this.select(this)
    $('body').on 'click.' + s.eventNamespace, '.overlay-button.overlay-delete,#delete-photo', -> _this.delete(this)
    $(s.photoGrid).on 'click.' + s.eventNamespace, '.overlay-button.overlay-zoom',-> _this.showModal(this)
    $(s.photoGrid).on 'click.' + s.eventNamespace, '.overlay-button.overlay-processing', (ev) -> _this.reloadWidget(this)

    $(s.photoGrid).on 'mouseenter.' + s.eventNamespace, '.photo-widget',  -> _this.showControls(this)
    $(s.photoGrid).on 'mouseleave.' + s.eventNamespace, '.photo-widget',  -> _this.hideControls(this)

    $('body').on 'click.' + s.eventNamespace, '#add-to-album-photo', -> _this.showAddToAlbum()
    $('#album-list-photo .btn-primary').on 'click' , (event) -> _this.addToAlbum(event)

    $('body').on 'click.' + s.eventNamespace, '#rotate-photo',  -> _this.rotatePhotos(this)


  reloadWidget: (element) ->
    photoWidget = $(element).parents('.photo-widget')
    photoId = photoWidget.data("photoid")

    url = '/photos/' + photoId + '?view=widget'
    $.get url, (data) ->
      photoWidget.replaceWith(data)
      photoWidget =  $('.photo-widget[data-photoid=' + photoId + '] img')
      photoWidget.attr('src', photoWidget.data('original') + '?' + escape(new Date()))
      return false

  rotatePhotos: (element) ->
    degrees = $(element).data('degrees')
    photoId = $('#photo_id').data("photo_id")
    processingButton = $('.photo-widget[data-photoid=' + photoId + '] .overlay-processing')

    $.get '/photos/' + photoId + '/rotate/' + degrees, (data) ->
      processingButton.addClass('overlay-show')
      $('.dropdown.open .dropdown-toggle').dropdown('toggle');
      alertify.log("Photo is queued for a rotation of " + degrees + " degrees");
    false

  showInControlSidebar: (element) ->
    photoId = $(element).parents('.photo-widget').data("photoid")
    App.ControlSidebar.showPhoto(photoId)
    $('.photo-widget.highlight').removeClass('highlight')
    $(element).parents('.photo-widget').addClass('highlight')

  select: (element) ->
    photoId = $(element).parents('.photo-widget').data("photoid")
    App.Bucket.addPhotoToBucket(photoId)


  delete: (element) ->
    if $(element).attr('id') == 'delete-photo'
      photoId = $('#photo_id').data("photo_id")
      $('#control-sidebar-tab-photo').children().fadeOut()
      App.ControlSidebar.closeMenu()
    else
      photoWidget = $(element).parents('.photo-widget')
      photoId = photoWidget.data("photoid")
      console.log 'lak'
    @deletePhoto(photoId)

  deletePhoto: (photoId) ->
    photoWidget = $('.photo-widget[data-photoid=' + photoId + ']')
    alertify.confirm 'Really! Delete this Photo?', (->
      url = '/photos/' + photoId + '.json'
      # Todo: What is photoid??
      $.ajax
        url: url
        type: 'DELETE',
        contentType: 'application/json',
        success: (data) ->
          photoWidget.fadeOut(700)
          alertify.log("Photo is queued for deletion!");
    )
    false

  showAddToAlbum: ->
    $('#album-list-photo').modal()
    $('#album-list-photo').removeClass 'hidden'

  addToAlbum: (event) ->
    album_id = $('#album-list-photo * #albums input:radio:checked').val()
    photoId = $('#photo_id').data("photo_id")
    $.get '/albums/add_photo', {album_id: album_id, photo_id: photoId}, ->
      alertify.log("Photo was added to album");


  showControls: (element) ->
    overlayButton = $('.overlay-button:not(.overlay-processing)', element)
    overlayButton.addClass('overlay-show')

  hideControls: (element) ->
    overlayButton = $('.overlay-button:not(.selected, .overlay-processing)', element)
    overlayButton.removeClass('overlay-show')

  modalInit: () ->
    @modal = new AnimatedModal(
      animatedIn: 'zoomIn'
      animatedOut: 'zoomOut'
      closeBtn: '.close-modal'
      modalBaseClass: 'animated-modal'
      modalTarget: 'photoDetails'
      escClose: true
      afterClose: null
      afterOpen: ->
        App.PhotoTaginput.refresh()
        App.PhotoEdit.refresh()
      beforeClose: null
      beforeOpen: null
    )

  showModal: (element) ->
    _this = this
    photoId = $(element).parents('.photo-widget').data("photoid")
    url = '/photos/' + photoId + '?view=modal'
    $('#photoDetails > .modal-content').load url, (result) ->
      #ev.preventDefault()
      _this.modal.open()

  getWidget: (photoId) ->
    return $('.infinite-container > .photo-widget[data-photoid=' + photoId + ']')

$(document).on "turbolinks:load", ->
  return unless $(".photos.index, .catalogs.show, .albums.show, .locations.show").length > 0
  App.PhotoWidget.init()
