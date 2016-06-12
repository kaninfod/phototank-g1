s = undefined
class App.PhotoEdit

  #Singleton implementation
  instance = null
  class PrivateClass
    constructor: () ->

  @get: (message) ->
    if not instance?
      instance = new @
      instance.init()
    else
      instance.bindUIActions()
    instance

  init: (@el) ->
    s =
      modalElement: $('#myModal')
      likeButtonId: '#like'
      numberOfLikes: $('#likes_num')
      searchSelector: 'input.typeahead'
    $('#date_taken').datepicker
      format: 'yyyy/mm/dd'
      autoclose: true
    $('#date_taken').datepicker 'update'


    # this is the event that is fired when a user clicks on a suggestion
    @bindUIActions()
    @initTypeahead()


  bindUIActions: ->
    _this = this
    $('.inp_toggle').change -> _this.toggleInput(this)


  toggleInput: (chkbox) ->
    console.log chkbox
    tb = $(chkbox).parents('.form-group').find('.inp')
    tb.prop 'disabled', !$(chkbox).is(":checked")

  initTypeahead: ->
    # initialize bloodhound engine
    bloodhound = new Bloodhound(
      datumTokenizer: (d) ->
        Bloodhound.tokenizers.whitespace d.value
      queryTokenizer: Bloodhound.tokenizers.whitespace
      remote: '/locations/typeahead/%QUERY'
      limit: 50)
    bloodhound.initialize()
    $(s.searchSelector).typeahead {
      highlight: true
      hint: true
      minLength: 3
    },
      displayKey: 'address'
      source: bloodhound.ttAdapter()
    $(s.searchSelector).bind 'typeahead:selected', (event, datum, name) ->
      $('#location_id').val datum.id


$(document).on "page:change", ->
  return unless $(".photos.edit").length > 0
  App.PhotoEdit.get()
