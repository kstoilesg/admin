local positionx = 1350
local positiony = 0

local form
local actionIndex = 1
local numberOfDrawableVariations
local textureNumber = 0
local presets = {}
local temp_table = {}
local setAllClothes = false

local index = 1
local maxTextureID = 0
local currentCloth = {}
local typed = false
local clothingMenuOpen = false
local isKeyboardOpen = false
local keyboard_result = {}
local ped = PlayerPedId()
local atStore = false
local storeCoords = {
    vector3(72.2545394897461,-1399.10229492188,29.3761386871338),
    vector3(449.81854248047,-993.30865478516,30.689584732056),
    vector3(-703.77685546875,-152.258544921875,37.4151458740234),
    vector3(-167.863754272461,-298.969482421875,39.7332878112793),
    vector3(428.694885253906,-800.1064453125,29.4911422729492),
    vector3(-829.413269042969,-1073.71032714844,11.3281078338623),
    vector3(-1193.42956542969,-772.262329101563,17.3244285583496),
    vector3(-1447.7978515625,-242.461242675781,49.8207931518555),
    vector3(11.6323690414429,6514.224609375,31.8778476715088),
    vector3(1696.29187011719,4829.3125,42.0631141662598),
    vector3(123.64656829834,-219.440338134766,54.5578384399414),
    vector3(618.093444824219,2759.62939453125,42.0881042480469),
    vector3(1190.55017089844,2713.44189453125,38.2226257324219),
    vector3(-3172.49682617188,1048.13330078125,20.8632030487061),
    vector3(-1108.44177246094,2708.92358398438,19.1078643798828),
    vector3(127.57326507568,-1038.4321289063,29.555480957031),
    vector3(-2152.7907714844,5231.9516601563,18.788805007935),
    vector3(210.32136535645,-1656.7593994141,29.803112030029),
    vector3(-455.61834716797,6012.7348632813,31.7164478302),
    vector3(629.93414306641,9.804479598999,44.394229888916),
    vector3(1439.3804931641,6331.80078125,23.954704284668),
    vector3(-1098.4307861328,-831.42083740234,14.282784461975),
    vector3(243.71351623535,-1370.1625976563,39.534339904785),
    vector3(1103.0277099609,197.00813293457,-49.440055847168),
    vector3(298.98516845703,-598.02362060547,43.284023284912),
    vector3(1839.0124511719,3689.259765625,34.270027160645),
    vector3(-253.41467285156,6309.4458007813,32.427234649658),
    vector3(902.40808105469,-2115.2661132813,30.771173477173),
    vector3(-565.46356201172,287.12573242188,91.797775268555),
}

local clothes = {
    {name = "Hats / Helmets", index = 0, listIndex = 1, type = "prop", currentListIndex = 1, textureN = 0},
    {name = "Glasses", index = 1, listIndex = 1, type = "prop", currentListIndex = 1, textureN = 0},
   -- {name = "Ear Accessories", index = 2, listIndex = 1, type = "prop", currentListIndex = 1, textureN = 0},
    {name = "Face", index = 0, listIndex = 1, type = "drawable", currentListIndex = 1, textureN = 0},
    {name = "Mask", index = 1, listIndex = 1, type = "drawable", currentListIndex = 1, textureN = 0},
    {name = "Shirts / Jackets", index = 11, listIndex = 1, type = "drawable", currentListIndex = 1, textureN = 0},
    {name = "Arms / Torso", index = 3, listIndex = 1, type = "drawable", currentListIndex = 1, textureN = 0},
   -- {name = "Watches", index = 6, listIndex = 1, type = "prop", currentListIndex = 1, textureN = 0},
   -- {name = "Bracelets", index = 7, listIndex = 1, type = "prop", currentListIndex = 1, textureN = 0},
    {name = "Undershirt", index = 8, listIndex = 1, type = "drawable", currentListIndex = 1, textureN = 0},
    {name = "Legs", index = 4, listIndex = 1, type = "drawable", currentListIndex = 1, textureN = 0},
    {name = "Shoes", index = 6, listIndex = 1, type = "drawable", currentListIndex = 1, textureN = 0},
    {name = "Bags", index = 5, listIndex = 1, type = "drawable", currentListIndex = 1, textureN = 0},
    {name = "Vests", index = 9, listIndex = 1, type = "drawable", currentListIndex = 1, textureN = 0},
    --{name = "Accessories", index = 7, listIndex = 1, type = "drawable", currentListIndex = 1, textureN = 0},
    {name = "Badges", index = 10, listIndex = 1, type = "drawable", currentListIndex = 1, textureN = 0},
}

local currentMenu = 1
local menuOpen = false
local creatingInstructions = false

Citizen.CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())
        for i=1, #storeCoords do
            if #(playerCoords-storeCoords[i]) <= 1.5 and not menuOpen then 
                currentMenu = i
                menuOpen = true
                RageUI.Visible(RMenu:Get('newClothingShop', 'main'), true)
            elseif #(playerCoords-storeCoords[i]) > 1.5 and menuOpen and currentMenu == i then
                menuOpen = false
                clothingMenuOpen = false
                RageUI.Visible(RMenu:Get('newClothingShop', 'main'), false)
            end
        end
        Wait(150)
     end
end)

function AddBlip()
    for i = 1, #storeCoords do
        local blip = AddBlipForCoord(storeCoords[i])
        SetBlipSprite(blip, 73)
        SetBlipScale(blip, 1.0)
        SetBlipDisplay(blip, 2)
        SetBlipColour(blip, 2)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Clothing Store")
        EndTextCommandSetBlipName(blip)
    end
end

RMenu.Add('newClothingShop', 'main', RageUI.CreateMenu("Clothing Shop", "Clothing Shop", positionx, positiony))
RMenu:Get('newClothingShop', 'main')
RageUI.CreateWhile(1.0, RMenu:Get('newClothingShop', 'main'), nil, function()
    RageUI.IsVisible(RMenu:Get('newClothingShop', 'main'), true, false, true, function()
        clothingMenuOpen = true
        if setAllClothes then
            for i=1, #clothes, 1 do
                local cloth = clothes[i]
                currentCloth = cloth
                currentCloth.textureN = current_clothing(cloth.type, cloth.index, true)
                if currentCloth.textureN == -1 then
                    currentCloth.textureN = 0
                end
                RageUI.List(cloth.name, get_drawables(cloth.type, cloth.index), clothes[i].currentListIndex, "Texture Index: "..currentCloth.textureN.."/"..maxTextureID-1, {}, true, function(Hovered, Active, Selected, Index)
                    if Active then
                        clothes[i].currentListIndex = current_clothing(cloth.type, cloth.index, false)
                        if IsControlJustPressed(0, 172) or IsControlJustPressed(0, 241) or IsControlJustPressed(0, 173) or IsControlJustPressed(0, 242) then
                            if cloth.index ~= currentCloth.index then
                                currentCloth = cloth
                            end
                        end
                        if cloth.name == currentCloth.name then
                            local ped = PlayerPedId()
                            if typed then
                                if keyboard_result ~= nil and keyboard_result["id"] <= #get_drawables(cloth.type, cloth.index) and keyboard_result["id"] >= 0 then
                                    Index = keyboard_result["id"]
                                    currentCloth.textureN = 0
                                    typed = false
                                else
                                    typed = false
                                end
                            else
                                if currentCloth.textureN >= get_textures(currentCloth.type, currentCloth.index, Index) then
                                    currentCloth.textureN = 0
                                end
                                set_clothing(currentCloth.type, currentCloth.index, Index, currentCloth.textureN)
                            end
                            clothes[i].currentListIndex = Index
                        end
                    end
                    if Selected then
                        currentCloth.textureN = currentCloth.textureN + 1
                        if currentCloth.textureN >= get_textures(currentCloth.type, currentCloth.index, Index) then
                            currentCloth.textureN = 0
                        end
                        set_clothing(currentCloth.type, currentCloth.index, currentCloth.currentListIndex, currentCloth.textureN)
                        end
                    end, function() end, nil)  
                end
            end
        end, function()
    end)
end)

function current_clothing(type, index, texture)
    if type == "prop" then
        if texture then
            if GetPedPropTextureIndex(PlayerPedId(), index) ~= nil then
                return GetPedPropTextureIndex(PlayerPedId(), index)
            else
                return 0
            end
        else
            if GetPedPropIndex(PlayerPedId(), index) ~= nil then
                if GetPedPropIndex(PlayerPedId(), index) == -1 then
                    return GetPedPropIndex(PlayerPedId(), index)+2
                else
                    return GetPedPropIndex(PlayerPedId(), index)+1
                end
            else
                return 0
            end
        end
    elseif type == "drawable" then
        if texture then
            if GetPedTextureVariation(PlayerPedId(), index) ~= nil then
                return GetPedTextureVariation(PlayerPedId(), index)
            else
                return 0
            end
        else
            if GetPedDrawableVariation(PlayerPedId(), index) ~= nil then
                return GetPedDrawableVariation(PlayerPedId(), index)+1
            else
                return 0
            end
        end
    end
end

function set_clothing(class, type, index, textureIndex)
    local ped = PlayerPedId()
    if class == "drawable" then
        SetPedComponentVariation(ped, type, index-1, textureIndex, 0)
    elseif class == "prop" then
        SetPedPropIndex(ped, type, index-1, textureIndex, 0)
    end
end

function get_drawables(class, type)
    local ped = PlayerPedId()
    local maxDrawableVariations = GetNumberOfPedDrawableVariations(ped, type)
    local maxPropVariations = GetNumberOfPedPropDrawableVariations(ped, type)
    
    if class == "drawable" then
        local numberOfDrawableVariations = {"0/"..maxDrawableVariations}
        for i=1, GetNumberOfPedDrawableVariations(ped, type), 1 do
            numberOfDrawableVariations[#numberOfDrawableVariations+1] = (i.."/"..maxDrawableVariations)
        end
        return numberOfDrawableVariations
    else
        local numberOfDrawableVariations = {"0/"..maxPropVariations}
        for i=1, GetNumberOfPedPropDrawableVariations(ped, type), 1 do
            numberOfDrawableVariations[#numberOfDrawableVariations+1] = (i.."/"..maxPropVariations)
        end
        return numberOfDrawableVariations
    end
end

function get_facial_features(type)
    numberOfOverlays = {}

    for i=1, GetPedHeadOverlayNum(type), 1 do
        table.insert(numberOfOverlays, i)
    end

    return numberOfOverlays
end

function get_textures(class, type, index)
    if class == "drawable" then
        if type == 2 then
            return GetNumHairColors()
        end
        maxTextureID = GetNumberOfPedTextureVariations(PlayerPedId(), type, index-1)
        return maxTextureID
    else
        maxTextureID = GetNumberOfPedPropTextureVariations(PlayerPedId(), type, index-1)
        return maxTextureID
    end
end

Citizen.CreateThread(function()
    while true do 
        Wait(0)
        for i,v in pairs(skinshops) do 
            local x,y,z = v[2], v[3], v[4]
            if not HasStreamedTextureDictLoaded("clothing") then
				RequestStreamedTextureDict("clothing", true)
				while not HasStreamedTextureDictLoaded("clothing") do
					Wait(1)
				end
			else
			    DrawMarker(9, x, y, z, 0.0, 0.0, 0.0, 90.0, 0.0, 0.0, 1.0, 1.0, 1.0, 51, 153, 255, 1.0,false, false, 2, true, "clothing", "clothing", false)
            end 
        end 
    end
end)

function set_clothing_id()
    AddTextEntry('FMMC_MPM_NA', "Enter clothing ID you want to wear")
	DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter clothing ID you want to wear", "", "", "", "", 30)
    while (UpdateOnscreenKeyboard() == 0) do
        Wait(0)
    end
    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        if result then
            isKeyboardOpen = false
            local id = tonumber(result)
            local ped = PlayerPedId()
            if id ~= nil then
                keyboard_result["id"] = id+1
            else
                keyboard_result["id"] = currentCloth.index
            end
            typed = true
            
			return result
		end
    end
	isKeyboardOpen = false
end

Citizen.CreateThread(function()
    for i=1, #clothes, 1 do
        clothes[i].currentListIndex = current_clothing(clothes[i].type, clothes[i].index, false)
        clothes[i].textureN = current_clothing(clothes[i].type, clothes[i].index, true)
    end
    setAllClothes = true
    Wait(15000)
end)

function drawSkinInstructionKeys()
    local buttonsToDraw = {
        {
            ["label"] = "Enter Clothing ID ",
            ["button"] = "~INPUT_CELLPHONE_EXTRA_OPTION~"
        },
        {
            ["label"] = "Change Texture ",
            ["button"] = "~INPUT_CELLPHONE_SELECT~"
        },
        {
            ["label"] = "Next Index ",
            ["button"] = "~INPUT_CELLPHONE_RIGHT~"
        },
        {
            ["label"] = "Previous Index ",
            ["button"] = "~INPUT_CELLPHONE_LEFT~"
        }
    }

    Citizen.CreateThread(function()
        Wait(0)
        local instructionScaleform = RequestScaleformMovie("instructional_buttons")

        while not HasScaleformMovieLoaded(instructionScaleform) do
            Wait(0)
        end

        PushScaleformMovieFunction(instructionScaleform, "CLEAR_ALL")
        PushScaleformMovieFunction(instructionScaleform, "TOGGLE_MOUSE_BUTTONS")
        PushScaleformMovieFunctionParameterBool(0)
        PopScaleformMovieFunctionVoid()

        for buttonIndex, buttonValues in ipairs(buttonsToDraw) do
            PushScaleformMovieFunction(instructionScaleform, "SET_DATA_SLOT")
            PushScaleformMovieFunctionParameterInt(buttonIndex - 1)

            PushScaleformMovieMethodParameterButtonName(buttonValues["button"])
            PushScaleformMovieFunctionParameterString(buttonValues["label"])
            PopScaleformMovieFunctionVoid()
        end

        PushScaleformMovieFunction(instructionScaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
        PushScaleformMovieFunctionParameterInt(-1)
        PopScaleformMovieFunctionVoid()
        while clothingMenuOpen do
            Wait(0)
            DrawScaleformMovieFullscreen(instructionScaleform, 255, 255, 255, 255)
        end
        creatingInstructions = false
    end)
end

Citizen.CreateThread(function() 
    while true do
        if currentCloth.index ~= nil and RageUI.Visible(RMenu:Get('newClothingShop', 'main')) then 
            if IsControlJustPressed(0, 179) and not isKeyboardOpen then
                isKeyboardOpen = true
                set_clothing_id()
            end
        end 
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        if clothingMenuOpen and not creatingInstructions then
            drawSkinInstructionKeys()
            creatingInstructions = true
        end
        Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k,v in pairs(storeCoords) do
            DrawMarker(25, v.x, v.y, v.z-0.99, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 51, 51, 255, 155, 0, 0, 0, 0, 0, 0, 0)
        end
    end
end)

Citizen.CreateThread(AddBlip)