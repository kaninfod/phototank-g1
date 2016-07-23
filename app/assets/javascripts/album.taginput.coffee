s = undefined
App.AlbumTaginput = do ->

  init: (@el) ->
    s =
      photoGrid: '#photogrid'
      modalElement: $('#photoDetails')
      taginput: '#album_tags'
      genericClass: 'label label-primary'
      mentionClass: 'label label-warning'
      remoteUrl: '/photos/get_tag_list?query=%QUERY'
    @bindUIActions()
    @initTaginput()
    @initdatepicker()

  refresh: ->
    @initTaginput()

  bindUIActions: ->
    _this = this
    $('body').on 'itemAdded.' + s.eventNamespace, '.tags', (event) -> _this.addTag(event)
    $('body').on 'beforeItemRemove.' + s.eventNamespace, '.tags', (event) -> _this.removeTag(event)


  initdatepicker: ->
    $('.input-daterange').datepicker
      format: 'yyyy/mm/dd'
      inputs: $('.actual_range')
    $('#album_start').datepicker('setDate', $('#album_start').val());
    $('#album_end').datepicker('setDate', $('#album_end').val());



  initTaginput: ->

    $(s.taginput).tagsinput
      itemValue: 'value'
      itemText: 'text'
      tagClass: (item) ->
        switch item.text.charAt(0)
          when '@'
            s.genericClass
          else
            s.mentionClass

    $('.bootstrap-tagsinput > input').autocomplete
      source: '/photos/get_tag_list'
      minLength: 1
      select: (event, ui) ->
        $(s.taginput).tagsinput('add', { "value": ui.item.id, "text": ui.item.value})

    t = $(s.taginput).data('tags')
    $.each t, (index, o) ->
      $(s.taginput).tagsinput('add', { "value": o.id, "text": o.value});

    $(s.taginput).on 'itemAdded', (event) ->
      $('.bootstrap-tagsinput input').val('')


$(document).on "page:change", ->
  return unless $(".albums.edit").length > 0
  App.AlbumTaginput.init()
