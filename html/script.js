// Balance stuff
const formatter = new Intl.NumberFormat('en-US', {
	style: 'currency',
	currency: 'USD'
});

const updateBalance = (balance) => {
	let money = formatter.format(balance);
	money = money.substring(1);
	$('.balance').html(money);
};



// Close UI
const closeUi = () => {
	$('#bankui').fadeOut();
	$.post('https://orp_banking/closeMenu');
};

$('.close').click(closeUi);

document.onkeyup = function(data) {
	if(data.key == 'Escape') closeUi();
};



// NUI event listener
window.addEventListener('message', function(event) {
	const data = event.data;

	if(data.type == 'openBank') {
		updateBalance(data.balance);
		$('#bankui').fadeIn();
		$('#depositval').val('');
		$('#withdrawval').val('');

	} else if(data.type == 'updateBalance') {
		updateBalance(data.balance);

	};
});



// Main buttons and inputs
$('#deposit').click(function(e) {
	e.preventDefault();
	$.post('https://orp_banking/deposit', JSON.stringify({
		amount: $('#depositval').val()
	}));

	$('#depositval').val('');
});

$('#withdraw').click(function(e) {
	e.preventDefault();
	$.post('https://orp_banking/withdraw', JSON.stringify({
		amount: $('#withdrawval').val()
	}));

	$('#withdrawval').val('');
});

$('#transfer').click(function(e) {
	e.preventDefault();
	$.post('https://orp_banking/transfer', JSON.stringify({
		to: $('#idval').val(),
		amount: $('#transferval').val()
	}));

	$('#transferval').val('');
});



// Quick withdraw buttons
$('#withdraw-100').click(function(e) {
	e.preventDefault();
	$.post('https://orp_banking/withdraw', JSON.stringify({
		amount: 100
	}));
});

$('#withdraw-250').click(function(e) {
	e.preventDefault();
	$.post('https://orp_banking/withdraw', JSON.stringify({
		amount: 250
	}));
});

$('#withdraw-500').click(function(e) {
	e.preventDefault();
	$.post('https://orp_banking/withdraw', JSON.stringify({
		amount: 500
	}));
});
