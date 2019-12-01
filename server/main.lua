ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_carmileage:addMileage')
AddEventHandler('esx_carmileage:addMileage', function(vehPlate, km)
    local src = source
    local identifier = ESX.GetPlayerFromId(src).identifier
	local plate = vehPlate
	local newKM = km
	-- print("guardando los km en bbdd")
	-- print(newkm)
	-- print(plate)

    MySQL.Async.execute('UPDATE veh_km SET km = @kms WHERE carplate = @plate', {['@plate'] = plate, ['@kms'] = newKM})
end)

ESX.RegisterServerCallback('esx_carmileage:getMileage', function(source, cb, plate)

	local xPlayer = ESX.GetPlayerFromId(source)
	local vehPlate = plate
	-- print("veh plate is:")
	-- print(vehPlate)
	
	-- print("local plate is:")
	-- print(plate)

	MySQL.Async.fetchAll(
		'SELECT * FROM veh_km WHERE carplate = @plate',
		{
			['@plate'] = vehPlate
		},
		function(result)

			local found = false

			for i=1, #result, 1 do

				local vehicleProps = result[i].carplate

				if vehicleProps == vehPlate then
					KMSend = result[i].km
					-- print("mostrando KMS")
					-- print(KMSend)
					found = true
					break
				end

			end

			if found then
				cb(KMSend)
			else
				MySQL.Async.fetchAll("SELECT plate FROM owned_vehicles WHERE plate=@plate",{['@plate'] = plate}, function(data) 
					if #data > 0 then
						cb(0)
						MySQL.Async.execute('INSERT INTO veh_km (carplate) VALUES (@carplate)',{['@carplate'] = plate})
					else
						cb(math.random(100,500000))
					end
				end)				
				Wait(2000)
			end

		end
	)

end)
