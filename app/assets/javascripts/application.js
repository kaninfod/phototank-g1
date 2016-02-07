// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs

//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .


$(function() {
	
		setTimeout(updateJobs, 2000);
	
})

function updateJobs() {
	
	
	$.ajax({
	  method: "GET",
	  url: "/administration/jobs_pending?format=json",
	  data: {  },
	  success : function(resque)
      {
		  $("#jobs-pending-pending").html(resque['pending'])
		  $("#jobs-pending-failed").html(resque['failed'])
		  $("#jobs-pending-working").html(resque['working'])
		  $("#jobs-pending-import").html(resque['import'])
		  $("#jobs-pending-locate").html(resque['locate'])
      }
	})
	setTimeout(updateJobs, 5000)
	
}