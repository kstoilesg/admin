local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "vRP_gunshop")

RegisterServerEvent('FRG:CheckForPerm')
AddEventHandler('FRG:CheckForPerm', function()
    local source = source
    local user_id = vRP.getUserId({source})
    if vRP.hasGroup({user_id, "cop"}) then
        TriggerClientEvent('FRG:AllowPD', source)
    end
end)

RegisterServerEvent('FRG:placeSpike')
AddEventHandler('FRG:placeSpike', function(netid, coords)
    TriggerClientEvent('FRG:addSpike', -1, netid, coords)
end)

RegisterServerEvent('FRG:removeSpike')
AddEventHandler('FRG:removeSpike', function(netid)
    TriggerClientEvent('FRG:deleteSpike', -1, netid)
end)

RegisterServerEvent('Finished:PD')
AddEventHandler('Finished:PD', function(paycheck)
    local source = source
    local user_id = vRP.getUserId({source})
    if vRP.hasGroup({user_id, "police"}) then
        vRP.giveMoney({userid, tonumber(paycheck)})
    end
end)


RegisterServerEvent("FRG:buyweapon")
AddEventHandler('FRG:buyweapon', function(hash)
    local source = source
    local userid = vRP.getUserId({source})
    if vRP.hasPermission(userid, "cop.whitelisted") then
        if vRP.hasPermission(userid, "police.menu") then
            TriggerClientEvent("FRG:giveweapon", source, hash)
        else
            vRPclient.notify(source, {"~r~You're not on duty"})
        end
    else
        vRPclient.notify(source, {"~r~You're not part of the police force"})
    end
end)

RegisterServerEvent("FRG:buyarmour")
AddEventHandler('FRG:buyarmour', function()
    local source = source
    local userid = vRP.getUserId({source})
    if vRP.hasPermission(userid, "cop.whitelisted") then
        if vRP.hasPermission(userid, "police.menu") then
            TriggerClientEvent("FRG:givearmour", source)
        else
            vRPclient.notify(source, {"~r~You're not on duty"})
        end
    else
        vRPclient.notify(source, {"~r~You're not part of the police force"})
    end
end)

RegisterServerEvent("FRG:CheckForPerm")
AddEventHandler('FRG:CheckForPerm', function(hash)
    local source = source
    userid = vRP.getUserId({source})
    if vRP.hasPermission(userid, "cop.whitelisted") then
        if vRP.hasPermission(userid, "cop") then
            TriggerClientEvent("FRG:AllowPD", source)
        else
            vRPclient.notify(source, {"~r~You're not on duty"})
        end
    else
        vRPclient.notify(source, {"~r~You're not part of the police force"})
    end
end)