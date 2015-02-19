-- passive logistics wagon

PassiveWagon = class(Wagon, function (class,parent,data)
	debugLog("Creating new passive logistics wagon")
	class = Wagon.init(class,parent,data)
	class.wagonType = "PassiveWagon"

	if(data == nil) then
		if parent ~= nil then	
			class.valid = true
			class.parent = parent
			class.position = parent.position
			class.proxy = class:createProxy(parent)
		end	
	else
		--debugLog("Recreating class")
		
		class.valid = data.valid
		class.parent = data.parent
		class.position = data.position
		class.proxy = data.proxy
	end
	
	return class
end)

function PassiveWagon:updateWagon()

end

function PassiveWagon:createProxy(parent)
	local proxyType = "lw-logistic-chest-passive-provider-trans"
	return Wagon:createProxy(parent, proxyType)
end

function PassiveWagon:copyInventory(copyFrom, copyTo, entityName)
	if copyFrom ~= nil and copyTo ~= nil then
		local action = {}
		local fromContents = copyFrom.getcontents()
		local toContents = copyTo.getcontents()
		for name,count in pairs(fromContents) do
				local diff = self:getItemDifference(name,fromContents[name], toContents[name])
				if diff ~= 0 then
					action[name] = diff
				end	
		end
				
		for name,count in pairs(toContents) do
				if fromContents[name] == nul then
					action[name] = self:getItemDifference(name,fromContents[name],toContents[name])
				end
		end

		for name,diff in pairs(action) do
			--debugLog("#################itemName: " .. name .. " diff: " .. diff)
			if diff > 0 then
				copyTo.insert({name=name,count=diff})
			elseif diff < 0 then
				copyTo.remove({name=name,count=0-diff})
			end
		end
	end
end

function PassiveWagon:getItemDifference(item, syncFromItemCount, syncToItemCount)
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

-- This returns the number of inventory stacks the entity can have. 
-- Since this is hardcoded then it will only work for the cargo containers that are placed here
function PassiveWagon:getMaxInventory(entity)
	if entity.type == "locomotive" then
		return 3
	elseif entity.type == "cargo-wagon" then
		return 20
	end
end