ESX.RegisterUsableItem(Config.FitBit, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerClientEvent('DFNZ_FITBIT:openMenu', source)

end)


