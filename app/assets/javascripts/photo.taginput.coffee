s = undefined
App.PhotoTaginput = do ->

  init: (@el) ->
    s =
      photoGrid: '#photogrid'
    # tags = @initTags()
    @bindUIActions()

  bindUIActions: ->
    _this = this
    $(".tagger").on 'tag:added', (event, data) -> _this.addTag(event, data)
    $(".tagger").on 'tag:removed', (event, data) -> _this.removeTag(event, data)


  initTags: ->
    _this = this
    _this.bindUIActions()
    photo_id = $('.image_info').data("photo_id")
    url = "/photos/get_tag_list?photo_id=" + photo_id
    $.get(url).done (data) ->
      _this.handleInit(data)

  handleInit: (data)->
    App.Tagger.initTagger
      identifier: ".tagger"
      ajaxUrl: "/photos/get_tag_list?term="
      minLength: 2
      tags: data

  addTag: (event, data) ->
    photo_id = $('.image_info').data("photo_id")
    console.log photo_id
    url = '/photos/' + photo_id + '/addtag'
    $.get url, data, (data) ->
      $('.bootstrap-tagsinput input').val('')

  removeTag: (event, data) ->
    photo_id = $('.image-info').data("photo_id")
    url = '/photos/' + photo_id + '/removetag'
    $.get url, data

$(document).on "turbolinks:load", ->
  return unless $(".photos.index, .catalogs.show, .albums, .locations.show").length > 0
  App.PhotoTaginput.init()
