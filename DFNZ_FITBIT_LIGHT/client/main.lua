lib.locale()

RegisterCommand(Config.Command, function()
    local item = ESX.SearchInventory('fitbit', 1)
        
    if item >= 1 then
        TriggerEvent('DFNZ_FITBIT:openMenu')
    else
        lib.notify({
            title = locale("notify_title"),
            description = locale("no_fitbit"),
            type = 'error',
            position = Config.NotifyPosition,
            duration = Config.NotifyDuration * 1000
        })
    end
end)

Citizen.CreateThread(function()
    local item = ESX.SearchInventory('fitbit', 1)
        
    if item >= 1 then
        while true do
            local bitHungry, bitThirsty, extremHungry, extremThirsty = false, false, false, false

            TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
                if hunger.val < 250000 and hunger.val > 50000 then
                    PlaySoundFrontend(-1, "LOSER", "HUD_AWARDS")
                    lib.notify({
                        title = locale("notify_title"),
                        description = locale("bit_hungry"),
                        type = 'info',
                        position = Config.NotifyPosition,
                        duration = Config.NotifyDuration * 1000
                    })
                    bitHungry = true
                else
                    bitHungry = false
                end
                if hunger.val < 50000 then
                    PlaySoundFrontend(-1, "LOSER", "HUD_AWARDS")
                    lib.notify({
                        title = locale("notify_title"),
                        description = locale("extrem_hungry"),
                        type = 'info',
                        position = Config.NotifyPosition,
                        duration = Config.NotifyDuration * 1000
                    })
                    extremHungry = true
                else
                    extremHungry = false
                end
            end)

            TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)
                if thirst.val < 250000 and thirst.val > 50000 then
                    PlaySoundFrontend(-1, "LOSER", "HUD_AWARDS")
                    lib.notify({
                        title = locale("notify_title"),
                        description = locale("bit_thirsty"),
                        type = 'info',
                        position = Config.NotifyPosition,
                        duration = Config.NotifyDuration * 1000
                    })
                    bitThirsty = true
                else
                    bitThirsty = false
                end
                if thirst.val < 50000 then
                    PlaySoundFrontend(-1, "LOSER", "HUD_AWARDS")
                    lib.notify({
                        title = locale("notify_title"),
                        description = locale("extrem_thirsty"),
                        type = 'info',
                        position = Config.NotifyPosition,
                        duration = Config.NotifyDuration * 1000
                    })
                    extremThirsty = true
                else
                    extremThirsty = false
                end
            end)
        Citizen.Wait(Config.CheckTime * 60000)
        end
    end
end)

RegisterNetEvent('DFNZ_FITBIT:openMenu')
AddEventHandler('DFNZ_FITBIT:openMenu', function()
    local hp_current = GetEntityHealth(PlayerPedId())
    local hp_max = GetEntityMaxHealth(PlayerPedId())
    local hp_percent = math.floor((hp_current / hp_max) * 100)
    local color2 = 'white'
    local percent2 = 0

    percent2 = hp_percent

    if hp_percent > 70 then
        color2 = 'green'
    elseif hp_percent >= 30 and hp_percent <= 69 then
        color2 = 'yellow'
    else
        color2 = 'red'
    end
        TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
        local color3 = 'white'
        local percent3 = 0
        local hunger_percent = math.floor(hunger.val / 10000)
            
        percent3 = hunger_percent

        if hunger_percent > 70 then
            color3 = 'green'
        elseif hunger_percent >= 30 and hunger_percent <= 69 then
            color3 = 'yellow'
        else
            color3 = 'red'
        end

        TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)
            local color4 = 'white'
            local percent4 = 0
            local thirst_percent = math.floor(thirst.val / 10000)
                
            percent4 = thirst_percent
    
            if thirst_percent > 70 then
                color4 = 'green'
            elseif thirst_percent >= 30 and thirst_percent <= 69 then
                color4 = 'yellow'
            else
                color4 = 'red'
            end

            lib.registerContext({
                id = 'fitbit_menu',
                title = 'Fitbit',
                options = {
                    {
                        title = locale("hp")..hp_percent..'%',
                        icon = 'fa-regular fa-heart',
                        progress = percent2,
                        colorScheme = color2,
                        iconColor = color2,
                    },
                    {
                        title = locale("hunger")..hunger_percent..'%',
                        icon = 'burger',
                        progress = percent3,
                        colorScheme = color3,
                        iconColor = color3,
                    },
                    {
                        title = locale("thirst")..thirst_percent..'%',
                        icon = 'bottle-water',
                        progress = percent4,
                        colorScheme = color4,
                        iconColor = color4,
                    }
                }
            })
            lib.showContext('fitbit_menu')
        end)
    end)
end)

RegisterNetEvent('DFNZ_FITBIT:changeBattery')
AddEventHandler('DFNZ_FITBIT:changeBattery', function()
    lib.progressCircle({
        duration = Config.ChangeBatteryTime * 1000,
        label = locale("change_battery"),
        position = 'bottom',
        useWhileDead = false,
        anim = {
            dict = 'missmic4',
            clip = 'michael_tux_fidget',
        }
    })
    TriggerServerEvent('DFNZ_FITBIT:addBattery')
end)

RegisterNetEvent('DFNZ_FITBIT:addBatteryAdmin')
AddEventHandler('DFNZ_FITBIT:addBatteryAdmin', function()
    local input = lib.inputDialog(locale("add_battery"), {
        {type = 'input', description = locale("enter_id"), required = true, icon = 'user'},
        {type = 'input', description = locale("enter_amount"), required = true}
    })
    if input == nil then
        lib.notify({
            title = locale("notify_title"),
            description = locale("no_input"),
            type = 'error',
            position = Config.NotifyPosition,
            duration = Config.NotifyDuration * 1000
        })
    else
        local id = tonumber(input[1])
        local amount = tonumber(input[2])
        if amount > 100 then
            lib.notify({
                title = locale("notify_title"),
                description = locale("to_much"),
                type = 'error',
                position = Config.NotifyPosition,
                duration = Config.NotifyDuration * 1000
            })
        else
            TriggerServerEvent('DFNZ_FITBIT:addBatteryAdmin', id, amount)
        end
    end
end)

