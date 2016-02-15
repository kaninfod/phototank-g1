$(function(){
	$('#add-item').click(function(){
		id=$("#watch-path-group").children().length + 1
		$("#watch-path-group").append(
			'<input id=wp_"' + id + '" name=wp_"' + id + '" type="text" class="form-control" placeholder="New path here...">'
		)
	})
})

$(function(){
	$('#import_to_master').on('show.bs.modal', function (event) {
		var catalog_id = $(event.relatedTarget).data("catalogid")
		var modal = $(this)
		modal.find('.modal-footer a').attr("href", "catalogs/" + catalog_id + "/import")

		$.ajax({
			method: "GET",
			url: "catalogs/" + catalog_id + "/get_catalog",
			success : function(response) {
				path_list = modal.find('.modal-body ul')
				path_list.html("")
				$.each(response['watch_path'], function(index, value) {
					path_list.append("<li>" + value + "</li>")
				})
			}
		})
	})
})

$(function(){
	$("#sync_from").change(function(val) {
		$("#album-list").toggleClass('hidden');
		$("#catalog-list").toggleClass('hidden');
	})
})
