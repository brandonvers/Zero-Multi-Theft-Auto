local sx, sy = guiGetScreenSize()
local playerBlips = {}
local showPlayers
local checkTimer

local dummystate = false
addCommandHandler("showdummy", 
    function()
        if exports['core-system']:getPlayerDeveloper(localPlayer) then
            dummystate = not dummystate
            if dummystate then
                local syntax = exports['core-system']:getServerSyntax(false, "success")        
                outputChatBox(syntax .. "Dummy listázás bekapcsolva!", 0, 255, 0, true)
                addEventHandler("onClientRender", root, showVehicleDummy, true, "low-5")
            else
                local syntax = exports['core-system']:getServerSyntax(false, "error")        
                outputChatBox(syntax .. "Dummy listázás kikapcsolva!", 255, 0, 0, true)
                removeEventHandler("onClientRender", root, showVehicleDummy)
            end
        end
    end
)

function showVehicleDummy()
	local x,y,z = getElementPosition(localPlayer)
	for k, veh in ipairs(getElementsByType("vehicle", root, true)) do
		if isElementOnScreen(veh) then
			local xx,yy,yz = getElementPosition(veh)
			if getDistanceBetweenPoints3D(x,y,z,xx,yy,yz) < 10 then
				for v in pairs(getVehicleComponents(veh)) do
					local x,y,z = getVehicleComponentPosition(veh, v, "world")
					local wx,wy,wz = getScreenFromWorldPosition(x, y, z)
					if wx and wy then
						dxDrawText(v, wx -1, wy -1, wx -1, wy -1, tocolor(0,0,0), 1, "default-bold", "center", "center")
						dxDrawText(v, wx +1, wy -1, wx +1, wy -1, tocolor(0,0,0), 1, "default-bold", "center", "center")
						dxDrawText(v, wx -1, wy +1, wx -1, wy +1, tocolor(0,0,0), 1, "default-bold", "center", "center")
						dxDrawText(v, wx +1, wy +1, wx +1, wy +1, tocolor(0,0,0), 1, "default-bold", "center", "center")
						dxDrawText(v, wx, wy, wx, wy, tocolor(0,255,255), 1, "default-bold", "center", "center")
					end
				end
			end
		end
	end
end

addCommandHandler("devmode", 
    function()
        if exports['core-system']:getPlayerDeveloper(localPlayer) then
            local mode = getDevelopmentMode()
            if not mode then
                local syntax = exports['core-system']:getServerSyntax(false, "success")    
                outputChatBox(syntax .. "Fejlesztői mód bekapcsolva!", 0, 255, 0, true)
            else
                local syntax = exports['core-system']:getServerSyntax(false, "error")    
                outputChatBox(syntax .. "Fejlesztői mód kikapcsolva!", 255, 0, 0, true)
            end
            setDevelopmentMode(not mode)
        end
    end
)

addCommandHandler("aircars", 
    function(cmd)
        if exports['core-system']:getPlayerDeveloper(localPlayer) then
            local mode = isWorldSpecialPropertyEnabled(cmd)
            if not mode then
                local syntax = exports['core-system']:getServerSyntax(false, "success")    
                outputChatBox(syntax .. "Aircars mód bekapcsolva!", 0, 255, 0, true)
            else
                local syntax = exports['core-system']:getServerSyntax(false, "error")    
                outputChatBox(syntax .. "Aircars mód kikapcsolva!", 255, 0, 0, true)
            end
            setWorldSpecialPropertyEnabled(cmd, not mode)
        end
    end
)


function displayMyTask ()
    local x,y = 50,400
    for k=0,4 do
        local a,b,c,d = getPedTask ( getLocalPlayer(), "primary", k )
        dxDrawText ( "Primary task #"..k.." is "..tostring(a).." -> "..tostring(b).." -> "..tostring(c).." -> "..tostring(d).." -> ", x, y )
        y = y + 15
    end
    y = y + 15
    for k=0,5 do
        local a,b,c,d = getPedTask ( getLocalPlayer(), "secondary", k )
        dxDrawText ( "Secondary task #"..k.." is "..tostring(a).." -> "..tostring(b).." -> "..tostring(c).." -> "..tostring(d).." -> ", x, y )    
        y = y + 15
    end
end

local taskList = nil
addCommandHandler("showtask", 
    function()
        if exports['core-system']:getPlayerDeveloper(localPlayer) then
            taskList = not taskList
            if taskList then
                local syntax = exports['core-system']:getServerSyntax(false, "success") 
                addEventHandler("onClientRender", root, displayMyTask, true, "low")
                outputChatBox(syntax .. "TaskList bekapcsolva!", 0, 255, 0, true)
            else
                local syntax = exports['core-system']:getServerSyntax(false, "error")    
                removeEventHandler("onClientRender", root, displayMyTask)
                outputChatBox(syntax .. "TaskList kikapcsolva!", 255, 0, 0, true)
            end
        end
    end
)

local testValues = {
	["none"] = "Kikapcsolva",
	["no_mem"] = "Nincs memória",
	["low_mem"] = "Kevés memória",
	["no_shader"] = "Nincs shader",
}
addCommandHandler("setmode", 
    function(cmd, value)
        if exports['core-system']:getPlayerDeveloper(localPlayer) then
            if testValues[value] then
                local syntax = exports['core-system']:getServerSyntax(false, "success") 
                dxSetTestMode(value)
                outputChatBox(syntax .. "DX Memória teszt mód: " .. value, 220, 175, 20, true)
            else
                local syntax = exports['core-system']:getServerSyntax(false, "error")
                outputChatBox(syntax .. "DX Memória teszt módok:", 245, 20, 20, true)
                for k, v in pairs(testValues) do
                    outputChatBox(syntax .. ""..k.." > "..v, 245, 20, 20, true)
                end
            end
        end
    end
)
