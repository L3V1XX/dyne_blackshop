ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    InitThread()
end)

InitThread = function()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            local sleep = true
            local coords = GetEntityCoords(PlayerPedId())
            local zone = Config.Shop
            local distance = GetDistanceBetweenCoords(coords, zone ,true)

            if distance < 2.0 then
                sleep = false
                Create3D(vector3(zone.x,zone.y,zone.z+2), "Pulsa ~y~E~w~ para ver los productos")
                if IsControlJustReleased(0, 38) then
                    ShopMenu()
                end
            else
                if ESX ~= nil and ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(),'shop_menu') or ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(),'shop_confirm') then
                    ESX.UI.Menu.CloseAll()
                end
            end
            local zone2 = Config.WeaponShop
            local distance2 = GetDistanceBetweenCoords(coords,zone2, true)
            if distance2 < 2.0 then
                sleep = false
                Create3D(vector3(zone2.x,zone2.y,zone2.z+2), "Pulsa ~y~E~w~ para ver el armamento")
                if IsControlJustReleased(0, 38) then
                    WeaponShop()
                end
            else
                if ESX ~= nil and ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(),'shop_weapon') or ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(),'weapon_confirm') then
                    ESX.UI.Menu.CloseAll()
                end
            end
            local zone3 = Config.BuyClips
            local distance3 = GetDistanceBetweenCoords(coords,zone3, true)
            if distance3 < 2.0 then
                sleep = false
                Create3D(vector3(zone3.x,zone3.y,zone3.z+2), "Pulsa ~y~E~w~ para ver la mercancia")
                if IsControlJustReleased(0, 38) then
                    BuyClips()
                end
            else
                if ESX ~= nil and ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(),'clips_menu') or ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(),'clips_confirm') then
                    ESX.UI.Menu.CloseAll()
                end
            end
            if sleep then
                Citizen.Wait(500)
            end
        end
    end)
end

---- Eventos ----
RegisterNetEvent('dyne_blackshop:cargador')
AddEventHandler('dyne_blackshop:cargador', function(type)
    local weapon = GetSelectedPedWeapon(PlayerPedId())
    for i = 1, #Config.Weapons[type], 1 do
        if weapon == GetHashKey(Config.Weapons[type][i]) then
            AddAmmoToPed(PlayerPedId(), weapon, 30)
            ESX.ShowNotification('Has cargado correctamente el arma')
            TriggerServerEvent('dyne_blackshop:cargador',type)
            break
        else
            ESX.ShowNotification('El cargador no corresponde a este tipo de arma')
        end 
    end 
end)

---- NPC ----

Citizen.CreateThread(function()
	local coords = vector3(Config.Shop.x,Config.Shop.y,Config.Shop.z)
	local heading = 344.07
	local model = GetHashKey('ig_omega')

	loadModel(model)

	local ped = CreatePed(4, model, coords.x, coords.y, coords.z, heading, false, false)
	SetEntityInvincible(ped, true)
	FreezeEntityPosition(ped, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCanBeTargetted(ped, false)
	SetModelAsNoLongerNeeded(model)
    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_SMOKING')

    local coords2 = vector3(Config.WeaponShop.x,Config.WeaponShop.y,Config.WeaponShop.z)
	local heading2 = 30.95
	local model2 = GetHashKey('s_m_y_blackops_02')
    
	loadModel(model2)

	local ped2 = CreatePed(4, model2, coords2.x, coords2.y, coords2.z, heading2, false, false)
	SetEntityInvincible(ped2, true)
	FreezeEntityPosition(ped2, true)
	SetBlockingOfNonTemporaryEvents(ped2, true)
    SetPedCanBeTargetted(ped2, false)
	SetModelAsNoLongerNeeded(model2)
    TaskStartScenarioInPlace(ped2, 'WORLD_HUMAN_CLIPBOARD')

    local coords3 = vector3(Config.BuyClips.x,Config.BuyClips.y,Config.BuyClips.z)
	local heading3 = 93.24
	local model3 = GetHashKey('s_m_y_blackops_01')
    
	loadModel(model3)

	local ped3 = CreatePed(4, model3, coords3.x, coords3.y, coords3.z, heading3, false, false)
	SetEntityInvincible(ped3, true)
	FreezeEntityPosition(ped3, true)
	SetBlockingOfNonTemporaryEvents(ped3, true)
    SetPedCanBeTargetted(ped3, false)
	SetModelAsNoLongerNeeded(model3)
    TaskStartScenarioInPlace(ped3, 'WORLD_HUMAN_SMOKING')

    
end)

loadModel = function(model)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(100)
	end
end

----- Funciones ----

ShopMenu = function()
    ESX.UI.Menu.CloseAll()

    local elements = {
        {label = "Fertilizante", item = "fertilizer", value = 1, price = 30, type = "slider", min = 1, max = 100 },
        {label = "Regadera", item = "water_tank", value = 1, price = 50, type = "slider", min = 1, max = 100}
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_menu', {
        title = "¿Que quieres comprar?",
        align = 'bottom-right',
        elements = elements
    }, function(data, menu)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
        title = "¿Quieres comprar x"..data.current.value.." de "..data.current.label.."?",
        align = 'bottom-right',
        elements = {
            {label = "Si", value = "yes"},
            {label = "No", value = "no"}
        }}, function(data2, menu2)
            if data2.current.value == 'yes' then
                TriggerServerEvent('dyne_blackshop:buyitem', data.current.item, data.current.value, data.current.price)
            end
            ShopMenu()
        end, function(data2, menu2)
            menu2.close()
        end)
    end, function(data, menu)
        menu.close()
    end)
end

WeaponShop = function()
    ESX.UI.Menu.CloseAll()

    local elements ={
        {label = "Cuchillo", item = "weapon_knife", price = 50, need = "chatarra"},
        {label = "Machete", item = "weapon_machete",price = 80, need = "chatarra"},
        {label = "Pistola", item = "weapon_pistol",price = 250, need = "chatarra"}
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_weapon', {
        title = "¿Que quieres comprar?",
        align = 'bottom-right',
        elements = elements
    }, function(data, menu)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weapon_confirm', {
        title = "¿Quieres comprar un "..data.current.label.." x "..data.current.price.." de "..data.current.need.."?",
        align = 'bottom-right',
        elements = {
            {label = "Si", value = "yes"},
            {label = "No", value = "no"}
        }}, function(data2, menu2)
            if data2.current.value == 'yes' then
                TriggerServerEvent('dyne_blackshop:buyweapon', data.current.item, data.current.price, data.current.need)
            end
            WeaponShop()
        end, function(data2, menu2)
            menu2.close()
        end)
    end, function(data, menu)
        menu.close()
    end)
end


BuyClips = function()
    ESX.UI.Menu.CloseAll()

    local elements = {
        {label = "Cargador Pequeño ", item = "cargador_pequeño", value = 1, price = 30, type = "slider", min = 1, max = 100 },
        {label = "Cargador Mediano", item = "cargador_mediano", value = 1, price = 40, type = "slider", min = 1, max = 100},
        {label = "Cargador Grande", item = "cargador_grande", value = 1, price = 50, type = "slider", min = 1, max = 100},
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'clips_menu', {
        title = "¿Que quieres comprar?",
        align = 'bottom-right',
        elements = elements
    }, function(data, menu)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'clips_confirm', {
        title = "¿Quieres comprar x"..data.current.value.." de "..data.current.label.."?",
        align = 'bottom-right',
        elements = {
            {label = "Si", value = "yes"},
            {label = "No", value = "no"}
        }}, function(data2, menu2)
            if data2.current.value == 'yes' then
                TriggerServerEvent('dyne_blackshop:buyitem', data.current.item, data.current.value, data.current.price)
            end
            ShopMenu()
        end, function(data2, menu2)
            menu2.close()
        end)
    end, function(data, menu)
        menu.close()
    end)
end


Create3D = function(coords, texto)
    local x, y, z = table.unpack(coords)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(5)
        AddTextComponentString(texto)
        DrawText(_x,_y)
    end
end