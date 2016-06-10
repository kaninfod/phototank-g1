# app/assets/javascripts/app.chart.coffee
class App.Grid
  constructor: (@el) ->
    $('img.lazy').lazyload()
    modalInit()
    initWaypoint()

  render: ->


$(document).on "page:change", ->
  return unless $(".photos.index").length > 0
  grid = new App.Grid
  grid.render()


  #menu actions on dropdowns
  #-delete:
  $('.delete_photo').on 'click', ->
    photoId = $(this).attr('photo_id')
    pw=$('.delete_photo[photo_id="'+photoId+'"]').parents('.photo-widget')
    $.ajax
      url: '/photos/' + photoId
      type: 'DELETE',
      contentType: 'application/json',
      success: (data) ->
        pw.fadeOut(700)
    return false
  return false

  # Rotate
  $('#rotate').on 'click', ->
    rotateValue = $("input[name=rotate]:checked").val()
    window.location = rotateValue


  #scroll to top marker
  jQuery(window).scroll ->
    offset = 550
    duration = 300
    if jQuery(this).scrollTop() > offset
      jQuery('.back-to-top').fadeIn duration
    else
      jQuery('.back-to-top').fadeOut duration
    return

  jQuery('.back-to-top').click (event) ->
    event.preventDefault()
    jQuery('html, body').animate { scrollTop: 0 }, duration
    false
  return

  #prepare url when breadcrumb part is clicked
  $('.searchbox, .breadcrumb li a').on 'click', ->
    el = $(this)
    url = el.attr("href")
    url = url + extendUrl()
    el.attr("href", url)

  #prepare url and redirect when change dropdowns
  $('#searchbox_country, #searchbox_direction').on 'change', ->
    dateUrl =$('.breadcrumb').attr('date_url')
    window.location = dateUrl + extendUrl()

#extend url before actions
extendUrl = ->
  direction = $("#searchbox_direction").prop('checked')
  country = $("#searchbox_country").val()
  if country != "All"
    return "/country/" + country + "/direction/" + direction
  return "/direction/" + direction

initWaypoint = ->
  waypoint = new Waypoint(
    element: $('.loadMore')
    offset: ->
      @context.innerHeight() - @adapter.outerHeight() + 500
    handler: (direction) ->
      if direction == 'down'
        getNextPage()
      return
    )

getNextPage = ->
  url = $('.next_page').last()[0].href
  nextPage = $.get(url)
  nextPage.success (data) ->
    $('.infinite-container').append data
    afterAjaxrefresh()
    Waypoint.refreshAll()
    #afterAjaxrefresh()
    return
  return

afterAjaxrefresh = ->
  $('img.lazy').lazyload()
  $('[data-toggle="popover"]').popover()
  $('.dropdown-toggle').dropdown()
  modalInit()
  return

modalInit = ->
  $('.lazy').on 'click', ->
    url = '/photos/' + $(this).attr('photo_id')
    $('.modal-body').load url, (result) ->
      $('#myModal').modal
        show: true
        keyboard: true
      new (App.Photo)
      new (App.Comment)
      new (App.Taginput)
      return
    return
  return
