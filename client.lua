-- TODO: Create new Polyzones for banks (line 76 and below)

local uiOpened = false
local isInBank = false

local OpenBank = function(bank)
	ESX.TriggerServerCallback('orp_banking:getBalance', function(balance)
		uiOpened = true
		isInBank = bank == true

		SetNuiFocus(true, true)
		SendNUIMessage({
			type = 'openBank',
			balance = balance,
			isInBank = isInBank
		})

		if not isInBank then
			SendNotify('Please note that you can only deposit money at bank', 'inform')
		end
	end)
end

local CloseBank = function()
	uiOpened = false
	SetNuiFocus(false, false)
end

local currentResource = GetCurrentResourceName()
AddEventHandler('onResourceStop', function(resource)
	if resource == currentResource then CloseBank() end
end)



-- NUI callbacks
RegisterNUICallback('closeMenu', CloseBank)

RegisterNetEvent('orp_banking:update', function(balance)
	if uiOpened then
		SendNUIMessage({
			type = 'updateBalance',
			balance = balance
		})
	end
end)

RegisterNUICallback('deposit', function(data)
	if isInBank then
		TriggerServerEvent('orp_banking:deposit', tonumber(data.amount))
	else
		SendNotify('You cannot deposit money at an ATM', 'error')
	end
end)

RegisterNUICallback('withdraw', function(data)
	TriggerServerEvent('orp_banking:withdraw', tonumber(data.amount))
end)

RegisterNUICallback('transfer', function(data)
	TriggerServerEvent('orp_banking:transfer', data.to, data.amount)
end)



-- qtarget stuff
exports.qtarget:AddTargetModel(Config.ATMProps, {
	options = {{
		icon = 'fas fa-credit-card',
		label = 'Use ATM',
		action = OpenBank
	}},
	distance = 1.5
})

exports.qtarget:AddBoxZone('LegionSquare_Fleeca1', vec3(145.84, -1035.6, 29.33), 0.5, 1.0,
	{
		name = 'LegionSquare_Fleeca1',
		heading = 160.0,
		minZ = 29.0,
		maxZ = 30.5
	},
	{
		options = {{
			icon = 'fas fa-credit-card',
			label = 'Use ATM',
			action = OpenBank
		}},
		distance = 1.5
	}
)

exports.qtarget:AddBoxZone('LegionSquare_Fleeca2', vec3(147.5, -1036.2, 29.33), 0.5, 1.0,
	{
		name = 'LegionSquare_Fleeca2',
		heading = 160.0,
		minZ = 29.0,
		maxZ = 30.5
	}, {
		options = {{
			icon = 'fas fa-credit-card',
			label = 'Use ATM',
			action = OpenBank
		}},
		distance = 1.5
	}
)

for k,v in pairs(Config.BankZones) do
	local pos = GetObjectOffsetFromCoords(v, 0.0, 0.7, 0.0)
	local name = ('Bank_%s'):format(k)

	exports.qtarget:AddBoxZone(name, pos, 1.0, 4.5,
		{
			name = name,
			heading = v.w,
			minZ = pos.z - 1.0,
			maxZ = pos.z + 1.5
		}, {
			options = {{
				icon = 'fas fa-money-bill-wave',
				label = 'Access bank account',
				action = function()
					OpenBank(true)
				end
			}},
			distance = 2.0
		}
	)
end
