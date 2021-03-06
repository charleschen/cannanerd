$(function(){
	$("textarea#strain_flavor_tokens").tokenInput("/strains/tags.json?tag_type=flavors",{
		crossDomain: false,
		preventDuplicates: true,
		prePopulate: $("strain_flavor_tokens").data("pre"),
		tokenLimit: 1
	});
		
	$("textarea#strain_type_tokens").tokenInput("/strains/tags.json?tag_type=types",{
		crossDomain: false,
		preventDuplicates: true,
		prePopulate: $("strain_type_tokens").data("pre"),
		tokenLimit: 1
	});
	
	$("textarea#strain_condition_tokens").tokenInput("/strains/tags.json?tag_type=conditions",{
		crossDomain: false,
		preventDuplicates: true,
		prePopulate: $("strain_condition_tokens").data("pre"),
		tokenLimit: 3
	});
	
	$("textarea#strain_symptom_tokens").tokenInput("/strains/tags.json?tag_type=symptoms",{
		crossDomain: false,
		preventDuplicates: true,
		prePopulate: $("strain_symptom_tokens").data("pre"),
		tokenLimit: 3
	});
	
	$("textarea#strain_effect_tokens").tokenInput("/strains/tags.json?tag_type=effects",{
		crossDomain: false,
		preventDuplicates: true,
		prePopulate: $("strain_effect_tokens").data("pre"),
		tokenLimit: 3
	});
	
	$("textarea#strain_price_tokens").tokenInput("/strains/tags.json?tag_type=prices",{
		crossDomain: false,
		preventDuplicates: true,
		prePopulate: $("strain_price_tokens").data("pre"),
		tokenLimit: 1
	});
});

