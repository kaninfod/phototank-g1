# app/assets/javascripts/app.chart.coffee
class App.Bucket
  constructor: (@el) ->
    #update the photo count in the bucket
    update_bucket_count()
    loadBucket()
    $('.bucket').slimScroll height: $(window).height() - 400

  render: ->


$(document).on "page:change", ->
  bucket = new App.Bucket
  bucket.render()



  $('#photo_bucket_panel').on 'click', ->
    if $(this).closest(".dropdown").hasClass("open")
      $.get '/bucket/list', (data) ->
        $('#photos_in_bucket').html data
        return
      return
    return

  $(document).on 'click', '.photo-widget-overlay', ->
    toggleBucket($(this))
    return

  #Event binding for adding photos to the bucket
  $('[data-toggle="popover"]').popover();


  $('.context-menu').hover (->
    $.AdminLTE.controlSidebar.open()
    return
  ), null
  $('.control-sidebar').hover null, ->
    if !$('#pin').hasClass('active')
      $.AdminLTE.controlSidebar.close()
    return
  $('#pin').on 'click', ->
    $(this).toggleClass 'active'
    return

  $('.bucket').on 'bucket:update', ->
    loadBucket()
    return

  #Like picture
  $('#like').on 'click', ->
    photo_id = $('.image_info').attr('photo_id')
    url = '/bucket/like'
    $.get url
    return

  #Unlike picture
  $('#unlike').on 'click', ->
    photo_id = $('.image_info').attr('photo_id')
    url = '/bucket/unlike'
    $.get url
    return

  # Add comment
  $('#comment-input-bucket').keypress (e) ->
    if e.which == 13
      photo_id = $('.image_info').attr('photo_id')
      url = '/bucket/add_comment'
      $.get url, comment: $(this).val()
      $(this).val ''
      return false
    return


#load bucket into side panel
loadBucket = ->
  $.get '/bucket/list', (data) ->
    $('.bucket').html data
    return
  return

toggleBucket = (photoOverlay) ->
  photoOverlay.toggleClass("bucket_overlay")
  imgDiv = photoOverlay.next()

  if $(photoOverlay).hasClass('bucket_overlay')
    url = '/bucket/' + $(imgDiv).attr('photo_id') + '/add'
  else
    url = '/bucket/' + $(imgDiv).attr('photo_id') + '/remove'

  $.ajax
    method: 'POST'
    url: url
    data: {}
    success: (response) ->
      $('#bucket_counter').html response['count']
      $(".bucket").trigger('bucket:update')
      return
  return

update_bucket_count = ->
  $.get '/bucket/count', (data) ->
    $('#bucket_counter').html data['count']
