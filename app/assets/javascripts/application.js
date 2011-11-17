// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_directory .

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");   // tells it to destroy the record
  $(link).closest(".fields").hide();     				
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
	//alert(content.replace(regexp, new_id))
}

function return_content(link){
	alert($(link).prev("input").val());
}


$(function(){
	$("#answer_tag_tokens").tokenInput("/tags.json",{
		crossDomain: false,
		prePopulate: $("#answer_tag_tokens").data("pre"),
		theme: "facebook"
	});
	
	$("#strain_tag_tokens").tokenInput("/tags.json",{
		crossDomain: false,
		prePopulate: $("#answer_tag_tokens").data("pre"),
		theme: "facebook"
	});
	
	// $(".pagination a").live("click",function(){
	// 	alert(this.href);
	// 	$(".pagination").html("Page is loading...");
	// 	$.getScript(this.href);
	// 	return false;
	// });
});