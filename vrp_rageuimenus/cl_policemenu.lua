Citizen.CreateThread(function()
    while (true) do
        Citizen.Wait(0)
        if IsControlJustPressed(1, 56) then
            if GetResourceKvpInt("Police_ClockedOn") == 2 then
                RageUI.Visible(RMenu:Get('policeMenu', 'main'), not RageUI.Visible(RMenu:Get('policeMenu', 'main')))
            end
        end
    end
end)


local InJail = false
local JailTime = 0
local spikes = {}

local objects = {
    {"Road Closed","prop_barrier_work05", true},
    {"Incident Ahead","prop_barrier_incident", true},
    {"Police Checkpoint","prop_barrier_checkpoint", true},
    {"Police Collision","prop_barrier_collision", true},
    {"Diagonal Left","prop_barrier_diagonalleft", true},
    {"Diagonal Right","prop_barrier_diagonalright", true},
    {"Small Cone","prop_roadcone02b", true},
    {"Big Cone","prop_roadcone01a", true},
    {"Gazebo","prop_gazebo_02", true},
    {"Worklight","prop_worklight_03b", true},
    {"Gate Barrier","ba_prop_battle_barrier_02a", true},
    {"Gazebo","prop_gazebo_02", true},
    {"Concrete Barrier","prop_mp_barrier_01", true},
    {"Concrete Barrier 2","prop_mp_barrier_01b", true},
}

local index = {
    object = 1,
    speedRad = 1,
    speed = 1
  }

local tires = {
    {bone = "wheel_lf", index = 0},
    {bone = "wheel_rf", index = 1},
    {bone = "wheel_lm", index = 2},
    {bone = "wheel_rm", index = 3},
    {bone = "wheel_lr", index = 4},
    {bone = "wheel_rr", index = 5}
}

local listObjects = {}
for k, v in pairs(objects) do 
  listObjects[k] = v[1]
end

RMenu.Add('policeMenu', 'main', RageUI.CreateMenu("Met Police", "Working for a Safer London!", 1300, 0))
RMenu.Add("policeMenu", "fine", RageUI.CreateSubMenu(RMenu:Get("policeMenu", "main", 1300, 0)))
RMenu:Get('policeMenu', 'main')

RageUI.CreateWhile(1.0, RMenu:Get('policeMenu', 'main'), nil, function()
    RageUI.IsVisible(RMenu:Get('policeMenu', 'main'), true, false, true, function()

        RageUI.List("Spawn Object", listObjects, index.object, nil, {}, true, function(Hovered, Active, Selected, Index)
            if (Active) then 
                index.object = Index;
            end
            if (Selected) then
                SpawnObject(objects[Index][2], objects[Index][3])
            end
        end)

        RageUI.Button('Spike Strips', "~b~Place spikes trips", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            if (Selected) then
                local coords = GetEntityCoords(PlayerPedId())
                local obj = CreateObject(`P_ld_stinger_s`, coords.x,coords.y,coords.z, true, true , true)
                SetEntityHeading(obj, GetEntityHeading(PlayerPedId()))
                PlaceObjectOnGroundProperly(obj)
                local netid = NetworkGetNetworkIdFromEntity(obj)
                TriggerServerEvent("FRG:placeSpike", netid, coords)
            end
        end, RMenu:Get('policeMenu', 'main'))

        RageUI.Button("Fine Citizen", "~b~Fine Citizen", { RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
            if (Hovered) then
  
            end
            if (Active) then
  
            end
            if (Selected) then
                local TempID = KeyboardInput("Enter Temp ID: (Blank to cancel)", "", 10)
                local Amount = KeyboardInput("Enter Amount to Fine: (Blank to cancel)", "", 10)
    
                if tonumber(Amount) then
                    
                else
                    notify('~r~Invalid Amount')
                end
            end
        end, RMenu:Get('policeMenu', 'main'))

        RageUI.Button('Jail Citizen', "~b~Jail Citizen", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            if (Selected) then
                local tempcitizenID = KeyboardInput("Enter Temp ID: (Blank to cancel)", "", 10)
                local time = KeyboardInput("Minutes: (Blank to cancel)", "", 10)

                if tonumber(time) then

                else
                    notify('~r~Invalid Time')
                end
            end
        end, RMenu:Get('policeMenu', 'main'))

        end, function()
    end)
end)

RegisterNetEvent('VRP:ClientJail')
AddEventHandler('VRP:ClientJail', function(time)
    JailTime = tonumber(time)
    InJail = true
    SetEntityCoords(PlayerPedId(), 1775.83, 2579.362, 45.71674)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local jailUserCoords = GetEntityCoords(PlayerPedId())
        local jailCoords = vector3(1775.83, 2579.362, 45.71674)

        if InJail then
            DrawTextBank(0.95, 1.44, 1.0,1.0,0.5, "Time Left : " .. JailTime .. " min", 255, 255, 255, 255, 1)
            if #(jailCoords - jailUserCoords) > 150.0 then
                SetEntityCoords(PlayerPedId(), jailCoords)
            end
        end

        
        if InJail and JailTime == 0 then
            SetEntityCoords(PlayerPedId(), 1852.182, 2586.01, 45.67199)
            notify('~g~You have been released from Jail.')
            InJail = false
        end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
		if JailTime > 0 then
			JailTime = JailTime - 1
        end
    end
end)



function DrawTextBank(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry)
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end


RegisterNetEvent("FRG:addSpike")
AddEventHandler("FRG:addSpike", function(coords, netid) 
    spikes[netid] = {coords, netid}
end)

RegisterNetEvent("FRG:deleteSpike")
AddEventHandler("FRG:deleteSpike", function(netid) 
    spikes[netid] = nil
end)

local closetSpike = 1 

Citizen.CreateThread(function() 
    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        for k,v in pairs(spikes) do 
            local v1 = v[1]
            if #(v1-coords)  <= 5.00 then 
                closetSpike = k
            end
        end 
        Citizen.Wait(150)
    end
end)

Citizen.CreateThread(function() 
    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        if IsPedInAnyVehicle(ped, true) then 
            local veh = GetVehiclePedIsIn(ped, false)
            if spikes[closetSpike] then 
                for t = 1, #tires do 
                    local tirePos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, tires[t].bone))
                    local spike = spikes[closetSpike]
                    if #(tirePos-spike[1]) <= 3.6 then 
                        if not IsVehicleTyreBurst(veh, tires[t].index, true) or IsVehicleTyreBurst(veh, tires[t].index, false) then
                            SetVehicleTyreBurst(veh, tires[t].index, false, 1000.0)
                            TriggerServerEvent("FRG:removeSpike", spike[2])
                        end
                    end
                end
            end

            
        end
        Citizen.Wait(150)
    end
end)

function SpawnObject(object, freeze)
    local Player = PlayerPedId()
    local heading = GetEntityHeading(Player)
    local playerCoords = GetOffsetFromEntityInWorldCoords(Player, 0.0, 0.2, 0.0)
    local modelHash = loadModel(object)
    local obj = CreateObject(modelHash, playerCoords.x, playerCoords.y, playerCoords.z, true, false)
    if freeze then
        local _, groundZ = GetGroundZFor_3dCoord(playerCoords.x, playerCoords.y, playerCoords.z, 0)
        SetEntityCoords(obj, playerCoords.x, playerCoords.y, groundZ + 0.1, true, true, true, true)
        FreezeEntityPosition(obj, true)
    else
        PlaceObjectOnGroundProperly(obj)
    end
    SetEntityHeading(obj, heading)
    SetModelAsNoLongerNeeded(modelHash)
end

function deleteObject() 
    for k, v in pairs(objects) do 
      local theobject1 = v[2]
      local object1 = GetHashKey(theobject1)
      local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
      if DoesObjectOfTypeExistAtCoords(x, y, z, 0.9, object1, true) then
          local obj1 = GetClosestObjectOfType(x, y, z, 0.9, object1, false, false, false)
          DeleteObject(obj1)
      end
    end
end

function loadModel(modelName)
    local modelHash
    if (type(modelName) ~= "string") then 
        modelHash = modelName
    else
        modelHash = GetHashKey(modelName)
    end
    if not HasModelLoaded(modelHash) then
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Wait(0)
        end
    end
    return modelHash
end