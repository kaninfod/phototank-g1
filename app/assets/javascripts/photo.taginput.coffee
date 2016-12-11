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
    _this = this
    $('.chips').on 'chip.add', (e, chip) -> _this.addTag(e, chip)
    $('.chips').on 'chip.delete', (e, chip) -> _this.removeTag(e, chip)
    $('.chips > input').autocomplete
      data: {
      "Apple": null,
      "Microsoft": null,
      "Google": 'http://placehold.it/250x250'
      }

  bindUIActions: ->
    _this = this
    #$('.chips .chips-initial').on 'chip.add', (e, chip) -> _this.addTag(event)
    #$('body').on 'itemAdded.', '.tags', (event) -> _this.addTag(event)
    #$('body').on 'beforeItemRemove.', '.tags', (event) -> _this.removeTag(event)
    # $('.chips > input').autocomplete
    #   source: '/photos/get_tag_list'
    #   minLength: 1

  addTag: (e, chip) ->
    console.log chip
    photo_id = $('#photo_id').data("photo_id")
    url = '/photos/' + photo_id + '/addtag'

    $.get url, chip, (data) ->
      $('.bootstrap-tagsinput input').val('')


  removeTag: (e, chip) ->
    photo_id = $('#photo_id').data("photo_id")
    url = '/photos/' + photo_id + '/removetag'

    $.get url, chip

  initTaginput: ->
    $('.chips').material_chip()
    tags = JSON.parse(JSON.stringify($('.chips').data('tags')).replace(/name/g, "tag"))





    # $(s.taginput).tagsinput
    #   tagClass: (item) ->
    #     switch item.charAt(0)
    #       when '@'
    #         s.genericClass
    #       else
    #         s.mentionClass
    #   trimValue: true
    # $('.chips > input').autocomplete
    #   source: '/photos/get_tag_list'
    #   minLength: 1
    #   select: (event, ui) ->
    #     console.log "dayum"
        #$(s.tagInput).tagsinput('add', ui.item.value);


$(document).on "turbolinks:load", ->
  return unless $(".photos.index, .catalogs.show, .albums.show , .locations.show").length > 0
  App.PhotoTaginput.init()
