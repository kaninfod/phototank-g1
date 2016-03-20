

$(document).ready ->
  #Event binding for adding photos to the bucket
  $('[data-toggle="popover"]').popover();

#prepare url when breadcrumb part is clicked
$ ->
  $('.searchbox, .breadcrumb li a').on 'click', ->
    el = $(this)
    url = el.attr("href")
    url = url + extendUrl()
    el.attr("href", url)

#prepare url and redirect when change dropdowns
$ ->
  $('#country, #direction').on 'change', ->
    dateUrl =$('.breadcrumb').attr('date_url')
    window.location = dateUrl + extendUrl()

#extend url before actions
extendUrl = ->
  direction = $("#direction").val()
  country = $("#country").val()
  if country != "All"
    return "/country/" + country + "/direction/" + direction
  return "/direction/" + direction

#wire things up when rotating an image
$ ->
  $('#rotate').on 'click', ->
    rotateValue = $("input[name=rotate]:checked").val()
    window.location = rotateValue

#infinite scrolling
$ ->
  if $('#infinite-scrolling').size() > 0
    $(window).on 'scroll', ->
      more_posts_url = $('.pagination a[rel=next]').attr('href')

      if more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - 500
          $('.pagination').html("")
          $.ajax
            url: more_posts_url
            success: (data) ->
              $("#photos").append(data)#.hide().fadeIn(1000)
              $('[data-toggle="popover"]').popover();
              $('.dropdown-toggle').dropdown()
      if !more_posts_url
        $('.pagination').html("")
    return


jQuery(document).ready ->
  offset = 250
  duration = 300
  jQuery(window).scroll ->
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
