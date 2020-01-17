local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData              = {}
local gpsattivo               = false

ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
	while true do

		Citizen.Wait(1)           
		local playerPed = GetPlayerPed(-1)
		local vehicle   = ESX.Game.GetVehicleInDirection()
		local x,y,z = table.unpack(GetEntityCoords(vehicle))   

		if IsControlJustReleased(1, 166) then
			if DoesEntityExist(vehicle) then
				if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
					ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
						if quantity >= 1 then
					        if not gpsattivo then
					            local playerPed = GetPlayerPed(-1)
					            local vehicle   = ESX.Game.GetVehicleInDirection()
				                local x,y,z = table.unpack(GetEntityCoords(vehicle))

								gpsattivo = true

								prop = GetHashKey("prop_cs_hand_radio")

                                segnalatore = CreateObject(GetHashKey("prop_police_radio_main"), GetEntityCoords(PlayerPedId()), true)
        
                                AttachEntityToEntity(segnalatore, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), -0.03, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

								RequestAnimSet( "move_ped_crouched" )
					            RequestAnimSet( "move_m@casual@d" )

                                while ( not HasAnimSetLoaded( "move_ped_crouched" ) and not HasAnimSetLoaded( "move_m@casual@d" ) ) do 
                                Citizen.Wait( 100 )
                                end 

                                SetPedMovementClipset(playerPed, "move_ped_crouched", 0.25 )
								
								RequestAnimDict('weapons@projectile@sticky_bomb')
								while not HasAnimDictLoaded('weapons@projectile@sticky_bomb') do
									Citizen.Wait(100)
								end
							
								TaskPlayAnim(playerPed, 'weapons@projectile@sticky_bomb', 'plant_vertical', 8.0, -8, -1, 49, 0, 0, 0, 0)

								Wait(2000)
								
								DeleteEntity(segnalatore)
								ResetPedMovementClipset(GetPlayerPed(-1), 0)
								ClearPedTasksImmediately(GetPlayerPed(-1))

						        Sospetto = AddBlipForEntity(vehicle)
						        SetBlipSprite(Sospetto, 119)
						        SetBlipColour(Sospetto, 1)
						        SetBlipScale(Sospetto, 1.0)
						        SetBlipAsShortRange(Sospetto, true)
						        BeginTextCommandSetBlipName("STRING")
						        AddTextComponentString('Sospetto')
						        EndTextCommandSetBlipName(Sospetto)
						        TriggerServerEvent('esx_policejob:togligps')
							else
								gpsattivo = false
								RequestAnimSet( "move_ped_crouched" )
					            RequestAnimSet( "move_m@casual@d" )

                                while ( not HasAnimSetLoaded( "move_ped_crouched" ) and not HasAnimSetLoaded( "move_m@casual@d" ) ) do 
                                Citizen.Wait( 100 )
                                end 

								--ResetPedMovementClipset(GetPlayerPed(-1), 0)
                                SetPedMovementClipset(playerPed, "move_ped_crouched", 0.25 )
								
								RequestAnimDict('weapons@projectile@sticky_bomb')
								while not HasAnimDictLoaded('weapons@projectile@sticky_bomb') do
									Citizen.Wait(100)
								end
							
								TaskPlayAnim(playerPed, 'weapons@projectile@sticky_bomb', 'plant_vertical', 8.0, -8, -1, 49, 0, 0, 0, 0)

								Wait(2000)
								
								ResetPedMovementClipset(GetPlayerPed(-1), 0)
								ClearPedTasksImmediately(GetPlayerPed(-1))
						        RemoveBlip(Sospetto)
							end
						else
						    ESX.ShowNotification('~r~Non hai il GPS')
						end
					end, 'gps')
				end
			else
				ESX.ShowNotification('~r~Nessun veicolo nelle vicinanze')
			end
		end
    end
end)