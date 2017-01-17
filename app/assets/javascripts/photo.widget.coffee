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

    #initialise the 'save to album' modal
    $('.modal').modal()

    @bindUIActions()


  bindUIActions: ->
    _this = this
    @modalInit()

    $(s.photoGrid).on 'click.' + s.eventNamespace, '.photo-widget', -> _this.showInControlSidebar(this)

    $(s.photoGrid).on 'click.' + s.eventNamespace, '.overlay-button.overlay-select', -> _this.select(this)
    $('body').on 'click.' + s.eventNamespace, '.overlay-button.overlay-delete, #delete-photo', -> _this.delete(this)
    $(s.photoGrid).on 'click.' + s.eventNamespace, '.overlay-button.overlay-zoom',-> _this.showModal(this)
    $(s.photoGrid).on 'click.' + s.eventNamespace, '.overlay-button.overlay-processing', (ev) -> _this.reloadWidget(this)

    $(s.photoGrid).on 'mouseenter.' + s.eventNamespace, '.photo-widget',  -> _this.showControls(this)
    $(s.photoGrid).on 'mouseleave.' + s.eventNamespace, '.photo-widget',  -> _this.hideControls(this)

    $('#add-to-album-photo').on 'click' , (event) -> _this.addToAlbum(event)

    $('body').on 'click.' + s.eventNamespace, '#rotate-photo',  -> _this.rotatePhotos(this)

    $('body').on 'click.' + s.eventNamespace, '#download-photo', -> _this.downloadPhoto(this)


  downloadPhoto: (element) ->
    dataUrl = $(element).data('download-url')
    console.log dataUrl
    # Construct the a element
    link = document.createElement('a')
    link.download = "filename"
    link.target = '_blank'
    # Construct the uri
    link.href = dataUrl
    document.body.appendChild link
    link.click()
    # Cleanup the DOM
    document.body.removeChild link

    return false

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
      Materialize.toast("Photo is queued for a rotation of " + degrees + " degrees", 3000)

      return false
    $('.dropdown-button').dropdown('close');
    return false

  showInControlSidebar: (element) ->
    photoId = $(element).parents('.photo-widget').data("photoid")

  select: (element) ->
    photoId = $(element).parents('.photo-widget').data("photoid")
    App.Bucket.addPhotoToBucket(photoId)


  delete: (element) ->
    if $(element).attr('id') == 'delete-photo'
      photoId = $('#photo_id').data("photo_id")
      $('#control-sidebar-tab-photo').children().fadeOut()
      localStorage.controlSidebarStatus = 0
    else
      photoWidget = $(element).parents('.photo-widget')
      photoId = photoWidget.data("photoid")
    @deletePhoto(photoId)

  deletePhoto: (photoId) ->
    photoWidget = $('.photo-widget[data-photoid=' + photoId + ']')
    alertify.confirm 'Really! Delete this Photo?', (->
      console.log photoId
      url = '/photos/' + photoId + '.json'
      # Todo: What is photoid??
      $.ajax
        url: url
        type: 'DELETE',
        contentType: 'application/json',
        success: (data) ->
          photoWidget.fadeOut(700)
          Materialize.toast("Photo is queued for deletion!", 3000)
    )
    false

  addToAlbum: (event) ->
    album_id = $('#album-list-photo * #albums input:radio:checked').val()
    photoId = $('#photo_id').data("photo_id")
    $.get '/albums/add_photo', {album_id: album_id, photo_id: photoId}, ->
      Materialize.toast("Photo was added to album", 3000)
      $('#album-list-photo').modal('close')


  showControls: (element) ->
    overlayButton = $('.overlay-button:not(.overlay-processing)', element)
    overlayButton.addClass('overlay-show')

  hideControls: (element) ->
    overlayButton = $('.overlay-button:not(.selected, .overlay-processing)', element)
    overlayButton.removeClass('overlay-show')

  modalInit: () ->
    $('#photo-modal').modal
      dismissible: true
      opacity: .5
      in_duration: 300
      out_duration: 200
      starting_top: '4%'
      ending_top: '10%'
      ready: (modal, trigger) ->
        App.PhotoTaginput.init()
        $('.collapsible').collapsible();
        $('.dropdown-button').dropdown();
      complete: ->
        return

  showModal: (element) ->
    _this = this
    photoId = $(element).parents('.photo-widget').data("photoid")
    url = '/photos/' + photoId + '?view=modal'
    $('#photo-modal > .modal-content').load url, (result) ->
      $('#photo-modal').modal('open');

  getWidget: (photoId) ->
    return $('.infinite-container > .photo-widget[data-photoid=' + photoId + ']')

$(document).on "turbolinks:load", ->
  return unless $(".photos.index, .catalogs.show, .albums.show, .locations.show").length > 0
  App.PhotoWidget.init()
