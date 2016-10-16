s = undefined
App.PhotoTaginput = do ->

  init: (@el) ->
    s =
      photoGrid: '#photogrid'
      modalElement: $('#photoDetails')
      taginput: '.tags'
      genericClass: 'label label-primary'
      mentionClass: 'label label-warning'
      remoteUrl: '/photos/get_tag_list?query=%QUERY'

    @bindUIActions()

  refresh: ->
    @initTaginput()


  bindUIActions: ->
    _this = this
    $('body').on 'itemAdded.', '.tags', (event) -> _this.addTag(event)
    $('body').on 'beforeItemRemove.', '.tags', (event) -> _this.removeTag(event)
    $('.bootstrap-tagsinput > input').autocomplete
      source: '/photos/get_tag_list'
      minLength: 1

  addTag: (event) ->
    photo_id = $('#photo_id').data("photo_id")
    url = '/photos/' + photo_id + '/addtag'
    tag = {tag: event.item}
    $.get url, tag, (data) ->
      $('.bootstrap-tagsinput input').val('')


  removeTag: (event) ->
    photo_id = $('#photo_id').data("photo_id")
    url = '/photos/' + photo_id + '/removetag'
    tag = {tag: event.item}
    $.get url, tag

  initTaginput: ->
    $(s.taginput).tagsinput
      tagClass: (item) ->
        switch item.charAt(0)
          when '@'
            s.genericClass
          else
            s.mentionClass
      trimValue: true
    $('.bootstrap-tagsinput > input').autocomplete
      source: '/photos/get_tag_list'
      minLength: 1
      select: (event, ui) ->
        $(s.tagInput).tagsinput('add', ui.item.value);


$(document).on "turbolinks:load", ->
  return unless $(".photos.index, .catalogs.show, .albums.show , .locations.show").length > 0
  App.PhotoTaginput.init()
