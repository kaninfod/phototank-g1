$(document).ready ->
  #Event binding for adding photos to the bucket
  $('[data-toggle="popover"]').popover();



$ ->
  if $('#infinite-scrolling').size() > 0
    $(window).on 'scroll', ->
      more_posts_url = $('.pagination a[rel=next]').attr('href')

      if more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - 300
          $('.pagination').html("")
          $.ajax
            url: more_posts_url
            success: (data) ->
              $("#photos").append(data)
              $('[data-toggle="popover"]').popover();
              $('.dropdown-toggle').dropdown()
      if !more_posts_url
        $('.pagination').html("")
    return
