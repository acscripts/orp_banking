local isATM = false

exports.qtarget:AddTargetModel(Config.ATMProps, {
	options = {{
		icon = 'fas fa-credit-card',
		label = 'Use ATM',
		event = 'orp_banking:showMoney'
	}},
	distance = 1.5
})

exports.qtarget:AddBoxZone('LegionSquare_Fleeca1', vector3(145.84, -1035.6, 29.33), 0.5, 1.0,
	{
		name = 'LegionSquare_Fleeca1',
		heading = 160.0,
		minZ = 29.0,
		maxZ = 30.5
	},
	{
		options = {{
			event = 'orp_banking:showMoney',
			icon = 'fas fa-credit-card',
			label = 'Use ATM'
		}},
		distance = 1.5
	}
)

exports.qtarget:AddBoxZone('LegionSquare_Fleeca2', vector3(147.5, -1036.2, 29.33), 0.5, 1.0,
	{
		name = 'LegionSquare_Fleeca2',
		heading = 160.0,
		minZ = 29.0,
		maxZ = 30.5
	}, {
		options = {{
			event = 'orp_banking:showMoney',
			icon = 'fas fa-credit-card',
			label = 'Use ATM'
		}},
		distance = 1.5
	}
)

for k,v in pairs(Config.BankZones) do
	local pos = GetObjectOffsetFromCoords(v[1], v[2], 0.0, 0.7, 0.0)
	exports.qtarget:AddBoxZone('Bank_Zone'..k, pos, 1.0, 4.5,
		{
			name = 'Bank_Zone'..k,
			heading = v[2],
			minZ = pos.z - 1.0,
			maxZ = pos.z + 1.5
		}, {
			options = {{
				icon = 'fas fa-money-bill-wave',
				label = 'Access bank account',
				event = 'orp_banking:showBankMoney',

			}},
			distance = 2.0
		}
	)
end





RegisterNetEvent('orp_banking:showMoney')
AddEventHandler('orp_banking:showMoney', function()
	isATM = true
	SetNuiFocus(true, true)
	SendNUIMessage({ type = 'openBank' })
	TriggerServerEvent('orp_banking:balance')
	SendNotify('Please note that you can only deposit money at bank', 'inform')
end)

RegisterNetEvent('orp_banking:showBankMoney')
AddEventHandler('orp_banking:showBankMoney', function()
	isATM = false
	SetNuiFocus(true, true)
	SendNUIMessage({ type = 'openBank' })
	TriggerServerEvent('orp_banking:balance')
end)

RegisterNetEvent('orp_banking:info')
AddEventHandler('orp_banking:info', function(balance)
	SendNUIMessage({
		type = 'updateBalance',
		balance = balance
	})
end)

RegisterNetEvent('orp_banking:back')
AddEventHandler('orp_banking:back', function(balance)
	SendNUIMessage({
		type = 'balanceReturn',
		bal = balance
	})
end)

RegisterNetEvent('orp_bank:notify')
AddEventHandler('orp_bank:notify', function(msg, type)
	SendNotify(msg, type)
end)





RegisterNUICallback('balance', function()
	TriggerServerEvent('orp_banking:balance')
end)

RegisterNUICallback('transfer', function(data)
	TriggerServerEvent('orp_banking:transfer', data.to, data.amount)
	TriggerServerEvent('orp_banking:balance')
end)

RegisterNUICallback('deposit', function(data)
	if not isATM then
		TriggerServerEvent('orp_banking:deposit', tonumber(data.amount))
		TriggerServerEvent('orp_banking:balance')
	else
		SendNotify('You cannot deposit money at an ATM', 'error')
	end
end)

RegisterNUICallback('withdraw', function(data)
	TriggerServerEvent('orp_banking:withdraw', tonumber(data.amount))
	TriggerServerEvent('orp_banking:balance')
end)

RegisterNUICallback('closeMenu', function()
	SetNuiFocus(false, false)
	SendNUIMessage({ type = 'closeAll' })
end)



AddEventHandler('onResourceStop', function(res)
	if res ~= GetCurrentResourceName() then return end

	SetNuiFocus(false, false)
	SendNUIMessage({ type = 'closeAll' })
end)
