ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_policejob:togligps')
AddEventHandler('esx_policejob:togligps', function()
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	sourceXPlayer.removeInventoryItem('gps', 1)

end)