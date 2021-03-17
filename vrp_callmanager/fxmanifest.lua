fx_version 'adamant'
games { 'gta5' }

description "FRG FiveM Server"

dependencies {
  "Design",
}

client_scripts {
    "@Design/src/RMenu.lua",
    "@Design/src/menu/RageUI.lua",
    "@Design/src/menu/Menu.lua",
    "@Design/src/menu/MenuController.lua",
    "@Design/src/components/Audio.lua",
    "@Design/src/components/Rectangle.lua",
    "@Design/src/components/Screen.lua",
    "@Design/src/components/Sprite.lua",
    "@Design/src/components/Text.lua",
    "@Design/src/components/Visual.lua",
    "@Design/src/menu/elements/ItemsBadge.lua",
    "@Design/src/menu/elements/ItemsColour.lua",
    "@Design/src/menu/elements/PanelColour.lua",
    "@Design/src/menu/items/UIButton.lua",
    "@Design/src/menu/items/UICheckBox.lua",
    "@Design/src/menu/items/UIList.lua",
    "@Design/src/menu/items/UIProgress.lua",
    "@Design/src/menu/items/UISlider.lua",
    "@Design/src/menu/items/UISliderHeritage.lua",
    "@Design/src/menu/items/UISliderProgress.lua",
    "@Design/src/menu/panels/UIColourPanel.lua",
    "@Design/src/menu/panels/UIGridPanel.lua",
    "@Design/src/menu/panels/UIGridPanelHorizontal.lua",
    "@Design/src/menu/panels/UIPercentagePanel.lua",
    "@Design/src/menu/panels/UIStatisticsPanel.lua",
    "@Design/src/menu/windows/UIHeritage.lua",
    "lib/Tunnel.lua",
    "lib/Proxy.lua",
    "cl_callmenu.lua",
}

server_scripts {
    "@vrp/lib/utils.lua",
    '@mysql-async/lib/MySQL.lua',
    "sv_callmenu.lua",
}


client_script '@ac/main.lua'
