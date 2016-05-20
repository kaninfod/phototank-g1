# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  #update the photo count in the bucket
  update_bucket_count()

  #Event binding for adding photos to the bucket
  $(document).on 'click', '.photo-widget-overlay', (event) ->
    toggleBucket($(this))
    return

toggleBucket = (photoOverlay) ->
  photoOverlay.toggleClass("bucket")
  imgDiv = photoOverlay.next()

  if $(photoOverlay).hasClass('bucket')
    url = '/bucket/' + $(imgDiv).attr('photo_id') + '/add'
  else
    url = '/bucket/' + $(imgDiv).attr('photo_id') + '/remove'

  $.ajax
    method: 'POST'
    url: url
    data: {}
    success: (response) ->
      $('#bucket_counter').html response['count']
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
