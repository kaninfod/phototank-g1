$ ->
  $('#add-item').click ->
    id = $('#watch-path-group').children().length + 1
    $('#watch-path-group').append '<input style="margin-top: 4px;" id=wp_"' + id + '" name=wp_"' + id + '" type="text" class="form-control" placeholder="New path...">'
    return
  return
$ ->
  $('#sync_from').change (val) ->
    $('#album-list').toggleClass 'hidden'
    $('#catalog-list').toggleClass 'hidden'
    return
  return
$(document).ready ->
  sync_from = $('#sync_from').val()
  if sync_from == 'album'
    $('#catalog-list').toggleClass 'hidden'
  else
    $('#album-list').toggleClass 'hidden'
  return
