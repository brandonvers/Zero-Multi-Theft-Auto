local cache = {}
local serverslot = getMaxPlayers()

addEventHandler("onResourceStart", resourceRoot,
    function()
        for k,v in pairs(getElementsByType("player")) do
            local id = getElementData(v, "acc:id")
            if id then
                cache[id] = v
            end
        end
    end
)

addEventHandler("onPlayerJoin", root,
    function()
        for i = 1, serverslot do
            if not cache[i] then
                cache[i] = source
                setElementData(source, "acc:id", i)
                return
            end
        end
    end
)

addEventHandler("onPlayerQuit", root,
    function()
        local id = getElementData(source, "acc:id")
        if id then
            cache[id] = nil
        end
    end
)