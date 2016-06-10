# app/assets/javascripts/app.chart.coffee
class App.Comment
  constructor: (@el) ->
    #init scroll on comments_widget
    $('.box-comments').slimScroll height: $(window).height() - 100


  render: ->



$(document).on "page:change", ->
  comment = new App.Comment
  comment.render()


  # Add comment
  $('#myModal').on 'click','#like', ->
  $('#myModal').on 'keypress', '#comment_input', (e) ->
    if e.which == 13
      photo_id = $('.image_info').attr('photo_id')
      url = '/photos/' + photo_id + '/add_comment'
      $.get url, { comment: $(this).val() }, (msg) ->
        $(msg).hide().prependTo('.box-comments').fadeIn 1000
        return
      $(this).val ''
      return false
    return
  return
