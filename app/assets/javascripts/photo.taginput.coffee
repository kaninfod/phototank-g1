# app/assets/javascripts/app.chart.coffee
s = undefined
class App.PhotoTaginput
  instance = null
  class PrivateClass
    constructor: () ->

  @get: (message) ->
    if not instance?
      instance = new @
      instance.init()
    instance

  init: (@el) ->
    s =
      modalElement: $('#myModal')
      tagInput: '.tags'
      genericClass: 'label-success'
      mentionClass: 'label-danger'
      remoteUrl: '/photos/get_tag_list?query=%QUERY'
    @initTaginput()
    @bindUIActions()

  bindUIActions: ->
    _this = this
    s.modalElement.on 'itemAdded', '.tags', (event) -> _this.addTag(event)
    s.modalElement.on 'itemRemoved', '.tags', (event) -> _this.removeTag(event)

  refresh: ->
    @initTaginput()

  addTag: (event) ->
    photo_id = $('.image_info').attr('photo_id')
    url = '/photos/' + photo_id + '/addtag'
    tag = event.item
    $.ajax
      method: 'GET'
      url: url
      data: tag: tag


  removeTag: (event) ->
    photo_id = $('.image_info').attr('photo_id')
    url = '/photos/' + photo_id + '/removetag'
    tag = event.item
    $.ajax
      method: 'GET'
      url: url
      data: tag: tag

  initTaginput: ->
    bloodhound = new Bloodhound(
      datumTokenizer: (d) ->
        Bloodhound.tokenizers.whitespace d.value
      queryTokenizer: Bloodhound.tokenizers.whitespace
      remote: s.remoteUrl
      limit: 50)
    bloodhound.initialize()

    $(s.tagInput).tagsinput
      tagClass: (item) ->
        if item.charAt(0) == '@' then s.genericClass else s.mentionClass
      trimValue: true
      typeaheadjs:
        displayKey: 'name'
        valueKey: 'name'
        source: bloodhound.ttAdapter()

$(document).on "page:change", ->
  return unless $(".photos.index").length > 0
  App.PhotoTaginput.get()
