-- TODO: Multiple UI colors (Fleeca, Lombank, Maze bank)

local uiOpened = false
local isInBank = false

local OpenBank = function(bank)
	lib.callback('orp_banking:getBalance', 100, function(balance)
		uiOpened = true
		isInBank = bank == true

		SetNuiFocus(true, true)
		SendNUIMessage({
			type = 'openBank',
			balance = balance,
			isInBank = isInBank
		})

		if not isInBank then
			lib.notify({
				type = 'inform',
				description = 'Please note that you can only deposit money at bank'	
			})
		end
	end)
end

local CloseBank = function()
	uiOpened = false
	SetNuiFocus(false, false)
end

AddEventHandler('onResourceStop', function(resource)
	if resource == cache.resource then
		CloseBank()
	end
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
		TriggerServerEvent('orp_banking:deposit', data)
	else
		lib.notify({
			type = 'error',
			description = 'You cannot deposit money at an ATM'	
		})
	end
end)

RegisterNUICallback('withdraw', function(data)
	TriggerServerEvent('orp_banking:withdraw', data)
end)

RegisterNUICallback('transfer', function(data)
	TriggerServerEvent('orp_banking:transfer', data)
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

exports.qtarget:AddBoxZone('ATM_L', vec3(147.49, -1036.18, 29.34), 0.4, 1.3,
	{
		name = 'ATM_L',
		heading = 340.0,
		minZ = 28.69,
		maxZ = 30.64
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

exports.qtarget:AddBoxZone('ATM_R', vec3(145.85, -1035.61, 29.34), 0.4, 1.3,
	{
		name = 'ATM_R',
		heading = 340.0,
		minZ = 28.69,
		maxZ = 30.64
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
	local name = ('Bank_%s'):format(k)
	exports.qtarget:AddBoxZone(name, v.pos, v.length, v.width,
		{
			name = name,
			heading = v.h,
			minZ = v.minZ,
			maxZ = v.maxZ
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
