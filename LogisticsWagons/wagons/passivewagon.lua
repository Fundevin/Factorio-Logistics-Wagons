-- passive logistics wagon
local class = require 'middleclass'

PassiveWagon = class('PassiveWagon',ProxyWagon)

function PassiveWagon:initialize(parent,data)
	ProxyWagon.initialize(self, parent, data)
	self.wagonType = "PassiveWagon"
end

function PassiveWagon:createProxyType()
	local proxyType = "lw-logistic-chest-passive-provider-trans"
	return self:createProxy(proxyType, true)
end