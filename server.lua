local ox_inventory = exports.ox_inventory

lib.callback.register('orp_banking:getBalance', function(source)
	local accounts = Ox.GetPlayer(source).getAccounts()
	return accounts.get('bank') or 0
end)



RegisterNetEvent('orp_banking:deposit', function(data)
	local amount = tonumber(data?.amount)

	if not amount or amount <= 0 or amount > ox_inventory:GetItem(source, 'money', nil, true) then
		TriggerClientEvent('ox_lib:notify', source, {
			type = 'error',
			description = 'Invalid amount'
		})
	else
		local accounts = Ox.GetPlayer(source).getAccounts()
		accounts.add('bank', amount)
		ox_inventory:RemoveItem(source, 'money', amount)

		TriggerClientEvent('orp_banking:update', source, accounts.get('bank'))
		TriggerClientEvent('ox_lib:notify', source, {
			type = 'success',
			description = 'You have successfully deposited $'.. amount
		})
	end
end)

RegisterNetEvent('orp_banking:withdraw', function(data)
	local accounts = Ox.GetPlayer(source).getAccounts()
	local balance = accounts.get('bank')
	local amount = tonumber(data?.amount)

	if not amount or amount <= 0 or amount > balance then
		TriggerClientEvent('ox_lib:notify', source, {
			type = 'error',
			description = 'Invalid amount'
		})
	else
		accounts.remove('bank', amount)
		ox_inventory:AddItem(source, 'money', amount)

		TriggerClientEvent('orp_banking:update', source, balance - amount)
		TriggerClientEvent('ox_lib:notify', source, {
			type = 'success',
			description = 'You have successfully withdrawn $'.. amount
		})
	end
end)

RegisterNetEvent('orp_banking:transfer', function(data)
	local amount = tonumber(data?.amount)

	if type(data?.target) ~= 'number' then
		TriggerClientEvent('ox_lib:notify', source, {
			type = 'error',
			description = 'Recipient not found'
		})
	elseif data?.target == source then
		TriggerClientEvent('ox_lib:notify', source, {
			type = 'error',
			description = 'You cannot transfer money to yourself'
		})
	elseif not amount or amount <= 0 then
		TriggerClientEvent('ox_lib:notify', source, {
			type = 'error',
			description = 'Invalid amount'
		})
	else
		local accounts = Ox.GetPlayer(source).getAccounts()
		local balance = accounts.get('bank')

		if balance <= 0 or balance < amount or amount <= 0 then
			TriggerClientEvent('ox_lib:notify', source, {
				type = 'error',
				description = 'You don\'t have enough money for this transfer'
			})
		else
			accounts.remove('bank', amount)
			TriggerClientEvent('orp_banking:update', source, balance - amount)
			TriggerClientEvent('ox_lib:notify', source, {
				type = 'success',
				description = 'You have successfully transferred $'.. amount
			})

			local target = Ox.GetPlayer(data.target).getAccounts()
			target.add('bank', amount)
			TriggerClientEvent('orp_banking:update', source, target.get('bank'))
			TriggerClientEvent('ox_lib:notify', source, {
				type = 'success',
				description = 'You just received $'.. amount ..' via bank transfer'
			})
		end
	end
end)
