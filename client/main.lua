ESX              = nil
local PlayerData = {}
local inVeh = false
local distance = 0
local vehPlate

local x = 0.01135
local y = 0.002
hasKM = 0
showKM = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
		SetTextFont(font)
		SetTextProportional(0)
		SetTextScale(sc, sc)
		N_0x4e096588b13ffeca(jus)
		SetTextColour(r, g, b, a)
		SetTextDropShadow(0, 0, 0, 0,255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(x - 0.1+w, y - 0.02+h)
end

-- print("Script starting...")


Citizen.CreateThread(function()
  while true do
	Citizen.Wait(250)
			if IsPedInAnyVehicle(PlayerPedId(), false) and not inVeh then
			-- print('player is now in a vehicle')
			Citizen.Wait(50)
			local veh = GetVehiclePedIsIn(PlayerPedId(),false)
			local driver = GetPedInVehicleSeat(veh, -1)
			if driver == PlayerPedId() and GetVehicleClass(veh) ~= 13 and GetVehicleClass(veh) ~= 14 and GetVehicleClass(veh) ~= 15 and GetVehicleClass(veh) ~= 16 and GetVehicleClass(veh) ~= 17 and GetVehicleClass(veh) ~= 21 then
			inVeh = true
			Citizen.Wait(50)
			vehPlate = GetVehicleNumberPlateText(veh)
			Citizen.Wait(1)
			-- print(vehPlate)
			ESX.TriggerServerCallback('esx_carmileage:getMileage', function(hasKM)
			-- print("pidiendo KMS a base de datos, si los tiene devolver valor, si no crearlo y devolver")
			-- print(hasKM)
			showKM = math.floor(hasKM*1.33)/1000
			-- showKM = math.floor(hasKM*1)/1
			-- print("the player is in the vehcile with plate:")
			-- print(vehPlate)
			local oldPos = GetEntityCoords(PlayerPedId())
			-- print("old pos is:")
			-- print(oldPos)
			Citizen.Wait(1000)
			local curPos = GetEntityCoords(PlayerPedId())
			-- print("cur pos is:")
			-- print(curPos)
			if IsVehicleOnAllWheels(veh) then
			dist = GetDistanceBetweenCoords(oldPos.x, oldPos.y, oldPos.z, curPos.x, curPos.y, curPos.z, true)
			else
			dist = 0
			end
			-- print("distance is:")
			-- print(dist)
			hasKM = hasKM + dist
			-- print("car km are:")
			-- print(hasKM)
			TriggerServerEvent('esx_carmileage:addMileage', vehPlate, hasKM)
			inVeh = false
			end, GetVehicleNumberPlateText(veh))
			else
			-- print("salimos del bucle xq somos pasajero")
			end
		end
	end
end)

displayHud = true

	Citizen.CreateThread(function()
		while true do
			if IsPedInAnyVehicle(PlayerPedId(), false) then
						local veh = GetVehiclePedIsIn(PlayerPedId(),false)
					local driver = GetPedInVehicleSeat(veh, -1)
					if driver == PlayerPedId() and GetVehicleClass(veh) ~= 13 and GetVehicleClass(veh) ~= 14 and GetVehicleClass(veh) ~= 15 and GetVehicleClass(veh) ~= 16 and GetVehicleClass(veh) ~= 17 and GetVehicleClass(veh) ~= 21 then
				DrawAdvancedText(0.296 - x, 0.92 - y, 0.005, 0.0028, 0.6, round(showKM, 2).. ' km', 255, 255, 255, 255, 6, 1)
				end
			else
				Citizen.Wait(750)
			end

			Citizen.Wait(0)
		end
	end)

-- this will be used in the future to add damage to cars with more kms and make them slower

-- Citizen.CreateThread(function()
	-- while true do
	-- Citizen.Wait(250)
		-- if IsPedInAnyVehicle(PlayerPedId(), false) then
			-- local veh = GetVehiclePedIsIn(PlayerPedId(),false)
				-- local driver = GetPedInVehicleSeat(veh, -1)
					-- if driver == PlayerPedId() then
						-- if showKM >= 5000 then
						-- -- print("tiene mas de 5000 km")
						-- -- SetVehicleDirtLevel(veh, 15.0)
						-- SetVehicleEngineHealth(veh, 650)
						-- end
				-- end
			-- else
				-- Citizen.Wait(15000)
			-- end
		-- Citizen.Wait(1)
	-- end
-- end)
	
function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end
