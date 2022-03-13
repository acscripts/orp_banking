local inventory = exports.ox_inventory

lib.callback.register('orp_banking:getBalance', function(source)
	local player = Player(source)
	return player.getAccount('bank') or 0
end)



RegisterNetEvent('orp_banking:deposit', function(data)
	local player = Player(source)
	local amount = tonumber(data?.amount)

	if not amount or amount <= 0 or amount > inventory:GetItem(source, 'money', false, true) then
		TriggerClientEvent('orp_banking:notify', source, 'Invalid amount', 'error')
	else
		inventory:RemoveItem(source, 'money', amount)
		player.addAccount('bank', amount)
		TriggerClientEvent('orp_banking:update', source, player.getAccount('bank'))
		TriggerClientEvent('orp_banking:notify', source, 'You have successfully deposited $'.. amount, 'success')
	end
end)

RegisterNetEvent('orp_banking:withdraw', function(data)
	local player = Player(source)
	local balance = player.getAccount('bank')
	local amount = tonumber(data?.amount)

	if not amount or amount <= 0 or amount > balance then
		TriggerClientEvent('orp_banking:notify', source, 'Invalid amount', 'error')
	else
		player.removeAccount('bank', amount)
		inventory:AddItem(source, 'money', amount)
		TriggerClientEvent('orp_banking:update', source, balance - amount)
		TriggerClientEvent('orp_banking:notify', source, 'You have successfully withdrawn $'.. amount, 'success')
	end
end)

RegisterNetEvent('orp_banking:transfer', function(data)
	local amount = tonumber(data?.amount)

	if type(data?.target) ~= 'number' then
		TriggerClientEvent('orp_banking:notify', source, 'Recipient not found', 'error')
	elseif data?.target == source then
		TriggerClientEvent('orp_banking:notify', source, 'You cannot transfer money to yourself', 'error')
	elseif not amount or amount <= 0 then
		TriggerClientEvent('orp_banking:notify', source, 'Invalid amount', 'error')
	else
		local player = Player(source)
		local target = Player(data.target)
		local balance = player.getAccount('bank')

		if balance <= 0 or balance < amount or amount <= 0 then
			TriggerClientEvent('orp_banking:notify', source, 'You don\'t have enough money for this transfer', 'error')
		else
			player.removeAccount('bank', amount)
			TriggerClientEvent('orp_banking:update', source, balance - amount)
			TriggerClientEvent('orp_banking:notify', source, 'You have successfully transferred $'.. amount, 'success')

			target.addAccount('bank', amount)
			TriggerClientEvent('orp_banking:update', source, target.getAccount('bank'))
			TriggerClientEvent('orp_banking:notify', source, 'You just received $'.. amount ..' via bank transfer', 'success')
		end
	end
end)
