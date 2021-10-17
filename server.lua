RegisterServerEvent('orp_banking:deposit')
AddEventHandler('orp_banking:deposit', function(amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local amount = tonumber(amount)

	if amount == nil or amount <= 0 or amount > xPlayer.getMoney() then
		TriggerClientEvent('orp_bank:notify', xPlayer.source, 'Invalid amount', 'error')
	else
		xPlayer.removeMoney(amount)
		xPlayer.addAccountMoney('bank', amount)
		TriggerClientEvent('orp_bank:notify', xPlayer.source, 'You have successfully deposited $'.. amount, 'success')
	end
end)

RegisterServerEvent('orp_banking:withdraw')
AddEventHandler('orp_banking:withdraw', function(amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local amount = tonumber(amount)
	local balance = xPlayer.getAccount('bank').money

	if amount == nil or amount <= 0 or amount > balance then
		TriggerClientEvent('orp_bank:notify', xPlayer.source, 'Invalid amount', 'error')
	else
		xPlayer.removeAccountMoney('bank', amount)
		xPlayer.addMoney(amount)
		TriggerClientEvent('orp_bank:notify', xPlayer.source, 'You have successfully withdrawn $'.. amount, 'success')
	end
end)

RegisterServerEvent('orp_banking:balance')
AddEventHandler('orp_banking:balance', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local balance = xPlayer.getAccount('bank').money
	TriggerClientEvent('orp_banking:info', xPlayer.source, balance)
end)

RegisterServerEvent('orp_banking:transfer')
AddEventHandler('orp_banking:transfer', function(target, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)
	local amount = tonumber(amount)

	if xTarget == nil or xTarget == -1 then
		TriggerClientEvent('orp_bank:notify', xPlayer.source, 'Recipient not found', 'error')
	else
		if xPlayer.source == xTarget.source then
			TriggerClientEvent('orp_bank:notify', xPlayer.source, 'You cannot transfer money to yourself', 'error')
		else
			local balance = xPlayer.getAccount('bank').money
			if balance <= 0 or balance < amount or amount <= 0 then
				TriggerClientEvent('orp_bank:notify', xPlayer.source, 'You don\'t have enough money for this transfer', 'error')
			else
				xPlayer.removeAccountMoney('bank', amount)
				xTarget.addAccountMoney('bank', amount)
				
				TriggerClientEvent('orp_bank:notify', xPlayer.source, 'You have successfully transferred $'.. amount, 'success')
				TriggerClientEvent('orp_bank:notify', xTarget.source, 'You just received $'.. amount ..' via bank transfer', 'success')
			end
		end
	end
end)
