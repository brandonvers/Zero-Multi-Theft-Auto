function findID(cmd, id)
    if not id then
        outputChatBox(" /"..cmd.." [target]", 255,255,255,true)
        return
    end
    local target = findPlayer(localPlayer, id)
    if target then
        outputChatBox(" A játékos idje: " .. tonumber(getElementData(target, "acc:charid") or -1), 255,255,255,true)
    else
        outputChatBox("A játékos nem található", 255,255,255,true)
    end
end
addCommandHandler("id", findID)

