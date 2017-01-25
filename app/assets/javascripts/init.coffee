window.App ||= {}

App.init = ->
  App.objects = []
$(document).on "turbolinks:load", ->
  App.init()
