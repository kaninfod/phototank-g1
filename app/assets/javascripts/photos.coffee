

updateBucketCounter = (count) ->
  $('#bucket_counter').html count
  return

$ ->
  $('.bucket-check').change ->

    if $(this).is(':checked')
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
  $('.show_map').popover container: 'body'
  return
