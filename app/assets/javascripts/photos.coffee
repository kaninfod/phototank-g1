
$ ->
  $('.show_map').popover container: 'body'
  return

$ ->
  if $('#infinite-scrolling').size() > 0
    $(window).on 'scroll', ->
      more_posts_url = $('.pagination a[rel=next]').attr('href')

      if more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - 100
          $('.pagination').html("")
          $.ajax
            url: more_posts_url
            success: (data) ->
              $("#photos").append(data)

      if !more_posts_url
        $('.pagination').html("")
    return
