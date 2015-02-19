-- Wagon class definitions and functions

Wagon = class(function(class,parent,data)
	--debugLog("Parent wagon here")
	
	if(data == nil) then
		class.iswagon = true
		class.valid = false
	else
		class.iswagon = data.iswagon
		class.valid = data.valid
	end
	
	if( parent ~= nil) then
		Wagon:registerWagonParent(parent.name)
	end
	
	return class
end)

function Wagon:updateWagon()
	--debugLog("This shouldn't be called!")
end

function Wagon:createProxy(parent, proxyType, makeOperable)
	debugLog("Creating new wagon proxy of type " .. proxyType)
	
	if makeOperable == nil then
		makeOperable = false
	end
	
	local proxy = {}
	if parent ~= nil and parent.valid then
		local proxyPosition = parent.position
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
		--debugLog("not valid?")
		--debugLog(parent.valid)
	end
	return proxy
end

function Wagon:emptyProxy(wagon)
	if (wagon.proxy.valid) then
		local container = wagon.proxy.getinventory(1)
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

function Wagon:remove()
	debugLog("Trying to remove wagon")
	Wagon:emptyProxy(self)
	self.proxy.destroy()
end