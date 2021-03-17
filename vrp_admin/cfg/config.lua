cfg = {}

cfg.key = 289

cfg.perm = "admin.menu"
cfg.IgnoreButtonPerms = false

cfg.admins_cant_ban_admins = false


--[[ {enabled -- true or false}, permission required ]]
cfg.buttonsEnabled = {

    --[[ admin Menu ]]
    ["adminMenu"] = {true, "admin.menu"},
    ["warn"] = {true, "admin.warn"},      
    ["showwarn"] = {true, "admin.showwarn"},
    ["ban"] = {true, "admin.ban"},
    ["kick"] = {true, "admin.kick"},
    ["nof10kick"] = {true, "admin.nof10kick"},
    ["revive"] = {true, "admin.revive"},
    ["TP2"] = {true, "admin.tp2player"},
    ["TP2ME"] = {true, "admin.summon"},
    ["FREEZE"] = {true, "admin.freeze"},
    ["spectate"] = {true, "admin.spectate"}, 
    ["SS"] = {true, "admin.screenshot"},
    ["slap"] = {true, "admin.slap"},
    ["giveMoney"] = {true, "admin.givemoney"},

    --[[ Functions ]]
    ["tp2waypoint"] = {true, "admin.tp2waypoint"},
    ["tp2coords"] = {true, "admin.tp2coords"},
    ["removewarn"] = {true, "admin.removewarn"},
    ["spawnBmx"] = {true, "admin.spawnBmx"},

    --[[ Add Groups ]]
    ["getgroups"] = {true, "admin.getgroups"},
    ["staffGroups"] = {true, "admin.staffAddGroups"},
    ["nhsGroups"] = {true, "admin.nhsAddGroups"},
    ["mpdGroups"] = {true, "admin.mpdAddGroups"},
    ["casinoGroups"] = {true, "admin.casinoAddGroups"},


    --[[ Developer ]]
    ["devMenu"] = {true, "dev.menu"},
    ["spawnCar"] = {true, "dev.spawncar"},
    ["spawnWeapon"] = {true, "dev.spawnweapon"},
    ["deleteCar"] = {true, "dev.deletecar"},
    ["fixCar"] = {true, "dev.fixcar"}
}

return cfg
