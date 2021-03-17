--[[RageUI Stuff]]
local players = {}
RMenu.Add("vrpadmin", "main", RageUI.CreateMenu("FRG Admin", "All Players", 1300, 100, "root_cause", "rageui_admin"))
RMenu.Add("vrpadmin", "allPlayers", RageUI.CreateSubMenu(RMenu:Get("vrpadmin", "main")))
RMenu.Add("vrpadmin", "functionMenu", RageUI.CreateSubMenu(RMenu:Get("vrpadmin", "main")))
RMenu.Add("vrpadmin", "playerFunctions", RageUI.CreateSubMenu(RMenu:Get("vrpadmin", "allPlayers")))
RMenu.Add("vrpadmin", "developerMenu", RageUI.CreateSubMenu(RMenu:Get("vrpadmin", "main")))
RMenu.Add("vrpadmin", "groups", RageUI.CreateSubMenu(RMenu:Get("vrpadmin", "playerFunctions")))
RMenu.Add("vrpadmin", "staffGroups", RageUI.CreateSubMenu(RMenu:Get("vrpadmin", "groups")))
RMenu.Add("vrpadmin", "nhsGroups", RageUI.CreateSubMenu(RMenu:Get("vrpadmin", "groups")))
RMenu.Add("vrpadmin", "mpdGroups", RageUI.CreateSubMenu(RMenu:Get("vrpadmin", "groups")))
RMenu.Add("vrpadmin", "casinoGroups", RageUI.CreateSubMenu(RMenu:Get("vrpadmin", "groups")))
RMenu.Add("vrpadmin", "addgroup", RageUI.CreateSubMenu(RMenu:Get("vrpadmin", "groups")))
RMenu.Add("vrpadmin", "removegroup", RageUI.CreateSubMenu(RMenu:Get("vrpadmin", "groups")))

local searchTerm
local selectedPlayer = {}
local getStaffGroupsGroupIds = {
	["founder"] = "Founder",
	["dev"] = "Developer",
    ["staffmanager"] = "Staff Manager",
    ["commanager"] = "Community Manager",
    ["headadmin"] = "Head Admin",
    ["senioradmin"] = "Senior Admin",
	["administrator"] = "Admin",
	["moderator"] = "Moderator",
    ["support"] = "Support Team",
    ["trialstaff"] = "Trial Staff",
    ["vip"] = "VIP",
    ["rebel"] = "Rebel License",
    ["large"] = "Large License",
    ["heroin"] = "Heroin License",
    ["weed"] = "Weed License",
    ["doge"] = "Doge license",
    ["ethereum"] = "Ethereum license",
    ["bitcoin"] = "Bitcoin license",
}
local getPoliceGroupsGroupIds = {
	["cop"] = "MPD",
    ["rt"] = "MPD Armoury (RT)", --  BATTON | GLOCK | TASER | REMINGTON 870 | MP5
    ["sco"] = "MPD Armoury (SCO-19)", -- EVERY WEAPON EXEPT OF THE 3 SNIPERS
    ["gc"] = "MPD Armoury (GC)", -- EVERY WEAPON FOR GC
}
local getNHSGroupsGroupIds = {
	["nhshq"] = "NHS HQ",
	["ems"] = "NHS",

}
local getCasinoGroupsGroupIds = {
	["cSecurity"] = "Casino Security",
	["cOwner"] = "Casino Owner",
}

local searchPlayerGroups = {}
local selectedGroup
local savedCoords = nil 

RageUI.CreateWhile(
    1.0,
    RMenu:Get("vrpadmin", "main"),
    nil,
    function()
        RageUI.IsVisible(RMenu:Get("vrpadmin", "main"),true, false, true,function()
            if cfg.buttonsEnabled["adminMenu"][1] and buttons["adminMenu"] then
                RageUI.Button("All Players","Shows All Online Players",{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        RMenu:Get("vrpadmin", "allPlayers"):SetTitle("")
                        RMenu:Get("vrpadmin", "allPlayers"):SetSubtitle("All Online Players")
                    end
                end,RMenu:Get("vrpadmin", "allPlayers"))
            end

            if cfg.buttonsEnabled["adminMenu"][1] and buttons["adminMenu"] then
                RageUI.Button("Functions","Server/Client Admin Functions",{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        RMenu:Get("vrpadmin", "functionMenu"):SetTitle("")
                        RMenu:Get("vrpadmin", "functionMenu"):SetSubtitle("Functions")
                    end
                end,RMenu:Get("vrpadmin", "functionMenu"))
            end

            if cfg.buttonsEnabled["devMenu"][1] and buttons["devMenu"] then
                RageUI.Button("Developer","Developer Functions",{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        RMenu:Get("vrpadmin", "developerMenu"):SetTitle("")
                        RMenu:Get("vrpadmin", "developerMenu"):SetSubtitle("Functions")
                    end
                end,RMenu:Get("vrpadmin", "developerMenu"))
            end  
        end,function()end)
        RageUI.IsVisible(RMenu:Get("vrpadmin", "allPlayers"),true,false,true,function()
            for k, v in pairs(players) do
                RageUI.Button(string.format("[%s] %s" ,v[2], v[1]),"Name: " .. v[1] .. " | Perm ID: " .. v[3] .. " | Temp ID: " .. v[2],{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        RMenu:Get("vrpadmin", "playerFunctions"):SetTitle("")
                        RMenu:Get("vrpadmin", "playerFunctions"):SetSubtitle("Name: " .. v[1] .. " | Perm ID: " .. v[3] .. " | Temp ID: " .. v[2])
                        selectedPlayer = players[k]
                    end
                end,RMenu:Get("vrpadmin", "playerFunctions"))
            end
        end,function() end)


        RageUI.IsVisible(
            RMenu:Get("vrpadmin", "playerFunctions"),true,false,true,function()
                if cfg.buttonsEnabled["showwarn"][1] and buttons["showwarn"] then
                    showwarnBtn(selectedPlayer)
                end
                if cfg.buttonsEnabled["warn"][1] and buttons["warn"] then
                    warnPlayerBtn(selectedPlayer)
                end
                if cfg.buttonsEnabled["kick"][1] and buttons["kick"] then
                    kickPlayerBtn(selectedPlayer)
                end
                if cfg.buttonsEnabled["getgroups"][1] and buttons["getgroups"] then
                    RageUI.Button("Get Groups","Get Users Groups",{RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            RMenu:Get("vrpadmin", "groups"):SetTitle("")
                            RMenu:Get("vrpadmin", "groups"):SetSubtitle("Groups")
                            TriggerServerEvent("FRG:getGroups", selectedPlayer[2], selectedPlayer[3])
                        end
                    end,RMenu:Get("vrpadmin", "groups"))
                end
                if cfg.buttonsEnabled["nof10kick"][1] and buttons["nof10kick"] then
                    nof10kickPlayerBtn(selectedPlayer)
                end
                if cfg.buttonsEnabled["ban"][1] and buttons["ban"] then
                    banPlayerBtn(selectedPlayer)
                end
                if cfg.buttonsEnabled["revive"][1] and buttons["revive"] then
                    revPlayerBtn(selectedPlayer)
                end
                if cfg.buttonsEnabled["spectate"][1] and buttons["spectate"] then
                    spectatePlayerBtn(selectedPlayer)
                end
                if cfg.buttonsEnabled["FREEZE"][1] and buttons["FREEZE"] then
                    freezePlayerBtn(selectedPlayer)
                end
                if cfg.buttonsEnabled["TP2"][1] and buttons["TP2"] then
                    tp2PlayerBtn(selectedPlayer)
                end
                if cfg.buttonsEnabled["TP2ME"][1] and buttons["TP2ME"] then
                    tp2meBtn(selectedPlayer)
                end
                if cfg.buttonsEnabled["SS"][1] and buttons["SS"] then
                    screenshot(selectedPlayer)
                end
                if cfg.buttonsEnabled["slap"][1] and buttons["slap"] then
                    slapBtn(selectedPlayer)
                end
                if cfg.buttonsEnabled["giveMoney"][1] and buttons["giveMoney"] then
                    giveMoneyBtn(selectedPlayer)
                end
            end,function() end)
        RageUI.IsVisible(
            RMenu:Get("vrpadmin", "functionMenu"),true,false,true,function()
                if cfg.buttonsEnabled["tp2waypoint"][1] and buttons["tp2waypoint"] then
                    tp2waypointBtn()
                end
                if cfg.buttonsEnabled["tp2coords"][1] and buttons["tp2coords"] then
                    tp2coordsBtn()
                end
                if cfg.buttonsEnabled["removewarn"][1] and buttons["removewarn"] then
                    removewarnBtn()
                end
                if cfg.buttonsEnabled["spawnBmx"][1] and buttons["spawnBmx"] then
                    spawnBmxBtn()
                end
                if cfg.buttonsEnabled["ban"][1] and buttons["ban"] then
                    offlineBanBtn()
                end
                if cfg.buttonsEnabled["ban"][1] and buttons["ban"] then
                    unbanBtn()
                end
        end,function() end)
        RageUI.IsVisible(
            RMenu:Get("vrpadmin", "developerMenu"),true,false,true,function()
                if cfg.buttonsEnabled["spawnCar"][1] and buttons["spawnCar"] then
                    spawncarBtn()
                end
                if cfg.buttonsEnabled["spawnWeapon"][1] and buttons["spawnWeapon"] then
                    spawnWeaponBtn()
                end
                if cfg.buttonsEnabled["deleteCar"][1] and buttons["deleteCar"] then
                    fixCarBtn()
                end
                if cfg.buttonsEnabled["fixCar"][1] and buttons["fixCar"] then
                    deleteCarBtn()
                end
                -- if cfg.buttonsEnabled["clientScript"][1] and buttons["clientScript"] then
                --     clientScriptBtn()
                -- end
        end,function() end)
        RageUI.IsVisible(RMenu:Get("vrpadmin", "groups"),true,false,true,function()
            if cfg.buttonsEnabled["staffGroups"][1] and buttons["staffGroups"] then
                RageUI.Button("Staff Groups", "", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if (Hovered) then
        
                    end
                    if (Active) then
        
                    end
                    if (Selected) then
                        RMenu:Get("vrpadmin", "groups"):SetTitle("")
                        RMenu:Get("vrpadmin", "groups"):SetSubtitle("Staff Groups")
                    end
                end, RMenu:Get('vrpadmin', 'staffGroups'))
            end
            if cfg.buttonsEnabled["nhsGroups"][1] and buttons["nhsGroups"] then
                RageUI.Button("NHS Groups", "", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if (Hovered) then
        
                    end
                    if (Active) then
        
                    end
                    if (Selected) then
                        
                    end
                end, RMenu:Get('vrpadmin', 'nhsGroups'))
            end
            if cfg.buttonsEnabled["mpdGroups"][1] and buttons["mpdGroups"] then
                RageUI.Button("MPD Groups", "", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if (Hovered) then
        
                    end
                    if (Active) then
        
                    end
                    if (Selected) then
                        
                    end
                end, RMenu:Get('vrpadmin', 'mpdGroups'))
            end
            if cfg.buttonsEnabled["casinoGroups"][1] and buttons["casinoGroups"] then
                RageUI.Button("Casino Groups", "", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if (Hovered) then
        
                    end
                    if (Active) then
        
                    end
                    if (Selected) then
                        
                    end
                end, RMenu:Get('vrpadmin', 'casinoGroups'))
            end
        end,function() end)
        RageUI.IsVisible(RMenu:Get("vrpadmin", "staffGroups"),true,false,true,function()
            for k,v in pairs(getStaffGroupsGroupIds) do
                if searchPlayerGroups[k] ~= nil then
                    RageUI.Button("~g~"..v, "~g~User has this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if (Hovered) then
    
                        end
                        if (Active) then
    
                        end
                        if (Selected) then
                            RMenu:Get("vrpadmin", "removegroup"):SetTitle("")
                            RMenu:Get("vrpadmin", "removegroup"):SetSubtitle("Remove Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('vrpadmin', 'removegroup'))
                else
                    RageUI.Button("~r~"..v, "~r~User does not have this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if (Hovered) then
    
                        end
                        if (Active) then
    
                        end
                        if (Selected) then
                            RMenu:Get("vrpadmin", "addgroup"):SetTitle("")
                            RMenu:Get("vrpadmin", "addgroup"):SetSubtitle("Add Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('vrpadmin', 'addgroup'))
                end
            end
        end,function() end)
        RageUI.IsVisible(RMenu:Get("vrpadmin", "nhsGroups"),true,false,true,function()
            for k,v in pairs(getNHSGroupsGroupIds) do
                if searchPlayerGroups[k] ~= nil then
                    RageUI.Button("~g~"..v, "~g~User has this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if (Hovered) then
    
                        end
                        if (Active) then
    
                        end
                        if (Selected) then
                            RMenu:Get("vrpadmin", "removegroup"):SetTitle("")
                            RMenu:Get("vrpadmin", "removegroup"):SetSubtitle("Remove Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('vrpadmin', 'removegroup'))
                else
                    RageUI.Button("~r~"..v, "~r~User does not have this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if (Hovered) then
    
                        end
                        if (Active) then
    
                        end
                        if (Selected) then
                            RMenu:Get("vrpadmin", "addgroup"):SetTitle("")
                            RMenu:Get("vrpadmin", "addgroup"):SetSubtitle("Add Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('vrpadmin', 'addgroup'))
                end
            end
        end,function() end)
        RageUI.IsVisible(RMenu:Get("vrpadmin", "mpdGroups"),true,false,true,function()
            for k,v in pairs(getPoliceGroupsGroupIds) do
                if searchPlayerGroups[k] ~= nil then
                    RageUI.Button("~g~"..v, "~g~User has this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if (Hovered) then
    
                        end
                        if (Active) then
    
                        end
                        if (Selected) then
                            RMenu:Get("vrpadmin", "removegroup"):SetTitle("")
                            RMenu:Get("vrpadmin", "removegroup"):SetSubtitle("Remove Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('vrpadmin', 'removegroup'))
                else
                    RageUI.Button("~r~"..v, "~r~User does not have this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if (Hovered) then
    
                        end
                        if (Active) then
    
                        end
                        if (Selected) then
                            RMenu:Get("vrpadmin", "addgroup"):SetTitle("")
                            RMenu:Get("vrpadmin", "addgroup"):SetSubtitle("Add Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('vrpadmin', 'addgroup'))
                end
            end
        end,function() end)
        RageUI.IsVisible(RMenu:Get("vrpadmin", "casinoGroups"),true,false,true,function()
            for k,v in pairs(getCasinoGroupsGroupIds) do
                if searchPlayerGroups[k] ~= nil then
                    RageUI.Button("~g~"..v, "~g~User has this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if (Hovered) then
    
                        end
                        if (Active) then
    
                        end
                        if (Selected) then
                            RMenu:Get("vrpadmin", "removegroup"):SetTitle("")
                            RMenu:Get("vrpadmin", "removegroup"):SetSubtitle("Remove Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('vrpadmin', 'removegroup'))
                else
                    RageUI.Button("~r~"..v, "~r~User does not have this group.", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                        if (Hovered) then
    
                        end
                        if (Active) then
    
                        end
                        if (Selected) then
                            RMenu:Get("vrpadmin", "addgroup"):SetTitle("")
                            RMenu:Get("vrpadmin", "addgroup"):SetSubtitle("Add Group")
                            selectedGroup = k
                        end
                    end, RMenu:Get('vrpadmin', 'addgroup'))
                end
            end
        end,function() end)
        RageUI.IsVisible(RMenu:Get('vrpadmin', 'addgroup'),true,false,true, function()
            RageUI.Button("Add this group to user", "", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                if (Hovered) then
    
                end
                if (Active) then
    
                end
                if (Selected) then
                    TriggerServerEvent("FRG:addGroup",selectedPlayer[3],selectedGroup)
                end
            end, RMenu:Get('vrpadmin', 'groups'))
        end,function() end)
        
        RageUI.IsVisible(RMenu:Get('vrpadmin', 'removegroup'),true,false,true, function()
            RageUI.Button("Remove user from group", "", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                if (Hovered) then
    
                end
                if (Active) then
    
                end
                if (Selected) then
                    TriggerServerEvent("FRG:removeGroup",selectedPlayer[3],selectedGroup)
                end
            end, RMenu:Get('vrpadmin', 'groups'))
        end,function() end)
    end
)



RegisterNetEvent("vrp_admin:SendPlayersInfo")
AddEventHandler("vrp_admin:SendPlayersInfo",function(players_table, btns)
    players = players_table
    buttons = btns
    RageUI.Visible(RMenu:Get("vrpadmin", "main"), not RageUI.Visible(RMenu:Get("vrpadmin", "main")))
end)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(0)
            if IsControlJustPressed(1, 289) then
                TriggerServerEvent("vrp_admin:GetPlayerInformation")
            end
        end
    end
)

--[[ Frozen Function ]]
local isFrozen = false

RegisterNetEvent("vrp_admin:FREEZE")
AddEventHandler("vrp_admin:FREEZE",function()
    FreezeEntityPosition(PlayerPedId(-1), true)
end)

RegisterNetEvent("vrp_admin:UNFREEZE")
AddEventHandler("vrp_admin:UNFREEZE",function()
    FreezeEntityPosition(PlayerPedId(-1), false)
end)





---[[Get Message Functions]]

function getKickUserMsg(id)
    AddTextEntry("FMMC_MPM_NA", "Enter Kick Message")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Kick Message:", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0)
        Wait(0)
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        if result then
            TriggerServerEvent("vrp_admin:KickPlayer", id, result)
        end
    end
    return false
end

function getKickUserMsgnof10(id)
    AddTextEntry("FMMC_MPM_NA", "Enter Kick Message")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Kick Message:", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0)
        Wait(0)
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        if result then
            TriggerServerEvent("vrp_admin:KickPlayernof10", id, result)
        end
    end
    return false
end

function getBanReasonMsg()
	AddTextEntry('FMMC_MPM_NA', "Enter Ban Message ")
	DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter Ban Message", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
		if result then
			return result
		end
    end
	return false
end


function getBanTimeMsg()
	AddTextEntry('FMMC_MPM_NA', "Enter Ban Time (hours)")
	DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter Ban Time", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
		if result then
			return result
		end
    end
	return false
end

function getPermId()
	AddTextEntry('FMMC_MPM_NA', "Enter Perm ID")
	DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter Perm ID", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
		if result then
			return result
		end
    end
	return false
end


--[[ Get Warning Message ]]
function getWarningUserMsg()
	AddTextEntry('FMMC_MPM_NA', "Enter warning message")
	DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter warning message", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
		if result then
			return result
		end
    end
	return false
end

--[[ Slap Function ]]
RegisterNetEvent("FRG:SLAPLAYER")
AddEventHandler(
    "FRG:SLAPLAYER",
    function()
        SetEntityHealth(PlayerPedId(-1), 0)
    end
)

function FreezePlayer()
    FreezeEntityPosition(PlayerPedId(-1), not isFrozen)
end

--[[ Give Money ]]
function getAmountMsg()
	AddTextEntry('FMMC_MPM_NA', "Enter Amount To Give")
	DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter Amount To Give", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
		if result then
			return result
		end
    end
	return false
end

--[[ Spawn Car ]]
function getCarMsg()
	AddTextEntry('FMMC_MPM_NA', "Enter Spawn Code")
	DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter Spawn Code", "", "", "", "", 100)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
		if result then
			return result
		end
    end
	return false
end


---[[ Buttons ]]

--[[ Show Warnings ]]
showwarning = false
function showwarnBtn(player)
    RageUI.Button("Show F10","Shows users warnings",{}, true, function(Hovered, Active, Selected)
        if Selected then
            if showwarning == true then
                showwarning = false
                TriggerServerEvent("vrp_admin:stopwarn", player[3])
            else
                showwarning = true
                TriggerServerEvent("vrp_admin:showwarn", player[3])
            end
        end
    end)
end

--[[ Warn Player ]]
function warnPlayerBtn(player)
    RageUI.Button("Warn Player","Gives user a warning",{}, true, function(Hovered, Active, Selected)
        if Selected then
            userWarningMessage = getWarningUserMsg()
            TriggerServerEvent("FRG:warnPlayer",player[3],GetPlayerName(PlayerId()),userWarningMessage)
        end
    end)
end

--[[ Kick Player ]]
function kickPlayerBtn(player)
    RageUI.Button("Kick Player","Kick Player From The Server",{}, true, function(Hovered, Active, Selected)
        if Selected then
            getKickUserMsg(player[2])
        end
    end)
end

--[[ No F10 Kick ]]
function nof10kickPlayerBtn(player)
    RageUI.Button("No F10 Kick","Kicks user without giving an F10",{}, true, function(Hovered, Active, Selected)
        if Selected then
            getKickUserMsgnof10(player[2])
        end
    end)
end

--[[ Ban Player ]]
function banPlayerBtn(player)
    RageUI.Button("Ban Player","Bans The Player From The Server",{}, true, function(Hovered, Active, Selected)
        if Selected then
            local bannedReason = getBanReasonMsg()
            local bannedTime = getBanTimeMsg()
            TriggerServerEvent("FRG:SETBAN", player[2], bannedReason, bannedTime)
        end
    end)
end

--[[ Offline Ban Player ]]
function offlineBanBtn()
    RageUI.Button("Offline Ban","Bans The Player From The Server",{}, true, function(Hovered, Active, Selected)
        if Selected then
            local permid = getPermId()
            local bannedReason = getBanReasonMsg()
            local bannedTime = getBanTimeMsg()
            TriggerServerEvent("FRG:SETOFFLINEBAN", permid, bannedReason, bannedTime)
        end
    end)
end

--[[ Unban Ban Player ]]
function unbanBtn()
    RageUI.Button("Unban Player","Unbans the Player",{}, true, function(Hovered, Active, Selected)
        if Selected then
            local permid = getPermId()
            TriggerServerEvent("FRG:SETUNBAN", permid)
        end
    end)
end

--[[ Teleport to Waypoint ]]
function tp2waypointBtn()
    RageUI.Button("Teleport to Waypoint","Teleport to you waypoint",{}, true, function(Hovered, Active, Selected)
        if Selected then
            TriggerServerEvent("vrp_admin:TPWAYPOINT")
        end
    end)
end

--[[ Teleport to Coords ]]
function tp2coordsBtn()
    RageUI.Button("Teleport to Coords","Teleport to your coords",{}, true, function(Hovered, Active, Selected)
        if Selected then
            TriggerServerEvent("FRG:TPCOORDS")
        end
    end)
end

--[[ Teleport to Player ]]
function tp2PlayerBtn(player)
    RageUI.Button("Teleport to Player","Teleport to the Player",{}, true, function(Hovered, Active, Selected)
        if Selected then
            TriggerServerEvent("vrp_admin:TP2PLAYER", player[2])
        end
    end)
end

--[[ Summon Player ]]
function tp2meBtn(player)
    RageUI.Button("Summon Player","Teleports Player To You",{}, true, function(Hovered, Active, Selected)
        if Selected then
            TriggerServerEvent("vrp_admin:TP2ME", player[2], GetEntityCoords(PlayerPedId(-1)))
        end
    end)
end

--[[ Freeze Player ]]
function freezePlayerBtn(player)
    RageUI.Button("Freeze Player","Stops a player from moving",{}, true, function(Hovered, Active, Selected)
        if Selected then
            if (isFrozen == false) then
                isFrozen = true
                TriggerServerEvent("vrp_admin:FREEZEPLAYER", player[2], player[3])
            else
                isFrozen = false
                TriggerServerEvent("vrp_admin:UNFREEZEPLAYER", player[2], player[3])
            end
        end
    end)
end

--[[ Revive Player ]]
function revPlayerBtn(player)
    RageUI.Button("Revive","Revive Player",{}, true, function(Hovered, Active, Selected)
        if Selected then
            TriggerServerEvent("vrp_admin:REVIVE", player[2], player[3])
        end
    end)
end

--[[ Remove Warning ]]
function removewarnBtn(player)
    RageUI.Button("Remove Warning","Removes warning from player",{}, true, function(Hovered, Active, Selected)
        if Selected then
            TriggerServerEvent("vrp_admin:FREEZEPLAYER", player[2])
        end
    end)
end

--[[ Screenshot ]]
function screenshot(player)
    RageUI.Button("Take Screenshot","Screenshots the player",{}, true, function(Hovered, Active, Selected)
        if Selected then
            TriggerServerEvent("SH:TakeScreenshot",player[2])
        end
    end)
end

--[[ Slap ]]
function slapBtn(player)
    RageUI.Button("Slap","Slaps the Player",{}, true, function(Hovered, Active, Selected)
        if Selected then
            TriggerServerEvent("FRG:SLAP", player[2])
        end
    end)
end

--[[ Give Money ]]
function giveMoneyBtn(player)
    RageUI.Button("Give Money","Adds Money To Player Bank!",{}, true, function(Hovered, Active, Selected)
        if Selected then
            amountMessage = getAmountMsg()
            TriggerServerEvent("PHRP:GIVEMONEY", player[2], amountMessage)
        end
    end)
end

--[[ Fix Vehicle ]]
function fixCarBtn()
    RageUI.Button("Fix Vehicle","Fixes Current Vehicle",{}, true, function(Hovered, Active, Selected)
        if Selected then
            SetVehicleEngineHealth(GetVehiclePedIsIn(PlayerPedId(), 1000))
            SetVehicleBodyHealth(GetVehiclePedIsIn(PlayerPedId(), 1000))
            SetVehicleFixed(GetVehiclePedIsIn(PlayerPedId()))
        end
    end)
end

--[[ Delete Vehicle ]]
function deleteCarBtn()
    RageUI.Button("Delete Vehicle","Deletes Current Vehicle",{}, true, function(Hovered, Active, Selected)
        if Selected then
            SetEntityAsMissionEntity(GetVehiclePedIsIn(PlayerPedId(), true, true))
            DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
        end
    end)
end

--[[ Spawncar ]]
function spawncarBtn(player)
    RageUI.Button("Spawn Vehicle","Spawns a Vehicle",{}, true, function(Hovered, Active, Selected)
        if Selected then
            spawn = getCarMsg()
	    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(GetVehiclePedIsUsing(GetPlayerPed(-1))))
	    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5))
	    vehiclehash = GetHashKey(spawn)
	    RequestModel(vehiclehash)
	    Citizen.CreateThread(function() 
	      local waiting = 0
	      while not HasModelLoaded(vehiclehash) do
		  waiting = waiting + 100
		  Citizen.Wait(100)
		  if waiting > 5000 then
		      sendMsg("~r~Failed to load vehicle model.")
		      break
		  end
	      end
	      local nveh = CreateVehicle(vehiclehash, GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), true, false)
	      SetVehicleOnGroundProperly(nveh)
	      SetVehicleNumberPlateText(nveh, "FRG")
	      DecorSetInt(vehicle,"GamemodeCar",955)
	      SetPedIntoVehicle(GetPlayerPed(-1),nveh,-1)
	      SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)), 0)
	      WashDecalsFromVehicle(GetVehiclePedIsUsing(GetPlayerPed(-1)))
	      SetVehicleWindowTint(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1)
              SetVehicleModKit(GetVehiclePedIsUsing(GetPlayerPed(-1)), 0)
               for modType = 0, 10, 1 do 
                   local bestMod = GetNumVehicleMods(GetVehiclePedIsUsing(GetPlayerPed(-1)), modType)-1
                   SetVehicleMod(GetVehiclePedIsUsing(GetPlayerPed(-1)), modType, bestMod, false)
               end
	       ToggleVehicleMod(GetVehiclePedIsUsing(GetPlayerPed(-1)), 18, true)
               local performanceModIndices = {11,12,13,16}
               for _, modType in ipairs(performanceModIndices) do
                   max = GetNumVehicleMods(GetVehiclePedIsUsing(GetPlayerPed(-1)), modType) - 1
                   SetVehicleMod(GetVehiclePedIsUsing(GetPlayerPed(-1)), modType, max, false)
               end
	      sendMsg("~g~Spawned vehicle: "..spawn)
	    end)	
        end
    end)
end

--[[ Spawncar ]]
function spawnBmxBtn()
    RageUI.Button("Spawn BMX","Spawns a BMX",{}, true, function(Hovered, Active, Selected)
        if Selected then
            carCode = bmx
            local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5))  
            local veh = carCode
            if veh == nil then veh = "bmx" end
            vehiclehash = GetHashKey(veh)
            RequestModel(vehiclehash)
            
            Citizen.CreateThread(function() 
                local waiting = 0
                while not HasModelLoaded(vehiclehash) do
                    waiting = waiting + 100
                    Citizen.Wait(100)
                    if waiting > 5000 then
                        ShowNotification("~r~Could not load the vehicle model in time, a crash was prevented.")
                        break
                    end
                end
                local bmx = CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(PlayerPedId())+90, 1, 0)
                DecorSetInt(vehicle,"GamemodeCar",955)
            end)
        end
    end)
end


--[[ Spawn Weapon ]]
function spawnWeaponBtn()
    RageUI.Button("Spawn Weapon","Spawn a Weapon",{}, true, function(Hovered, Active, Selected)
        if Selected then
            scriptMessage = getCarMsg()
            GiveWeaponToPed(PlayerPedId(), GetHashKey(scriptMessage), 1000, false, false,0)
        end
    end)
end




local function teleportToWaypoint()
	local targetPed = GetPlayerPed(-1)
	local targetVeh = GetVehiclePedIsUsing(targetPed)
	if(IsPedInAnyVehicle(targetPed))then
		targetPed = targetVeh
    end

	if(not IsWaypointActive())then
		return
	end

	local waypointBlip = GetFirstBlipInfoId(8) -- 8 = waypoint Id
	local x,y,z = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypointBlip, Citizen.ResultAsVector())) 

	-- ensure entity teleports above the ground
	local ground
	local groundFound = false
	local groundCheckHeights = {100.0, 150.0, 50.0, 0.0, 200.0, 250.0, 300.0, 350.0, 400.0,450.0, 500.0, 550.0, 600.0, 650.0, 700.0, 750.0, 800.0}

	for i,height in ipairs(groundCheckHeights) do
		SetEntityCoordsNoOffset(targetPed, x,y,height, 0, 0, 1)
		Wait(10)

		ground,z = GetGroundZFor_3dCoord(x,y,height)
		if(ground) then
			z = z + 3
			groundFound = true
			break;
		end
	end

	if(not groundFound)then
		z = 1000
		GiveDelayedWeaponToPed(PlayerPedId(), 0xFBAB5776, 1, 0) -- parachute
	end

	SetEntityCoordsNoOffset(targetPed, x,y,z, 0, 0, 1)
end
RegisterNetEvent("FRG:TpToWaypoint")
AddEventHandler("FRG:TpToWaypoint", teleportToWaypoint)

RegisterNetEvent("FRG:gotgroups")
AddEventHandler("FRG:gotgroups",function(gotGroups)
    searchPlayerGroups = gotGroups
end)

function getSearchField(field)
	AddTextEntry('FMMC_MPM_NA', "Search by " .. field)
	DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Search by " .. field, "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
		if result then
			return result
        else
            return ""
        end
    end
	return ""
end

--[[ Test ]]
function testBtn()
    RageUI.Button("Test","Test",{}, true, function(Hovered, Active, Selected)
        if Selected then
            local upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            local lowerCase = "abcdefghijklmnopqrstuvwxyz"
            local numbers = "0123456789"
            local characterSet = upperCase .. lowerCase .. numbers
            local keyLength = 5
            local output = ""
            for i = 1, keyLength do
                local rand = math.random(#characterSet)
                output = output .. string.sub(characterSet, rand, rand)
            end
        end
    end)
end

--[[ Spectate ]]
inSpectatorAdminMode = false
function spectatePlayerBtn(player)
    RageUI.Button("Spectate Player", "Make sure they aint doing bad stuff" ,{}, true, function(Hovered, Active, Selected)
        if Selected then
            TriggerServerEvent("FRG:spectatePlayer",player[2])
            inSpectatorAdminMode = true
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        if inSpectatorAdminMode then
            DrawAdvancedText1(0.605, 0.803, 0.005, 0.0028, 0.7, "You are in spectate mode", 255, 0, 0, 255, 6, 0)
            DrawAdvancedText1(0.605, 0.850, 0.005, 0.0028, 0.7, "Press [E] to stop spectating", 255, 0, 0, 255, 6, 0)
            if IsControlJustPressed(0, 51) then 
                inSpectatorAdminMode = false
                spectatePlayer(GetPlayerPed(-1))
                spectatedUserServerID = nil 
                spectatedUserClientID = nil 
                isSpectating = false 
                SetEntityCoords(GetPlayerPed(-1), savedCoords.x, savedCoords.y, savedCoords.z)
            end
        end
		Wait(0)
    end
end)


RegisterNetEvent("FRG:getSpectate")
AddEventHandler('FRG:getSpectate', function(playerServerId, tgtCoords)
    FreezeEntityPosition(GetPlayerPed(-1),  true)
    RequestCollisionAtCoord(GetEntityCoords(GetPlayerPed(playerServerId), 1))
    NetworkSetInSpectatorMode(1, GetPlayerPed(playerServerId))
end)




function DrawAdvancedText1(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end




















































































-------------------
--- BadgerTools ---
------------------- 

--- CODE ---

-- START BadgerTools

-- END BadgerTools

function spectatePlayer(targetPed)
	local playerPed = PlayerPedId() -- yourself
	enable = true
	
	if targetPed == playerPed then enable = false end

    if(enable)then
		--local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
		NetworkSetInSpectatorMode(true, targetPed)	
		SetEntityInvincible(GetPlayerPed(-1), true, 0) 
		SetEntityVisible(GetPlayerPed(-1), false, 0)
		SetEveryoneIgnorePlayer(GetPlayerPed(-1), true)
		SetEntityCollision(GetPlayerPed(-1), false, false)
    else
		--local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
		NetworkSetInSpectatorMode(false, targetPed)
		SetEntityInvincible(GetPlayerPed(-1), false, 0)
		SetEntityVisible(GetPlayerPed(-1), true, 0)
		SetEveryoneIgnorePlayer(GetPlayerPed(-1), false)
		SetEntityCollision(GetPlayerPed(-1), true, true)
	end
end
isSpectating = false;

-- 

-- Spectate Cycle Controls --
Citizen.CreateThread(function() 
	while true do 
		Citizen.Wait(0)
		-- Runs every millisecond
		-- LEFT ARROW = 174 RIGHT ARROW = 175
		if isSpectating then 
			-- They are spectating, check their controls and teleport them above the player 
			local playerIndex = getPlayerIndex(spectatedUserClientID)
			if playerIndex == nil then 
				-- Set them to another player to spectate 
				if GetPlayersCountButSkipMe() >= 1 then 
					local players = GetPlayersButSkipMyself()
					local player = GetPlayerPed(players[1]) 
					spectatedUserClientID = players[1]
					spectatedUserServerID = GetPlayerServerId(spectatedUserClientID)
					spectatePlayer(GetPlayerPed(spectatedUserClientID))
					ShowNotification('~b~Spectating ~f~' .. GetPlayerName(spectatedUserClientID))
				else
					-- Not enough players, spectate themselves 
					ShowNotification("~r~Error: Not enough players to spectate")
					spectatePlayer(GetPlayerPed(-1))
					sendMsg('^1Error: Not enough players to spectate')
					spectatedUserServerID = nil 
					spectatedUserClientID = nil 
					isSpectating = false 
				end
			end
			local player = GetPlayerPed(-1)
			local spectatedCoords = GetEntityCoords(GetPlayerPed(spectatedUserClientID))
			-- Teleport them above the player 
			SetEntityCoords(player, spectatedCoords.x, spectatedCoords.y + 10, spectatedCoords.z)
			local players = GetPlayersButSkipMyself()
			if IsControlJustReleased(0, 174) then 
				-- Go backwards, spectatedUserClientID - 1
				local index = getPlayerIndex(spectatedUserClientID, PlayerId());

				index = index - 1;
				if players[index] == nil then 
					-- Can't go backwards anymore 
					index = #players 
				end
				local newSpectate = players[index]
				spectatedUserClientID = tonumber(newSpectate) 
				spectatedUserServerID = GetPlayerServerId(newSpectate)
				spectatePlayer(GetPlayerPed(spectatedUserClientID))
				ShowNotification('~b~Spectating ~f~' .. GetPlayerName(spectatedUserClientID))
				sendMsg('^5Spectating ^0' .. GetPlayerName(spectatedUserClientID))
			elseif IsControlJustReleased(0, 175) then 
				-- Go forwards, spectatedUserClientID + 1
				local index = getPlayerIndex(spectatedUserClientID, PlayerId());
				index = index + 1
				if players[index] == nil then 
					-- Can't go forward anymore 
					index = 1 
				end
				local newSpectate = players[index]
				spectatedUserClientID = tonumber(newSpectate) 
				spectatedUserServerID = GetPlayerServerId(newSpectate)
				spectatePlayer(GetPlayerPed(spectatedUserClientID))
				ShowNotification('~b~Spectating ~f~' .. GetPlayerName(spectatedUserClientID))
				sendMsg('^5Spectating ^0' .. GetPlayerName(spectatedUserClientID))
			end
		end
	end
end)


spectatedUserServerID = nil 
spectatedUserClientID = nil 

function DrawText2WithSize(text, size, x, y)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextScale(0.0, size)
		SetTextJustification(1) -- Center Text
		SetTextCentre(true)
        SetTextDropshadow(1, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(x, y)
end

function DrawText2(text, x, y)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextScale(0.0, 0.45)
		SetTextJustification(1) -- Center Text
		SetTextCentre(true)
        SetTextDropshadow(1, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(x, y)
end

RegisterNetEvent('BT:Client:SpectateID')
AddEventHandler('BT:Client:SpectateID', function(id)
	-- Spectate the specified ID 
	if not isSpectating then 
		-- They were not spectating, give them cycle spectate, but start from specified ID 
		spectatedUserServerID = tonumber(id)
		local players = GetPlayersButSkipMyself()
		local found = false 
		for i = 1, #players do 
			local playerID = players[i] -- Their client side ID 
			if spectatedUserServerID == GetPlayerServerId(playerID) then 
				spectatedUserClientID = playerID
				found = true 
			end
		end
		if found then 
			-- SAVE THEIR LOCATION:
            savedCoords = GetEntityCoords(PlayerPedId())
			TriggerServerEvent('BadgerTools:Server:UserTag', false) -- Hide UserTag
			spectatePlayer(GetPlayerPed(spectatedUserClientID))
			ShowNotification('~b~Spectating ~f~' .. GetPlayerName(spectatedUserClientID))
			isSpectating = true 
		end
	else
		-- They were spectating, just change the person they are spectating 
		local serverID = tonumber(id)
		local players = GetPlayersButSkipMyself()
		local found = false 
		for i = 1, #players do 
			local playerID = players[i] -- Their client side ID 
			if serverID == GetPlayerServerId(playerID) then 
				spectatedUserClientID = playerID
				spectatedUserServerID = serverID
				found = true 
			end
		end
		if found then 
			TriggerServerEvent('BadgerTools:Server:UserTag', false) -- Hide UserTag
			spectatePlayer(GetPlayerPed(spectatedUserClientID))
			ShowNotification('~b~Spectating ~f~' .. GetPlayerName(spectatedUserClientID))
			isSpectating = true 
		end
	end 
end)

RegisterNetEvent('BT:Client:Spectate')
AddEventHandler('BT:Client:Spectate', function()
	-- Regular cycling spectate 
	if not isSpectating then 
		-- They are not spectating, spectate cycle start:
		if GetPlayersCountButSkipMe() >= 1 then 
			local players = GetPlayersButSkipMyself()
			spectatedUserClientID = players[1]
			spectatedUserServerID = GetPlayerServerId(spectatedUserClientID)
			isSpectating = true 
			-- SAVE THEIR LOCATION:
			savedCoords = GetEntityCoords(PlayerPedId()) 
			TriggerServerEvent('BadgerTools:Server:UserTag', false) -- Hide UserTag
			spectatePlayer(GetPlayerPed(spectatedUserClientID))
			ShowNotification('~b~Spectating ~f~' .. GetPlayerName(spectatedUserClientID))
			sendMsg('^5Spectating ^0' .. GetPlayerName(spectatedUserClientID))
		else
			sendMsg('^1ERROR: Not enough players on to spectate') 
		end 
	else 
		-- They were spectating, stop their spectate 
		ShowNotification("~g~Success: No longer spectating anyone!")
		spectatePlayer(GetPlayerPed(-1))
		sendMsg('^2Success: No longer spectating anyone!')
		spectatedUserServerID = nil 
		spectatedUserClientID = nil 
		isSpectating = false 
		SetEntityCoords(GetPlayerPed(-1), savedCoords.x, savedCoords.y, savedCoords.z) -- Teleport them
		TriggerServerEvent('BadgerTools:Server:UserTag', true) -- Show UserTag
	end
end)

function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end
function get_index (tab, val)
	local counter = 1
    for index, value in ipairs(tab) do
        if value == val then
            return counter
        end
		counter = counter + 1
    end

    return nil
end

function getPlayerIndex(id, skipMe) 
	local counter = 0;
	for _, i in ipairs(GetActivePlayers()) do
        if NetworkIsPlayerActive(i) then
        	if i ~= skipMe then 
        		counter = counter + 1;
			end
			if i == id then
				return counter;
			end
		end
    end
    return nil;
end
function GetPlayers()
    local players = {}

    for _, i in ipairs(GetActivePlayers()) do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end
function GetPlayersButSkipMyself()
    local players = {}
    local ind = 1;
    for _, i in ipairs(GetActivePlayers()) do
        if NetworkIsPlayerActive(i) then
			if i ~= PlayerId() then
				players[ind] = i;
				ind = ind + 1;
			end
		end
    end

    return players
end
function GetPlayersCountButSkipMe()
    local count = 0
    for _, i in ipairs(GetActivePlayers()) do
        if NetworkIsPlayerActive(i) then
			if GetPlayerPed(i) ~= GetPlayerPed(-1) then
				count = count + 1
			end
		end
    end
    return count
end
function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(0,1)
end



RegisterNetEvent("SH:CaptureScreenshot")
AddEventHandler('SH:CaptureScreenshot', function(toggle, url, field)
    print("hi")
    exports['screenshot-basic']:requestScreenshotUpload("https://discord.com/api/webhooks/807846172496101427/QQoFEeS82FIQAyhwF44AJCEPtCiITq6Xc-LubsnHbAsVMwQ-xTJ_ylwWqKZdpUvF_NFl", 'files[]', function(data)

    print("doneeeeee")
		TriggerServerEvent("SH:TookScreenshot", data)
	end)
end)
