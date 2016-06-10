# app/assets/javascripts/app.chart.coffee
class App.Edit
  constructor: (@el) ->
    initTypeahead()

  render: ->


$(document).on "page:change", ->
  edit = new App.Edit
  edit.render()


  $('.inp_toggle').change ->
    tb = $(this).parent().siblings().find(':input')
    tb.prop 'disabled', !@checked
    return

  $('#date_taken').datepicker
    format: 'yyyy/mm/dd'
    autoclose: true

  $('#date_taken').datepicker 'update'

initTypeahead = ->
  # initialize bloodhound engine
  searchSelector = 'input.typeahead'
  bloodhound = new Bloodhound(
    datumTokenizer: (d) ->
      Bloodhound.tokenizers.whitespace d.value
    queryTokenizer: Bloodhound.tokenizers.whitespace
    remote: '/locations/typeahead/%QUERY'
    limit: 50)
  bloodhound.initialize()

  # initialize typeahead widget and hook it up to bloodhound engine
  # #typeahead is just a text input
  $(searchSelector).typeahead {
    highlight: true
    hint: true
    minLength: 3
  },
    displayKey: 'address'
    source: bloodhound.ttAdapter()
  # this is the event that is fired when a user clicks on a suggestion
  $(searchSelector).bind 'typeahead:selected', (event, datum, name) ->
    $('#location_id').val datum.id
    return
  return
