s = undefined
class App.PhotoGrid

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
      instance.initWaypoint()
    instance

  init: (@el) ->
    @wp = null
    s =
      duration: 300
    @wp = @initWaypoint()
    @bindUIActions()

  bindUIActions: ->
    _this = this
    $('img.lazy').lazyload()
    $('.delete_photo').on 'click', -> _this.deletePhoto(this)
    $('#rotate').on 'click', -> _this.rotatePhoto()
    jQuery(window).scroll -> _this.showScrollTop(this)
    jQuery('.back-to-top').click (event) -> _this.scrollTop()
    $('.searchbox, .breadcrumb li a').on 'click', -> _this.setBreadcrumbUrl(this)
    $('#searchbox_country, #searchbox_direction').on 'change', -> _this.searboxDropdownChange()
    $('.lazy').on 'click', -> _this.modalInit(this)
    $('.dropdown-toggle').dropdown()
    $('[data-toggle="popover"]').popover()
    Waypoint.refreshAll()



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

  scrollTop: ->
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

  modalInit: (photoContainer) ->
    url = '/photos/' + $(photoContainer).attr('photo_id')
    $('.modal-body').load url, (result) ->
      $('#myModal').modal
        show: true
        keyboard: true
      App.PhotoLike.get()
      App.PhotoTaginput.get()
      App.PhotoComment.get()


$(document).on "page:change", ->

  return unless $(".photos.index").length > 0

  App.PhotoGrid.get()
