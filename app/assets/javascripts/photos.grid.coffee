s = undefined
App.PhotoGrid = do ->

  init: (@el) ->
    @wp = null
    s =
      photoGrid: '#photogrid'
      duration: 300
    @wp = @initWaypoint()
    @bindUIActions()

  bindUIActions: ->
    _this = this
    @modalInit()
    $('img.lazy').lazyload()
    $(s.photoGrid).on 'click.' + s.eventNamespace,'.lazy', (ev) -> _this.showModal(ev, this)
    $(s.photoGrid).on 'click.' + s.eventNamespace, '.delete_photo', -> _this.deletePhoto(this)
    $(s.photoGrid).on 'click.' + s.eventNamespace, '#rotate', -> _this.rotatePhoto()
    jQuery(window).scroll -> _this.showScrollTop(this)
    jQuery('.back-to-top').click (event) -> _this.scrollTop(event)
    $('body').on 'click.' + s.eventNamespace, '.searchbox, .breadcrumb li a', -> _this.setBreadcrumbUrl(this)
    $('body').on 'change.' + s.eventNamespace, '#searchbox_country, #searchbox_direction', -> _this.searboxDropdownChange()
    $('.dropdown-toggle').dropdown()
    $('[data-toggle="popover"]').popover()
    Waypoint.refreshAll()
    @initControlSidebar()

  deletePhoto: (photoContainer) ->
    photoId = $(photoContainer).attr('photo_id')
    # Todo: What is photoid??
    pw=$('.delete_photo[photo_id="'+ photoId +'"]').parents('.photo-widget')
    $.ajax
      url: '/photos/' + photoId
      type: 'DELETE',
      contentType: 'application/json',
      success: (data) ->
        pw.fadeOut(700)

  rotatePhoto: ->
    rotateValue = $("input[name=rotate]:checked").val()
    window.location = rotateValue

  scrollTop: (event) ->
    event.preventDefault()
    jQuery('html, body').animate { scrollTop: 0 }, s.duration
    false

  showScrollTop: (scroll)->
    if jQuery(scroll).scrollTop() > s.offset
      jQuery('.back-to-top').fadeIn s.duration
    else
      jQuery('.back-to-top').fadeOut s.duration
    return

  setBreadcrumbUrl: (element) ->
    el = $(element)
    url = el.attr("href")
    url = url + @extendUrl()
    el.attr("href", url)

  searboxDropdownChange: ->
    dateUrl =$('.breadcrumb').attr('date_url')
    window.location = dateUrl + @extendUrl()

  extendUrl: ->
    direction = $("#searchbox_direction").prop('checked')
    country = $("#searchbox_country").val()
    if country != "All"
      return "/country/" + country + "/direction/" + direction
    return "/direction/" + direction


  initWaypoint: ->
    _this = this
    waypoint = new Waypoint(
      element: $('.loadMore')
      offset: ->
        @context.innerHeight() - @adapter.outerHeight() + 500
      handler: (direction) ->
        _this.getNextPage(direction)
      )
    return waypoint

  getNextPage: (direction) ->
    _this = this
    if direction == 'down'
      url = $('.next_page').last()[0].href
      nextPage = $.get(url)
      nextPage.success (data) ->
        $('.infinite-container').append data
        _this.bindUIActions()

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

  showModal: (ev, photoContainer) ->
    _this = this
    url = '/photos/' + $(photoContainer).attr('photo_id')
    $('#photoDetails > .modal-content').load url, (result) ->
      ev.preventDefault()
      _this.modal.open()



  initControlSidebar: ->
    if $._data($('[data-toggle=\'control-sidebar\']')[0]).events == undefined
      $.AdminLTE.controlSidebar.activate()


$(document).on "page:change", ->
  return unless $(".photos.index").length > 0
  App.PhotoGrid.init()
