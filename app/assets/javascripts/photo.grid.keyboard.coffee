s = undefined
App.PhotoGridKeyboard = do ->

  init: (@el) ->
    s =
      scrollDuration: 100
      scrollMargin: 200
    @bindUIActions()


  bindUIActions: ->
    _this = this
    Mousetrap.bind 'right', -> _this.highlightRight()
    Mousetrap.bind 'left', -> _this.highlightLeft()
    Mousetrap.bind 'down', -> _this.highlightDown()
    Mousetrap.bind 'up', -> _this.highlightUp()
    Mousetrap.bind 'v', -> _this.viewHighlightSmall()
    Mousetrap.bind 'm', -> _this.viewHighlightLarge()
    Mousetrap.bind 'c', -> _this.toggleControlMenu()
    Mousetrap.bind 'l', -> _this.likePhoto()
    Mousetrap.bind 'd', -> _this.deletePhoto()
    Mousetrap.bind 'b', -> _this.addToBucket()

  addToBucket: ->
    photoId = $('.photo-widget.highlight').data('photoid')
    App.PhotoWidget.addToBucket(photoId)


  deletePhoto: ->
    photoId = $('.photo-widget.highlight').data('photoid')
    App.PhotoWidget.deletePhoto(photoId)

  likePhoto: ->
    photoId = $('.photo-widget.highlight').data('photoid')
    App.PhotoLike.likePhoto(photoId)

  toggleControlMenu: ->
    if $('body').hasClass('control-sidebar-open')
      $.AdminLTE.controlSidebar.close()
      localStorage.controlSidebarStatus == 'close'
    else
      $.AdminLTE.controlSidebar.open()
      localStorage.controlSidebarStatus == 'open'

  viewHighlightLarge: ->
    highlight = $('.photo-widget.highlight img')
    App.PhotoWidget.showModal(highlight)

  viewHighlightSmall: ->
    highlight = $('.photo-widget.highlight img')
    App.PhotoWidget.show(highlight)

  highlightUp: ->
    if $('.photo-widget.highlight').length == 0
      highlight = $('.photo-widget').first()
    else
      current = $('.photo-widget.highlight')
      currentIndex = $('.photo-widget').index(current)
      nextIndex = 1 + currentIndex - this._numberOfWidgetPerRow()

      highlight = $( ".photo-widget:nth-of-type(" + nextIndex + ")" )
      $('.photo-widget.highlight').removeClass('highlight')
    this._setFocus(highlight)

  highlightDown: ->
    if $('.photo-widget.highlight').length == 0
      highlight = $('.photo-widget').first()
    else
      current = $('.photo-widget.highlight')
      currentIndex = $('.photo-widget').index(current)
      nextIndex = 1 + currentIndex + this._numberOfWidgetPerRow()

      highlight = $( ".photo-widget:nth-of-type(" + nextIndex + ")" )
      $('.photo-widget.highlight').removeClass('highlight')
    this._setFocus(highlight)


  highlightRight: ->
    if $('.photo-widget.highlight').length == 0
      highlight = $('.photo-widget').first()
    else
      highlight = $('.photo-widget.highlight').next('.photo-widget')
      $('.photo-widget.highlight').removeClass('highlight')
    this._setFocus(highlight)

  highlightLeft: ->
    if $('.photo-widget.highlight').length == 0
      highlight = $('.photo-widget').first()
    else
      highlight = $('.photo-widget.highlight').prev()
      $('.photo-widget.highlight').removeClass('highlight')
    this._setFocus(highlight)

  _numberOfWidgetPerRow: ->
    containerWidth=$('.infinite-container').outerWidth(true)
    photoWidgetWidth=$('.photo-widget:first').outerWidth(true)
    return Math.floor(containerWidth/photoWidgetWidth)

  _setFocus: (element) ->
    element.addClass('highlight')
    element.focus()
    $('html, body').animate(scrollTop: element.offset().top - s.scrollMargin , s.scrollDuration)
    # if $('body').hasClass('control-sidebar-open')
    #   App.PhotoWidget.show(element.find('img'))

$(document).on "page:change", ->
  return unless $(".photos.index, .catalogs.show, .albums.show").length > 0
  App.PhotoGridKeyboard.init()
