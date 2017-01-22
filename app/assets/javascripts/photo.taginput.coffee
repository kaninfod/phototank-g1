class App.PhotoTaginput

  constructor: (photoId) ->
    url = "/photos/get_tag_list?photo_id=" + photoId
    $.get(url).done (data) =>
      new App.Tagger
        identifier: ".tag-input"
        ajaxUrl: "/photos/get_tag_list?term="
        minLength: 2
        photoId: photoId
        tags: data
      @bindUIActions()

  bindUIActions:  ->
    $(".tagger").on 'tag:added', (event, data) => @addTag(event, data)
    $(".tagger").on 'tag:removed', (event, data) => @removeTag(event, data)

  addTag: (event, data) ->
    url = '/photos/' + data.photoId + '/addtag'
    $.get url, data, (data)

  removeTag: (event, data) ->
    photo_id = $('.image-info').data("photo_id")
    url = '/photos/' + data.photoId + '/removetag'
    $.get url, data

$(document).on "turbolinks:load", ->
  return unless $(".photos.index, .catalogs.show, .albums, .locations.show").length > 0
