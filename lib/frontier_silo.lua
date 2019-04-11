-- frontier_silo.lua
-- Jan 2018
-- My take on frontier silos for my Oarc scenario

require("config")
require("lib/oarc_utils")

--------------------------------------------------------------------------------
-- Frontier style rocket silo stuff
--------------------------------------------------------------------------------

-- This creates a random silo position, stored to global.siloPosition
-- It uses the config setting global.ocfg.frontier_silo_distance and spawns the
-- silo somewhere on a circle edge with radius using that distance.
function SetRandomSiloPosition(num_silos)
    if (global.siloPosition == nil) then

        global.siloPosition = {}

        random_angle_offset = math.random(0, math.pi * 2)

        for i=1,num_silos do
            theta = ((math.pi * 2) / num_silos);
            angle = (theta * i) + random_angle_offset;

            tx = (global.ocfg.frontier_silo_distance*CHUNK_SIZE * math.cos(angle))
            ty = (global.ocfg.frontier_silo_distance*CHUNK_SIZE * math.sin(angle))

            table.insert(global.siloPosition, {x=math.floor(tx), y=math.floor(ty)})

            log("Silo position: " .. tx .. ", " .. ty .. ", " .. angle)
        end
    end
end

-- Sets the global.siloPosition var to the set in the config file
function SetFixedSiloPosition(pos)
    table.insert(global.siloPosition, pos)
end

-- Create a rocket silo at the specified positionmmmm
-- Also makes sure tiles and entities are cleared if required.
local function CreateRocketSilo(surface, siloPosition, force)

    -- Delete any entities beneath the silo?
    for _, entity in pairs(surface.find_entities_filtered{area = {{siloPosition.x-5,
                                                                    siloPosition.y-6},
                                                                    {siloPosition.x+6,
                                                                    siloPosition.y+6}}}) do
        entity.destroy()
    end

    -- Remove nearby enemies again
    for _, entity in pairs(surface.find_entities_filtered{area = {{siloPosition.x-(CHUNK_SIZE*4),
                                                                    siloPosition.y-(CHUNK_SIZE*4)},
                                                                    {siloPosition.x+(CHUNK_SIZE*4),
                                                                    siloPosition.y+(CHUNK_SIZE*4)}}, force = "enemy"}) do
        entity.destroy()
    end

    -- Set tiles below the silo
    tiles = {}
    i = 1
    for dx = -5,5 do
        for dy = -5,5 do
            tiles[i] = {name = "concrete", position = {siloPosition.x+dx, siloPosition.y+dy}}
            i=i+1
        end
    end
    surface.set_tiles(tiles, true)

    -- Create indestructible silo and assign to a force
    local silo = surface.create_entity{name = "rocket-silo", position = {siloPosition.x+0.5, siloPosition.y}, force = force}
    silo.destructible = false
    silo.minable = false

    -- TAG it on the main force at least.
    game.forces[global.ocfg.main_force].add_chart_tag(game.surfaces[GAME_SURFACE_NAME],
                                            {position=siloPosition, text="Rocket Silo",
                                                icon={type="item",name="rocket-silo"}})

    -- Make silo safe from being removed by regrowth
    -- if global.ocfg.enable_regrowth then
        OarcRegrowthOffLimits(siloPosition, 5)
    -- end


    if ENABLE_SILO_BEACONS then
        PhilipsBeacons(surface, siloPosition, game.forces[global.ocfg.main_force])
    end
    if ENABLE_SILO_RADAR then
        PhilipsRadar(surface, siloPosition, game.forces[global.ocfg.main_force])
    end
        
end

-- Generates all rocket silos, should be called after the areas are generated
-- Includes a crop circle
function GenerateAllSilos(surface)                       
    
    -- Create each silo in the list
    for idx,siloPos in pairs(global.siloPosition) do
        CreateRocketSilo(surface, siloPos, global.ocfg.main_force)
    end
end

-- Generate clean land and trees around silo area on chunk generate event
function GenerateRocketSiloChunk(event)

    -- Silo generation can take awhile depending on the number of silos.
    if (game.tick < global.ocfg.frontier_silo_count*10*TICKS_PER_SECOND) then
        local surface = event.surface
        local chunkArea = event.area

        local chunkAreaCenter = {x=chunkArea.left_top.x+(CHUNK_SIZE/2),
                                 y=chunkArea.left_top.y+(CHUNK_SIZE/2)}
        
        for idx,siloPos in pairs(global.siloPosition) do
            local safeArea = {left_top=
                                {x=siloPos.x-(CHUNK_SIZE*4),
                                 y=siloPos.y-(CHUNK_SIZE*4)},
                              right_bottom=
                                {x=siloPos.x+(CHUNK_SIZE*4),
                                 y=siloPos.y+(CHUNK_SIZE*4)}}
                                     

            -- Clear enemies directly next to the rocket
            if CheckIfInArea(chunkAreaCenter,safeArea) then
                for _, entity in pairs(surface.find_entities_filtered{area = chunkArea, force = "enemy"}) do
                    entity.destroy()
                end

                -- Remove trees/resources inside the spawn area
                RemoveInCircle(surface, chunkArea, "tree", siloPos, global.ocfg.spawn_config.gen_settings.land_area_tiles+5)
                RemoveInCircle(surface, chunkArea, "resource", siloPos, global.ocfg.spawn_config.gen_settings.land_area_tiles+5)
                RemoveInCircle(surface, chunkArea, "cliff", siloPos, global.ocfg.spawn_config.gen_settings.land_area_tiles+5)
                RemoveDecorationsArea(surface, chunkArea)

                -- Create rocket silo
                CreateCropOctagon(surface, siloPos, chunkArea, CHUNK_SIZE*2)
            end
        end
    end
end

-- Generate chunks where we plan to place the rocket silos.
function GenerateRocketSiloAreas(surface)
    for idx,siloPos in pairs(global.siloPosition) do
        if (global.ocfg.frontier_silo_vision) then
            ChartRocketSiloAreas(surface, game.forces[global.ocfg.main_force])
        end
        surface.request_to_generate_chunks({siloPos.x, siloPos.y}, 3)
    end
end

-- Chart chunks where we plan to place the rocket silos.
function ChartRocketSiloAreas(surface, force)
    for idx,siloPos in pairs(global.siloPosition) do
        force.chart(surface, {{siloPos.x-(CHUNK_SIZE*2),
                                siloPos.y-(CHUNK_SIZE*2)},
                                {siloPos.x+(CHUNK_SIZE*2),
                                siloPos.y+(CHUNK_SIZE*2)}})
    end
end

global.oarc_silos_generated = false
function DelayedSiloCreationOnTick(surface)

    -- Delay the creation of the silos so we place them on already generated lands.
    if (not global.oarc_silos_generated and (game.tick >= global.ocfg.frontier_silo_count*10*TICKS_PER_SECOND)) then
        log("Frontier silos generated!")
        global.oarc_silos_generated = true
        GenerateAllSilos(surface)
    end

end 


function PhilipsBeacons(surface, siloPos, force)

    -- Add Beacons
    -- x = right, left; y = up, down
    -- top 1 left 1
    local beacon = surface.create_entity{name = "beacon", position = {siloPos.x-8, siloPos.y-8}, force = force}
    beacon.destructible = false
    beacon.minable = false
    -- top 2
    local beacon = surface.create_entity{name = "beacon", position = {siloPos.x-5, siloPos.y-8}, force = force}
    beacon.destructible = false
    beacon.minable = false
    -- top 3
    local beacon = surface.create_entity{name = "beacon", position = {siloPos.x-2, siloPos.y-8}, force = force}
    beacon.destructible = false
    beacon.minable = false
    -- top 4
    local beacon = surface.create_entity{name = "beacon", position = {siloPos.x+2, siloPos.y-8}, force = force}
    beacon.destructible = false
    beacon.minable = false
    -- top 5
    local beacon = surface.create_entity{name = "beacon", position = {siloPos.x+5, siloPos.y-8}, force = force}
    beacon.destructible = false
    beacon.minable = false
    -- top 6 right 1
    local beacon = surface.create_entity{name = "beacon", position = {siloPos.x+8, siloPos.y-8}, force = force}
    beacon.destructible = false
    beacon.minable = false
    -- left 2
    local beacon = surface.create_entity{name = "beacon", position = {siloPos.x-8, siloPos.y-5}, force = force}
    beacon.destructible = false
    beacon.minable = false
    -- left 3
    local beacon = surface.create_entity{name = "beacon", position = {siloPos.x-8, siloPos.y-2}, force = force}
    beacon.destructible = false
    beacon.minable = false
    -- left 4
    local beacon = surface.create_entity{name = "beacon", position = {siloPos.x-8, siloPos.y+2}, force = force}
    beacon.destructible = false
    beacon.minable = false
    -- left 5
    local beacon = surface.create_entity{name = "beacon", position = {siloPos.x-8, siloPos.y+5}, force = force}
    beacon.destructible = false
    beacon.minable = false
    -- left 6 bottom 1
    local beacon = surface.create_entity{name = "beacon", position = {siloPos.x-8, siloPos.y+8}, force = force}
    beacon.destructible = false
    beacon.minable = false
    -- left 7 bottom 2
    local beacon = surface.create_entity{name = "beacon", position = {siloPos.x-5, siloPos.y+8}, force = force}
    beacon.destructible = false
    beacon.minable = false
    -- right 2
    local beacon = surface.create_entity{name = "beacon", position = {siloPos.x+8, siloPos.y-5}, force = force}
    beacon.destructible = false
    beacon.minable = false
    -- right 3
    local beacon = surface.create_entity{name = "beacon", position = {siloPos.x+8, siloPos.y-2}, force = force}
    beacon.destructible = false
    beacon.minable = false
    -- right 4
    local beacon = surface.create_entity{name = "beacon", position = {siloPos.x+8, siloPos.y+2}, force = force}
    beacon.destructible = false
    beacon.minable = false
    -- right 5
    local beacon = surface.create_entity{name = "beacon", position = {siloPos.x+8, siloPos.y+5}, force = force}
    beacon.destructible = false
    beacon.minable = false
    -- right 6 bottom 3
    local beacon = surface.create_entity{name = "beacon", position = {siloPos.x+5, siloPos.y+8}, force = force}
    beacon.destructible = false
    beacon.minable = false
    -- right 7 bottom 4
    local beacon = surface.create_entity{name = "beacon", position = {siloPos.x+8, siloPos.y+8}, force = force}
    beacon.destructible = false
    beacon.minable = false
    -- substations
    -- top left
    local substation = surface.create_entity{name = "substation", position = {siloPos.x-5, siloPos.y-5}, force = force}
    substation.destructible = false
    substation.minable = false
    -- top right
    local substation = surface.create_entity{name = "substation", position = {siloPos.x+6, siloPos.y-5}, force = force}
    substation.destructible = false
    substation.minable = false
    -- bottom left
    local substation = surface.create_entity{name = "substation", position = {siloPos.x-5, siloPos.y+6}, force = force}
    substation.destructible = false
    substation.minable = false
    -- bottom right
    local substation = surface.create_entity{name = "substation", position = {siloPos.x+6, siloPos.y+6}, force = force}
    substation.destructible = false
    substation.minable = false

    -- end adding beacons
end

function PhilipsRadar(surface, siloPos, force)
    
    local radar = surface.create_entity{name = "solar-panel", position = {siloPos.x-43, siloPos.y+3}, force = force}
    radar.destructible = false
    local radar = surface.create_entity{name = "solar-panel", position = {siloPos.x-43, siloPos.y-3}, force = force}
    radar.destructible = false
    local radar = surface.create_entity{name = "solar-panel", position = {siloPos.x-40, siloPos.y-6}, force = force}
    radar.destructible = false
    local radar = surface.create_entity{name = "solar-panel", position = {siloPos.x-37, siloPos.y-6}, force = force}
    radar.destructible = false
    local radar = surface.create_entity{name = "solar-panel", position = {siloPos.x-34, siloPos.y-6}, force = force}
    radar.destructible = false
    local radar = surface.create_entity{name = "solar-panel", position = {siloPos.x-34, siloPos.y-3}, force = force}
    radar.destructible = false
    local radar = surface.create_entity{name = "solar-panel", position = {siloPos.x-34, siloPos.y}, force = force}
    radar.destructible = false
    local radar = surface.create_entity{name = "solar-panel", position = {siloPos.x-34, siloPos.y+3}, force = force}
    radar.destructible = false
    local radar = surface.create_entity{name = "solar-panel", position = {siloPos.x-43, siloPos.y-6}, force = force}
    radar.destructible = false
    local radar = surface.create_entity{name = "solar-panel", position = {siloPos.x-40, siloPos.y+3}, force = force}
    radar.destructible = false
    local radar = surface.create_entity{name = "solar-panel", position = {siloPos.x-37, siloPos.y+3}, force = force}
    radar.destructible = false
    local radar = surface.create_entity{name = "radar", position = {siloPos.x-43, siloPos.y}, force = force}
    radar.destructible = false
    local substation = surface.create_entity{name = "substation", position = {siloPos.x-38, siloPos.y-1}, force = force}
    substation.destructible = false
    local radar = surface.create_entity{name = "accumulator", position = {siloPos.x-40, siloPos.y-1}, force = force}
    radar.destructible = false
    local radar = surface.create_entity{name = "accumulator", position = {siloPos.x-40, siloPos.y-3}, force = force}
    radar.destructible = false
    local radar = surface.create_entity{name = "accumulator", position = {siloPos.x-40, siloPos.y+1}, force = force}
    radar.destructible = false
    local radar = surface.create_entity{name = "accumulator", position = {siloPos.x-38, siloPos.y-3}, force = force}
    radar.destructible = false
    local radar = surface.create_entity{name = "accumulator", position = {siloPos.x-38, siloPos.y+1}, force = force}
    radar.destructible = false
    local radar = surface.create_entity{name = "accumulator", position = {siloPos.x-36, siloPos.y-1}, force = force}
    radar.destructible = false
    local radar = surface.create_entity{name = "accumulator", position = {siloPos.x-36, siloPos.y-3}, force = force}
    radar.destructible = false
    local radar = surface.create_entity{name = "accumulator", position = {siloPos.x-36, siloPos.y+1}, force = force}
    radar.destructible = false
end