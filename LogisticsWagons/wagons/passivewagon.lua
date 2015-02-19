-- passive logistics wagon
local class = require 'middleclass'

PassiveWagon = class('PassiveWagon',ProxyWagon)

function PassiveWagon:initialize(parent,data)
	ProxyWagon.initialize(self, parent, data)
	self.wagonType = "PassiveWagon"

	if(data == nil) then
		if parent ~= nil then
			self.valid = true
			self.parent = parent
			self.proxy = nil
			self.inventoryCount = -1
		end	
	else
		self.valid = data.valid
		self.parent = data.parent
		self.proxy = data.proxy
		self.inventoryCount = data.inventoryCount or -1
	end
	
	self:updateDataSerialisation()
end

function PassiveWagon:updateDataSerialisation()
--	debugLog("Updating PassiveWagon serialisation")
	ProxyWagon.updateDataSerialisation(self)
	
	self.data.proxy = self.proxy
	self.data.inventoryCount = self.inventoryCount
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