local ids = {};
local mysql = exports.Connection;
local database = mysql:getConnection(getThisResource());
white = "#ffffff"
local devSerials = {}
local devNames = {}
local servername = getServerName();
local maxplayers = getMaxPlayers();
local serverpassword = getServerPassword();
local slot = getMaxPlayers();

local syntax = getServerSyntax(false, "success");
local syntax2 = getServerSyntax(false, "warning");
local syntax3 = getServerSyntax(false, "error");
local startTime = getRealTime()["timestamp"];


addEventHandler('onResourceStart', resourceRoot,
    function()
	    aclReload();
        -- Server Settings --
        setGameType(serverData['mod'] .. " " .. serverData['version']);
        setMapName(serverData['city']);
        setRuleValue('modversion', serverData['version'])
		setRuleValue('designer', serverData['designer'])
		setRuleValue('developer', serverData['developer'])
        --showchat(false);
        dbQuery(function(query)
            local query, query_lines = dbPoll(query, 0)
            if query_lines > 0 then
                for i, row in pairs(query) do
                    local serial = row["serial"]
                    local name = row["name"]
                    devSerials[serial] = true
                    devNames[serial] = name
                end
            end
			outputDebugString("[Success] Loading devserials has finished successfuly. Loaded: " .. query_lines .. " serials!")
        end, database, "SELECT * FROM `developer`")   
	end
)



addEventHandler("onPlayerJoin", root,
    function()
        local serial = getPlayerSerial(source)
        setElementCollisionsEnabled(source, false)
        if devSerials[serial] then
            local playerNick = getPlayerName(source)
            local playerIP = getPlayerIP(source)
            local playerSerial = serial
           outputChatBox(syntax .. "Developer serial érzékelve! Üdv a szerveren "..playerNick.."!", source, 255, 255, 255, true)
        end
    end
)

function getPlayerDeveloper(player)
    if getElementData(player, "isPlaying") then
        local serial = getPlayerSerial(player)
        if devSerials[serial] then
            return true, devNames[serial]
        else
            return false
        end
    end
end


function CreateDeveloper(thePlayer, cmd, serial, name)
    local playerSerial = getPlayerSerial(thePlayer)
     if devSerials[playerSerial] then
        if not serial or not name then
            outputChatBox(syntax2 .. "/"..cmd.." [serial] [name]", thePlayer, 255, 255, 255, true)
            return
        end
            
        if devSerials[serial] then
            outputChatBox(syntax3 .. "Ez a serial már rögzítve van devserialként!", thePlayer, 255, 255, 255, true)
            return
        end
            
        dbExec(database, "INSERT INTO `developer` SET `serial` = ?, `name` = ?", serial, name)
        devSerials[serial] = true
        devNames[serial] = name
        local green = exports['core-system']:getServerColor("orange", true)
        local syntax = exports['core-system']:getServerSyntax(false, "success")
        -- local aName = exports['cr_admin']:getAdminName(thePlayer, true)
        outputChatBox(syntax .. "Sikeresen hozzáadtad "..green..name..white.."-t ("..green..serial..white..") a devserialokhoz!", thePlayer, 255, 255, 255, true)
        -- local syntax = exports['cr_admin']:getAdminSyntax()
        --exports['cr_core']:sendMessageToAdmin(thePlayer, syntax..green..aName..white.." hozzáadta "..green..name..white.."-t ("..green..serial..white..") a devserialokhoz!", 9)
        --exports['cr_logs']:addLog(thePlayer, "Admin", "createdeveloper", (tonumber(getElementData(thePlayer, "acc >> id")) or inspect(thePlayer)) .." hozzáadta "..name.."-t ("..serial..") a devserialokhoz!")
        -- triggerClientEvent(root, "client >> devserials >> saveCache", root, devSerials, devNames)
    end
end
addCommandHandler("createdeveloper", CreateDeveloper);


function RemoveDeveloper(thePlayer, cmd, serial)
    local playerSerial = getPlayerSerial(thePlayer)
    if devSerials[playerSerial] then
        if not serial then
            outputChatBox(syntax2 .. "/"..cmd.." [serial]", thePlayer, 255, 255, 255, true)
            return
        end
            
        if not devSerials[serial] then
            outputChatBox(syntax3 .. "A törlendő serialnek devserialnak kell lennie (Ez a serial nem devserial!)", thePlayer, 255, 255, 255, true)
            return
        end
        dbExec(database, "DELETE FROM `developer` WHERE `serial` = ?", serial)
        local name = devNames[serial]
        devSerials[serial] = false
        devNames[serial] = nil
     --   triggerClientEvent(root, "client >> devserials >> saveCache", root, devSerials, devNames)
        local green = exports['core-system']:getServerColor("orange", true)
        local syntax = exports['core-system']:getServerSyntax(false, "success")
        --local aName = exports['cr_admin']:getAdminName(thePlayer, true)
        outputChatBox(syntax .. "Sikeresen kitörölted "..green.."A fejlesztot serial:"..white.."-t ("..green..serial..white..") a devserialokból!", thePlayer, 255, 255, 255, true)
       -- local syntax = exports['cr_admin']:getAdminSyntax()
       -- exports['cr_core']:sendMessageToAdmin(thePlayer, syntax..green..aName..white.." kitörölte "..green..name..white.."-t ("..green..serial..white..") a devserialokból!", 9)
        --exports['cr_logs']:addLog(thePlayer, "Admin", "removedevserial", (tonumber(getElementData(thePlayer, "acc >> id")) or inspect(thePlayer)) .." kitörölte "..name.."-t ("..serial..") a devserialokból!")
        --triggerClientEvent(root, "client >> devserials >> saveCache", root, devSerials, devNames)
    end
end
addCommandHandler("removedeveloper", RemoveDeveloper);