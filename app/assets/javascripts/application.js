// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require best_in_place
//= require jquery.purr
//= require_tree ./public

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");   // tells it to destroy the record
  $(link).closest(".fields").hide();     				
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().after(content.replace(regexp, new_id));
	//alert(content.replace(regexp, new_id))
}

function return_content(link){
	alert($(link).prev("input").val());
}


$(function(){
	$('.best_in_place').best_in_place();
	
	// $("#answer_tag_tokens").tokenInput("/tags.json",{
	// 	crossDomain: false,
	// 	prePopulate: $("#answer_tag_tokens").data("pre"),
	// 	theme: "facebook"
	// });
	// 
	// $("#strain_tag_tokens").tokenInput("/tags.json",{
	// 	crossDomain: false,
	// 	prePopulate: $("#answer_tag_tokens").data("pre"),
	// 	theme: "facebook"
	// });
	
	// $("#strain_flavor_tokens").tokenInput("/strains/flavors.json",{
	// 	crossDomain: false,
	// 	prePopulate: $("strain_flavor_tokens").data("pre"),
	// 	theme: "facebook"
	// });
	
	// $(".pagination a").live("click",function(){
	// 	alert(this.href);
	// 	$(".pagination").html("Page is loading...");
	// 	$.getScript(this.href);
	// 	return false;
	// });
	
	$(".ajax_form > input").live("click",function(){
		//alert('button clicking');
		//$('.ajax_form').append('loading....');
		//$('.ajax_form input.werd').type('hidden');
		//$('.ajax_form input#'+$('.ajax_form').data('button-id')).hide();
		$(this).parent().append('loading....');
		$(this).hide();
		$(this).callRemote();
		return false;
	});
	
	// $("#strain_search_form").submit(function(){
	// 	$.get(this.action, $(this).serialize(), null, "script");
	// 	return false;
	// }); 
	
	jQuery('.jbar').jbar();
});