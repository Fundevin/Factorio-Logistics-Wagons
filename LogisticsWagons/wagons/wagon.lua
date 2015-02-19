-- Wagon class definitions and functions
local class = require 'middleclass'

Wagon = class('Wagon')

function Wagon:initialize(parent,data)
	--debugLog("Parent wagon here")
	self.wagonType = "Wagon"
	
	if(data == nil) then
		self.iswagon = true
		self.valid = false
		self.parent = parent
	else
		self.iswagon = data.iswagon
		self.valid = data.valid
		self.parent = data.parent
	end
	
	if( parent ~= nil) then
		self:registerWagonParent(parent.name)
	end
	
	return class
end

function Wagon:updateDataSerialisation()
--	debugLog("Updating Wagon serialisation")
	
	if(self.data == nil) then
		self.data = {}
	end
	
	self.data.iswagon = self.iswagon
	self.data.valid = self.valid
	self.data.parent = self.parent
	self.data.wagonType = self.wagonType
end

function Wagon:__len()
	-- If this is being asked for, make sure serialisation is up to date
	self:updateDataSerialisation()
	return #self.data
end

function Wagon:__pairs()
	return coroutine.wrap(function() 
          for k,v in pairs(self.data) do
            coroutine.yield(k,v)
          end
        end)
end

function Wagon:updateWagon()
	if(self.proxy ~= nil) then
		if(self:isMoving() and not self:allowsProxyWhileMoving()) then
			-- Moving and not allowing proxy while moving, should remove the proxy
			self:removeProxy()
			self.proxy = nil
		else
			-- Standing still, should update the proxy count
			self:updateProxyInventory()
		end
	else
		if(not self:isMoving() or (self:isMoving() and self:allowsProxyWhileMoving())) then
			-- No proxy, but there should be one
			self.proxy = self:createProxyType()
		end
	end
end

function Wagon:isMoving()
	return self:getSpeed() > 0
end

function Wagon:getSpeed()
	if (self.parent and self.parent.train) then
		return self.parent.train.speed
	else
		return 0
	end
end

function Wagon:allowsProxyWhileMoving()
	return false
end

function Wagon:getProxyPosition()
	debugLog("Trying to get position of : " .. serpent.dump(self.parent))
	
	local parentEntity = self.parent
	if(parentEntity ~= nil) then
		local proxyPosition = parentEntity.position
		proxyPosition.x = proxyPosition.x + 2
	
		return proxyPosition
	end
	
	return nil
end

function Wagon:moveProxy(parent)
	self.proxy.position = self:getProxyPosition()
end

function Wagon:createProxy(proxyType, makeOperable)
--	debugLog("Creating new proxy of type " .. proxyType)
	
	if makeOperable == nil then
		makeOperable = false
	end
	
	local proxy = {}
	local parentEntity = self.parent
	if parentEntity ~= nil and parentEntity.valid then
		local proxyPosition = self:getProxyPosition()
		debugLog("Creating " .. proxyType .. " at " .. proxyPosition.x .. " " .. proxyPosition.y)
		
		game.createentity{name=proxyType, position=proxyPosition, force=game.player.force}
		proxysearch = game.findentitiesfiltered{area = {{proxyPosition.x - 1, proxyPosition.y - 1}, {proxyPosition.x + 1, proxyPosition.y + 1}}, name=proxyType} 
		for i,e in ipairs(proxysearch) do
			proxy = e
		end
		proxy.operable = makeOperable;
		return proxy
	else
		debugLog("not valid?")
--		debugLog(serpent.dump(self))
	end
	return nil
end

function Wagon:emptyProxy()
	if (self.proxy.valid) then
		local container = self.proxy.getinventory(1)
		local contents = container.getcontents()
		for name,count in pairs(contents) do
			container.remove({name=name,count=count})
		end
	end
end

function Wagon:addToProxy(entityName,amount)
	if self.proxy ~= nil and amount > 0 then
		self.proxy.getinventory(1).insert({name=entityName,count=amount})
	end
end

function Wagon:registerWagonParent(name)
	glob.logisticWagonsEntityNames = glob.logisticWagonsEntityNames or {}
	
	if(glob.logisticWagonsEntityNames[name] == nil) then
		debugLog("Got a new wagon type: " .. name)
		glob.logisticWagonsEntityNames[name] = true
	end
end

function Wagon:removeProxy()
	debugLog("Trying to remove proxy: " .. serpent.dump(self.proxy))
	self:emptyProxy(self)
	self.proxy.destroy()
end

function Wagon:syncProxyToInventory()

end