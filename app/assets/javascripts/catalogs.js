$(function(){
	$('#add-item').click(function(){
		id=$("#watch-path-group").children().length + 1
		$("#watch-path-group").append(
			'<input style="margin-top: 4px;" id=wp_"' + id + '" name=wp_"' + id + '" type="text" class="form-control" placeholder="New path...">'
		)
	})
})




$(function(){
	$("#sync_from").change(function(val) {
		$("#album-list").toggleClass('hidden');
		$("#catalog-list").toggleClass('hidden');
	})
})

$( document ).ready(function() {
  var sync_from = $("#sync_from").val()
	if (sync_from=="album") {
		$("#catalog-list").toggleClass('hidden');
	} else {
		$("#album-list").toggleClass('hidden');
	}

});
