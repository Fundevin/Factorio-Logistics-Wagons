-- Debug functions needs to be in global scope to be able to be called from the classes

function debugLog(message)
	if true then -- set for debug
		game.player.print(math.floor(game.tick / 60) .. " : " .. message)
	end
end

--

module(..., package.seeall)
require "defines"
require "util"

require "wagons.wagon"
require "wagons.passiveWagon"

-- Initialisation
game.oninit(function() oninit() end)
game.onload(function() onload() end)

-- Entity was placed on map
game.onevent(defines.events.onbuiltentity, function(event) onbuiltentity(event) end)
game.onevent(defines.events.onrobotbuiltentity, function(event) onbuiltentity(event) end)

-- Entity item was removed from the map
game.onevent(defines.events.onentitydied, function(event) onentityremoved(event) end)
game.onevent(defines.events.onpreplayermineditem, function(event) onentityremoved(event) end)
game.onevent(defines.events.onrobotpremined, function(event) onentityremoved(event) end)

-- Main loop
game.onevent(defines.events.ontick, function(event) ontick(event) end)

function oninit()
	debugLog("init")
	glob.logisticWagons = glob.logisticWagons or {}
end

function onload()
	debugLog("load")
	glob.logisticWagons = glob.logisticWagons or {}
	
--	for i,wagon in pairs(glob.logisticWagons) do	
--		debugLog("Loaded wagon: " .. i .. " - " .. serpent.dump(wagon))
--		if wagon.wagonType == "Wagon" then
--			glob.sensors[i] = Wagon(wagon.parent,wagon)
--		elseif wagon.wagonType == "PassiveWagon" then
--			glob.sensors[i] = PassiveWagon(wagon.parent,wagon)
--		end
--	end
end

function ontick(event)
--	debugLog("tick")
	for i,wagon in pairs(glob.logisticWagons) do	
		wagon:updateWagon()
	end
end

function onbuiltentity(event)
	debugLog("Build event: " .. serpent.dump(event))
	local entity = event.createdentity
	if entity.name == "lw-cargo-wagon-passive" then
		local test = PassiveWagon:new(entity)
		table.insert(glob.logisticWagons, test)
	elseif entity.name == "lw-cargo-wagon-active" then
		table.insert(glob.logisticWagons, ActiveWagon:new(entity))
	elseif entity.name == "lw-cargo-wagon-requester" then
		table.insert(glob.logisticWagons, RequesterWagon:new(entity))
	elseif entity.name == "lw-cargo-wagon-storage" then
		table.insert(glob.logisticWagons, StorageWagon:new(entity))
	end
end

function onentityremoved(event)
--	debugLog("Removal event: " .. serpent.dump(event))
	local entity = event.entity
	if isKnownEntity(entity.name) then
		debugLog("A wagon was removed!")
		local wagonPos = findWagonPosition(entity)
		if wagonPos ~= nil then
			debugLog("Wagon pos: "..wagonPos)
			local wagon = table.remove(glob.logisticWagons, wagonPos)
			wagon:removeProxy()
		end
	end
end

function isKnownEntity(entity_name)
	if( glob.logisticWagonsEntityNames ~= nil and glob.logisticWagonsEntityNames[entity_name] ~= nil ) then
		return true
	end
end

function findWagonPosition(entity)
	for i,wagon in pairs(glob.logisticWagons) do	
		if(wagon.parent.equals(entity)) then
			return i
		end
	end
	
	return nil;
end


