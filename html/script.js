window.addEventListener('message', function(event) {
	if(event.data.type === 'openBank') {
		$('#bankui').fadeTo(10, 1.0);
		$('#depositval').val('');
		$('#withdrawval').val('');

	} else if(event.data.type === 'closeAll') {
		$('#bankui').fadeTo(10, 0.0);

	} else if(event.data.type === 'updateBalance') {
		let money = formatter.format(event.data.balance);
		money = money.substring(1);
		$('.balance').html(money);

	};
});



$('.close').click(function() {
	$('bankui').hide();
	$.post(`https://${GetParentResourceName()}/closeMenu`, JSON.stringify({}));
});

$('#withdraw').click(function(e) {
	e.preventDefault();
	$.post(`https://${GetParentResourceName()}/withdraw`, JSON.stringify({
		amount: $('#withdrawval').val()
	}));
	$('#withdrawval').val('');
});

$('#deposit').click(function(e) {
	e.preventDefault();
	$.post(`https://${GetParentResourceName()}/deposit`, JSON.stringify({
		amount: $('#depositval').val()
	}));
	$('#depositval').val('');
});

$('#withdraw-100').click(function(e) {
	e.preventDefault();
	$.post(`https://${GetParentResourceName()}/withdraw`, JSON.stringify({
		amount: 100
	}));
});

$('#withdraw-250').click(function(e) {
	e.preventDefault();
	$.post(`https://${GetParentResourceName()}/withdraw`, JSON.stringify({
		amount: 250
	}));
});

$('#withdraw-500').click(function(e) {
	e.preventDefault();
	$.post(`https://${GetParentResourceName()}/withdraw`, JSON.stringify({
		amount: 500
	}));
});

$('#transfer').click(function(e) {
	e.preventDefault();
	$.post(`https://${GetParentResourceName()}/transfer`, JSON.stringify({
		to: $('#idval').val(),
		amount: $('#transferval').val()
	}));
	$('#transferval').val('');
});

document.onkeyup = function(data) {
	if (data.key == 'Escape') {
		$('#bankui').fadeTo(10, 0.0);
		$.post(`https://${GetParentResourceName()}/closeMenu`, JSON.stringify({}));
	};
};

var formatter = new Intl.NumberFormat('en-US', {
	style: 'currency',
	currency: 'USD'
});
