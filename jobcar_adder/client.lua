RegisterCommand("addjobcar", function(source, args)
    local job = args[1]
    local label = table.concat(args, " ", 2)

    if not job or label == "" then
        print("Použij: /addjobcar [job] [název vozidla]")
        return
    end

    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle == 0 then
        print("Musíš sedět ve vozidle.")
        return
    end

    local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
    local props = ESX.Game.GetVehicleProperties(vehicle)

    TriggerServerEvent("custom:addJobCar", plate, props, job, label)
end)
