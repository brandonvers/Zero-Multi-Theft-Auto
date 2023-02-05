function findPlayer(sourcePlayer, id)
    if id then

        if id == "*" or utfSub(id, 1, 1) == "*" then
            return sourcePlayer
        end

        local table = {}
        for k,v in pairs(getElementsByType("player")) do
            local name = string.lower(getElementData(v, "acc:uname") or getPlayerName(v))
            local logged = false
            if utfSub(name, 1, #id) == string.lower(id) then
                table[#table + 1] = {v, name}
                logged = true
            end
            local number = tonumber(getElementData(v, "acc:id")) or -1
            local number2 = tonumber(id) or -2
            if number == number2 and not logged then
                table[#table + 1] = {v, adminname}
                logged = true
            end
        end

        if #table == 0 then
        elseif #table == 1 then
            return table[1][1]
        elseif #table > 1 then
            if serverSide then
                outputChatBox(fSyntax .. "Találatok: ("..id.."-ra/re)", sourcePlayer, 255, 255, 255, true)
                for k,v in pairs(table) do
                    local name = v[2]
                    local id = getElementData(v[1], "acc:id")
                    outputChatBox(name .. "("..id..")", sourcePlayer, 255, 255, 255, true)
                end
            else
                outputChatBox(fSyntax .. "Találatok: ("..id.."-ra/re)", 255, 255, 255, true)
                for k,v in pairs(table) do
                    local name = v[2]
                    local id = getElementData(v[1], "acc:id")
                    outputChatBox(name .. "("..id..")", 255, 255, 255, true)
                end
            end
        end
    end
    
    return false
end