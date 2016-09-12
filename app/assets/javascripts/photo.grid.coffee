s = undefined
App.PhotoGrid = do ->

  init: ->
    s =
      photoGrid: '#photogrid'
      duration: 300
      offset:900
      loading: true
    @bindUIActions()


  bindUIActions: ->

    _this = this

    $('img.lazy').lazyload()

    $(window).unbind('scroll');
    $(window).scroll -> _this.showScrollTop(this)

    $('.back-to-top').click (event) -> _this.scrollTop(event)

    $('.dropdown-toggle').dropdown()

    $('body,html').scroll();
    $.AdminLTE.controlSidebar.activate()

  scrollTop: (event) ->
    event.preventDefault()
    $('html, body').animate { scrollTop: 0 }, s.duration
    false

  showScrollTop: (scroll)->
    #Infinite scroll event
    scrollPosition = $('.loadMore').offset().top  - ($(window).height() + $(window).scrollTop() + s.offset)
    console.log scrollPosition
    console.log s.loading
    if scrollPosition < 0 and s.loading
      @getNextPage()

    #Scroll to top show event
    if $(scroll).scrollTop() > s.offset
      $('.back-to-top').fadeIn s.duration
    else
      $('.back-to-top').fadeOut s.duration
    return

  getNextPage:  ->
    _this = this
    s.loading = false
    if $('.next_page').last().length > 0
      url = $('.next_page').last()[0].href
      $('.loading-notification').fadeIn 100

      data = App.ControlSidebar.getSearchParams()

      nextPage = $.get(url, data)
      nextPage.success (data) ->
        $('.infinite-container').append data
        $('.loading-notification').fadeOut 100
        $('.pagination:first').parent().remove()
        $('img.lazy').lazyload()
        s.loading = true


$(document).on "turbolinks:load", ->
  return unless $(".photos.index, .catalogs.show, .albums.show, .locations.show").length > 0
  App.PhotoGrid.init()
