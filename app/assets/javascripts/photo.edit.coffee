s = undefined
App.PhotoEdit = do ->

  init: (@el) ->
    s =
      searchSelector: 'input.typeahead'
    @refresh()
    @bindUIActions()



  refresh: ->
    _this = this
    #$('#date_taken').datepicker
    #  format: 'yyyy/mm/dd'
    #$('#date_taken').datepicker 'update'

    $('.inp_toggle').change -> _this.toggleInput(this)



  bindUIActions: ->
    _this = this
    $('body').on 'click.' + s.eventNamespace, '#rotate', -> _this.rotatePhoto()
    $('body').on 'click.' + s.eventNamespace, '#save-meta-data', -> _this.saveMetaData()
    $('#location_address').autocomplete
      source: '/locations/typeahead/kaj'
      minLength: 2
      select: (event, ui) ->
        $('#location_id').val ui.item.id

  toggleInput: (chkbox) ->
    tb = $(chkbox).parents('.form-group').children().find('.inp')
    tb.prop 'disabled', !$(chkbox).is(":checked")
    tb.select()

  saveMetaData: ->
    photo_id = $('#photo_id').data("photo_id")#$('.image_info').attr('photo_id')
    data = JSON.parse(JSON.stringify(jQuery('#edit-meta-data').serializeArray()))
    $.ajax
      url: '/photos/' + photo_id
      type: 'PUT',
      contentType: 'application/json',
      data: JSON.stringify(data)

  rotatePhoto: ->
    photo_id = $('#photo_id').data("photo_id")
    rotateValue = $("input[name=rotate]:checked").val()
    processingButton = $('.photo-widget[data-photoid=' + photo_id + '] .overlay-processing')
    url = '/photos/'+ photo_id + '/rotate/' + rotateValue
    $.get url, (data) ->
      processingButton.addClass('overlay-show')
      Materialize.toast("Photo is queued for a rotation of " + rotateValue + " degrees", 3000)

$(document).on "turbolinks:load", ->
  # return unless $(".photos.edit").length > 0
  App.PhotoEdit.init()
