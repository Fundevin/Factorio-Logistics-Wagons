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

function Wagon:registerWagonParent(name)
	glob.logisticWagonsEntityNames = glob.logisticWagonsEntityNames or {}
	
	if(glob.logisticWagonsEntityNames[name] == nil) then
		debugLog("Got a new wagon type: " .. name)
		glob.logisticWagonsEntityNames[name] = true
	end
end