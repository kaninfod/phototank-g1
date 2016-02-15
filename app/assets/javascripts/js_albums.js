

$(function() {
  $("#search-albums").change(function() {
    console.log(this.value)
    if (this.value == "") {
      window.location = "albums"
    } else {
      window.location = "albums?q=" + this.value
      }
  })
})
