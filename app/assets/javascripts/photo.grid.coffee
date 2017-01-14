s = undefined
App.PhotoGrid = do ->

  init: ->
    s =
      photoGrid: '#photogrid'
      duration: 300
      offset:800
      loading: true
    @bindUIActions()


  bindUIActions: ->

    _this = this
    @modalInit()
    $(".fixed-action-btn").on 'click.' + s.eventNamespace, '#locations',-> _this.showModal(this)
    $('img.lazy').lazyload()

    $(window).unbind('scroll');
    $(window).scroll -> _this.showScrollTop(this)

    $('.back-to-top').click (event) -> _this.scrollTop(event)

    $('.dropdown-toggle').dropdown()

    $('body,html').scroll();


  modalInit: () ->
    $('#list-modal').modal


  showModal: (element) ->
    _this = this
    console.log 'kaj'
    url = '/locations'
    $('#list-modal > .modal-content').load url, (result) ->
      $('#list-modal').modal('open');


  scrollTop: (event) ->
    event.preventDefault()
    $('html, body').animate { scrollTop: 0 }, s.duration
    false

  showScrollTop: (scroll)->
    #Infinite scroll event
    scrollPosition = $('.loadMore').offset().top  - ($(window).height() + $(window).scrollTop() + s.offset)
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

    if $('.next_page').length > 0 and $('.next_page.disabled').length == 0
      url = $('.next_page').last()[0].href
      $('.loading-notification').fadeIn 100

      data = App.BottomPanel.getSearchParams()
      nextPage = $.get(url, data, dataType: "json")
      nextPage.done (data) ->
        $('#photogrid').append data
        $('.loading-notification').fadeOut 100
        $('.pagination:first').parent().remove()
        $('img.lazy').lazyload()
        s.loading = true


$(document).on "turbolinks:load", ->
  return unless $(".photos.index, .catalogs.show, .albums.show, .locations.show").length > 0
  App.PhotoGrid.init()
