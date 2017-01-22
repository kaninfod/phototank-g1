App.PhotoTaginput = do ->

  init: ->

  bindUIActions:  ->
    _this = this
    $(".tagger").on 'tag:added', (event, data) -> _this.addTag(event, data)
    $(".tagger").on 'tag:removed', (event, data) -> _this.removeTag(event, data)


  initTags: ->
    me = this
    photo_id = $('.image_info').data("photo_id")
    url = "/photos/get_tag_list?photo_id=" + photo_id
    $.get(url).done (data) ->
      new App.Tagger
        identifier: ".tag-input"
        ajaxUrl: "/photos/get_tag_list?term="
        minLength: 2
        photoId: photo_id
        tags: data
      me.bindUIActions()

  addTag: (event, data) ->
    url = '/photos/' + data.photoId + '/addtag'
    $.get url, data, (data) ->
      $('.bootstrap-tagsinput input').val('')

  removeTag: (event, data) ->
    photo_id = $('.image-info').data("photo_id")
    url = '/photos/' + data.photoId + '/removetag'
    $.get url, data

$(document).on "turbolinks:load", ->
  return unless $(".photos.index, .catalogs.show, .albums, .locations.show").length > 0
  App.PhotoTaginput.init()
