# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('#photo_bucket_panel').click ->
    $.get '/bucket/list', (data) ->
      $('#photos_in_bucket').html data
      return
    return
  return

$.fn.visibleHeight = ->
  elBottom = undefined
  elTop = undefined
  scrollBot = undefined
  scrollTop = undefined
  visibleBottom = undefined
  visibleTop = undefined
  _ref = undefined
  _ref1 = undefined
  scrollTop = $(window).scrollTop()
  scrollBot = scrollTop + $(window).height()
  elTop = @offset().top
  elBottom = elTop + @outerHeight()
  visibleTop = if elTop < scrollTop then scrollTop else elTop
  visibleBottom = if elBottom > scrollBot then scrollBot else elBottom
  visibleBottom - visibleTop

$(document).click (e) ->
  # check that your clicked
  # element has no id=info
  if (!$('#photos_in_bucket').find(e.target).length)
    if (e.target.id != 'photo_bucket_panel' && !$('#photo_bucket_panel').find(e.target).length && $('#photos_in_bucket').hasClass("control-sidebar-open"))
      console.log(e.target)
      $('#photos_in_bucket').toggleClass("control-sidebar-open")
    return
  else
    window.location = "/bucket"
  return
