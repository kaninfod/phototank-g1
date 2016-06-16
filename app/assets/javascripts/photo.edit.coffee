s = undefined
App.PhotoEdit = do ->

  init: (@el) ->
    s =
      searchSelector: 'input.typeahead'
    @refresh()
    @bindUIActions()


  refresh: ->
    $('#date_taken').datepicker
      format: 'yyyy/mm/dd'
      autoclose: true
    $('#date_taken').datepicker 'update'

    @bloodhound = new Bloodhound(
      datumTokenizer: (d) ->
        Bloodhound.tokenizers.whitespace d.value
      queryTokenizer: Bloodhound.tokenizers.whitespace
      remote: '/locations/typeahead/%QUERY'
      limit: 50)
    @initTypeahead()
    @bindUIActions()

  bindUIActions: ->
    _this = this
    $('.inp_toggle').change -> _this.toggleInput(this)
    @bloodhound.initialize()
    $(s.searchSelector).bind 'typeahead:selected', (event, datum, name) ->
      $('#location_id').val datum.id

  toggleInput: (chkbox) ->
    tb = $(chkbox).parents('.form-group').children().find('.inp')#.parents('.form-group').children('input[type=text]')
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



$(document).on "page:change", ->
  # return unless $(".photos.edit").length > 0
  App.PhotoEdit.init()
