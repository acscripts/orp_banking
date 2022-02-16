ESX.RegisterServerCallback('orp_banking:getBalance', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer and xPlayer.getAccount('bank').money or 0)
end)



RegisterNetEvent('orp_banking:deposit', function(amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local amount = tonumber(amount)

	if amount == nil or amount <= 0 or amount > xPlayer.getMoney() then
		TriggerClientEvent('orp_banking:notify', xPlayer.source, 'Invalid amount', 'error')
	else
		xPlayer.removeMoney(amount)
		xPlayer.addAccountMoney('bank', amount)
		TriggerClientEvent('orp_banking:update', xPlayer.source, balance + amount)
		TriggerClientEvent('orp_banking:notify', xPlayer.source, 'You have successfully deposited $'.. amount, 'success')
	end
end)

RegisterNetEvent('orp_banking:withdraw', function(amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local amount = tonumber(amount)
	local balance = xPlayer.getAccount('bank').money

	if amount == nil or amount <= 0 or amount > balance then
		TriggerClientEvent('orp_banking:notify', xPlayer.source, 'Invalid amount', 'error')
	else
		xPlayer.removeAccountMoney('bank', amount)
		xPlayer.addMoney(amount)
		TriggerClientEvent('orp_banking:update', xPlayer.source, balance - amount)
		TriggerClientEvent('orp_banking:notify', xPlayer.source, 'You have successfully withdrawn $'.. amount, 'success')
	end
end)

RegisterNetEvent('orp_banking:transfer', function(target, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)
	local amount = tonumber(amount)

	if xTarget == nil or xTarget == -1 then
		TriggerClientEvent('orp_banking:notify', xPlayer.source, 'Recipient not found', 'error')
	else
		if xPlayer.source == xTarget.source then
			TriggerClientEvent('orp_banking:notify', xPlayer.source, 'You cannot transfer money to yourself', 'error')
		else
			local balance = xPlayer.getAccount('bank').money
			if balance <= 0 or balance < amount or amount <= 0 then
				TriggerClientEvent('orp_banking:notify', xPlayer.source, 'You don\'t have enough money for this transfer', 'error')
			else
				xPlayer.removeAccountMoney('bank', amount)
				TriggerClientEvent('orp_banking:update', xPlayer.source, balance - amount)
				TriggerClientEvent('orp_banking:notify', xPlayer.source, 'You have successfully transferred $'.. amount, 'success')

				xTarget.addAccountMoney('bank', amount)
				TriggerClientEvent('orp_banking:update', xTarget.source, xTarget.getAccount('bank').money)
				TriggerClientEvent('orp_banking:notify', xTarget.source, 'You just received $'.. amount ..' via bank transfer', 'success')
			end
		end
	end
end)
