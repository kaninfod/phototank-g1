# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('#photo_bucket_panel').click ->
    $.get '/bucket/list', (data) ->
      $('#control-sidebar-home-tab').html data


      return
    return
  return
