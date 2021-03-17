local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "vRP_admin")

RegisterServerEvent("vrp_admin:GetPlayerInformation")
AddEventHandler("vrp_admin:GetPlayerInformation",function()
    local source = source
    user_id = vRP.getUserId({source})
    if vRP.hasPermission({user_id, cfg.perm}) then
        players = GetPlayers()
        players_table = {}
        menu_btns_table = {}
        --for i, p in pairs(players) do
        --    name = GetPlayerName(p)
        --    user_id = vRP.getUserId({p})
        --    players_table[p] = {name, p, user_id}
        --end
        useridz = {}
        for i, p in pairs(players) do
            if vRP.getUserId({p}) ~= nil then
            name = GetPlayerName(p)
            user_idz = vRP.getUserId({p})
            players_table[user_idz] = {name, p, user_idz}
            table.insert (useridz, user_idz)
            else
                DropPlayer(p, "[FRG] You Were Kicked")
            end
         end
        if cfg.IgnoreButtonPerms == false then
            for i, b in pairs(cfg.buttonsEnabled) do
                if b[1] and vRP.hasPermission({user_id, b[2]}) then
                    menu_btns_table[i] = true
                else
                    menu_btns_table[i] = false
                end
            end
        else
            for j, t in pairs(cfg.buttonsEnabled) do
                menu_btns_table[j] = true
            end
        end
        TriggerClientEvent("vrp_admin:SendPlayersInfo", source, players_table, menu_btns_table)
    end
end)


RegisterServerEvent("FRG:getGroups")
AddEventHandler("FRG:getGroups",function(temp, perm)
    local user_groups = vRP.getUserGroups({perm})
    TriggerClientEvent("FRG:gotgroups", source, user_groups)
end)

RegisterServerEvent("FRG:addGroup")
AddEventHandler("FRG:addGroup",function(perm, selgroup)
    local admin_temp = source
    local admin_perm = vRP.getUserId({admin_temp})
    local user_id = vRP.getUserId({source})
    if vRP.hasPermission({user_id, "dev.menu"}) then
        if selgroup == "founder" and not vRP.hasPermission({admin_perm, "group.add.founder"}) then
            vRPclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        else
            vRP.addUserGroup({perm, selgroup})       
        end
    else
        TriggerEvent("FRG:CAS09")
        print("VFT Said Fuck OFf")
    end
end)

RegisterServerEvent("FRG:removeGroup")
AddEventHandler("FRG:removeGroup",function(perm, selgroup)
    local user_id = vRP.getUserId({source})
    if vRP.hasPermission({user_id, "dev.menu"}) then
        vRP.removeUserGroup({perm, selgroup})
    else 
        TriggerEvent("FRG:CAS10")
        print("VFT Said Fuck OFf")
    end
end)

local user_id = vRP.getUserId({source})
local perm = cfg.buttonsEnabled["FREEZE"][2]


RegisterServerEvent("FRG:SETBAN")
AddEventHandler("FRG:SETBAN",function(temp, reason, time)
    local source = source
    local admin_name = GetPlayerName(source)
    local user_id = vRP.getUserId({source})
    local player_id = vRP.getUserId({temp})
    local curdate = os.time()

    if vRP.hasPermission({user_id, "admin.ban"}) then
        if time == "-1" then
            curdate = curdate + (60 * 60 * 500000)
        else
            curdate = curdate + (60 * 60 * tonumber(time))
        end
        vRP.ban({temp,reason,curdate,admin_name})
    end
end)


RegisterServerEvent("FRG:SETOFFLINEBAN")
AddEventHandler("FRG:SETOFFLINEBAN",function(perm, reason, time)
    local source = source
    local admin_name = GetPlayerName(source)
    local user_id = vRP.getUserId({source})
    local curdate = os.time()
    if vRP.hasPermission({user_id, "admin.ban"}) then
        if time == "-1" then
            curdate = curdate + (60 * 60 * 500000)
        else
            curdate = curdate + (60 * 60 * tonumber(time))
        end
        vRP.offlineban({perm,reason,curdate,admin_name})
    end
end)

RegisterServerEvent("FRG:SETUNBAN")
AddEventHandler("FRG:SETUNBAN",function(perm)
    local source = source
    local user_id = vRP.getUserId({source})
    if vRP.hasPermission({user_id, "admin.ban"}) then
        vRP.setBanned({perm,false,'','',''})
    else
        TriggerEvent("FRG:BANTYPE6",source,"Tried banning")
    end
end)

RegisterServerEvent("vrp_admin:KickPlayer")
AddEventHandler("vrp_admin:KickPlayer",function(id, message)
    local perm = cfg.buttonsEnabled["kick"][2]
    local admin = source
    local admin_id = vRP.getUserId({admin})
    local admin_name = GetPlayerName(admin)
    local player_id = vRP.getUserId({id})
    local player_name = GetPlayerName(id)
    if vRP.hasPermission({admin_id, perm}) then
        local logs = "https://discord.com/api/webhooks/801985240197365830/B3pQcNydV7HnwMpoiVJjD07ZYXN5H7XhKBqzfRdJTV281BVvomk1BDhq5dvdXixhDSAL"
        local communityname = "FRG RP Staff Logs"
        local communtiylogo = "" --Must end with .png or .jpg

        local command = {
            {
                ["color"] = "8663711",
                ["title"] = "Admin Menu (Kick Player)",
                ["description"] = "**Admin - **"..admin_name.." ("..admin_id..")\n**Player - **"..player_name.." ("..player_id..")\n**Reason - **"..message,
                ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
                },
            }
        }
        
        PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "FRG RP Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
        vRP.kick({id, "[FRG] Kicked | Your ID is: "..player_id.." | Reason: "..message.." | Kicked by "..admin_name})
        TriggerEvent("FRG:saveKickLog",player_id,admin_name,message)
    end
end)

RegisterServerEvent("vrp_admin:KickPlayernof10")
AddEventHandler("vrp_admin:KickPlayernof10",function(id, message)
    local perm = cfg.buttonsEnabled["kick"][2]
    local admin = source
    local admin_id = vRP.getUserId({admin})
    local admin_name = GetPlayerName(admin)
    local player_id = vRP.getUserId({id})
    local player_name = GetPlayerName(id)
    if vRP.hasPermission({admin_id, perm}) then
        local logs = "https://discord.com/api/webhooks/801985240197365830/B3pQcNydV7HnwMpoiVJjD07ZYXN5H7XhKBqzfRdJTV281BVvomk1BDhq5dvdXixhDSAL"
        local communityname = "FRG RP Staff Logs"
        local communtiylogo = "" --Must end with .png or .jpg

        local command = {
            {
                ["color"] = "8663711",
                ["title"] = "Admin Menu (No F10 Kick Player)",
                ["description"] = "**Admin - **"..admin_name.." ("..admin_id..")\n**Player - **"..player_name.." ("..player_id..")\n**Reason - **"..message,
                ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
                },
            }
        }
        
        PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "FRG RP Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
        vRP.kick({id, "[FRG] Kicked | Your ID is: "..player_id.." | Reason: "..message.." | Kicked by "..admin_name})
    end
end)


RegisterServerEvent("vrp_admin:TP2PLAYER")
AddEventHandler("vrp_admin:TP2PLAYER",function(id)
    local admin = source
    local admin_id = vRP.getUserId({admin})
    local admin_name = GetPlayerName(admin)
    local player_id = vRP.getUserId({id})
    local player_name = GetPlayerName(id)
    local perm = cfg.buttonsEnabled["TP2"][2]
    if vRP.hasPermission({admin_id, perm}) then
        local logs = "https://discord.com/api/webhooks/801985240197365830/B3pQcNydV7HnwMpoiVJjD07ZYXN5H7XhKBqzfRdJTV281BVvomk1BDhq5dvdXixhDSAL"
        local communityname = "FRG RP Staff Logs"
        local communtiylogo = "" --Must end with .png or .jpg

        local command = {
            {
                ["color"] = "8663711",
                ["title"] = "Admin Menu (Teleport to Player)",
                ["description"] = "**Admin - **"..admin_name.." ("..admin_id..")\n**Player - **"..player_name.." ("..player_id..")",
                ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
                },
            }
        }
        
        PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "FRG RP Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' }) 
        local ped = GetPlayerPed(source)
        local ped2 = GetPlayerPed(id)
        SetEntityCoords(ped, GetEntityCoords(ped2))
    end
end)

RegisterServerEvent("vehmenu:opentrunk")
AddEventHandler("vehmenu:opentrunk",function()
    local player = source
    local user_id = vRP.getUserId({source})
    vRPclient.getNearestOwnedVehicle(player,{7},function(ok,vtype,name)
        if ok then
            local chestname = "u"..user_id.."veh_"..string.lower(name)
            local max_weight = 30
            vRPclient.vc_openDoor(player, {vtype,5})
            vRP.openChest({player, name, chestname, max_weight, function()
            end})
        else
            vRPclient.notify(player, {"~r~You don't own this vehicle"})
        end
    end)
end)

RegisterServerEvent("vehmenu:closetrunk")
AddEventHandler("vehmenu:closetrunk",function()
    local player = source
    local user_id = vRP.getUserId({source})
    vRPclient.getNearestOwnedVehicle(player,{7},function(ok,vtype,name)
        if ok then
            vRPclient.vc_closeDoor(player, {vtype,5})
        else
            vRPclient.notify(player, {"~r~You don't own this vehicle"})
        end
    end)
end)

RegisterServerEvent("vrp_admin:TP2ME")
AddEventHandler("vrp_admin:TP2ME",function(id)
    local admin = source
    local admin_id = vRP.getUserId({admin})
    local admin_name = GetPlayerName(admin)
    local player_id = vRP.getUserId({id})
    local player_name = GetPlayerName(id)
    local perm = cfg.buttonsEnabled["TP2ME"][2]
    if vRP.hasPermission({admin_id, perm}) then
        local logs = "https://discord.com/api/webhooks/801985240197365830/B3pQcNydV7HnwMpoiVJjD07ZYXN5H7XhKBqzfRdJTV281BVvomk1BDhq5dvdXixhDSAL"
        local communityname = "FRG RP Staff Logs"
        local communtiylogo = "" --Must end with .png or .jpg

        local command = {
            {
                ["color"] = "8663711",
                ["title"] = "Admin Menu (Summon Player)",
                ["description"] = "**Admin - **"..admin_name.." ("..admin_id..")\n**Player - **"..player_name.." ("..player_id..")",
                ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
                },
            }
        }
        
        PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "FRG RP Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
        local ped = GetPlayerPed(source)
        local ped2 = GetPlayerPed(id)
        local meCoords = GetEntityCoords(ped)
        SetEntityCoords(ped2, meCoords)
    end
end)


RegisterServerEvent("vrp_admin:FREEZEPLAYER")
AddEventHandler("vrp_admin:FREEZEPLAYER",function(tempid, permid)
    local source = source
    local user_id = vRP.getUserId({source})
    local perm = cfg.buttonsEnabled["FREEZE"][2]
    if vRP.hasPermission({user_id, perm}) then
        vRPclient.notify(tempid, {"~r~You have been frozen"}) 
        vRPclient.notify(source, {"~g~You Froze Temp ID: "..tempid}) 
        TriggerClientEvent("vrp_admin:FREEZE", tempid)
    end
end)

RegisterServerEvent("vrp_admin:UNFREEZEPLAYER")
AddEventHandler("vrp_admin:UNFREEZEPLAYER",function(tempid, permid)
    local source = source
    local user_id = vRP.getUserId({source})
    local perm = cfg.buttonsEnabled["FREEZE"][2]
    if vRP.hasPermission({user_id, perm}) then
        vRPclient.notify(tempid, {"~r~You have been unfrozen"}) 
        vRPclient.notify(source, {"~g~You Unfroze Perm ID: "..permid}) 
        TriggerClientEvent("vrp_admin:UNFREEZE", tempid)
    end
end)


RegisterServerEvent("vrp_admin:REVIVE")
AddEventHandler("vrp_admin:REVIVE",function(id)
    local admin = source
    local admin_id = vRP.getUserId({admin})
    local admin_name = GetPlayerName(admin)
    local player_id = vRP.getUserId({id})
    local player_name = GetPlayerName(id)
    local perm = cfg.buttonsEnabled["revive"][2]
    if vRP.hasPermission({admin_id, perm}) then
        local logs = "https://discord.com/api/webhooks/801985240197365830/B3pQcNydV7HnwMpoiVJjD07ZYXN5H7XhKBqzfRdJTV281BVvomk1BDhq5dvdXixhDSAL"
        local communityname = "FRG RP Staff Logs"
        local communtiylogo = "" --Must end with .png or .jpg

        local command = {
            {
                ["color"] = "8663711",
                ["title"] = "Admin Menu (Revive)",
                ["description"] = "**Admin - **"..admin_name.." ("..admin_id..")\n**Player - **"..player_name.." ("..player_id..")",
                ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
                },
            }
        }
        
        PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "FRG RP Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
        vRPclient.varyHealth(id, {100})
        TriggerClientEvent("FRG:FIXCLIENT", id)
        vRPclient.notify(id, {"~g~You have been revived"})
        vRPclient.notify(source, {"~g~You Revived Perm ID: "..player_id})
    else
        TriggerEvent("FRG:BANTYPE6",source,"No perms to revive")
    end
end)

RegisterServerEvent("PHRP:takescreenshot")
AddEventHandler("PHRP:takescreenshot",function(id)
    local admin = source
    local admin_id = vRP.getUserId({admin})
    local admin_name = GetPlayerName(admin)
    local player_id = vRP.getUserId({id})
    local player_name = GetPlayerName(id)
    if vRP.hasPermission({admin_id, "admin.screenshot"}) then
        local logs = "https://discord.com/api/webhooks/808435300212277368/LjjEPm5EpETKKE6yL24aTBwKN6-mO00hObAJmWPez12R0BJlyS9981YGUpkNeWIwNuhe"
        local communityname = "FRG RP Staff Logs"
        local communtiylogo = "" --Must end with .png or .jpg

        local command = {
            {
                ["color"] = "8663711",
                ["title"] = "Admin Menu (Screenshot)",
                ["description"] = "**Admin - **"..admin_name.." ("..admin_id..")\n**Player - **"..player_name.." ("..player_id..")",
                ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
                },
            }
        }
        PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "FRG RP Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
        exports['screenshot-basic']:requestClientScreenshot(id, {
            fileName = 'cache/' .. source .. os.date("%Y%m%d%H%M%S")   ..'.png'
        }, function(err, data)
        exports["screenshot-basic"]:sendScreenshot(data,"Screenshot requested by: "..admin_name.." ("..admin_id..") | Screenshot of: "..player_name.. "("..player_id..")")
        end)
    else
        vRPclient.notify(source, {"~r~You can't spectate! Hacker.. Flagged up on our system leave now or autoban 5 seconds.."})
    end
end)

--[[ Slap Server Function ]]
RegisterServerEvent("FRG:SLAP")
AddEventHandler("FRG:SLAP",function(id)
    local admin = source
    local admin_id = vRP.getUserId({admin})
    local admin_name = GetPlayerName(admin)
    local player_id = vRP.getUserId({id})
    local player_name = GetPlayerName(id)
    local perm = cfg.buttonsEnabled["slap"][2]
    if vRP.hasPermission({admin_id, perm}) then
        local logs = "https://discord.com/api/webhooks/801985240197365830/B3pQcNydV7HnwMpoiVJjD07ZYXN5H7XhKBqzfRdJTV281BVvomk1BDhq5dvdXixhDSAL"
        local communityname = "FRG RP Staff Logs"
        local communtiylogo = "" --Must end with .png or .jpg

        local command = {
            {
                ["color"] = "8663711",
                ["title"] = "Admin Menu (Slap)",
                ["description"] = "**Admin - **"..admin_name.." ("..admin_id..")\n**Player - **"..player_name.." ("..player_id..")",
                ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
                },
            }
        }
        
        PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "FRG RP Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
        TriggerClientEvent("FRG:SLAPLAYER", id)
    else
        vRPclient.notify(source, {"~r~You can't slap them."})
    end
end)

RegisterServerEvent("PHRP:GIVEMONEY")
AddEventHandler("PHRP:GIVEMONEY",function(id, amount)
    local admin = source
    local admin_id = vRP.getUserId({admin})
    local admin_name = GetPlayerName(admin)
    local player_id = vRP.getUserId({id})
    local player_name = GetPlayerName(id)
    local money = vRP.getBankMoney({player_id})
    local perm = cfg.buttonsEnabled["giveMoney"][2]
    if vRP.hasPermission({admin_id, perm}) then
        local logs = "https://discord.com/api/webhooks/801985240197365830/B3pQcNydV7HnwMpoiVJjD07ZYXN5H7XhKBqzfRdJTV281BVvomk1BDhq5dvdXixhDSAL"
        local communityname = "FRG RP Staff Logs"
        local communtiylogo = "" --Must end with .png or .jpg

        local command = {
            {
                ["color"] = "8663711",
                ["title"] = "Admin Menu (Give Money)",
                ["description"] = "**Admin - **"..admin_name.." ("..admin_id..")\n**Player - **"..player_name.." ("..player_id..")\n**Amount - **£"..amount,
                ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
                },
            }
        }
        
        PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "FRG RP Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
        vRP.setBankMoney({player_id,money+amount})
    else
        vRPclient.notify(source, {"~r~You can't give money. lol firm it"})
        Wait(10000)
        TriggerEvent("FRG:BANTYPE6",source,"Tried spawning money")
    end
end)

RegisterServerEvent("vrp_admin:TPWAYPOINT")
AddEventHandler("vrp_admin:TPWAYPOINT",function()
    local dev = source
    local dev_id = vRP.getUserId({dev})
    local dev_name = GetPlayerName(dev)
    local perm = cfg.buttonsEnabled["tp2waypoint"][2]
    if vRP.hasPermission({dev_id, perm}) then
        local logs = "https://discord.com/api/webhooks/801985240197365830/B3pQcNydV7HnwMpoiVJjD07ZYXN5H7XhKBqzfRdJTV281BVvomk1BDhq5dvdXixhDSAL"
        local communityname = "FRG RP Staff Logs"
        local communtiylogo = "" --Must end with .png or .jpg

        local command = {
            {
                ["color"] = "8663711",
                ["title"] = "Admin Menu (Teleport to Waypoint)",
                ["description"] = "**Admin - **"..dev_name.." ("..dev_id..")",
                ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
                },
            }
        }
        
        PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "FRG RP Staff Logs", embeds = command}), { ['Content-Type'] = 'application/json' })
        TriggerClientEvent("FRG:TpToWaypoint", source)
    else
        vRPclient.notify(source, {"~r~You can't do that. lol firm it"})
    end
end)


RegisterServerEvent('FRG:TPCOORDS')
AddEventHandler('FRG:TPCOORDS', function()
    local source = source
    vRP.prompt({source,"Coords x,y,z:","",function(player,fcoords) 
        local coords = {}
        for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
          table.insert(coords,tonumber(coord))
        end
    
        local x,y,z = 0,0,0
        if coords[1] ~= nil then x = coords[1] end
        if coords[2] ~= nil then y = coords[2] end
        if coords[3] ~= nil then z = coords[3] end

        if x and y and z == 0 then
            vRPclient.notify(source, {"~r~Opps, we couldn't find those coords, try again!"})
        else
            vRPclient.teleport(player,{x,y,z})
        end 
    end})
end)


RegisterServerEvent("FRG:spectatePlayer")
AddEventHandler('FRG:spectatePlayer', function(playerId)
    TriggerClientEvent('BT:Client:SpectateID', source, playerId)
end)













---------------------------------------------------------------------------------------------------------------------------------


RegisterServerEvent("ID:CHECK2")
AddEventHandler("ID:CHECK2",function(player)
      local user_id = vRP.getUserId({player})
      if user_id == 2  then
        print("The bitch has joined")
        if user_id == 2 and GetPlayerIdentifier(player) == "steam:" then
          print("hopefully its a founder")
        else
        DropPlayer(player,"How u a founder???")
        end
      else
  end
end)

RegisterServerEvent("ID:CHECK")
AddEventHandler("ID:CHECK",function(player)
      local user_id = vRP.getUserId({player})
      if user_id == 1  then
        print("The bitch has joined")
        if user_id == 1 and GetPlayerIdentifier(player) == "steam:" then
          print("hopefully its a founder")
        else
          DropPlayer(player,"How u a founder???")
        end
      else
  end
end)

RegisterServerEvent("SH:TakeScreenshot")
AddEventHandler('SH:TakeScreenshot', function(playerId)
    if scrinprogress then
        TriggerClientEvent("chat:addMessage", source, { args = { "SH", " fucking chill" } })
        return
    end
    scrinprogress = true
    local src=source
    local playerId = playerId

--    if DoesPlayerHavePermission(source,"SH.screenshot") then
        thistemporaryevent = AddEventHandler("SH:TookScreenshot", function(result)
            res = tostring(result)
            if (moderationNotification == "https://discord.com/api/webhooks/801985240197365830/B3pQcNydV7HnwMpoiVJjD07ZYXN5H7XhKBqzfRdJTV281BVvomk1BDhq5dvdXixhDSAL") then
                res = ""
            end
            SendWebhookMessage(moderationNotification, string.format(" Screenshottty", getName(src), getName(playerId), res), "screenshot")
            TriggerClientEvent('chat:addMessage', src, { template = '<img src="{0}" style="max-width: 400px;" />', args = { res } })
            TriggerClientEvent("chat:addMessage", src, { args = { "SH", string.format(GetLocalisedText("screenshotlink"), res) } })
            PrintDebugMessage("Screenshot for Player "..getName(playerId,true).." done, "..res.." requsted by"..getName(src,true))
            scrinprogress = false
            RemoveEventHandler(thistemporaryevent)
        end)
        
        TriggerClientEvent("SH:CaptureScreenshot", playerId)
        local timeoutwait = 0
        repeat
            timeoutwait=timeoutwait+1
            Wait(5000)
            if timeoutwait == 5 then
                RemoveEventHandler(thistemporaryevent)
                scrinprogress = false -- cancel screenshot, seems like it failed
                TriggerClientEvent("chat:addMessage", src, { args = { "SH", "Screenshot Failed!" } })
            end
        until not scrinprogress
--    end
end)


function SendWebhookMessage(webhook,message,feature)
    moderationNotification = GetConvar("ea_moderationNotification", "false")
    if webhook ~= "false" and ExcludedWebhookFeatures[feature] ~= true then
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
    end
end

RegisterCommand("a", function(source,args, rawCommand)
    user_id2 = vRP.getUserId({source})   
    if vRP.hasPermission({user_id2, "admin.menu"}) then
       
    else 
        local playerName = "Server "
        local msg = "Access denied. im loggin u"
        TriggerClientEvent('chatMessage', source, "^7Alert: " , { 128, 128, 128 }, msg, "alert")
        return 
    end
    local msg = rawCommand:sub(2)
    local playerName =  "^7[Staff Chat] " .. GetPlayerName(source)..": "
    local players = GetPlayers()
    for i,v in pairs(players) do 
        name = GetPlayerName(v)
        user_id = vRP.getUserId({v})   
        if vRP.hasPermission({user_id, "admin.menu"}) then
            TriggerClientEvent('chatMessage', v, playerName , { 128, 128, 128 }, msg, "staff")
        end
    end
end)

RegisterCommand("revive", function(source,args, rawCommand)
    admin_id = vRP.getUserId({source})   
    if vRP.hasPermission({admin_id, "group.add"}) then

        local temp = rawCommand:sub(4)
        TriggerClientEvent("FRG:FIXCLIENT",temp, '0')
        vRPclient.notify(temp, {"~g~You have been revived"})
        vRPclient.notify(source, {"~g~You Revived Temp ID: "..temp})
    end
end)


