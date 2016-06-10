# app/assets/javascripts/app.chart.coffee
class App.Photo
  constructor: (@el) ->
    


  render: ->

$(document).on "page:change", ->
  photo = new App.Photo
  photo.render()


  #Like picture
  $('#myModal').on 'click','#like', ->
    photo_id = $('.image_info').attr('photo_id')
    url = '/photos/' + photo_id + '/like'
    $.get url, (data) ->
      $('#likes_num').html data['likes'] + ' likes'
      $('#like').toggleClass 'btn-success'
      return
    return
