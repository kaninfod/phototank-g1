

updateBucketCounter = (count) ->
  $('#bucket_counter').html count
  return
  
$ ->
  $('.show_map').popover container: 'body'
  return


$ ->
  $('.photo-widget .photo-widget-header img').click (e) ->
    console.log this
    $(this).toggleClass("bucket")

    if $(this).hasClass('bucket')
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
