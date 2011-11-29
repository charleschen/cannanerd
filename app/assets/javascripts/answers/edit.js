$(function(){
	$("#answer_tag_tokens").tokenInput("/strains/all_tags.json",{
		crossDomain: false,
		preventDuplicates: true,
		prePopulate: $("answer_tag_tokens").data("pre"),
		theme: "facebook"
	});
});