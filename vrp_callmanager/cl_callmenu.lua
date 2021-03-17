RMenu.Add('callmenu', 'main', RageUI.CreateMenu("Call Manager", "~b~Call Menu", 1300,100))
RMenu.Add('callmenu', 'Admin', RageUI.CreateSubMenu(RMenu:Get('callmenu', 'main'), "", "~b~Admin Tickets"))
RMenu.Add('callmenu', 'Police', RageUI.CreateSubMenu(RMenu:Get('callmenu', 'main'), "", "~b~Police Calls"))
RMenu.Add('callmenu', 'NHS', RageUI.CreateSubMenu(RMenu:Get('callmenu', 'main'), "", "~b~NHS Calls"))
RMenu.Add('callmenu', 'LFB', RageUI.CreateSubMenu(RMenu:Get('callmenu', 'main'), "", "~b~LFB Calls"))


local LFB = false
local Police = false
local NHS = false
local Admin = false

adminCalls = {}
policeCalls = {}
nhsCalls = {}
lfbCalls = {}
desc = desc or ""
policedesc = policedesc or ""
local user_id = GetPlayerServerId(GetPlayerPed(-1))

-- RageUI.CreateWhile(wait, menu, key, closure)
RageUI.CreateWhile(1.0, RMenu:Get('callmenu', 'main'), nil, function()

 -- RageUI.IsVisible(menu, header, glare, instructional, items, panels)
    RageUI.IsVisible(RMenu:Get('callmenu', 'main'), true, false, true, function()
        adminBtn()
        policeBtn()
        medicBtn()
    end, function()
        ---Panels
    end)
        adminSM()
        policeSM()
        medicSM()
end)


function adminBtn()
    if Admin == false then return end
    RageUI.Button("Admin Calls" , nil, {RightLabel = "→→→",}, true, function(Hovered, Active, Selected)
        if Selected then
            --TriggerServerEvent('FRG:adminNotification')
        end
    end, RMenu:Get('callmenu', 'Admin'))
end

function medicBtn()
    if NHS == false then return end
    RageUI.Button("NHS Calls" , nil, {RightLabel = "→→→",}, true, function(Hovered, Active, Selected)
        if Selected then
            --TriggerServerEvent('FRG:adminNotification')
        end
    end, RMenu:Get('callmenu', 'NHS'))
end

function policeBtn()
    if Police == false then return end
    RageUI.Button("Police Calls" , nil, {RightLabel = "→→→",}, true, function(Hovered, Active, Selected)
        if Selected then
            --TriggerServerEvent('FRG:adminNotification')
        end
    end, RMenu:Get('callmenu', 'Police'))
end

RegisterNetEvent('FRG:CheckingPerms')
AddEventHandler('FRG:CheckingPerms', function(var)

    if var == "LFB" then
        LFB = true
    end
    if var == "Admin" then
        Admin = true
    end
    if var == "Police" then
        Police = true
    end
   -- print(var)
    if var == "NHS" then
        NHS = true
    end
end)

--[[Sub Menus]]
local cooldown = false
function adminSM()
    RageUI.IsVisible(RMenu:Get('callmenu', 'Admin'), true, false, true, function(v,ok)
        for k,v in pairs(adminCalls) do
            RageUI.Button(v.reason, "Name: "..v.Name.." | PermID: "..v.PermID.. " | TempID: "..v.callerSource,{}, true, function(Hovered, Active, Selected)
                if Selected then
                    local  playerlocal2 = GetPlayerServerId(PlayerId())
                  if v.callerSource == playerlocal2 then
                        notify("~r~OII!!, Stop trying to money farm")
                        return
                    end
                    local FRGCallerSource = v.callerSource
                    updateAdmin()
                    cooldown = true
                    TriggerServerEvent('FRG:staffTeleport', FRGCallerSource)
                    TriggerServerEvent('FRG:removeAdminTicket',k)
                    TriggerServerEvent('FRG:checkstaffWhitelist')
                    Citizen.Wait(1)
                    TriggerServerEvent('FRG:checkstaffWhitelist2')
                    Citizen.Wait(1)
                    TriggerServerEvent('FRG:checkstaffWhitelist3')
                    Citizen.Wait(1)
                    TriggerServerEvent('FRG:checkstaffWhitelist4')
                    Citizen.Wait(1)
                    TriggerServerEvent('FRG:checkstaffWhitelist5')
                    Citizen.Wait(1)
                    TriggerServerEvent('FRG:checkstaffWhitelist6')
                    Citizen.Wait(1)
                    TriggerServerEvent('FRG:checkstaffWhitelist7')
                    Citizen.Wait(1)
                    TriggerServerEvent('FRG:checkstaffWhitelist8')
                    Citizen.Wait(1)
                end
            end)
        end
        end, function()
    end)
end

Citizen.CreateThread(function()
while true do
Wait(5000)
if cooldown == true then
cooldown = false
end
end
end)


function medicSM()
    RageUI.IsVisible(RMenu:Get('callmenu', 'NHS'), true, false, true, function(v,ok)
        for k,v in pairs(nhsCalls) do
            RageUI.Button("Name: "..v.policeName, "Reason: "..v.policereason,{}, true, function(Hovered, Active, Selected)
                if Selected then
                    local  playerlocal2 = GetPlayerServerId(PlayerId())
                    if v.callerSource == playerlocal2 then
                        notify("~r~ You Can't Take Your Own Ticket!")
                        return
                    end
                    TriggerServerEvent('FRG:setpoliceWaypoint', v.policecallerSource)
                    TriggerServerEvent('FRG:removeNHSCall',k)
                end
            end)
        end
        end, function()
    end)
end

function policeSM()
    RageUI.IsVisible(RMenu:Get('callmenu', 'Police'), true, false, true, function(v,ok)
        for k,v in pairs(policeCalls) do
            RageUI.Button("Name: "..v.policeName, "Reason: "..v.policereason,{}, true, function(Hovered, Active, Selected)
                if Hovered then
                    TriggerServerEvent('FRG:setpoliceWaypoint', v.policecallerSource)
                end
                if Selected then
                    local  playerlocal2 = GetPlayerServerId(PlayerId())
                    if v.policecallerSource == playerlocal2 then
                        notify("~r~ You Can't Take Your Own Police Call")
                        return
                    end
                    TriggerServerEvent('FRG:setpoliceWaypoint', v.policecallerSource)
                    TriggerServerEvent('FRG:removePoliceTicket',k)
                end
            end)
        end
        end, function()
    end)
end

function notify(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(true, false)
end

RegisterNetEvent('FRG:staffTPTOPlayer')
AddEventHandler('FRG:staffTPTOPlayer',function(callerSource)
    local callerSource = callerSource
    local player =PlayerPedId()
    local player2 = GetPlayerPed(callerSource)
    local toPlayer = GetPlayerFromServerId(callerSource)
    local player2 = GetPlayerPed(callerSource)
    local coords = callerSource
    SetEntityCoordsNoOffset(player, coords.x, coords.y, coords.z, false, false, false)
end)

RegisterNetEvent("_35635675789685225345")
AddEventHandler("_35635675789685225345", function(coords)
  --  print("TP!")
   -- print(coords.x)
    SetEntityCoordsNoOffset(GetPlayerPed(-1), coords.x, coords.y, coords.z, false, false, false)
end)

RegisterNetEvent('FRG:policeWaypoint')
AddEventHandler('FRG:policeWaypoint', function(policecallerSource)
    local player =PlayerPedId()
    local coords = policecallerSource
    SetNewWaypoint(coords.x, coords.y)
end)

RegisterCommand("nhs", function()
  TriggerServerEvent("FRG:recieveNHSCall")
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if IsControlPressed(0, 243, true) then
            LFB = false
            Admin = false
            Police = false
            NHS = false
            TriggerServerEvent('FRG:CheckingPerms')
            updateAdmin()
            RageUI.Visible(RMenu:Get("callmenu", "main"), true)
        end
    end
end)



function updateAdmin()
    TriggerServerEvent('FRG:updateAdmin')
    TriggerServerEvent('FRG:updatePolice')
    TriggerServerEvent("FRG:updateNHS")
end

RegisterNetEvent('FRG:receiveAdminCalls')
AddEventHandler('FRG:receiveAdminCalls', function(table)
    adminCalls = table
end)
RegisterNetEvent('FRG:CloseMenu')
AddEventHandler('FRG:CloseMenu', function()
   -- print("Hello!")
    RageUI.Visible(RMenu:Get("callmenu", "main"), false)
    RageUI.Visible(RMenu:Get("callmenu", "Admin"), false)
    RageUI.Visible(RMenu:Get("callmenu","Police"), false)
    RageUI.Visible(RMenu:Get("callmenu","NHS"), false)
    RageUI.Visible(RMenu:Get("callmenu","LFB"), false)
end)

RegisterNetEvent('FRG:updatePolice')
AddEventHandler('FRG:updatePolice', function(table)
    policeCalls = table
end)


RegisterNetEvent('FRG:updateNHS')
AddEventHandler('FRG:updateNHS', function(table)
    nhsCalls = table
end)
