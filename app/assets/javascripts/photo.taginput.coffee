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
    $(s.photoGrid).on 'click.' + s.eventNamespace, '.tags', (event) -> _this.addTag(event)
    $(s.photoGrid).on 'click.' + s.eventNamespace, '.tags', (event) -> _this.removeTag(event)


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
  App.PhotoTaginput.init()
