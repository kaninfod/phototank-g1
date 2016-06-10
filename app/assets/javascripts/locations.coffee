$ ->
  $('#search-locations').change ->
    if @value == ''
      window.location = '/locations'
    else
      window.location = '/locations?q=' + @value
    return
  return
