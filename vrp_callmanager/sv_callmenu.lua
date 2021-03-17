local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "vRP_admin")
local config = module("cfg/base")
FRGStaffClient = Tunnel.getInterface("FRG_Staff","FRG_Staff")

weeklyTickets = 0
totalTickets = 0

ticketid = 1

adminTickets = {}

policeTickets = {}

nhsTickets = {}

lfbTickets = {}

--- Check To See if player has perms to access admin,nhs,police or lfb buttons

RegisterServerEvent('FRG:CheckingPerms')
AddEventHandler('FRG:CheckingPerms', function()
    local user_id = vRP.getUserId({source})
    if user_id ~= nil and vRP.hasPermission({user_id,"admin.tickets"}) then
        TriggerClientEvent('FRG:CheckingPerms', source,"Admin")
    end
    if user_id ~= nil and vRP.hasPermission({user_id,"police.menu"}) then
        TriggerClientEvent('FRG:CheckingPerms', source,"Police")
    end
    if user_id ~= nil and vRP.hasPermission({user_id,"lfb.vehicle"}) then
        TriggerClientEvent('FRG:CheckingPerms', source,"LFB")
    end
    if user_id ~= nil and vRP.hasPermission({user_id,"emergency.vehicle"}) then
        TriggerClientEvent('FRG:CheckingPerms', source,"NHS")
    end
end)

-- ADMIN SECTION--

-- Recieve Admin Tickets Event
RegisterServerEvent('FRG:ADMINTICKETSENT')
AddEventHandler('FRG:ADMINTICKETSENT', function(cooldown)
    players = {}
    if cooldown == true then
        vRPclient.notify(source,{"~r~Wait 60 seconds"})
        return
    end
    local user_id = vRP.getUserId({source})
    local source = source
    local name = GetPlayerName(source)
    if user_id ~= nil then
        vRP.prompt({source,"Describe your problem:","",function(player,desc)
            local desc = desc or ""
            if desc ~= nil and desc ~= "" then
                local index = #adminTickets + 1
                adminTickets[index] = {Name = name,PermID = user_id , reason = desc, callerSource = source}
                local Players = GetPlayers()
                for k,v in pairs(Players) do
                    --("------------")
                    --(k,v)
                    local user_id = vRP.getUserId({v})
                    local player = v
                    --(player)
                    if vRP.hasPermission({user_id,"admin.tickets"}) and player ~= nil then
                                    --("Hi: " .. player)
                                  table.insert(players,v)
                                end
                              end
                        Wait(1000)

                                  for a,v in pairs(players) do
                                    --(json.encode(players))
                                    vRPclient.notify(v,{"~o~Admin ticket recieved!"})
                                end
            end
        end})
    end
end)

--Updates the admin tickets each time the menu is opened client sided
RegisterServerEvent('FRG:updateAdmin')
AddEventHandler('FRG:updateAdmin', function()
    TriggerClientEvent('FRG:receiveAdminCalls', -1, adminTickets)
end)

--Removes the admin ticket every time an admin takes one
RegisterServerEvent('FRG:removeAdminTicket')
AddEventHandler('FRG:removeAdminTicket', function(index)
    adminTickets[index] = nil
    --(json.encode(adminTickets))
end)
-- Removes NHS call
RegisterServerEvent('FRG:removeNHSCall')
AddEventHandler('FRG:removeNHSCall', function(index)
    nhsTickets[index] = nil
end)

--teleports admin to the recipient
RegisterServerEvent('FRG:staffTeleport')
AddEventHandler('FRG:staffTeleport', function(callerSource)
    local source = source
    local callerSource = callerSource
    local user_id = vRP.getUserId({source})
    local admin_userid = vRP.getUserId({source})
    if user_id ~= nil and vRP.hasPermission({user_id,"admin.tickets"}) then
        vRP.giveBankMoney({admin_userid,3000})
        vRPclient.notify(source,{"~g~Here have £3000 for being a g! Keep the tickets up :p"})

        vRPclient.getPosition(source, {}, function(x,y,z)
            local location = tostring(x)..','..tostring(y)..','..tostring(z)
            exports['ghmattimysql']:execute("INSERT INTO vrp_admin_data (user_id, last_location) VALUES( @user_id, @location ) ON DUPLICATE KEY UPDATE `last_location` = @location", {user_id = admin_userid, location = location}, function() end)
        end)
        Wait(300)
        FRGStaffClient.StaffOn(source)
        TriggerClientEvent('FRG:staffTPTOPlayer', source, GetEntityCoords(GetPlayerPed(callerSource)))
        exports['ghmattimysql']:execute("SELECT * FROM FRG_admintickets WHERE UserID = @user_id", {user_id = admin_userid}, function(result)
            if #result > 0 then
                local tTickets = result[1].Tickets
                local wTickets = result[1].weeklyTickets
                local newtTickets = tonumber(tTickets) + 1
                local newwTickets = tonumber(wTickets) + 1
                exports['ghmattimysql']:execute("UPDATE FRG_admintickets SET weeklyTickets = @weeklyTickets, Tickets = @Tickets WHERE UserID = @user_id", {weeklyTickets = tonumber(newwTickets), Tickets = tonumber(newtTickets), user_id = admin_userid}, function() end)
            else
                exports['ghmattimysql']:execute("INSERT INTO FRG_admintickets (UserID, Name, weeklyTickets, Tickets) VALUES( @user_id, @Name, @weeklyTickets, @Tickets) ON DUPLICATE KEY UPDATE `Tickets` = @Tickets, `weeklyTickets` = @weeklyTickets", {user_id = admin_userid, Name = GetPlayerName(source), weeklyTickets = 1, Tickets = 1}, function() end)        
            end
        end)
    end
    TriggerClientEvent("FRG:CloseMenu",source)
end)
-- POLICE SECTION --

-- --Recieve Police Calls Event
RegisterServerEvent('FRG:receivePoliceTickets')
AddEventHandler('FRG:receivePoliceTickets', function()
    players = {}
    local admin_userid = vRP.getUserId({source})
    local user_id = vRP.getUserId({source})
    local sources = source
    local names = GetPlayerName(source)
    if user_id ~= nil then
        vRP.prompt({source,"Describe your Issue:","",function(player,policedesc)
            local policedesc = policedesc or ""
            if policedesc ~= nil and policedesc ~= "" then
                ----("Message should pass")
                local index = #policeTickets + 1
                policeTickets[index] = {policeName = names, policereason = policedesc, policecallerSource = sources}
                local Players = GetPlayers()
                for k,v in pairs(Players) do
                    --("------------")
                    --(k,v)
                    local user_id = vRP.getUserId({v})
                    local player = v
                    --(player)
                    if vRP.hasPermission({user_id,"police.menu"}) and player ~= nil then
                                    --("Hi: " .. player)
                                  table.insert(players,v)
                                end
                              end
                        Wait(1000)

                                  for a,v in pairs(players) do
                                    --(json.encode(players))
                                    vRPclient.notify(v,{"~b~Police call recieved!"})
                                    TriggerClientEvent('FRGSound:PlayOnOne', v, "adminsound", 1)
                                end
            end
        end})
    end
end)

RegisterServerEvent('FRG:recieveNHSCall')
AddEventHandler('FRG:recieveNHSCall', function()
    players = {}
    local admin_userid = vRP.getUserId({source})
    local user_id = vRP.getUserId({source})
    local sources = source
    local names = GetPlayerName(source)
    if user_id ~= nil then
        vRP.prompt({source,"Describe your Issue:","",function(player,policedesc)
            local policedesc = policedesc or ""
            if policedesc ~= nil and policedesc ~= "" then
                local index = #nhsTickets + 1
                nhsTickets[index] = {policeName = names, policereason = policedesc, policecallerSource = sources}
                --(json.encode(nhsTickets))
                ----(source)
                local Players = GetPlayers()
                for k,v in pairs(Players) do
                    --("------------")
                    --(k,v)
                    local user_id = vRP.getUserId({v})
                    local player = v
                    --(player)
                    if vRP.hasPermission({user_id,"emergency.vehicle"}) and player ~= nil then
                                    --("Hi: " .. player)
                                  table.insert(players,v)
                                end
                              end
                        Wait(1000)

                                  for a,v in pairs(players) do
                                    --(json.encode(players))
                                    vRPclient.notify(v,{"~g~NHS call recieved!"})
                                    TriggerClientEvent('FRGSound:PlayOnOne', v, "adminsound", 1)
                                end
            end
        end})
    end
end)

RegisterServerEvent('FRG:recieveNHSCall2')
AddEventHandler('FRG:recieveNHSCall2', function()
    local user_id = vRP.getUserId({source})
    local sources = source
    local names = GetPlayerName(source)
    if user_id ~= nil then
    local index = #nhsTickets + 1
    nhsTickets[index] = {policeName = names, policereason = "Patient is down! Assistance needed.", policecallerSource = sources}
    end
end)


-- GetEntityCoords(GetPlayerPed(policecallerSource))
-- Add Police Waypoint to Recipient
RegisterServerEvent('FRG:setpoliceWaypoint')
AddEventHandler('FRG:setpoliceWaypoint', function(policecallerSource)
    local user_id = vRP.getUserId({source})
    if user_id ~= nil  then

        TriggerClientEvent('FRG:policeWaypoint', source,GetEntityCoords(GetPlayerPed(policecallerSource)))
        TriggerClientEvent("FRG:CloseMenu",source)
    else
        return
    end
end)

--removes police ticket when accepted
RegisterServerEvent('FRG:removePoliceTicket')
AddEventHandler('FRG:removePoliceTicket', function(index)
    policeTickets[index] = nil
end)

RegisterServerEvent('FRG:updatePolice')
AddEventHandler('FRG:updatePolice', function()
    ----("Niggggggger")
    TriggerClientEvent('FRG:updatePolice', -1,policeTickets)
end)

RegisterServerEvent('FRG:updateNHS')
AddEventHandler('FRG:updateNHS', function()
    --("Update NHS")
    --(json.encode(nhsTickets))
    TriggerClientEvent('FRG:updateNHS', -1,nhsTickets)
end)

RegisterServerEvent("FRG:return")
AddEventHandler("FRG:return", function()
    local source = source
    local user_id = vRP.getUserId({source})
    local src = vRP.getUserSource({user_id})
    exports['ghmattimysql']:execute("SELECT last_location FROM vrp_admin_data WHERE user_id = @user_id", {user_id = user_id}, function(result)
        local t = {}

        for i in result[1].last_location:gmatch("([^,%s]+)") do  
            t[#t + 1] = i
        end 

        local x = tonumber(t[1])
        local y = tonumber(t[2])
        local z = tonumber(t[3])
        local coords = vector3(x,y,z)
        TriggerClientEvent("_35635675789685225345", src, coords)
        FRGStaffClient.StaffOff(source)
    end)
    exports['ghmattimysql']:execute("DELETE FROM vrp_admin_data WHERE `user_id` = @user_id", {user_id = user_id}, function() end)        
end)