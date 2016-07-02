s = undefined
_this = this
App.PhotoGrid = do ->

  init: (@el) ->
    @wp = null
    s =
      photoGrid: '#photogrid'
      duration: 300
      offset:500
    @wp = @initWaypoint()
    @bindUIActions()

  bindUIActions: ->
    $('img.lazy').lazyload()
    $(s.photoGrid).on 'click.' + s.eventNamespace, '.delete_photo', -> _this.deletePhoto(this)
    $(window).scroll -> _this.showScrollTop(this)
    $('.back-to-top').click (event) -> _this.scrollTop(event)
    $('body').on 'click.' + s.eventNamespace, '.searchbox, .breadcrumb li a', -> _this.setBreadcrumbUrl(this)
    $('body').on 'change.' + s.eventNamespace, '#searchbox_country, #searchbox_direction', -> _this.searboxDropdownChange()
    $('.dropdown-toggle').dropdown()
    $('[data-toggle="popover"]').popover()
    Waypoint.refreshAll()

  scrollTop: (event) ->
    event.preventDefault()
    
    $('html, body').animate { scrollTop: 0 }, s.duration
    false

  showScrollTop: (scroll)->
    if $(scroll).scrollTop() > s.offset
      $('.back-to-top').fadeIn s.duration
    else
      $('.back-to-top').fadeOut s.duration
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
      $('.loading-notification').fadeIn 100
      url = $('.next_page').last()[0].href
      nextPage = $.get(url)
      nextPage.success (data) ->
        $('.infinite-container').append data
        $('.loading-notification').fadeOut 100
        _this.bindUIActions()


$(document).on "page:change", ->
  return unless $(".photos.index, .catalogs.show, .albums.show").length > 0
  App.PhotoGrid.init()
