$ ->
  $('img.lazy').lazyload()
  return

$(document).ready ->
  #Event binding for adding photos to the bucket
  $('[data-toggle="popover"]').popover();



#prepare url when breadcrumb part is clicked
$ ->
  $('.searchbox, .breadcrumb li a').on 'click', ->
    el = $(this)
    url = el.attr("href")
    url = url + extendUrl()
    el.attr("href", url)

#prepare url and redirect when change dropdowns
$ ->
  $('#searchbox_country, #searchbox_direction').on 'change', ->
    dateUrl =$('.breadcrumb').attr('date_url')
    window.location = dateUrl + extendUrl()


#extend url before actions
extendUrl = ->
  direction = $("#searchbox_direction").prop('checked')
  country = $("#searchbox_country").val()
  if country != "All"
    return "/country/" + country + "/direction/" + direction
  return "/direction/" + direction

#wire things up when rotating an image
$ ->
  $('#rotate').on 'click', ->
    rotateValue = $("input[name=rotate]:checked").val()
    window.location = rotateValue

#scroll to top marker
jQuery(document).ready ->
  offset = 550
  duration = 300
  jQuery(window).scroll ->
    if jQuery(this).scrollTop() > offset
      jQuery('.back-to-top').fadeIn duration
    else
      jQuery('.back-to-top').fadeOut duration
    return
  jQuery('.back-to-top').click (event) ->
    event.preventDefault()
    jQuery('html, body').animate { scrollTop: 0 }, duration
    false
  return

#menu actions on dropdowns
#-delete:
$(document).ready ->
  $('.delete_photo').on 'click', ->
    photoId = $(this).attr('photo_id')
    pw=$('.delete_photo[photo_id="'+photoId+'"]').parents('.photo-widget')
    $.ajax
      url: '/photos/' + photoId
      type: 'DELETE',
      contentType: 'application/json',
      success: (data) ->
        pw.fadeOut(700)

    return false
  return false
