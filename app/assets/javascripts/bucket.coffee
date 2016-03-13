# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.photo-widget .photo-widget-header img').click (e) ->

    overlay = $(e.target).prev(".photo-widget-overlay")
    console.log(overlay)
    overlay.toggleClass("bucket")

    if $(overlay).hasClass('bucket')
      url = '/bucket/' + $(this).attr('photo_id') + '/add'
    else
      url = '/bucket/' + $(this).attr('photo_id') + '/remove'

    $.ajax
      method: 'POST'
      url: url
      data: {}
      success: (response) ->
        $('#bucket_counter').html response['count']
        return
    return
  return

$ ->
  $('#photo_bucket_panel').click ->
    if $(this).closest(".dropdown").hasClass("open")
      $.get '/bucket/list', (data) ->
        $('#photos_in_bucket').html data
        return
      return
    return
  return


update_bucket_count = ->
  $.get '/bucket/count', (data) ->
    $('#bucket_counter').html data['count']

$(document).ready ->
  update_bucket_count()
