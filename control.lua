-- control.lua
-- Mar 2019

-- Oarc's Separated Spawn Scenario
--
-- I wanted to create a scenario that allows you to spawn in separate locations
-- From there, I ended up adding a bunch of other minor/major features
--
-- Credit:
--  Tags - Taken from WOGs scenario
--  Rocket Silo - Taken from Frontier as an idea
--
-- Feel free to re-use anything you want. It would be nice to give me credit
-- if you can.



-- To keep the scenario more manageable (for myself) I have done the following:
--      1. Keep all event calls in control.lua (here)
--      2. Put all config options in config.lua and provided an example-config.lua file too.
--      3. Put other stuff into their own files where possible.
--      4. Put all other files into lib folder
--      5. Provided an examples folder for example/recommended map gen settings


-- Generic Utility Includes
require("lib/oarc_utils")

-- Other soft-mod type features.
require("lib/frontier_silo")
require("lib/tag")
require("lib/game_opts")
require("lib/player_list")
require("lib/rocket_launch")
require("lib/admin_commands")

-- For Philip. I currently do not use this and need to add proper support for
-- commands like this in the future.
-- require("lib/rgcommand")
-- require("lib/helper_commands")

-- Main Configuration File
require("config")

-- Save all config settings to global table.
require("lib/oarc_global_cfg.lua")

-- Scenario Specific Includes
require("lib/separate_spawns")
require("lib/separate_spawns_guis")

require("lib/oarc_gui_tabs")

-- OARC ENEMIES
require("oe/oarc_enemies_defines")
require("oe/oarc_enemies_evo")
require("oe/oarc_enemies")
require("oe/oarc_enemies_gui")
require("oe/oarc_enemies_tick_logic")


-- Create a new surface so we can modify map settings at the start.
GAME_SURFACE_NAME="oarc"


--------------------------------------------------------------------------------
-- ALL EVENT HANLDERS ARE HERE IN ONE PLACE!
--------------------------------------------------------------------------------

----------------------------------------
-- On Init - only runs once the first
--   time the game starts
----------------------------------------
script.on_init(function(event)
    InitOarcEnemies() -- Setup global tables and such

    -- FIRST
    InitOarcConfig()

    -- Create new game surface
    CreateGameSurface()

    -- MUST be before other stuff, but after surface creation.
    InitSpawnGlobalsAndForces()

    -- Frontier Silo Area Generation
    if (global.ocfg.frontier_rocket_silo) then
        SpawnSilosAndGenerateSiloAreas()
    end

    -- Everyone do the shuffle. Helps avoid always starting at the same location.
    global.vanillaSpawns = FYShuffle(global.vanillaSpawns)
    log("Vanilla spawns:")
    log(serpent.block(global.vanillaSpawns))
end)


----------------------------------------
-- Rocket launch event
-- Used for end game win conditions / unlocking late game stuff
----------------------------------------
script.on_event(defines.events.on_rocket_launched, function(event)
    OarcEnemiesRocketLaunched(event)
    if global.ocfg.frontier_rocket_silo then
        RocketLaunchEvent(event)
    end
end)


----------------------------------------
-- Chunk Generation
----------------------------------------
script.on_event(defines.events.on_chunk_generated, function(event)
    OarcEnemiesChunkGenerated(event)

    if global.ocfg.enable_undecorator then
        UndecorateOnChunkGenerate(event)
    end

    if global.ocfg.frontier_rocket_silo then
        GenerateRocketSiloChunk(event)
    end

    SeparateSpawnsGenerateChunk(event)

    CreateHoldingPen(event.surface, event.area, 16, 32)
end)


----------------------------------------
-- Gui Click
----------------------------------------
script.on_event(defines.events.on_gui_click, function(event)
    -- Don't interfere with other mod related stuff.
    if (event.element.get_mod() ~= nil) then return end

    OarcEnemiesGuiClick(event)

    if global.ocfg.enable_tags then
        TagGuiClick(event)
    end

    if global.ocfg.enable_player_list then
        PlayerListGuiClick(event)
    end

    WelcomeTextGuiClick(event)
    SpawnOptsGuiClick(event)
    SpawnCtrlGuiClick(event)
    SharedSpwnOptsGuiClick(event)
    BuddySpawnOptsGuiClick(event)
    BuddySpawnWaitMenuClick(event)
    BuddySpawnRequestMenuClick(event)
    SharedSpawnJoinWaitMenuClick(event)

    ClickOarcGuiButton(event)

    GameOptionsGuiClick(event)
end)

script.on_event(defines.events.on_gui_checked_state_changed, function (event)
    SpawnOptsRadioSelect(event)
    SpawnCtrlGuiOptionsSelect(event)
end)

script.on_event(defines.events.on_gui_selected_tab_changed, function (event)
    TabChangeOarcGui(event)
end)

----------------------------------------
-- Player Events
----------------------------------------
script.on_event(defines.events.on_player_joined_game, function(event)
    PlayerJoinedMessages(event)
    ServerWriteFile("player_events", game.players[event.player_index].name .. " joined the game." .. "\n")
end)

script.on_event(defines.events.on_player_created, function(event)
    OarcEnemiesPlayerCreatedEvent(event)

    local player = game.players[event.player_index]

    -- Move the player to the game surface immediately.
    player.teleport({x=0,y=0}, GAME_SURFACE_NAME)

    if global.ocfg.enable_long_reach then
        GivePlayerLongReach(player)
    end

    SeparateSpawnsPlayerCreated(event.player_index)

    InitOarcGuiTabs(player)
    OarcEnemiesCreateGui(event)
end)

script.on_event(defines.events.on_player_removed, function(event)
    OarcEnemiesPlayerRemovedEvent(event)
end)

script.on_event(defines.events.on_player_respawned, function(event)
    SeparateSpawnsPlayerRespawned(event)

    PlayerRespawnItems(event)

    if global.ocfg.enable_long_reach then
        GivePlayerLongReach(game.players[event.player_index])
    end
end)

script.on_event(defines.events.on_player_left_game, function(event)
    ServerWriteFile("player_events", game.players[event.player_index].name .. " left the game." .. "\n")
    FindUnusedSpawns(game.players[event.player_index], true)
end)

----------------------------------------
-- On BUILD entity. Don't forget on_robot_built_entity too!
----------------------------------------
script.on_event(defines.events.on_built_entity, function(event)
    OarcEnemiesTrackBuildings(event.created_entity)
    if global.ocfg.enable_autofill then
        Autofill(event)
    end

    if ENABLE_ANTI_GRIEFING then
        SetItemBlueprintTimeToLive(event)
    end

    if global.ocfg.frontier_rocket_silo then
        BuildSiloAttempt(event)
    end

end)


----------------------------------------
-- On script_raised_built. This should help catch mods that
-- place items that don't count as player_built and robot_built.
-- Specifically FARL.
----------------------------------------
script.on_event(defines.events.script_raised_built, function(event)
    OarcEnemiesTrackBuildings(event.entity)
end)


----------------------------------------
-- On tick events. Stuff that needs to happen at regular intervals.
-- Delayed events, delayed spawns, ...
----------------------------------------
script.on_event(defines.events.on_tick, function(event)
    OarcEnemiesOnTick()
    TimeoutSpeechBubblesOnTick()

    DelayedSpawnOnTick()

    if global.ocfg.frontier_rocket_silo then
        DelayedSiloCreationOnTick(game.surfaces[GAME_SURFACE_NAME])
    end

end)


----------------------------------------
-- Robots man!?
----------------------------------------
script.on_event(defines.events.on_robot_built_entity, function (event)
    OarcEnemiesTrackBuildings(event.created_entity)
    if global.ocfg.frontier_rocket_silo then
        BuildSiloAttempt(event)
    end
end)


----------------------------------------
-- Shared chat, so you don't have to type /s
-- But you do lose your player colors across forces.
----------------------------------------
script.on_event(defines.events.on_console_chat, function(event)
    if (event.player_index) then
        ServerWriteFile("server_chat", game.players[event.player_index].name .. ": " .. event.message .. "\n")
    end
    if (global.ocfg.enable_shared_chat) then
        if (event.player_index ~= nil) then
            ShareChatBetweenForces(game.players[event.player_index], event.message)
        end
    end
end)

----------------------------------------
-- On Research Finished
-- This is where you can permanently remove researched techs
----------------------------------------
script.on_event(defines.events.on_research_finished, function(event)
   OarcEnemiesResearchFinishedEvent(event)

    -- Never allows players to build rocket-silos in "frontier" mode.
    if global.ocfg.frontier_rocket_silo and not global.ocfg.frontier_allow_build then
        RemoveRecipe(event.research.force, "rocket-silo")
    end

    if global.ocfg.lock_goodies_rocket_launch and
        (not global.satellite_sent or not global.satellite_sent[event.research.force.name]) then
        RemoveRecipe(event.research.force, "productivity-module-3")
        RemoveRecipe(event.research.force, "speed-module-3")
    end

    if global.ocfg.enable_loaders then
        EnableLoaders(event)
    end
end)

----------------------------------------
-- On Entity Spawned and On Biter Base Built
-- This is where I modify biter spawning based on location and other factors.
----------------------------------------
script.on_event(defines.events.on_entity_spawned, function(event)
    event.entity.destroy()
    -- if (global.ocfg.modified_enemy_spawning) then
    --     ModifyEnemySpawnsNearPlayerStartingAreas(event)
    -- end
end)
script.on_event(defines.events.on_biter_base_built, function(event)
    OarcEnemiesBiterBaseBuilt(event)
    if (global.ocfg.modified_enemy_spawning) then
        ModifyEnemySpawnsNearPlayerStartingAreas(event)
    end
end)

----------------------------------------
-- On Corpse Timed Out
-- Save player's stuff so they don't lose it if they can't get to the corpse fast enough.
----------------------------------------
script.on_event(defines.events.on_character_corpse_expired, function(event)
    DropGravestoneChestFromCorpse(event.corpse)
end)

script.on_event(defines.events.on_entity_died, function(event)
    OarcEnemiesEntityDiedEvent(event)
end)
script.on_event(defines.events.on_unit_removed_from_group, function(event)
    OarcEnemiesUnitRemoveFromGroupEvent(event)
end)
script.on_event(defines.events.on_ai_command_completed, function(event)
    -- log("AI cmd completed? " .. event.unit_number .. " : " .. event.result .. " " .. game.tick)
    if (event.result == defines.behavior_result.fail) then
        OarcEnemiesGroupCmdFailed(event)
    end
end)
script.on_event(defines.events.on_script_path_request_finished, function(event)
    ProcessAttackCheckPathComplete(event)
end)

script.on_event(defines.events.on_force_created, function(event)
    OarcEnemiesForceCreated(event)
end)

script.on_event(defines.events.on_sector_scanned, function (event)
    OarcEnemiesSectorScanned(event)
end)