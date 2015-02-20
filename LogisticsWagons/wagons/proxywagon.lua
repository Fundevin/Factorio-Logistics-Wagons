-- Wagon class definitions and functions
local class = require 'middleclass'

ProxyWagon = class('ProxyWagon',Wagon)

function ProxyWagon:initialize(parent,data)
	debugLog("Proxy wagon init")
	Wagon.initialize(self, parent, data)
	self.wagonType = "ProxyWagon"
	
	if(data == nil) then
		if parent ~= nil then
			self.valid = true
			self.parent = parent
			self.proxy = nil
			self.inventoryCount = -1
			self.proxyCount = -1
		end	
	else
		self.valid = data.valid
		self.parent = data.parent
		self.proxy = data.proxy
		self.inventoryCount = data.inventoryCount or -1
		self.proxyCount = data.proxyCount or -1
	end
end

function ProxyWagon:updateDataSerialisation()
	Wagon.updateDataSerialisation(self)
	
	self.data.proxy = self.proxy
	self.data.inventoryCount = self.inventoryCount
	self.data.proxyCount = self.proxyCount
end

function ProxyWagon:updateWagon(tick)
	debugLog("ProxyWagon:updateWagon")
	if(self.proxy ~= nil) then
		if(self:isMoving() and not self:allowsProxyWhileMoving()) then
			-- Moving and not allowing proxy while moving, should remove the proxy
			self:removeProxy()
			self.proxy = nil
		else
			-- Standing still, should update the proxy count
			-- But only do it every so often
			--if(tick % 500 == 3) then
				self:syncProxyAndInventory()
			--end
		end
	else
		if(not self:isMoving() or (self:isMoving() and self:allowsProxyWhileMoving())) then
			-- No proxy, but there should be one
			self:createProxyType()
		end
	end
end

function ProxyWagon:allowsProxyWhileMoving()
	return false
end

function ProxyWagon:getProxyPosition()
	debugLog("Trying to get position of : " .. serpent.dump(self.parent))
	
	local parentEntity = self.parent
	if(parentEntity ~= nil) then
		local proxyPosition = parentEntity.position
		proxyPosition.x = proxyPosition.x + 0
	
		return proxyPosition
	end
	
	return nil
end

function ProxyWagon:moveProxy(parent)
	self.proxy.position = self:getProxyPosition()
end

function ProxyWagon:createProxy(proxyType, makeOperable)
--	debugLog("Creating new proxy of type " .. proxyType)
	
	if makeOperable == nil then
		makeOperable = false
	end
	
	local proxy = {}
	local parentEntity = self.parent
	if parentEntity ~= nil and parentEntity.valid then
		self.inventoryCount = -1
		self.proxyCount = -1
		
		local proxyPosition = self:getProxyPosition()
		debugLog("Creating " .. proxyType .. " at " .. proxyPosition.x .. " " .. proxyPosition.y)
		
		game.createentity{name=proxyType, position=proxyPosition, force=game.player.force}
		proxysearch = game.findentitiesfiltered{area = {{proxyPosition.x - 1, proxyPosition.y - 1}, {proxyPosition.x + 1, proxyPosition.y + 1}}, name=proxyType} 
		for i,e in ipairs(proxysearch) do
			proxy = e
		end
		proxy.operable = makeOperable;
		self.proxy = proxy
	else
		self.proxy = nil
	end
end

function ProxyWagon:emptyProxy()
	if (self.proxy.valid) then
		local container = self.proxy.getinventory(1)
		local contents = container.getcontents()
		for name,count in pairs(contents) do
			container.remove({name=name,count=count})
		end
	end
end

function ProxyWagon:removeProxy()
	debugLog("Trying to remove proxy: " .. serpent.dump(self.proxy))
	self:emptyProxy()
	self.proxy.destroy()
	self.inventoryCount = -1
	self.proxyCount = -1
end

function ProxyWagon:syncProxyAndInventory()
	if self.proxy == nil or not self.proxy.valid then
		debugLog("Proxy does not exist. something is wrong, we should not be here")
		--glob.logisticWagons[wagon]["proxy"] = nil
		return
	end
	local wagonInventory = self.parent.getinventory(1)
	local proxyInventory = self.proxy.getinventory(1)
	
	-- Should be saved, testing copying for now
		
	if wagonInventory.getitemcount() ~= self.inventoryCount then
--		debugLog("currentCount: " .. wagonInventory.getitemcount() .. " previous: " .. self.inventoryCount)
--		debugLog("proxy count: " .. proxyInventory.getitemcount() .. " previous: " .. self.proxyCount)
--		debugLog("copy to proxy")
		self:copyInventory(wagonInventory, proxyInventory)
		
		self.inventoryCount = wagonInventory.getitemcount()
		self.proxyCount = proxyInventory.getitemcount()

		return true
	elseif proxyInventory.getitemcount() ~= self.proxyCount then
--		debugLog("wagon count: " .. wagonInventory.getitemcount() .. " previous: " .. self.inventoryCount)
--		debugLog("proxy count: " .. proxyInventory.getitemcount() .. " previous: " .. self.proxyCount)
--		debugLog("copy to wagon")
		self:copyInventory(proxyInventory, wagonInventory)
		
		self.inventoryCount = wagonInventory.getitemcount()
		self.proxyCount = proxyInventory.getitemcount()

		return true
	end	
	return false
end

function ProxyWagon:copyInventory(copyFrom, copyTo)
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
--			debugLog("#################itemName: " .. name .. " diff: " .. diff)
			if diff > 0 then
				copyTo.insert({name=name,count=diff})
			elseif diff < 0 then
				copyTo.remove({name=name,count=0-diff})
			end
		end
	end
end

function ProxyWagon:getItemDifference(item, syncFromItemCount, syncToItemCount)
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