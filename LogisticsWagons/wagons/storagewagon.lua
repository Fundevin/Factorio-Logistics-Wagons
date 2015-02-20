-- long time storage logistics wagon
local class = require 'middleclass'

StorageWagon = class('StorageWagon',ProxyWagon)

function StorageWagon:initialize(parent,data)
	ProxyWagon.initialize(self, parent, data)
	self.wagonType = "StorageWagon"
end

function StorageWagon:createProxyType()
	local proxyType = "lw-logistic-chest-storage-provider-trans"
	return self:createProxy(proxyType)
end