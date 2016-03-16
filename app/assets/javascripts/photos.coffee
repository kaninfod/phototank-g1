$(document).ready ->
  #Event binding for adding photos to the bucket
  $('[data-toggle="popover"]').popover();

$ ->
  $('.searchbox, .breadcrumb li a').on 'click', ->
    el = $(this)
    url = el.attr("href")
    url = url + getCountryUrl()
    el.attr("href", url)


$ ->
  $('#country').on 'change', ->
    dateUrl =$('.breadcrumb').attr('date_url')
    if country != "Filter on country..."
      window.location = dateUrl + getCountryUrl()
    else
      window.location = dateUrl

getCountryUrl = ->
  country = $("#country").val()
  if country != "Filter on country..."
    return "/country/" + country
  return



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
