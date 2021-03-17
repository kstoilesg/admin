--[[
    FiveM Scripts
    Copyright C 2018  Sighmir

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    at your option any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local htmlEntities = module("vrp", "lib/htmlEntities")

vRPbm = {}
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_basic_menu")
BMclient = Tunnel.getInterface("vRP_basic_menu","vRP_basic_menu")
vRPbsC = Tunnel.getInterface("vRP_barbershop","vRP_basic_menu")
Tunnel.bindInterface("vrp_basic_menu",vRPbm)

local Lang = module("vrp", "lib/Lang")
local cfg = module("vrp", "cfg/base")
local lang = Lang.new(module("vrp", "cfg/lang/"..cfg.lang) or {})

-- LOG FUNCTION
function vRPbm.logInfoToFile(file,info)
  file = io.open(file, "a")
  if file then
    file:write(os.date("%c").." => "..info.."\n")
  end
  file:close()
end
-- MAKE CHOICES
--toggle service
--[[local choice_service = {function(player,choice)
  local user_id = vRP.getUserId({player})
  local service = "onservice"
  if user_id ~= nil then
    if vRP.hasGroup({user_id,service}) then
	  vRP.removeUserGroup({user_id,service})
	  if vRP.hasMission({player}) then
		vRP.stopMission({player})
	  end
      vRPclient.notify(player,{"~r~Off service"})
	else
	  vRP.addUserGroup({user_id,service})
      vRPclient.notify(player,{"~g~On service"})
	end
  end
end, "Go on/off service"}]]--

-- teleport waypoint
local choice_tptowaypoint = {function(player,choice)
  TriggerClientEvent("TpToWaypoint", player)
end, "Teleport to map blip."}

-- fix barbershop green hair for now
local ch_fixhair = {function(player,choice)
    local custom = {}
    local user_id = vRP.getUserId({player})
    vRP.getUData({user_id,"vRP:head:overlay",function(value)
	  if value ~= nil then
	    custom = json.decode(value)
        vRPbsC.setOverlay(player,{custom,true})
	  end
	end})
end, "Fix the barbershop bug for now."}

--toggle blips
local ch_blips = {function(player,choice)
  TriggerClientEvent("showBlips", player)
end, "Toggle blips."}

local spikes = {}
local ch_spikes = {function(player,choice)
	local user_id = vRP.getUserId({player})
	BMclient.isCloseToSpikes(player,{},function(closeby)
		if closeby and (spikes[player] or vRP.hasPermission({user_id,"admin.spikes"})) then
		  BMclient.removeSpikes(player,{})
		  spikes[player] = false
		elseif closeby and not spikes[player] and not vRP.hasPermission({user_id,"admin.spikes"}) then
		  vRPclient.notify(player,{"~r~You can carry only one set of spikes!"})
		elseif not closeby and spikes[player] and not vRP.hasPermission({user_id,"admin.spikes"}) then
		  vRPclient.notify(player,{"~r~You can deploy only one set of spikes!"})
		elseif not closeby and (not spikes[player] or vRP.hasPermission({user_id,"admin.spikes"})) then
		  BMclient.setSpikesOnGround(player,{})
		  spikes[player] = true
		end
	end)
end, "Toggle spikes."}

local ch_sprites = {function(player,choice)
  TriggerClientEvent("showSprites", player)
end, "Toggle sprites."}

local ch_deleteveh = {function(player,choice)
  BMclient.deleteVehicleInFrontOrInside(player,{5.0})
end, "Delete nearest car."}

--client function
local ch_crun = {function(player,choice)
  vRP.prompt({player,"Function:","",function(player,stringToRun) 
    stringToRun = stringToRun or ""
	TriggerClientEvent("RunCode:RunStringLocally", player, stringToRun)
  end})
end, "Run client function."}

--server function
local ch_srun = {function(player,choice)
  vRP.prompt({player,"Function:","",function(player,stringToRun) 
    stringToRun = stringToRun or ""
	TriggerEvent("RunCode:RunStringRemotelly", stringToRun)
  end})
end, "Run server function."}

--police weapons // comment out the weapons if you dont want to give weapons.
local police_weapons = {}
police_weapons["Equip"] = {function(player,choice)
    vRPclient.giveWeapons(player,{{
	  ["WEAPON_COMBATPISTOL"] = {ammo=200},
	  ["WEAPON_PUMPSHOTGUN"] = {ammo=200},
	  ["WEAPON_NIGHTSTICK"] = {ammo=200},
	  ["WEAPON_STUNGUN"] = {ammo=200}
	}, true})
	BMclient.setArmour(player,{100,true})
end}

--store money
local choice_store_money = {function(player, choice)
  local user_id = vRP.getUserId({player})
  if user_id ~= nil then
    local amount = vRP.getMoney({user_id})
    if vRP.tryPayment({user_id, amount}) then -- unpack the money
      vRP.giveInventoryItem({user_id, "money", amount, true})
    end
  end
end, "Store your money in your inventory."}

--medkit storage
local emergency_medkit = {}
emergency_medkit["Take"] = {function(player,choice)
	local user_id = vRP.getUserId({player}) 
	vRP.giveInventoryItem({user_id,"medkit",25,true})
	vRP.giveInventoryItem({user_id,"pills",25,true})
end}

--heal me
local emergency_heal = {}
emergency_heal["Heal"] = {function(player,choice)
	local user_id = vRP.getUserId({player}) 
	vRPclient.setHealth(player,{1000})
end}

--loot corpse
local choice_loot = {function(player,choice)
  local user_id = vRP.getUserId({player})
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
      local nuser_id = vRP.getUserId({nplayer})
      if nuser_id ~= nil then
        vRPclient.isInComa(nplayer,{}, function(in_coma)
          if in_coma then
            
  if vRP.hasPermission({user_id,"police.easy_fine"}) then
    return   vRPclient.notify(player,{"~r~You can't loot as a cop!"})
  end 
  if vRP.hasPermission({nuser_id,"police.easy_fine"}) then
    return   vRPclient.notify(player,{"~r~You cannot loot cops!"})
  end 
			local revive_seq = {
			  {"amb@medic@standing@kneel@enter","enter",1},
			  {"amb@medic@standing@kneel@idle_a","idle_a",1},
			  {"amb@medic@standing@kneel@exit","exit",1}
			}
  			vRPclient.playAnim(player,{false,revive_seq,false}) -- anim
            SetTimeout(1, function()
              local ndata = vRP.getUserDataTable({nuser_id})
              if ndata ~= nil then
			    if ndata.inventory ~= nil then -- gives inventory items
          -- vRP.clearInventory({nuser_id})
          
                  for k,v in pairs(ndata.inventory) do 
                    local weight = vRP.getInventoryWeight({user_id})
                    local itemweight = vRP.getItemWeight({k})*tonumber(v.amount)
                    local new_weight = tonumber(weight)+ itemweight
                    local maxweight = vRP.getInventoryMaxWeight({user_id})
                    print(weight,new_weight,maxweight,itemweight) 
                    if new_weight > maxweight then
                      vRPclient.notify(player,{"Darn your inventory is too full."})
                    else 
                      if vRP.tryGetInventoryItem({nuser_id, k, v.amount, true}) then 
                      vRP.giveInventoryItem({user_id,k,v.amount,true})
                      end 
                    end 
	              end
				end
			  end
			  local nmoney = vRP.getMoney({nuser_id})
			  if vRP.tryPayment({nuser_id,nmoney}) then
			    vRP.giveMoney({user_id,nmoney})
			  end
            end)
			vRPclient.stopAnim(player,{false})
          else
            vRPclient.notify(player,{lang.emergency.menu.revive.not_in_coma()})
          end
        end)
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end,"Loot nearby corpse"}

-- hack player
local ch_hack = {function(player,choice)
  -- get nearest player
  local user_id = vRP.getUserId({player})
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player,{25},function(nplayer)
      if nplayer ~= nil then
        local nuser_id = vRP.getUserId({nplayer})
        if nuser_id ~= nil then
          -- prompt number
		  local nbank = vRP.getBankMoney({nuser_id})
          local amount = math.floor(nbank*0.01)
		  local nvalue = nbank - amount
		  if math.random(1,100) == 1 then
			vRP.setBankMoney({nuser_id,nvalue})
            vRPclient.notify(nplayer,{"Hacked ~r~".. amount .."$."})
		    vRP.giveInventoryItem({user_id,"dirty_money",amount,true})
		  else
            vRPclient.notify(nplayer,{"~g~Hacking attempt failed."})
            vRPclient.notify(player,{"~r~Hacking attempt failed."})
		  end
        else
          vRPclient.notify(player,{lang.common.no_player_near()})
        end
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end,"Hack closest player."}

-- mug player
local ch_mug = {function(player,choice)
  -- get nearest player
  local user_id = vRP.getUserId({player})
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
      if nplayer ~= nil then
        local nuser_id = vRP.getUserId({nplayer})
        if nuser_id ~= nil then
          -- prompt number
		  local nmoney = vRP.getMoney({nuser_id})
          local amount = nmoney
		  if math.random(1,3) == 1 then
            if vRP.tryPayment({nuser_id,amount}) then
              vRPclient.notify(nplayer,{"Mugged ~r~"..amount.."$."})
		      vRP.giveInventoryItem({user_id,"dirty_money",amount,true})
            else
              vRPclient.notify(player,{lang.money.not_enough()})
            end
		  else
            vRPclient.notify(nplayer,{"~g~Mugging attempt failed."})
            vRPclient.notify(player,{"~r~Mugging attempt failed."})
		  end
        else
          vRPclient.notify(player,{lang.common.no_player_near()})
        end
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, "Mug closest player."}

-- drag player
local ch_drag = {function(player,choice)
  -- get nearest player
  local user_id = vRP.getUserId({player})
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
      if nplayer ~= nil then
        local nuser_id = vRP.getUserId({nplayer})
        if nuser_id ~= nil then
		  vRPclient.isHandcuffed(nplayer,{},function(handcuffed)
			if handcuffed then
				TriggerClientEvent("dr:drag", nplayer, player)
			else
				vRPclient.notify(player,{"Player is not handcuffed."})
			end
		  end)
        else
          vRPclient.notify(player,{lang.common.no_player_near()})
        end
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, "Drag closest player."}

RegisterServerEvent('FRG:DragPlayer')
AddEventHandler('FRG:DragPlayer', function()
  local user_id = vRP.getUserId({source})
  if vRP.hasPermission({user_id,"police.menu"}) then
    if user_id ~= nil then
      vRPclient.getNearestPlayer(source,{10},function(nplayer)
        if nplayer ~= nil then
          local nuser_id = vRP.getUserId({nplayer})
          if nuser_id ~= nil then
        vRPclient.isHandcuffed(nplayer,{},function(handcuffed)
        if handcuffed then
          TriggerClientEvent("dr:drag", nplayer, source)
        else
          vRPclient.notify(source,{"Player is not handcuffed."})
        end
        end)
          else
            vRPclient.notify(source,{lang.common.no_player_near()})
          end
        else
          vRPclient.notify(source,{lang.common.no_player_near()})
        end
      end)
    end
  end
end)

-- player check
local choice_player_check = {function(player,choice)
  vRPclient.getNearestPlayer(player,{5},function(nplayer)
    local nuser_id = vRP.getUserId({nplayer})
    if nuser_id ~= nil then
      vRPclient.notify(nplayer,{lang.police.menu.check.checked()})
      vRPclient.getWeapons(nplayer,{},function(weapons)
        -- prepare display data (money, items, weapons)
        local money = vRP.getMoney({nuser_id})
        local items = ""
        local data = vRP.getUserDataTable({nuser_id})
        if data and data.inventory then
          for k,v in pairs(data.inventory) do
            local item_name = vRP.getItemName({k})
            if item_name then
              items = items.."<br />"..item_name.." ("..v.amount..")"
            end
          end
        end

        local weapons_info = ""
        for k,v in pairs(weapons) do
          weapons_info = weapons_info.."<br />"..k.." ("..v.ammo..")"
        end

        vRPclient.setDiv(player,{"police_check",".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",lang.police.menu.check.info({money,items,weapons_info})})
        -- request to hide div
        vRP.request({player, lang.police.menu.check.request_hide(), 1000, function(player,ok)
          vRPclient.removeDiv(player,{"police_check"})
        end})
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end, lang.police.menu.check.description()}


-- armor item
vRP.defInventoryItem({"body_armor","Body Armor","Intact body armor.",
function(args)
  local choices = {}

  choices["Equip"] = {function(player,choice)
    local user_id = vRP.getUserId({player})
    if user_id ~= nil then
      if vRP.tryGetInventoryItem({user_id, "body_armor", 1, true}) then
		BMclient.setArmour(player,{100,true})
        vRP.closeMenu({player})
      end
    end
  end}

  return choices
end,
5.00})

-- store armor
local choice_store_armor = {function(player, choice)
  local user_id = vRP.getUserId({player})
  if user_id ~= nil then
    BMclient.getArmour(player,{},function(armour)
      if armour > 95 then
        vRP.giveInventoryItem({user_id, "body_armor", 1, true})
        -- clear armor
	    BMclient.setArmour(player,{0,false})
	  else
	    vRPclient.notify(player, {"~r~Damaged armor can't be stored!"})
      end
    end)
  end
end, "Store intact body armor in inventory."}

local unjailed = {}
function jail_clock(target_id,timer)
  local target = vRP.getUserSource({tonumber(target_id)})
  local users = vRP.getUsers({})
  local online = false
  for k,v in pairs(users) do
	if tonumber(k) == tonumber(target_id) then
	  online = true
	end
  end
  if online then
    if timer>0 then
	  vRPclient.notify(target, {"~r~Remaining time: " .. timer .. " minute(s)."})
      vRPclient.setHandcuffed(target,{false})
      vRP.setUData({tonumber(target_id),"vRP:jail:time",json.encode(timer)})
	  SetTimeout(60*1000, function()
		for k,v in pairs(unjailed) do -- check if player has been unjailed by cop or admin
		  if v == tonumber(target_id) then
	        unjailed[v] = nil
		    timer = 0
		  end
		end
		vRP.setHunger({tonumber(target_id), 0})
		vRP.setThirst({tonumber(target_id), 0})
	    jail_clock(tonumber(target_id),timer-1)
	  end) 
    else 
	  BMclient.loadFreeze(target,{false,true,true})
	  SetTimeout(1,function()
		BMclient.loadFreeze(target,{false,false,false})
	  end)
	  vRPclient.teleport(target,{1853.2822265625,2585.8454589844,46.5}) -- teleport to outside jail
	  vRPclient.setHandcuffed(target,{false})
      vRPclient.notify(target,{"~b~You have been set free."})
	  vRP.setUData({tonumber(target_id),"vRP:jail:time",json.encode(-1)})
    end
  end
end

-- dynamic jail
local ch_jail = {function(player,choice) 
  vRPclient.getNearestPlayers(player,{15},function(nplayers) 
	local user_list = ""
    for k,v in pairs(nplayers) do
	  user_list = user_list .. "[" .. vRP.getUserId({k}) .. "]" .. GetPlayerName(k) .. " | "
    end 
    local user_id = vRP.getUserId({player})
	if user_list ~= "" then
	  vRP.prompt({player,"Players Nearby:" .. user_list,"",function(player,target_id) 
	    if target_id ~= nil and target_id ~= "" then 
	      vRP.prompt({player,"Jail Time in minutes:","1",function(player,jail_time)
			if jail_time ~= nil and jail_time ~= "" then 
	          local target = vRP.getUserSource({tonumber(target_id)})
			  if target ~= nil then
		        if tonumber(jail_time) > 60 then
  			      jail_time = 60
		        end
		        if tonumber(jail_time) < 1 then
		          jail_time = 1
		        end
		  
                vRPclient.isHandcuffed(target,{}, function(handcuffed)  
                  if handcuffed then 
					BMclient.loadFreeze(target,{false,true,true})
					SetTimeout(1,function()
					  BMclient.loadFreeze(target,{false,false,false})
					end)
				    vRPclient.teleport(target,{1714.9566650391,2590.1953125,50.189720153809}) -- teleport to inside jail
            vRPclient.notify(target,{"~r~You have been sent to jail."})
            local officerName = GetPlayerName(player)
            local civJailedName = GetPlayerName(target)
            local FRGJailLogs = {
              {
                ["color"] = "8663711",
                ["title"] = "FRG Police Logs",
                ["description"] = '__**Jail Logs**__\n**Officer:** '..officerName..'('..user_id..')\n**Suspect:** '..civJailedName..'('..target_id..')\n**For:** '..jail_time..' minutes',
                ["footer"] = {
                  ["text"] = "FRG Police Logs",
                  ["icon_url"] = "https://i.imgur.com/XO1CbeM.png",
                },
              }
            }
            PerformHttpRequest("https://discord.com/api/webhooks/805348415432687626/30VoXDy5jCdmF4DCqmJBdXKFoAubVTkGu_w_-e6vvYIDVKQAtB5fNtFD3a_7OLE0KGB7", function(err, text, headers) end, 'POST', json.encode({username = "FRG Police Logs", embeds = FRGJailLogs}), { ['Content-Type'] = 'application/json' })
				    vRPclient.notify(player,{"~b~You sent a player to jail."})
				    vRP.setHunger({tonumber(target_id),0})
				    vRP.setThirst({tonumber(target_id),0})
				    jail_clock(tonumber(target_id),tonumber(jail_time))
					vRPbm.logInfoToFile("jailLog.txt",user_id .. " jailed "..target_id.." for " .. jail_time .. " minutes")
			      else
				    vRPclient.notify(player,{"~r~That player is not handcuffed."})
			      end
			    end)
			  else
				vRPclient.notify(player,{"~r~That ID seems invalid."})
			  end
			else
			  vRPclient.notify(player,{"~r~The jail time can't be empty."})
			end
	      end})
        else
          vRPclient.notify(player,{"~r~No player ID selected."})
        end 
	  end})
    else
      vRPclient.notify(player,{"~r~No player nearby."})
    end 
  end)
end,"Send a nearby player to jail."}

-- dynamic unjail
local ch_unjail = {function(player,choice) 
	vRP.prompt({player,"Player ID:","",function(player,target_id) 
	  if target_id ~= nil and target_id ~= "" then 
		vRP.getUData({tonumber(target_id),"vRP:jail:time",function(value)
		  if value ~= nil then
		  custom = json.decode(value)
			if custom ~= nil then
			  local user_id = vRP.getUserId({player})
			  if tonumber(custom) > 0 or vRP.hasPermission({user_id,"admin.easy_unjail"}) then
	            local target = vRP.getUserSource({tonumber(target_id)})
				if target ~= nil then
	              unjailed[target] = tonumber(target_id)
				  vRPclient.notify(player,{"~g~Target will be released soon."})
          vRPclient.notify(target,{"~g~Someone lowered your sentence."})
          local officerName = GetPlayerName(player)
          local civJailedName = GetPlayerName(target)
          local FRGJailLogs = {
            {
              ["color"] = "8663711",
              ["title"] = "FRG Police Logs",
              ["description"] = '__**Unjail Logs**__\n**Officer:** '..officerName..'('..user_id..')\n**Suspect:** '..civJailedName..'('..target_id..')\n**Time Left:** '..custom..' minutes',
              ["footer"] = {
                ["text"] = "FRG Police Logs",
                ["icon_url"] = "https://i.imgur.com/XO1CbeM.png",
              },
            }
          }
          PerformHttpRequest("https://discord.com/api/webhooks/805348415432687626/30VoXDy5jCdmF4DCqmJBdXKFoAubVTkGu_w_-e6vvYIDVKQAtB5fNtFD3a_7OLE0KGB7", function(err, text, headers) end, 'POST', json.encode({username = "FRG Police Logs", embeds = FRGJailLogs}), { ['Content-Type'] = 'application/json' })
				  vRPbm.logInfoToFile("jailLog.txt",user_id .. " freed "..target_id.." from a " .. custom .. " minutes sentence")
				else
				  vRPclient.notify(player,{"~r~That ID seems invalid."})
				end
			  else
				vRPclient.notify(player,{"~r~Target is not jailed."})
			  end
			end
		  end
		end})
      else
        vRPclient.notify(player,{"~r~No player ID selected."})
      end 
	end})
end,"Frees a jailed player."}

-- (server) called when a logged player spawn to check for vRP:jail in user_data
AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn) 
  local target = vRP.getUserSource({user_id})
  SetTimeout(35000,function()
    local custom = {}
    vRP.getUData({user_id,"vRP:jail:time",function(value)
	  if value ~= nil then
	    custom = json.decode(value)
	    if custom ~= nil then
		  if tonumber(custom) > 0 then
			BMclient.loadFreeze(target,{false,true,true})
			SetTimeout(1,function()
			  BMclient.loadFreeze(target,{false,false,false})
			end)
            vRPclient.setHandcuffed(target,{false})
            vRPclient.teleport(target,{1714.9566650391,2590.1953125,50.189720153809}) -- teleport inside jail
            vRPclient.notify(target,{"~r~Finish your sentence."})
			vRP.setHunger({tonumber(user_id),0})
			vRP.setThirst({tonumber(user_id),0})
			vRPbm.logInfoToFile("jailLog.txt",user_id.." has been sent back to jail for " .. custom .. " minutes to complete his sentence")
		    jail_clock(tonumber(user_id),tonumber(custom))
		  end
	    end
	  end
	end})
  end)
end)

-- dynamic fine
local ch_fine = {function(player,choice) 
  vRPclient.getNearestPlayers(player,{15},function(nplayers) 
	local user_list = ""
    for k,v in pairs(nplayers) do
	  user_list = user_list .. "[" .. vRP.getUserId({k}) .. "]" .. GetPlayerName(k) .. " | "
    end 
	if user_list ~= "" then
	  vRP.prompt({player,"Players Nearby:" .. user_list,"",function(player,target_id) 
	    if target_id ~= nil and target_id ~= "" then 
	      vRP.prompt({player,"Fine amount:","100",function(player,fine)
			if fine ~= nil and fine ~= "" then 
	          vRP.prompt({player,"Fine reason:","",function(player,reason)
			    if reason ~= nil and reason ~= "" then 
	              local target = vRP.getUserSource({tonumber(target_id)})
				  if target ~= nil then
		            if tonumber(fine) > 100000 then
  			          fine = 100000
		            end
		            if tonumber(fine) < 100 then
		              fine = 100
		            end
			  
		            if vRP.tryFullPayment({tonumber(target_id), tonumber(fine)}) then
                      vRP.insertPoliceRecord({tonumber(target_id), lang.police.menu.fine.record({reason,fine})})
                      vRPclient.notify(player,{lang.police.menu.fine.fined({reason,fine})})
                      vRPclient.notify(target,{lang.police.menu.fine.notify_fined({reason,fine})})
                      local user_id = vRP.getUserId({player})
                      local officerName = GetPlayerName(player)
                      local civJailedName = GetPlayerName(target)
                      local FRGJailLogs = {
                        {
                          ["color"] = "8663711",
                          ["title"] = "FRG Police Logs",
                          ["description"] = '__**U Logs**__\n**Officer:** '..officerName..'('..user_id..')\n**Suspect:** '..civJailedName..'('..target_id..')\n**Money:** £'..fine..'\n**Reason:** '..reason,
                          ["footer"] = {
                            ["text"] = "FRG Police Logs",
                            ["icon_url"] = "https://i.imgur.com/XO1CbeM.png",
                          },
                        }
                      }
                      PerformHttpRequest("https://discord.com/api/webhooks/805348415432687626/30VoXDy5jCdmF4DCqmJBdXKFoAubVTkGu_w_-e6vvYIDVKQAtB5fNtFD3a_7OLE0KGB7", function(err, text, headers) end, 'POST', json.encode({username = "FRG Police Logs", embeds = FRGJailLogs}), { ['Content-Type'] = 'application/json' })
					            vRPbm.logInfoToFile("fineLog.txt",user_id .. " fined "..target_id.." the amount of " .. fine .. " for ".. reason)
                      vRP.closeMenu({player})
                    else
                      vRPclient.notify(player,{lang.money.not_enough()})
                    end
				  else
					vRPclient.notify(player,{"~r~That ID seems invalid."})
				  end
				else
				  vRPclient.notify(player,{"~r~You can't fine for no reason."})
				end
	          end})
			else
			  vRPclient.notify(player,{"~r~Your fine has to have a value."})
			end
	      end})
        else
          vRPclient.notify(player,{"~r~No player ID selected."})
        end 
	  end})
    else
      vRPclient.notify(player,{"~r~No player nearby."})
    end  
  end)
end,"Fines a nearby player."}

-- improved handcuff
local ch_handcuff = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId({nplayer})
    if nuser_id ~= nil then 
      vRPclient.toggleHandcuff(nplayer,{})
	  local user_id = vRP.getUserId({player})
	  vRPbm.logInfoToFile("jailLog.txt",user_id .. " cuffed "..nuser_id)
      vRP.closeMenu({nplayer})
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.handcuff.description()}

local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRPajail = {}

local jX, jY, jZ = 1642.8597412109,2570.3967285156,45.564838409424 -- JAIL POSITION

local aUnjailed = {}
function ajail_clock(target_id,timer)
  local target = vRP.getUserSource({tonumber(target_id)})
  local users = vRP.getUsers({})
  local online = false
  for k,v in pairs(users) do
	if tonumber(k) == tonumber(target_id) then
	  online = true
	end
  end
  if online then
    if timer>0 then
	  vRPclient.notify(target, {"~r~Remaining time: " .. timer .. " minute(s)."})
      vRPclient.setHandcuffed(target,{false})
      vRP.setUData({tonumber(target_id),"vRP:admin:jail:time",json.encode(timer)})
	  SetTimeout(60*1000, function()
		for k,v in pairs(aUnjailed) do -- check if player has been unjailed by cop or admin
		  if v == tonumber(target_id) then
	        aUnjailed[v] = nil
		    timer = 0
		  end
		end
		vRP.setHunger({tonumber(target_id), 0})
		vRP.setThirst({tonumber(target_id), 0})
	    ajail_clock(tonumber(target_id),timer-1)
	  end) 
    else 
	  vRPclient.teleport(target,{1846.1331787109,2585.91015625,45.672069549561}) -- teleport to outside jail
	  vRPclient.setHandcuffed(target,{false})
      vRPclient.notify(target,{"~b~You have been set free. Please follow the rules!"})
	  vRP.setUData({tonumber(target_id),"vRP:admin:jail:time",json.encode(-1)})
    end
  end
end

local a_jail = {function(player,choice) 
	vRP.prompt({player,"Players ID:","",function(player,target_id) 
		if target_id ~= nil and target_id ~= "" then 
			vRP.prompt({player,"Jail Time in minutes:","",function(player,jail_time)
				if jail_time ~= nil and jail_time ~= "" then 
					vRP.prompt({player,"Jail Reason:","",function(player,jail_reason)
						if jail_reason ~= nil and jail_reason ~= "" then 
							local target = vRP.getUserSource({tonumber(target_id)})
							if target ~= nil then
								if tonumber(jail_time) > 500 then
									jail_time = 500
								end
								if tonumber(jail_time) < 1 then
									jail_time = 1
                                end
                                vRPclient.notify(player,{"~g~Player Admin Jailed!"})
								vRPclient.teleport(target,{jX, jY, jZ}) -- teleport to inside jail
								ajail_clock(tonumber(target_id),tonumber(jail_time))
							end
						else
							vRPclient.notify(player,{"~r~Invalid reason."})
						end
					end})
				else
					vRPclient.notify(player,{"~r~The jail time can't be empty."})
				end
			end})
		else
			vRPclient.notify(player,{"~r~No player ID selected."}) 
		end
	end})
end,"Send a player to admin jail."}

local a_unjail = {function(player,choice) 
	vRP.prompt({player,"Player ID:","",function(player,target_id) 
		if target_id ~= nil and target_id ~= "" then 
			vRP.getUData({tonumber(target_id),"vRP:admin:jail:time",function(value)
				if value ~= nil then
					custom = json.decode(value)
					if custom ~= nil then
						local user_id = vRP.getUserId({player})
						if tonumber(custom) > 0 or vRP.hasPermission({user_id,"admin.ajail"}) then
							local target = vRP.getUserSource({tonumber(target_id)})
							if target ~= nil then
								aUnjailed[target] = tonumber(target_id)
								vRPclient.notify(player,{"~g~Target will be released soon."})
							else
								vRPclient.notify(player,{"~r~That ID seems invalid."})
							end
						else
							vRPclient.notify(player,{"~r~Target is not jailed."})
						end
					end
				end
			end})
		else
			vRPclient.notify(player,{"~r~No player ID selected."})
		end 
	end})
end,"Frees a jailed player."}

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn) 
	local target = vRP.getUserSource({user_id})
	SetTimeout(35000,function()
		local custom = {}
		vRP.getUData({user_id,"vRP:jail:time",function(value)
			if value ~= nil then
				custom = json.decode(value)
				if custom ~= nil then
					if tonumber(custom) > 0 then
						vRPclient.teleport(target,{1687.8145751953,2518.6625976563,-120.84989929199}) -- teleport inside jail
						ajail_clock(tonumber(user_id),tonumber(custom))
					end
				end
			end
		end})
	end)
end)

function vRPbm.chargePhoneNumber(user_id,phone)
  local player = vRP.getUserSource({user_id})
  local directory_name = vRP.getPhoneDirectoryName({user_id, phone})
  if directory_name == "unknown" then
	directory_name = phone
  end
  vRP.prompt({player,"Amount to be charged to "..directory_name..":","0",function(player,charge)
	if charge ~= nil and charge ~= "" and tonumber(charge)>0 then 
	  vRP.getUserByPhone({phone, function(target_id)
		if target_id~=nil then
			if charge ~= nil and charge ~= "" then 
	          local target = vRP.getUserSource({target_id})
			  if target ~= nil then
				vRP.getUserIdentity({user_id, function(identity)
				  local my_directory_name = vRP.getPhoneDirectoryName({target_id, identity.phone})
				  if my_directory_name == "unknown" then
				    my_directory_name = identity.phone
				  end
			      local text = "~b~" .. my_directory_name .. "~w~ is charging you ~r~$" .. charge .. "~w~ for his services."
				  vRP.request({target,text,600,function(req_player,ok)
				    if ok then
					  local target_bank = vRP.getBankMoney({target_id}) - tonumber(charge)
					  local my_bank = vRP.getBankMoney({user_id}) + tonumber(charge)
                  if target_bank>0 then
              vRP.log(user_id, "ChargeMoney", "Charged " .. charge .. " | from " .. target_id)
              vRP.log(target_id, "ChargeMoney", "Got Charged " .. charge .. " | from " .. target_id)
					    vRP.setBankMoney({user_id,my_bank})
					    vRP.setBankMoney({target_id,target_bank})
					    vRPclient.notify(player,{"You charged ~y~$"..charge.." ~w~from ~b~"..directory_name .."~w~ for your services."})
						vRPclient.notify(target,{"~b~"..my_directory_name.."~w~ charged you ~r~$"..charge.."~w~ for his services."})
					    --vRPbm.logInfoToFile("mchargeLog.txt",user_id .. " mobile charged "..target_id.." the amount of " .. charge .. ", user bank post-payment for "..user_id.." equals $"..my_bank.." and for "..user_id.." equals $"..target_bank)
					    vRP.closeMenu({player})
                      else
                        vRPclient.notify(target,{lang.money.not_enough()})
                        vRPclient.notify(player,{"~b~" .. directory_name .. "~w~ tried to, but~r~ can't~w~ pay for your services."})
                      end
				    else
                      vRPclient.notify(player,{"~b~" .. directory_name .. "~r~ refused~w~ to pay for your services."})
				    end
				  end})
				end})
			  else
			    vRPclient.notify(player,{"~r~You can't make charges to offline players."})
			  end
			else
			  vRPclient.notify(player,{"~r~Your charge has to have a value."})
			end
		else
		  vRPclient.notify(player,{"~r~That phone number seems invalid."})
		end
	  end})
	else
	  vRPclient.notify(player,{"~r~The value has to be bigger than 0."})
	end
  end})
end

function vRPbm.payPhoneNumber(user_id,phone)
  local player = vRP.getUserSource({user_id})
  local directory_name = vRP.getPhoneDirectoryName({user_id, phone})
  if directory_name == "unknown" then
	directory_name = phone
  end
  vRP.prompt({player,"Amount to be sent to "..directory_name..":","0",function(player,transfer)
	if transfer ~= nil and transfer ~= "" and tonumber(transfer)>0 then 
	  vRP.getUserByPhone({phone, function(target_id)
	    local my_bank = vRP.getBankMoney({user_id}) - tonumber(transfer)
		if target_id~=nil then
          if my_bank >= 0 then
		    local target = vRP.getUserSource({target_id})
      if target ~= nil then
			  vRP.setBankMoney({user_id,my_bank})
              vRPclient.notify(player,{"~g~You tranfered ~r~$"..transfer.." ~g~to ~b~"..directory_name})
			  local target_bank = vRP.getBankMoney({target_id}) + tonumber(transfer)
			  vRP.setBankMoney({target_id,target_bank})
			  vRPbm.logInfoToFile("mpayLog.txt",user_id .. " mobile paid "..target_id.." the amount of " .. transfer .. ", user bank post-payment for "..user_id.." equals $"..my_bank.." and for "..user_id.." equals $"..target_bank)
        vRP.log({user_id, "MPay", user_id .. " mobile paid "..target_id.." the amount of " .. transfer .. ", user bank post-payment for "..user_id.." equals $"..my_bank.." and for "..user_id.." equals $"..target_bank})
        vRP.log({target_id, "MPay", user_id .. " mobile paid "..target_id.." the amount of " .. transfer .. ", user bank post-payment for "..user_id.." equals $"..my_bank.." and for "..user_id.." equals $"..target_bank})

        vRP.getUserIdentity({user_id, function(identity)
		        local my_directory_name = vRP.getPhoneDirectoryName({target_id, identity.phone})
			    if my_directory_name == "unknown" then
		          my_directory_name = identity.phone
			    end
                vRPclient.notify(target,{"~g~You received ~y~$"..transfer.." ~g~from ~b~"..my_directory_name})
			  end})
              vRP.closeMenu({player})
			else
			  vRPclient.notify(player,{"~r~You can't make payments to offline players."})
			end
          else
            vRPclient.notify(player,{lang.money.not_enough()})
          end
		else
		  vRPclient.notify(player,{"~r~That phone number seems invalid."})
		end
	  end})
	else
	  vRPclient.notify(player,{"~r~The value has to be bigger than 0."})
	end
  end})
end

-- mobilepay
local ch_mobilepay = {function(player,choice) 
	local user_id = vRP.getUserId({player})
	local menu = {}
	menu.name = lang.phone.directory.title()
	menu.css = {top = "75px", header_color = "rgba(0,0,255,0.75)"}
    menu.onclose = function(player) vRP.openMainMenu({player}) end -- nest menu
	menu[">Type Number"] = {
	  -- payment function
	  function(player,choice) 
	    vRP.prompt({player,"Phone Number:","000-0000",function(player,phone)
	      if phone ~= nil and phone ~= "" then 
		    vRPbm.payPhoneNumber(user_id,phone)
		  else
		    vRPclient.notify(player,{"~r~You have to digit a phone number."})
		  end
	    end})
	  end,"Type the phone number manually."}
	local directory = vRP.getPhoneDirectory({user_id})
	for k,v in pairs(directory) do
	  menu[k] = {
	    -- payment function
	    function(player,choice) 
		  vRPbm.payPhoneNumber(user_id,v)
	    end
	  ,v} -- number as description
	end
	vRP.openMenu({player, menu})
end,"Transfer money through phone."}

-- spawn vehicle
local ch_spawnveh = {function(player,choice) 
	vRP.prompt({player,"Vehicle Model:","",function(player,model)
	  if model ~= nil and model ~= "" then 
	    BMclient.spawnVehicle(player,{model})
	  else
		vRPclient.notify(player,{"~r~You have to type a vehicle model."})
	  end
	end})
end,"Spawn a vehicle model."}

-- lockpick vehicle
local ch_lockpickveh = {function(player,choice) 
	BMclient.lockpickVehicle(player,{20,true}) -- 20s to lockpick, allow to carjack unlocked vehicles (has to be true for NoCarJack Compatibility)
end,"Lockpick closest vehicle."}

-- dynamic freeze
local ch_freeze = {function(player,choice) 
	local user_id = vRP.getUserId({player})
	if vRP.hasPermission({user_id,"admin.bm_freeze"}) then
	  vRP.prompt({player,"Player ID:","",function(player,target_id) 
	    if target_id ~= nil and target_id ~= "" then 
	      local target = vRP.getUserSource({tonumber(target_id)})
		  if target ~= nil then
		    vRPclient.notify(player,{"~g~You un/froze that player."})
		    BMclient.loadFreeze(target,{true,true,true})
		  else
		    vRPclient.notify(player,{"~r~That ID seems invalid."})
		  end
        else
          vRPclient.notify(player,{"~r~No player ID selected."})
        end 
	  end})
	else
	  vRPclient.getNearestPlayer(player,{10},function(nplayer)
        local nuser_id = vRP.getUserId({nplayer})
        if nuser_id ~= nil then
		  vRPclient.notify(player,{"~g~You un/froze that player."})
		  BMclient.loadFreeze(nplayer,{true,false,false})
        else
          vRPclient.notify(player,{lang.common.no_player_near()})
        end
      end)
	end
end,"Freezes a player."}

-- lockpicking item
vRP.defInventoryItem({"lockpicking_kit","Lockpicking Kit","Used to lockpick vehicles.", -- add it for sale to vrp/cfg/markets.lua if you want to use it
function(args)
  local choices = {}

  choices["Lockpick"] = {function(player,choice)
    local user_id = vRP.getUserId({player})
    if user_id ~= nil then
      if vRP.tryGetInventoryItem({user_id, "lockpicking_kit", 1, true}) then
		BMclient.lockpickVehicle(player,{20,true}) -- 20s to lockpick, allow to carjack unlocked vehicles (has to be true for NoCarJack Compatibility)
        vRP.closeMenu({player})
      end
    end
  end,"Lockpick closest vehicle."}

  return choices
end,
5.00})

-- ADD STATIC MENU CHOICES // STATIC MENUS NEED TO BE ADDED AT vRP/cfg/gui.lua
vRP.addStaticMenuChoices({"police_weapons", police_weapons}) -- police gear
vRP.addStaticMenuChoices({"emergency_medkit", emergency_medkit}) -- pills and medkits
vRP.addStaticMenuChoices({"emergency_heal", emergency_heal}) -- heal button

-- REMEMBER TO ADD THE PERMISSIONS FOR WHAT YOU WANT TO USE

-- REGISTER MAIN MENU CHOICES
vRP.registerMenuBuilder({"main", function(add, data)
  local user_id = vRP.getUserId({data.player})
  if user_id ~= nil then
    local choices = {}
	
    if vRP.hasPermission({user_id,"player.player_menu"}) then
      choices["Player"] = ch_player_menu -- opens player submenu
    end
	
    if vRP.hasPermission({user_id,"player.loot"}) then
      choices["Loot"] = choice_loot -- take the items of nearest player in coma
    end
    if vRP.hasPermission({user_id,"player.check"}) then
      choices["Inspect"] = choice_player_check -- checks nearest player inventory, like police check from vrp
    end
    if vRP.hasPermission({user_id,"player.store_armor"}) then
      choices["Store Armor"] = choice_store_armor -- store player armor
    end
    add(choices)
  end
end})

-- RESGISTER ADMIN MENU CHOICES
vRP.registerMenuBuilder({"admin", function(add, data)
  local user_id = vRP.getUserId({data.player})
  if user_id ~= nil then
    local choices = {}
	
	if vRP.hasPermission({user_id,"admin.deleteveh"}) then
      choices["Delete Vehicle"] = ch_deleteveh -- Delete nearest vehicle (Fixed pull request https://github.com/Sighmir/vrp_basic_menu/pull/11/files/419405349ca0ad2a215df90cfcf656e7aa0f5e9c from benjatw)
	end
	
	if vRP.hasPermission({user_id,"admin.spawnveh"}) then
      choices["Spawn Vehicle"] = ch_spawnveh -- Spawn a vehicle model
	end
	
	if vRP.hasPermission({user_id,"admin.godmode"}) then
      choices["Godmode"] = ch_godmode -- Toggles admin godmode (Disable the default admin.god permission to use this!) 
	end
	
    if vRP.hasPermission({user_id,"player.blips"}) then
      choices["Blips"] = ch_blips -- turn on map blips and sprites
    end
	
    if vRP.hasPermission({user_id,"player.sprites"}) then
      choices["Sprites"] = ch_sprites -- turn on only name sprites
    end
	
    if vRP.hasPermission({user_id,"admin.crun"}) then
      choices["Crun"] = ch_crun -- run any client command, any GTA V client native http://www.dev-c.com/nativedb/
    end
	
    if vRP.hasPermission({user_id,"admin.srun"}) then
      choices["Srun"] = ch_srun -- run any server command, any GTA V server native http://www.dev-c.com/nativedb/
    end

	  if vRP.hasPermission({user_id,"player.tptowaypoint"}) then
        choices["TP to waypoint"] = choice_tptowaypoint -- teleport user to map blip
	  end
  
    if vRP.hasPermission({user_id,"admin.ajail"}) then
      choices["Admin Jail"] = a_jail -- admin jail
    end

    if vRP.hasPermission({user_id,"admin.ajail"}) then
      choices["Admin Unjail"] = a_unjail -- admin jail
    end

	  if vRP.hasPermission({user_id,"admin.easy_unjail"}) then
      choices["Police Unjail"] = ch_unjail -- Un jails chosen player if he is jailed (Use admin.easy_unjail as permission to have this in admin menu working in non jailed players)
    end
  
	  if vRP.hasPermission({user_id,"admin.spikes"}) then
      choices["Spikes"] = ch_spikes -- Toggle spikes
    end
	
	  if vRP.hasPermission({user_id,"admin.bm_freeze"}) then
      choices["Freeze"] = ch_freeze -- Toggle freeze
    end
	
    add(choices)
  end
end})

-- REGISTER POLICE MENU CHOICES
vRP.registerMenuBuilder({"police", function(add, data)
  local user_id = vRP.getUserId({data.player})
  if user_id ~= nil then
    local choices = {}
	
	
	if vRP.hasPermission({user_id,"police.easy_jail"}) then
      choices["Jail"] = ch_jail -- Send a nearby handcuffed player to jail with prompt for choice and user_list
    end
	
	if vRP.hasPermission({user_id,"police.easy_unjail"}) then
      choices["Unjail"] = ch_unjail -- Un jails chosen player if he is jailed (Use admin.easy_unjail as permission to have this in admin menu working in non jailed players)
    end
	
	if vRP.hasPermission({user_id,"police.easy_fine"}) then
      choices["Fine"] = ch_fine -- Fines closeby player
    end
	
	if vRP.hasPermission({user_id,"police.easy_cuff"}) then
      choices["Cuff"] = ch_handcuff -- Toggle cuffs AND CLOSE MENU for nearby player
    end
	
	if vRP.hasPermission({user_id,"police.spikes"}) then
      choices["Spikes"] = ch_spikes -- Toggle spikes
    end
	
    if vRP.hasPermission({user_id,"police.drag"}) then
      choices["Drag"] = ch_drag -- Drags closest handcuffed player
    end
	
	if vRP.hasPermission({user_id,"police.bm_freeze"}) then
      choices["Freeze"] = ch_freeze -- Toggle freeze
    end
	
    add(choices)
  end
end})

-- REGISTER PHONE MENU CHOICES
-- TO USE THIS FUNCTION YOU NEED TO HAVE THE ORIGINAL vRP UPDATED TO THE LASTEST VERSION
vRP.registerMenuBuilder({"phone", function(add) -- phone menu is created on server start, so it has no permissions.
    local choices = {} -- Comment the choices you want to disable by adding -- in front of them.
	
    choices["PalPay"] = ch_mobilepay -- transfer money through phone

    add(choices)
end})
