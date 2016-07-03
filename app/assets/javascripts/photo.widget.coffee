s = undefined
App.PhotoWidget = do ->

  init: (@el) ->
    s =
      duration: 175
      photoGrid: '#photogrid'
      modalElement: $('#photoDetails')
      animationEnd: 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend';
    @bindUIActions()


  bindUIActions: ->
    _this = this
    @modalInit()
    $(s.photoGrid).on 'click.' + s.eventNamespace, '.overlay-button.overlay-select', -> _this.select(this)
    $('body').on 'click.' + s.eventNamespace, '.overlay-button.overlay-delete,#delete-photo', -> _this.delete(this)
    $(s.photoGrid).on 'click.' + s.eventNamespace, '.overlay-button.overlay-zoom', (ev) -> _this.showModal(ev, this)
    $(s.photoGrid).on 'click.' + s.eventNamespace, '.lazy', -> _this.show(this)

    $(s.photoGrid).on 'mouseenter.' + s.eventNamespace, '.photo-widget',  -> _this.showControls(this)
    $(s.photoGrid).on 'mouseleave.' + s.eventNamespace, '.photo-widget',  -> _this.hideControls(this)

    $('body').on 'click.' + s.eventNamespace, '#add-to-album-photo', -> _this.showAddToAlbum()
    $('#album-list-photo .btn-primary').on 'click' , (event) -> _this.addToAlbum(event)

    $('body').on 'click.' + s.eventNamespace, '#rotate-photo',  -> _this.rotatePhotos(this)

  rotatePhotos: (element) ->
    degrees = $(element).data('degrees')
    photoId = $('#photo_id').data("photo_id")
    processingButton = $('.photo-widget[data-photoid=' + photoId + '] .overlay-processing')

    $.get '/photos/' + photoId + '/rotate/' + degrees, (data) ->
      processingButton.addClass('overlay-show')
      $('.dropdown.open .dropdown-toggle').dropdown('toggle');
    false


  show: (element) ->
    photoId = $(element).parents('.photo-widget').data("photoid")
    url = '/photos/' + photoId + '/show_small'
    $('#control-sidebar-tab-photo').load url, (result) ->
      $('.nav-tabs a[href="#control-sidebar-tab-photo"]').tab('show')
      App.PhotoTaginput.refresh()
      App.ControlSidebar.openMenu()
      $('.dropdown-toggle').dropdown()

  select: (element) ->
    $(element).toggleClass("selected")
    photoId = $(element).parents('.photo-widget').data("photoid")
    if $(element).hasClass('selected')
      url = '/bucket/' + photoId + '/add'
    else
      url = '/bucket/' + photoId + '/remove'
    $.ajax
      method: 'POST'
      url: url
      data: {}
      success: (response) ->
        $('#bucket_counter').html response['count']
        $(".bucket").trigger('bucket:update')
        $('.nav-tabs a[href="#control-sidebar-tab-bucket"]').tab('show')


  delete: (element) ->
    if $(element).attr('id') == 'delete-photo'
      photoId = $('#photo_id').data("photo_id")
      photoWidget = $('.photo-widget[data-photoid=' + photoId + ']')
      $('#control-sidebar-tab-photo').children().fadeOut()
      App.ControlSidebar.closeMenu()
    else
      photoWidget = $(element).parents('.photo-widget')
      photoId = photoWidget.data("photoid")
    url = '/photos/' + photoId + '.json'
    # Todo: What is photoid??
    $.ajax
      url: url
      type: 'DELETE',
      contentType: 'application/json',
      success: (data) ->
        photoWidget.fadeOut(700)
    false

  showAddToAlbum: ->
    $('#album-list-photo').modal()
    $('#album-list-photo').removeClass 'hidden'

  addToAlbum: (event) ->
    album_id = $('#album-list-photo * #albums input:radio:checked').val()
    photoId = $('#photo_id').data("photo_id")
    $.get '/albums/add_photo', {album_id: album_id, photo_id: photoId}


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

  showModal: (ev, element) ->
    _this = this
    photoId = $(element).parents('.photo-widget').data("photoid")
    url = '/photos/' + photoId + '.html'
    $('#photoDetails > .modal-content').load url, (result) ->
      ev.preventDefault()
      _this.modal.open()

$(document).on "page:change", ->
  return unless $(".photos.index, .catalogs.show, .albums.show").length > 0
  App.PhotoWidget.init()
