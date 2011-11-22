jQuery ->
	$('#questions').sortable
		axis: 'y'
		handle: '.handle'
		update: ->
			$.post($(this).data('update-url'), $(this).sortable('serialize'))