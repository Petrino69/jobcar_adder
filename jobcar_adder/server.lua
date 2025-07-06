ESX = exports["es_extended"]:getSharedObject()

-- Povolené skupiny
local allowedGroups = {
    owner = true,
    admin = true,
}

-- Discord webhook
local webhook = ''

RegisterServerEvent("custom:addJobCar")
AddEventHandler("custom:addJobCar", function(plate, props, job, label)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local group = xPlayer.getGroup()
    if not allowedGroups[group] then
        print(("Hráč %s se pokusil použít /addjobcar bez oprávnění (skupina: %s)"):format(xPlayer.getName(), group))
        return
    end

    local encodedProps = json.encode(props)

    MySQL.insert('INSERT INTO owned_vehicles (owner, plate, vehicle, type, job, stored, vehiclename) VALUES (NULL, ?, ?, ?, ?, ?, ?)', {
        plate,
        encodedProps,
        'car',
        job,
        1,
        label or 'unknown'
    }, function(id)
        if id then
            print(("Vozidlo s SPZ %s bylo přidáno pro job '%s' hráčem %s"):format(plate, job, xPlayer.getName()))

            -- Log na Discord
            local embed = {{
                {
                    ["color"] = 65309,
                    ["title"] = "🚗 Přidáno firemní vozidlo",
                    ["description"] = ("**Hráč:** %s\\n**SPZ:** %s\\n**Job:** %s\\n**Model:** %s\\n**Název:** %s"):format(
                        xPlayer.getName(),
                        plate,
                        job,
                        props.model or "neznámý",
                        label or "neuvedeno"
                    ),
                    ["footer"] = {
                        ["text"] = os.date("%d.%m.%Y %H:%M:%S"),
                    }
                }
            }}

            PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "JobCar Logger", embeds = embed}), { ['Content-Type'] = 'application/json' })
        end
    end)
end)
