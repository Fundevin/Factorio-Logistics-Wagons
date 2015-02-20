-- active logistics wagon
local class = require 'middleclass'

ActiveWagon = class('ActiveWagon',ProxyWagon)

function ActiveWagon:initialize(parent,data)
	debugLog("ActiveWagon init")
	ProxyWagon.initialize(self, parent, data)
	self.wagonType = "ActiveWagon"
end

function ActiveWagon:createProxyType()
	local proxyType = "lw-logistic-chest-active-provider-trans"
	return self:createProxy(proxyType)
end