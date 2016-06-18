s = undefined
App.PhotoEdit = do ->

  init: (@el) ->
    s =
      searchSelector: 'input.typeahead'
    @refresh()
    @bindUIActions()



  refresh: ->
    _this = this
    $('#date_taken').datepicker
      format: 'yyyy/mm/dd'
    $('#date_taken').datepicker 'update'

    $('.inp_toggle').change -> _this.toggleInput(this)

    @initBloodhound()
    @bloodhound.initialize()
    @initTypeahead()

  bindUIActions: ->
    _this = this
    $('body').on 'click.' + s.eventNamespace, '#rotate', -> _this.rotatePhoto()
    $('body').on 'click.' + s.eventNamespace, '#save-meta-data', -> _this.saveMetaData()


  toggleInput: (chkbox) ->
    tb = $(chkbox).parents('.form-group').children().find('.inp')
    tb.prop 'disabled', !$(chkbox).is(":checked")

  initTypeahead: ->
    _this = this
    $(s.searchSelector).typeahead {
      highlight: true
      hint: true
      minLength: 3
    },
      displayKey: 'address'
      source: _this.bloodhound.ttAdapter()

    $(s.searchSelector).bind 'typeahead:selected', (event, datum, name) ->
      $('#location_id').val datum.id


  initBloodhound: ->
    @bloodhound = new Bloodhound(
      datumTokenizer: (d) ->
        Bloodhound.tokenizers.whitespace d.value
      queryTokenizer: Bloodhound.tokenizers.whitespace
      remote: '/locations/typeahead/%QUERY'
      limit: 50)


  saveMetaData: ->
    photo_id = $('.image_info').attr('photo_id')
    data = JSON.parse(JSON.stringify(jQuery('#edit-meta-data').serializeArray()))
    $.ajax
      url: '/photos/' + photo_id
      type: 'PUT',
      contentType: 'application/json',
      data: JSON.stringify(data)



  rotatePhoto: ->
    photo_id = $('.image_info').attr('photo_id')
    rotateValue = $("input[name=rotate]:checked").val()
    url = '/photos/'+ photo_id + '/rotate/' + rotateValue
    $.get url

$(document).on "page:change", ->
  # return unless $(".photos.edit").length > 0
  App.PhotoEdit.init()
