# app/assets/javascripts/app.chart.coffee
class App.Taginput
  constructor: (@el) ->
    initTaginput()

  render: ->


$(document).on "page:change", ->
  tag = new App.Taginput
  tag.render()

  $('#myModal').on 'beforeItemAdd', '.tags', (event) ->
    photo_id = $('.image_info').attr('photo_id')
    url = '/photos/' + photo_id + '/addtag'
    tag = event.item
    $.ajax(
      method: 'GET'
      url: url
      data: tag: tag).done (data) ->
    return


  $('#myModal').on 'itemRemoved', '.tags', (event) ->
    # event.item: contains the item
    console.log event.item
    photo_id = $('.image_info').attr('photo_id')
    url = '/photos/' + photo_id + '/removetag'
    tag = event.item
    $.ajax(
      method: 'GET'
      url: url
      data: tag: tag).done (data) ->
    return
  return


initTaginput = ->

  bloodhound = new Bloodhound(
    datumTokenizer: (d) ->
      Bloodhound.tokenizers.whitespace d.value
    queryTokenizer: Bloodhound.tokenizers.whitespace
    remote: '/photos/get_tag_list?query=%QUERY'
    limit: 50)
  bloodhound.initialize()

  $('.tags').tagsinput
    tagClass: (item) ->
      if item.charAt(0) == '@' then 'label-success' else 'label-danger'
    trimValue: true
    typeaheadjs:
      displayKey: 'name'
      valueKey: 'name'
      source: bloodhound.ttAdapter()
  return
