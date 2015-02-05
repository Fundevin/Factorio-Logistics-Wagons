require "defines"
local wagonsInit = false

--THIS CAN BE CHANGE TO ONLY TICK IF THE WAGONS TABLE HAS STUFF IN IT.
game.onevent(defines.events.ontick, function(event)
	if wagonsInit == nil or wagonsInit == false then
		--game.player.clearconsole()
		
		debugLog("SETUP Start!!!!!!!!!!!!")
		wagonsInit = true
		apiWarning = false
		glob.apiVersion = getApiVersion()
		debugLog("API -- " .. glob.apiVersion)
		if glob.wagons ~= nil then
			glob.wagonsData = convertWagonsToWagonsData(glob.wagons)
			glob.wagons = nil
		end

		glob.wagonsData = initWagonsData(glob.wagonsData)
		debugLog("SETUP End!!!!!!!!!!!!")
	end
		
	if glob.wagonsData~=nil and event.tick %20 == 3 then
		glob.wagonsData = updateWagons(glob.wagonsData)
	end
	
	if glob.wagonsData ~= nile and event.tick ~= 1 then
		glob.wagonsData = updateProxyPositions(glob.wagonsData)
	end
end)

function updateWagons(wagonsData)
	local removeList = {}
	for i,wagonData in pairs(wagonsData) do
		--wagonCount = wagonCount + 1
		if wagonData ~= nil and wagonData.wagon ~= nil and wagonData.wagon.valid then
			wagonData = updateWagonPosition(wagonData)
			wagonData = updateWagonProxyPosition(wagonData)
			wagonData = processWagon(wagonData)
			wagonData = updateInventoryCount(wagonData)
			wagonData = updateRequestSlots(wagonData)
		else
			table.insert(removeList, 1, wagon)
		end
	end
	for i, wagon in ipairs(removeList) do
		removeWagonFromTable(wagonsData, wagon)
	end
	
	return wagonsData
end

function updateProxyPositions(wagonsData)
	local removeList = {}
	for i,wagonData in pairs(wagonsData) do
		--wagonCount = wagonCount + 1
		if wagonData ~= nil and wagonData.wagon ~= nil and wagonData.wagon.valid then
			wagonData = processWagon(wagonData)
			if wagonData.wagon.train ~= nil or wagonData.wagon.train.speed ~= 0 then
				-- Train is moving
				if wagonData["proxy"] ~= nil then
					moveProxies(wagonData["proxy"],wagonData.wagon)
				end
			end
		else
			table.insert(removeList, 1, wagon)			
		end
	end
	for i, wagon in ipairs(removeList) do
		removeWagonFromTable(wagonsData, wagon)
	end
	
	return wagonsData
end

game.onevent(defines.events.onentitydied, function(event)
	if isKnownWagon(event.entity.name) then
		removeWagonFromTable(glob.wagonsData, event.entity)
	end
end)

game.onevent(defines.events.onpreplayermineditem, function(event) -- THIS SHOULD BE THE SAME AS events.onentitydied - I should really create a new function...
	if isKnownWagon(event.entity.name) then
		removeWagonFromTable(glob.wagonsData, event.entity)
	end
end)

game.onevent(defines.events.onbuiltentity, function(event)
	if isKnownWagon(event.createdentity.name) then
		--event.createdentity.operable = false
		addWagonToTable(glob.wagonsData, event.createdentity)
	end
end)

game.onsave(function()
	for i, wagonData in pairs(glob.wagonsData) do
		if hasValidWagon(wagonData) then
			-- glob.wagonsData = updateWagons(glob.wagonsData)
			updateWagonPosition(wagonData)
			updateWagonProxyPosition(wagonData)
		end
	end
end)


function addWagonToTable(wagonsData, wagon) --, proxyPosition)
	if wagonsData==nil then
			wagonsData={}
	end
	
	if wagon ~= nil and wagon.valid then
		
		local newWagon = {}
		newWagon["wagon"] = wagon
		newWagon["position"] = wagon.position
		newWagon["proxy"] = findWagonProxies(wagon)
		if newWagon["proxy"] ~= nil and newWagon["proxy"][1] ~= nil and newWagon["proxy"][1].valid then
			newWagon["proxyPosition"] = newWagon["proxy"][1].position
		end
		if hasInventory(wagon) then
			local inventory = wagon.getinventory(1)
			newWagon["inventoryCount"] = inventory.getitemcount()
		end
		newWagon["requestSlots"] = {}
		
		table.insert(wagonsData, newWagon)
	end
	
	return wagonsData
end

function findWagonInTable(wagonsData, wagon)
	for i,wagonData in ipairs(wagonsData) do
		if wagonData.wagon ~= nil and wagon ~= nil and wagonData.wagon.equals(wagon) then
			return i
		end
	end
	return 0
end

function removeWagonFromTable(wagonsData, wagon)
	local loc = findWagonInTable(wagonsData, wagon)
	if loc == 0 then
		return
	end
	if wagonsData[loc] ~= nil then
		if wagonsData[loc]["proxy"]~= nil then
			for i,proxy in ipairs(wagonsData[loc]["proxy"]) do
				if proxy.valid then
					debugLog("Destroy Proxy: " .. proxy.name)
					proxy.destroy()
				end
			end
		end
	end
	table.remove(wagonsData, i)
	return wagons
end

function updateWagonPosition(wagonData)
	if hasValidWagon(wagonData) then
		wagonData["position"] = wagonData.wagon.position
	end
	return wagonData
end

function updateWagonProxyPosition(wagonData)
	if hasValidProxy(wagonData) then
		wagonData["proxyPosition"] = wagonData.proxy[1].position
	end
	return wagonData
end

function hasValidProxy(wagonData)
	if wagonData ~= nil and wagonData.proxy ~= nil and wagonData.proxy[1] ~= nil and wagonData.proxy[1].valid then
		return true
	end
	return false
end

function hasValidWagon(wagonData)
	if wagonData ~= nil and wagonData.wagon ~= nil and wagonData.wagon.valid then
		--debugLog("Valid: " .. wagonData.wagon.name)
		return true
	end
	return false
end

function updateInventoryCount(wagonData)
	--debugLog("updateInventoryCount()")
	if hasValidWagon(wagonData) and hasInventory(wagonData.wagon) then
			local inventory = wagonData.wagon.getinventory(1)
			wagonData["inventoryCount"] = inventory.getitemcount()
			--debugLog("count: " .. inventory.getitemcount())
	else
		wagonData["inventoryCount"] = -1
	end
	return wagonData
end

function updateRequestSlots(wagonData)
	if wagonData ~= nil and wagonData.proxy ~= nil and isRequester(wagonData.proxy[1]) then
		local i = 0
		local slots = {}
		while i < 10 do
			i = i + 1
			
			slots[i] = wagonData.proxy[1].getrequestslot(i)
			if slots[i] == nil then
				slots[i] = {}
			end
		end
		wagonData["requestSlots"] = slots
	end
	return wagonData
end

function setRequestSlots(proxy, requestSlots)
	if isRequester(proxy)then
		debugLog("Requester")
		local i = 0
		local slots = {}
		while i < 10 do
			i = i + 1
			local slot = requestSlots[i]
			if slot ~= nil and slot.name ~= nil then
				--if game.itemprototypes[slot.name] ~= nil then 
					--proxy.setrequestslot(slot, i)
				--end
			end
		end
	end
end

--Accesses glob.wagonsData
function findWagonDataFromEntity(entity)
	if entity ~= nil and entity.valid and glob.wagonsData ~= nil then
		for i,wagonData in ipairs(glob.wagonsData) do
			if wagonData ~= nil and wagonData.wagon ~= nil and wagonData.wagon.equals(entity) then
				return wagonData
			end
		end
	end
	return nil
end

function findWagonAtPosition(position)
	debugLog("Looking at x: " .. position.x .. " y: " .. position.y)
	--local cargoWagons = game.findentities{{position.x + 5, position.y - 5}, {position.x + 5, position.y + 5}}
	local cargoWagons = game.findentitiesfiltered{area = {{position.x - 1, position.y - 1}, {position.x + 1, position.y + 1}}} 
	for i,e in ipairs(cargoWagons) do
		debugLog("found " .. e.name)
		if e.valid then
			if isKnownWagon(e.name) then
				return e
			end
		end
	end
end

function findWagonProxies(wagon)
	debugLog("findProxy")
	if wagon ~= nil then
		if wagon.valid then
			debugLog("findProxy, wagon exists")
			wagonProxies = {}
			for i, proxyType in ipairs(getWagonProxyTypes(wagon)) do
				local foundProxies = game.findentitiesfiltered{area = {{wagon.position.x - 3, wagon.position.y - 3}, {wagon.position.x + 3, wagon.position.y + 3}}, name=proxyType} 
				for i,e in ipairs(foundProxies) do
					if e.valid then
						debugLog("Found Proxy!" .. e.name)
						table.insert(wagonProxies, e)
					end
				end
			end
			return wagonProxies
		end
	end
	return nil
end

function isKnownWagon(wagonName)
	if wagonName ~= nil then
		if wagonName == "cargo-wagon-passive" or wagonName == "cargo-wagon-active" 
			or wagonName == "cargo-wagon-storage" or wagonName == "cargo-wagon-requester" then
			return true
		end
	end
	return false
end

function getWagonProxyTypes(wagon)
	if wagon ~= nil then
		if wagon.valid then
			if wagon.name == "cargo-wagon-passive" then return {"logistic-chest-passive-provider-trans"}
			elseif wagon.name == "cargo-wagon-active" then return {"logistic-chest-active-provider-trans"}
			elseif wagon.name == "cargo-wagon-storage" then return {"logistic-chest-storage-provider-trans"}
			elseif wagon.name == "cargo-wagon-requester" then return {"logistic-chest-requester-trans"}
			end
			
			return "logistic-chest-passive-provider-trans" -- DEFAULT!
		end
	end
end

function rotatePoint(position, rotation)
	debugLog("POSITION X: " .. position.x .. " Y: " .. position.y)
	debugLog("ROTATION: " .. rotation)
	local radians = ((rotation * 2) - 1) * math.pi
	debugLog("RADIANS: " .. radians)
	local cosr = math.cos(radians)
	local sinr = math.sin(radians)
	
	local newPosition = {x = (position.x * cosr) - (position.y * sinr), y = (position.y * cosr) + (position.x * sinr)}
	--position.x = math.cos(radians) * position.x
	--position.y = math.sin(radians) * position.y
	return newPosition
end


function calculatePositionOfProxy(position, orientation, xScale, yScale, xShift, yShift, positionType) -- scale = {xscale,yscale}, positionType = "hidden","left","moving","right", shiftPosition - {xShift, yShift}
	local mod = (orientation - 0.25) % 1 
	
	if positionType ~= nil then
		debugLog("Not Moving")
		if positionType == "hidden" then
			if (orientation <= 1 and orientation > 0.5) or orientation == 0 then 
				mod = (orientation + 0.25) % 1 
			end
		elseif positionType == "left" then
			mod = (orientation + 0.25) % 1 
		elseif positionType == "moving" then
			if (orientation <= 1 and orientation > 0.5) or orientation == 0 then 
				mod = (mod + 0.5) % 1 
			end
		end
	end
	
	local transformedPosition = rotatePoint({x=0,y=1}, mod)
	
	local xMod = ( transformedPosition.x + xShift ) * xScale
	local yMod = ( transformedPosition.y + yShift )  * yScale
	
	if xMod < 0.001 and xMod > -0.001 then xMod = 0 end
	if yMod < 0.001 and yMod > -0.001 then yMod = 0 end
	
	return {x = position.x, y = position.y}
	--return {x = position.x + xMod, y = position.y + yMod}
end

function convertWagonsToWagonsData(wagons)
	local wagonsData = {}
	if wagons ~= nil then
		for wagon,value in pairs(wagons) do
			local newWagon = {}
			newWagon["wagon"] = wagon
			newWagon["position"] = value.position
			newWagon["proxy"] = value.proxy
			newWagon["inventoryCount"] = value.inventoryCount
			newWagon["requestSlots"] = value.requestSlots
			table.insert(wagonsData,newWagon)
		end
	end
	return wagonsData
end

function initWagonsData(wagonsData)
	local newWagons = {}

	if wagonsData ~= nil then
		for i, wagonData in ipairs(wagonsData) do
			local newValues = {}
			if wagonData.wagon.valid then
				debugLog("Wagon is valid " .. i)
				-- table.insert(newWagons,wadonData)
				addWagonToTable(newWagons, wagonData.wagon)
			else
				debugLog("Wagon is invalid. " .. i)
				if wagonData["position"] ~= nil then
					cleanOldProxies(wagonData.proxyPosition)
					local newWagon = findWagonAtPosition(wagonData["position"])
					if newWagon ~= nil and newWagon.valid then
						addWagonToTable(newWagons, newWagon)
						newWagons[i]["proxy"] = createProxies(newWagon, wagonData["requestSlots"])
						debugLog(newWagons[i]["proxy"])
					end
				end
			end
				
		end
	end
	return newWagons
end

function cleanOldProxies(position)
	if position ~= nil then
		local entities = game.findentities{{position.x-1, position.y-1}, {position.x+1, position.y+1}}
		for i, entity in ipairs(entities) do
			if entity ~= nil and entity.valid then
				debugLog("DESTROY PROXY FROM THE PAST! " .. entity.name)
				if endswith(entity.name, "-trans") then
					debugLog("DESTROY PROXY FROM THE PAST! " .. entity.name)
					entity.destroy()
				end
			end
					
		end
	end
end

function createProxies(wagon, requestSlots)
	local proxies = {}
	if wagon ~= nil and wagon.valid then
		debugLog("wagon has no proxies, creating...")
		local proxyTypes = getWagonProxyTypes(wagon)
		
		local proxyPosition = wagon.position --calculatePositionOfProxy(wagon.position, wagon.orientation, 1, 1, 0, 0, positionType) -- I should really use the inbuilt method...
		debugLog("**PROXY x: " .. proxyPosition.x .. " y: " .. proxyPosition.y)
		debugLog("**WAGON x: " .. wagon.position.x .. " y: " .. wagon.position.y)
		
		
		for i, proxyType in ipairs(proxyTypes) do
			if proxyPosition ~= nil then
				debugLog("x: " .. proxyPosition.x .. " y: " .. proxyPosition.y .. " o: " .. wagon.orientation .. " COUNT " .. i)
				createProxy(proxyType, proxyPosition)
				
				local foundProxies = findWagonProxies(wagon)
				for i, wagonProxy in ipairs(foundProxies) do
					debugLog("WagonProxyCount: " .. i)
					if wagonProxy ~= nil and wagonProxy.valid then
						debugLog("****** ProxyValid")
						if hasInventory(wagonProxy) then
							syncInventory(wagon, wagonProxy, -1)
						end
						
						if isRequester(wagonProxy) and requestSlots ~= nil then
							setRequestSlots(wagonProxy, requestSlots)
						end

						table.insert(proxies, wagonProxy)
					else
						debugLog("******** ProxyNotValid")
					end
				end
			end
		end
	end
	return proxies
end

function processWagon(wagonData)
	if hasValidWagon(wagonData) then
		if wagonData.wagon.train == nil or wagonData.wagon.train.speed == 0 then
			-- Wagons are unattached or train is stopped
			local proxyList = getWagonProxyTypes(wagonData.wagon)
			if wagonData["proxy"] == nil or wagonData["proxy"][1]==nil  then
				debugLog("why????")
				wagonData["proxy"] = createProxies(wagonData.wagon, wagonData["requestSlots"])
			elseif wagonData["proxy"][1] ~= nul and not wagonData["proxy"][1].valid then
				debugLog("Wagon has a proxy but it is invalid. WTF! time to destroy!") ------ NOOOOOOOOOOOOOOOOO BROKEN!
				wagonData["proxy"] = nil
			elseif wagonData["proxy"][1].name ~= proxyList[1] then
				debugLog("Wrong proxy: " .. wagonData["proxy"][1].name .. " != " .. proxyList[1])
				wagonData = syncAllState(wagonData)
				destroyProxies(wagonData["proxy"])
				wagonData["proxy"] = createProxies(wagonData.wagon, wagonData["requestSlots"])
			else
				wagonData = syncAllState(wagonData)
			end
		else
			-- Train is moving
			if wagonData["proxy"] ~= nil then
				wagonData = syncAllState(wagonData)
			end
		end
	end
	
	return wagonData
end

function isRequester(proxy)
	if proxy ~= nil and proxy.valid and proxy.name == "logistic-chest-requester-trans" then
		return true
	end
	return false
end

function syncAllState(wagonData)
	--debugLog("Sync State")
	for i,proxy in ipairs(wagonData["proxy"]) do
		if hasInventory(proxy) then
			--debugLog("SyncInventory: " .. wagonData.wagon.name)
			syncInventory(wagonData.wagon, proxy, wagonData.inventoryCount)
			wagonData = updateRequestSlots(wagonData)
		end
	end
	return wagonData
end

function clearInventory(entity, inventoryNumber)
	if hasInventory(entity, inventoryNumber) then
		local inv = entity.getinventory(1)
		for name, count in pairs(inv.getcontents()) do
			debugLog("Remove :" .. name .. " count: " .. count)
			inv.remove({name=name,count=count})
		end
	end
end

function hasInventory(proxy, inventoryNumber)
	if inventoryNumber == nil or inventoryNumber == 0 then
		inventoryNumber = 1
	end
	
	if proxy ~= nil and proxy.valid and pcall(function () proxy.getinventory(1) end) then
		return true
	end
	return false
end

function moveProxies(proxies, wagon)
--	debugLog("Moving proxy!")
	for i, proxy in ipairs(proxies) do
		if (proxy.position.x ~= wagon.position.x or proxy.position.y ~= wagon.position.y) then
--			debugLog("**PROXY x: " .. proxy.position.x .. " y: " .. proxy.position.y)
--			debugLog("**WAGON x: " .. wagon.position.x .. " y: " .. wagon.position.y)
		
			moveProxy(proxy, wagon.position)
		end
	end
end

function moveProxy(proxy, position)
	if proxy.valid then
--		debugLog("Trying to move proxy " .. proxy.name)
		proxy.teleport(position)
	end
end

function destroyProxies(proxies)
	for i, proxy in ipairs(proxies) do
		if proxy.valid then
			destroyProxy(proxy)
		end
	end
end

function destroyProxy(proxy)
	if proxy.valid then
		debugLog("Destroy " .. proxy.name)
		proxy.destroy()
	end
end

function syncInventory(wagon, proxy, inventoryCount) -- inventoryCount should be -1 for first sync
	if proxy == nil or not proxy.valid then
		debugLog("Proxy does not exist. something is wrong, we should not be here")
		--glob.wagons[wagon]["proxy"] = nil
		return
	end
	local wagonInventory = wagon.getinventory(1)
	local proxyInventory = proxy.getinventory(1)
	
	--debugLog("currentCount: " .. wagonInventory.getitemcount() .. " previous: " .. inventoryCount)
	if wagonInventory.getitemcount() ~= inventoryCount then
		--debugLog("copy to proxy")
		local wagonInventory = wagon.getinventory(1)
		local proxyInventory = proxy.getinventory(1)
		copyInventory(wagonInventory, proxyInventory, "")
	elseif not compareInventories(wagonInventory, proxyInventory) then
		copyInventory(proxyInventory, wagonInventory, "*")
	end
end

function compareInventories(inventoryA, inventoryB)
	if inventoryA.getitemcount() ~= inventoryB.getitemcount() then
		return false
	else
		local contentsA = inventoryA.getcontents()
		local contentsB = inventoryB.getcontents()
		for name, count in pairs(contentsA) do
			if contentsB[name] == nil or contentsB[name] ~= count then
				return false
			end
		end
	end
	return true
end

function getItemTypeFromName(name)
	local item = game.itemprototypes[name]
	if item ~= nil then
		return item.type
	end
end

function getEntityTypeFromName(name)
	local entity = game.entityprototypes[name]
	if entity ~= nil then
		return entity.type
	end
end

function copyInventory(copyFrom, copyTo, filter)
	local activeFilter = filter
	if filter == nil or filter == "" then
		filter = "*"
	end
	
	if copyFrom ~= nil and copyTo ~= nil then
		local action = {}
		local fromContents = copyFrom.getcontents()
		local toContents = copyTo.getcontents()
		for name,count in pairs(fromContents) do
			local filterType = getItemTypeFromName(name)
			if filterType == nil or filterType == "item" then
				filterType = getEntityTypeFromName(name)
			end
			if filter == name or filter == filterType or filter == "*" then
				local diff = getItemDifference(name,fromContents[name], toContents[name])
				debugLog(diff)
				if diff ~= 0 then
					action[name] = diff
				end
			end
		end
		for name,count in pairs(toContents) do
			local filterType = getItemTypeFromName(name)
			if filter == name or filter == filterType or filter == "*" then
				if fromContents[name] == nul then
					action[name] = getItemDifference(name,fromContents[name],toContents[name])
				end
			end
		end
		for name,diff in pairs(action) do
			debugLog("#################itemName: " .. name .. " diff: " .. diff)
			if diff > 0 then
				copyTo.insert({name=name,count=diff})
			elseif diff < 0 then
				copyTo.remove({name=name,count=0-diff})
			end
		end
	end
	
end

function getItemDifference(item, syncFromItemCount, syncToItemCount)
	if syncFromItemCount == nil then
		if syncToItemCount ~= nil then
			return 0 - syncToItemCount
		end
	elseif syncToItemCount == nil then 
		return syncFromItemCount
	else
		return syncFromItemCount - syncToItemCount
	end
	
	return 0
end

function createProxy(proxyType, proxyPosition)
	--local proxyPosition = findNewProxyPosition(position)
	if proxyPosition == nil then
		return false
	end
	debugLog("ncp X: " .. proxyPosition.x .. " Y: " .. proxyPosition.y)
	--if (game.canplaceentity{name="smart-chest", position=proxyPosition}) then -- Can this be taken out? Of course, I already know it is non colliding
		debugLog("Creating " .. proxyType .. " at " .. proxyPosition.x .. " " .. proxyPosition.y)
		game.createentity{name=proxyType, position=proxyPosition, force=game.player.force}
		return true
	--end
end

function getApiVersion()
	if pcall(function () game.removepath("versioncheck") end) then
		return "0.10"
	else
		return "0.9"
	end
end

function debugLog(message)
	if false then -- set for debug
		game.player.print(message)
	end
end

function printApiWarning(message)
	if apiWarning == nil or not apiWarning then
		apiWarning = true
		game.player.print(message)
	end
end

function endswith(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end