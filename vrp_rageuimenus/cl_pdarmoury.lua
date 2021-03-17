RMenu.Add('FRG:armory', 'main', RageUI.CreateMenu("", "~b~Police Armoury Menu", nil, nil, "root_cause", "shopui_title_warstock"))

RageUI.CreateWhile(1.0, RMenu:Get('FRG:armory', 'main'), nil, function()

    RageUI.IsVisible(RMenu:Get('FRG:armory', 'main'), true, false, true, function()

        RageUI.Button("Tazer" , nil, {RightLabel = ">>>"}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent('FRG:buyweapon', "WEAPON_STUNGUN")
            end
        end)
        RageUI.Button("Glock" , nil, {RightLabel = ">>>"}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent('FRG:buyweapon', "WEAPON_GLOCK17")
            end
        end)
        RageUI.Button("MP5K" , nil, {RightLabel = ">>>"}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent('FRG:buyweapon', "WEAPON_MP5")
            end
        end)
        RageUI.Button("G36K" , nil, {RightLabel = ">>>"}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent('FRG:buyweapon', "WEAPON_G36K")
            end
        end)
        RageUI.Button("M4A1" , nil, {RightLabel = ">>>"}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent('FRG:buyweapon', "WEAPON_M4A1")
            end
        end)
        RageUI.Button("SIGMCX" , nil, {RightLabel = ">>>"}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent('FRG:buyweapon', "WEAPON_MCX")
            end
        end)
        RageUI.Button("BARRET M98" , nil, {RightLabel = ">>>"}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent('FRG:buyweapon', "WEAPON_BARRET")
            end
        end)
        RageUI.Button("Bora" , nil, {RightLabel = ">>>"}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent('FRG:buyweapon', "WEAPON_BORA")
            end
        end)
        RageUI.Button("Remington870" , nil, {RightLabel = ">>>"}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent('FRG:buyweapon', "WEAPON_REMINGTON870")
            end
        end)
        RageUI.Button("100% Armour" , nil, {RightLabel = ">>>"}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent('FRG:buyarmour')
            end
        end)
    end, function()
        ---Panels
    end)
end)


isInMenu = false
currentAmmunition = nil
Citizen.CreateThread(function() 
    while true do
            local x,y,z = table.unpack({480.96,-995.8,30.69})
            local v1 = vector3(x,y,z)
            if isInArea(v1, 100.0) then 
                DrawMarker(27, 480.96,-995.8,30.69 - 0.999999, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 2.5, 255, 0, 0, 150, 0, 0, 2, 0, 0, 0, false)
            end
            if isInMenu == false then
            if isInArea(v1, 1.4) then 
                alert('Press ~INPUT_VEH_HORN~ to open police armory')
                if IsControlJustPressed(0, 51) then 
                    currentAmmunition = k
                    RageUI.Visible(RMenu:Get("FRG:armory", "main"), true)
                    isInMenu = true
                    currentAmmunition = k 
                end
            end
            end
            if isInArea(v1, 1.4) == false and isInMenu and k == currentAmmunition then
                RageUI.Visible(RMenu:Get("FRG:armory", "main"), false)
                isInMenu = false
                currentAmmunition = nil
            end
        Citizen.Wait(0)
    end
end)

vRPclient = Proxy.getInterface("vRP")
RegisterNetEvent("FRG:giveweapon")
AddEventHandler("FRG:giveweapon", function(hash) 
    vRPclient.allowWeapon({hash, "-1"})
    GiveWeaponToPed(PlayerPedId(), GetHashKey(hash), 250, false, false)
end)



RegisterNetEvent("FRG:givearmour")
AddEventHandler("FRG:givearmour", function()
    SetPedArmour(PlayerPedId(), 97)
end)

function isInArea(v, dis) 

    if Vdist2(GetEntityCoords(PlayerPedId(-1)), v) < dis then  
        return true
    else 
        return false
    end
end

function alert(msg) 
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end