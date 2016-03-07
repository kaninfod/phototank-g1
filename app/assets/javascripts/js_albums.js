

$(function() {
  $("#search-albums").change(function() {
    if (this.value == "") {
      window.location = "albums"
    } else {
      window.location = "albums?q=" + this.value
      }
  })
})
