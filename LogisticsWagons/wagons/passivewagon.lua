-- passive logistics wagon
local class = require 'middleclass'

PassiveWagon = class('PassiveWagon',Wagon)

function PassiveWagon:initialize(parent,data)
	debugLog("Creating new passive logistics wagon")
	Wagon.initialize(self, parent, data)
	self.wagonType = "PassiveWagon"

	if(data == nil) then
		if parent ~= nil then	
			self.valid = true
			self.parent = parent
			self.proxy = nil
			self.inventoryCount = 0
		end	
	else
		--debugLog("Recreating class")
		
		self.valid = data.valid
		self.parent = data.parent
		self.proxy = data.proxy
		self.inventoryCount = data.inventoryCount
	end
	
	self:updateDataSerialisation()
end

function PassiveWagon:updateDataSerialisation()
--	debugLog("Updating PassiveWagon serialisation")
	Wagon.updateDataSerialisation(self)
	
	self.data.proxy = self.proxy
end


function PassiveWagon:createProxyType()
	local proxyType = "lw-logistic-chest-passive-provider-trans"
	return self:createProxy(proxyType, true)
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