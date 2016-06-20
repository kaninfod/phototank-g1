s = undefined
App.PhotoTaginput = do ->

  init: (@el) ->
    s =
      photoGrid: '#photogrid'
      modalElement: $('#photoDetails')
      tagInput: '.tags'
      genericClass: 'label-success'
      mentionClass: 'label-danger'
      remoteUrl: '/photos/get_tag_list?query=%QUERY'
    @bindUIActions()

  refresh: ->
    @initTaginput()

  bindUIActions: ->
    _this = this
    $(s.photoGrid).on 'itemAdded.' + s.eventNamespace, '.tags', (event) -> _this.addTag(event)
    $(s.photoGrid).on 'beforeItemRemove.' + s.eventNamespace, '.tags', (event) -> _this.removeTag(event)
    $('.bootstrap-tagsinput > input').autocomplete
      source: '/photos/get_tag_list'
      minLength: 1

  addTag: (event) ->
    photo_id = $('.image_info').attr('photo_id')
    url = '/photos/' + photo_id + '/addtag'
    tag = {tag: event.item}
    $.get url, tag

  removeTag: (event) ->
    photo_id = $('.image_info').attr('photo_id')
    url = '/photos/' + photo_id + '/removetag'
    tag = {tag: event.item}
    $.get url, tag

  initTaginput: ->
    $(s.tagInput).tagsinput
      tagClass: (item) ->
        if item.charAt(0) == '@' then s.genericClass else s.mentionClass
      trimValue: true
    $('.bootstrap-tagsinput > input').autocomplete
      source: '/photos/get_tag_list'
      minLength: 1
      select: (event, ui) ->
        $(s.tagInput).tagsinput('add', ui.item.value);


$(document).on "page:change", ->
  return unless $(".photos.index").length > 0
  App.PhotoTaginput.init()
