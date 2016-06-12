# app/assets/javascripts/app.chart.coffee
s = undefined
class App.PhotoComment

  #Singleton implementation
  instance = null
  class PrivateClass
    constructor: () ->

  @get: (message) ->
    if not instance?
      instance = new @
      instance.init()
    instance


  init: (@el) ->
    s =
      modalElement: $('#myModal')
      commentInput: '#comment_input'
      commentsBox: '.box-comments'
    #init scroll on comments_widget
    $(s.commentsBox).slimScroll height: $(window).height() - 100
    @bindUIActions()

  bindUIActions: ->
    _this = this
    s.modalElement.on 'keypress', s.commentInput, (event) -> _this.addComment(event, this)

  addComment: (event, input) ->
    if event.which == 13
      url = @getUrl()
      console.log url
      $.get url, { comment: $(input).val() }, (msg) ->
        $(msg).hide().prependTo(s.commentsBox).fadeIn 1000
      $(input).val ''
      return false


  getUrl: ->
    photo_id = $('.image_info').attr('photo_id')
    url = '/photos/' + photo_id + '/add_comment'

$(document).on "page:change", ->
  return unless $(".photos.index").length > 0
  App.PhotoComment.get()
