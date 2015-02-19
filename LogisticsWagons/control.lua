-- Debug functions needs to be in global scope to be able to be called from the classes

function debugLog(message)
	if false then -- set for debug
		game.player.print(math.floor(game.tick / 60) .. " : " .. message)
	end
end

--

module(..., package.seeall)
require "defines"
require "util"

require "class"
require "wagons.wagon"

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
	
	for i,wagon in pairs(glob.logisticWagons) do	
		debugLog("Loaded wagon: " .. i .. " - " .. serpent.dump(wagon))
		if wagon.wagonType == "Wagon" then
--			glob.sensors[i] = Wagon(asensor.parent,asensor)
		elseif wagon.wagonType == "PassiveWagon" then
--			glob.sensors[i] = PassiveWagon(asensor.parent,asensor)
		end
	end
end

function ontick(event)
--	debugLog("tick")
	for i,wagon in pairs(glob.logisticWagons) do	
--		debugLog("Checking sensor: " .. i .. " - " .. serpent.dump(asensor))
		wagon:updateWagon()
	end
end

function onbuiltentity(event)
	debugLog("Build event: " .. serpent.dump(event))
	local entity = event.createdentity
	if entity.name == "rail-sensor" then
		table.insert(glob.logisticWagons, Wagon(entity))
	elseif entity.name == "electrical-actuator" then
		table.insert(glob.logisticWagons, PassiveWagon(entity))
	end
end

function onentityremoved(event)
--	debugLog("Removal event: " .. serpent.dump(event))
	local entity = event.entity
	if isKnownEntity(entity.name) then
		debugLog("A wagon was removed!")
		local wagonPos = findWagonPosition(entity)
		debugLog("Wagon pos: "..wagonPos)
		local wagon = table.remove(glob.logisticWagons, wagonPos)
		debugLog("Wagon: " .. serpent.dump(wagon))
		wagon:remove()
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
end


