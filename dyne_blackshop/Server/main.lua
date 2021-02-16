ESX = nil
 
TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
end)

RegisterServerEvent('dyne_blackshop:buyitem')
AddEventHandler('dyne_blackshop:buyitem', function(item,value,price)
    local _source  = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    price = value * price
    if xPlayer.canCarryItem(item, value) then
        if xPlayer.getMoney() >= price then
            xPlayer.addInventoryItem(item, value)
            xPlayer.removeMoney(price)
            xPlayer.showNotification('Has comprado x'..value..' de '..ESX.GetItemLabel(item)..' por '..price..'$')
        else
            xPlayer.showNotification('No tienes suficiente dinero')
        end
    else
        xPlayer.showNotification('No tienes espacio suficiente en el inventario')
    end
end)


RegisterServerEvent('dyne_blackshop:buyweapon')
AddEventHandler('dyne_blackshop:buyweapon', function(item,price,need)
    local _source  = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.getInventoryItem(need).count >= price then
        xPlayer.removeInventoryItem(need, price)
        xPlayer.addWeapon(item, 56)
        xPlayer.showNotification('Has comprado un '..ESX.GetWeaponLabel(item)..' por '..price..' piezas de  '..ESX.GetItemLabel(need))
    else
        xPlayer.showNotification('No tienes suficiente chatarra')
    end
end)

RegisterServerEvent('dyne_blackshop:cargador')
AddEventHandler('dyne_blackshop:cargador', function(type)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeInventoryItem(type, 1)
end)






--- Item ---

ESX.RegisterUsableItem('cargador_pequeño',function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.triggerEvent('dyne_blackshop:cargador', 'cargador_pequeño')

end)


ESX.RegisterUsableItem('cargador_mediano',function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.triggerEvent('dyne_blackshop:cargador', 'cargador_mediano')

end)


ESX.RegisterUsableItem('cargador_grande',function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.triggerEvent('dyne_blackshop:cargador', 'cargador_grande')

end)