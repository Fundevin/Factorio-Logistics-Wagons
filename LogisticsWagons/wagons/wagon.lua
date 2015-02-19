-- Wagon class definitions and functions
local class = require 'middleclass'

Wagon = class('Wagon')

function Wagon:initialize(parent,data)
	--debugLog("Parent wagon here")
	
	if(data == nil) then
		class.iswagon = true
		class.valid = false
		class.parent = parent
	else
		class.iswagon = data.iswagon
		class.valid = data.valid
		class.parent = data.parent
	end
	
	if( parent ~= nil) then
		Wagon:registerWagonParent(parent.name)
	end
	
	return class
end

function Wagon:updateWagon()
	if(self.proxy ~= nil) then
		if(self:isMoving() and not self:allowsProxyWhileMoving()) then
			debugLog("Moving, should remove proxy")
			self:removeProxy()
			self.proxy = nil
		end
	else
		if(not self:isMoving() or (self:isMoving() and self:allowsProxyWhileMoving())) then
			debugLog("No proxy created, making one!")
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
	debugLog("Creating new wagon proxy of type " .. proxyType)
	
	if makeOperable == nil then
		makeOperable = false
	end
	
	local proxy = {}
	local parentEntity = self.parent
	if parentEntity ~= nil and parentEntity.valid then
		local proxyPosition = self:getProxyPosition()
--		debugLog("**PROXY x: " .. proxyPosition.x .. " y: " .. proxyPosition.y)
--		debugLog("**PARENT x: " .. parent.position.x .. " y: " .. parent.position.y)
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