local PoliceRanks = {
    [1] = { Rank = "Commissioner", PayCheck = 60000 },
    [2] = { Rank = "Deputy Commissioner", PayCheck = 60000 },
    [3] = { Rank = "Deputy Assistant Commissioner", PayCheck = 60000 },
    [4] = { Rank = "Commander", PayCheck = 60000 },
    [5] = { Rank = "Chief Superintendent", PayCheck = 60000 },
    [6] = { Rank = "Superintendent", PayCheck = 60000 },
    [7] = { Rank = "Chief Inspector", PayCheck = 60000 },
    [8] = { Rank = "Inspector", PayCheck = 60000 },
    [9] = { Rank ="Seargant", PayCheck = 60000 },
    [10] = { Rank = "Senior Police Constable", PayCheck = 60000 },
    [11] = { Rank = "Police Constable", PayCheck = 60000 },
    [12] = { Rank = "PCSO", PayCheck = 60000 },
    [13] = { Rank = "Off Duty", PayCheck = 60000 },
}

local ClockOn_Coords = vector3(442.79,-981.73,30.69)
local ClockOn2_Coords = vector3(1852.3107910156,3689.814453125,34.267040252686)

-- Dont edit below

local _PayCheckTimer = 0
local HasStarted = false
local isPlayerOnDuty = false
local _SelectedRank = nil

RMenu.Add('police', 'main', RageUI.CreateMenu("Met PD", "~b~Metropolitan Police", 1300, 0))
RMenu:Get('police', 'main')

RageUI.CreateWhile(1.0, RMenu:Get('police', 'main'), nil, function()
    RageUI.IsVisible(RMenu:Get('police', 'main'), true, false, true, function()

        for k,v in pairs (PoliceRanks) do

            RageUI.Button(v.Rank, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    if v.Rank == "Off Duty" then
                        notify('~g~Clocked Off')
                        SetResourceKvpInt("Police_ClockedOn", 1)
                        HasStarted = false
                        _PayCheckTimer = 0
                    else
                        StartTimerCheck()
                        _SelectedRank = k
                        SetResourceKvpInt("Police_ClockedOn", 2)
                        notify('~g~You have clocked on as ' .. v.Rank)
                    end
                end
            end, RMenu:Get('police', 'main'))

        end

    end)
end)

Citizen.CreateThread(function()
    while (true) do
        Citizen.Wait(0)

        local Coords = GetEntityCoords(PlayerPedId())
        DrawMarker(25, ClockOn2_Coords.xy, ClockOn2_Coords.z-0.98, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 51, 128, 255, 155, 0, 0, 0, 0, 0, 0, 0)
        DrawMarker(25, ClockOn_Coords.xy, ClockOn_Coords.z-0.98, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 51, 128, 255, 155, 0, 0, 0, 0, 0, 0, 0)

        if #(Coords - ClockOn_Coords) < 1.0 then
            if IsControlJustPressed(1, 51) then
                TriggerServerEvent('FRG:CheckForPerm')
                Citizen.Wait(100)

                if isPlayerOnDuty then
                    print("On Duty")
                    RageUI.Visible(RMenu:Get('police', 'main'), not RageUI.Visible(RMenu:Get('police', 'main')))
                end
            end
        end

        if #(Coords - ClockOn2_Coords) < 1.0 then
            if IsControlJustPressed(1, 51) then
                TriggerServerEvent('FRG:CheckForPerm')
                Citizen.Wait(100)

                if isPlayerOnDuty then
                    RageUI.Visible(RMenu:Get('police', 'main'), not RageUI.Visible(RMenu:Get('police', 'main')))
                end
            end
        end

    end
end)

function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end

RegisterNetEvent('FRG:AllowPD')
AddEventHandler('FRG:AllowPD', function()
    isPlayerOnDuty = true
end)

function StartTimerCheck()
    _PayCheckTimer = 1800
end

Citizen.CreateThread(function()
    while (true) do
        Citizen.Wait(1000)
        if (_PayCheckTimer > 0) then
            HasStarted = true
            _PayCheckTimer = _PayCheckTimer - 1
        end

        if HasStarted and PayCheck == 0 then
            HasStarted = false
            notify('~g~Paycheck Recieved: ' .. PoliceRanks[_SelectedRank].PayCheck)
            TriggerServerEvent('Finished:PD', PoliceRanks[_SelectedRank].PayCheck)
        end
    end
end)