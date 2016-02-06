
function updateBucketCounter(count) {

	$('#bucket_counter').html(count)
}


$(function() {   
	
	$('input[type="checkbox"]').change(function(){

		if ($(this).is(':checked')) {
			url = "/bucket/" + $(this).attr('photo_id') + "/add"
		} else {
			url = "/bucket/" + $(this).attr('photo_id') + "/remove"
		}
	
	
		$.ajax({
		  method: "POST",
		  url: url,
		  data: {  },
		  success : function(response)
          {
			  $('#bucket_counter').html(response['count']);
          }
		})
	})
})

$(function() {   
	$('tr').click(function() {

		var cb = $(this).find('input')
		cb.trigger('click')

	})

})

$(function() { 
	$('.show_map').popover({
		container: 'body'
	}) 
})

