# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('.dropdown-toggle').dropdown()

$ ->
  $('#search-albums').change ->
    if @value == ''
      window.location = 'albums'
    else
      window.location = 'albums?q=' + @value
    return
  return
