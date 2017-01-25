class App.BucketTagger

  constructor:  ->
    console.log 'done'
    new App.Tagger
      identifier: "#bucket-tagger"
      ajaxUrl: "/photos/get_tag_list?term="
      minLength: 2
    @bindUIActions()

  bindUIActions:  ->
    $(".tagger").on 'tag:added', (event, data) => @addTag(event, data)
    $(".tagger").on 'tag:removed', (event, data) => @removeTag(event, data)

  addTag: (event, data) ->
    console.log data
  removeTag: (event, data) ->
    console.log data
$(document).on "turbolinks:load", ->
  bucketTagger = new App.BucketTagger
