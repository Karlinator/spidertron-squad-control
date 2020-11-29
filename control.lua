--[[ Copyright (c) 2020 npc_strider
 * For direct use of code or graphics, credit is appreciated. See LICENSE.txt for more information.
 * This mod may contain modified code sourced from base/core Factorio
 * 
 * control.lua
 * Spiderbot.
--]]

require("util")

require("constants")
require("control.debug")
-- REMEMBER TO COMMENT DEBUG OUT IN RELEASE!!
-- REMEMBER TO COMMENT DEBUG OUT IN RELEASE!!
-- REMEMBER TO COMMENT DEBUG OUT IN RELEASE!!
-- REMEMBER TO COMMENT DEBUG OUT IN RELEASE!!
-- REMEMBER TO COMMENT DEBUG OUT IN RELEASE!!
require("control.gui")
require("control.init")
require("control.remote")
require("control.give_remote")
require("control.player_select")
require("control.player_man_designate")
require("control.player_follow")
require("control.entity_follow")
require("control.functions")
-- require("control.select")

------------------------------------------------------------------------
-- EVENTS
------------------------------------------------------------------------

-- Follow
script.on_event("squad-spidertron-follow", function(event)
    -- squad_leader_state(event.player_index)
    SpiderbotFollow(game.players[event.player_index])
end)

-- link tool
script.on_event("squad-spidertron-link-tool", function(event)
    local index = event.player_index
    local settings = settings.get_player_settings(game.players[index])
    GiveLinkTool(index, settings)
end)

script.on_event("squad-spidertron-remote", function(event)
    local index = event.player_index
    local settings = settings.get_player_settings(game.players[index])
    GiveSquadTool(index, settings)
end)

script.on_event("squad-spidertron-list", function(event)
    ToggleGuiList(event.player_index)
end)

script.on_event(defines.events.on_lua_shortcut, function(event)
    local index = event.player_index
    local settings = settings.get_player_settings(game.players[index])
    local name = event.prototype_name
    if name == "squad-spidertron-remote" then
        GiveSquadTool(index, settings)
    elseif name == "squad-spidertron-link-tool" then
        GiveLinkTool(index, settings)
    elseif name == "squad-spidertron-follow" then
        -- squad_leader_state(index)
        SpiderbotFollow(game.players[index])
    elseif name == "squad-spidertron-list" then
        ToggleGuiList(index)
    end
end)

script.on_nth_tick(settings.global["spidertron-follow-update-interval"].value, function(event)
    UpdateFollow()
    UpdateFollowEntity()
end)
script.on_nth_tick(settings.global["spidertron-gui-update-interval"].value, function(event)
    for _, player in pairs(game.players) do
        UpdateGuiList(player)
    end
end)


-- script.on_event(defines.events.on_spider_command_completed, function (event)
--     game.print(game.tick)
-- end)

script.on_load(function()
    SpidertronWaypointsCompatibility()
end)
