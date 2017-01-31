class App.BucketTagger

  constructor:  ->
    new App.Tagger
      identifier: "#bucket-tagger"
      ajaxUrl: "/photos/get_tag_list?term="
      minLength: 2
    @bindUIActions()

  bindUIActions:  ->
    $(".tagger").on 'tag:added', (event, data) => @addTag(event, data)
    $(".tagger").on 'tag:removed', (event, data) => @removeTag(event, data)

  addTag: (event, data) ->

  removeTag: (event, data) ->

$(document).on "turbolinks:load", ->
  bucketTagger = new App.BucketTagger
