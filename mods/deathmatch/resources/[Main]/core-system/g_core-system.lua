colors = {
    --['colorname'] = {r, g, b, hex},
    ['red'] = {208, 36, 36, "#d02424"},
	['green'] = {113, 208, 36, "#71d024"},
    ['blue'] = {51, 153, 255,"#3399ff"},
	['blue2'] = {36, 109, 208, "#246dd0"},
	['yellow'] = {208, 153, 36, "#d09924"},
    ["orange"] = {255, 153, 51, "#ff9933"},
    ['lightyellow'] = {255, 209, 26, "#ffd11a"},
}

serverColor = 'orange'
serverName = 'ZeroMTA'
hexCode = colors[serverColor][4]
low = hexCode .. '[' .. serverName .. '] #FFFFFF'
local serverSide = false
addEventHandler("onResourceStart", resourceRoot,
    function()
        serverSide = true
    end
)

serverData = {
    --['dataname'] = unknow,
    ['developer'] = '|X|Brendon|X|', 
	['designer'] = '|X|Brendon|X|', 
    ['owner'] = '|X|Brendon|X|',
	['version'] = "v2.0",
    ['name'] = serverName,
    ['color'] = serverColor,
	['mod'] = 'Zero Roleplay',
	['city'] = 'Los Santos',
	['defaultBlurLevel'] = 0,
	['syntax'] = low,
}

function getVersion()
    return serverData["version"]
end

function converType(t)
    if t == "error" then
        return 'red'
    elseif t == "info" then
        return 'blue'
    elseif t == "warning" then
        return serverColor
    elseif t == "success" then
        return 'green'
    end
    
    return nil
end

function getServerSyntax(extra, t)
    if extra and type(extra) == "string" then
        if t then
            if colors[t] then
                return colors[t][4] .. '[' .. serverName .. ' - ' .. extra .. '] #FFFFFF'
            else
                return colors[converType(t)][4] .. '[' .. serverName .. ' - ' .. extra .. '] #FFFFFF'
            end
        else
            return hexCode .. '[' .. serverName .. ' - ' .. extra .. '] #FFFFFF'
        end
    else
        if t then
            if colors[t] then
                return colors[t][4] .. '[' .. serverName .. '] #FFFFFF'
            else
                return colors[converType(t)][4] .. '[' .. serverName .. '] #FFFFFF'
            end
        else
            return serverData['syntax']
        end
    end
end

local fSyntax = getServerSyntax(false, "success")

function getServerColor(color, hexCode)
    if not hexCode then
	    local r,g,b = colors[serverColor][1], colors[serverColor][2], colors[serverColor][3]
		if color and colors[color] then
		    r,g,b = colors[color][1], colors[color][2], colors[color][3]
		end
		return r,g,b
	else
	    local hex = colors[serverColor][4]
		if color and colors[color] then
		    hex = colors[color][4]
		end
		return hex
	end
end


function getServerData(dataName)
    local data = 'unknown'
    if dataName then
	    local value = serverData[dataName]
	    if value then
		    data = value
		end
	end
	return data
end

local times = {
    ['month'] = {
	    [0] = "Január",
		[1] = "Febrár", 
		[2] = "Március", 
		[3] = "Április", 
		[4] = "Május",
		[5] = "Június",
		[6] = "Júlis", 
		[7] = "Augusztus",
		[8] = "Szeptember",
		[9] = "Október",
		[10] = "November",
		[11] = "December",
	},
    ['week'] = {
	    [0] = "Vasárnap",
		[1] = "Hétfő", 
		[2] = "Kedd", 
		[3] = "Szerda", 
		[4] = "Csütörtök",
		[5] = "Péntek",
		[6] = "Szombat", 
	},
}

function getTimeStringByNumber(timevalue, number)
    if times[timevalue] and times[timevalue][number] then
	    return times[timevalue][number]
	end
	return false
end

_getTime = getTime
function getTime()
    local time = getRealTime()
    local hour = time.hour
    local minute = time.minute
    local month = time.month + 1
    local monthday = time.monthday
    local year = 1900 + time.year
    if hour < 10 then
        hour = "0" .. tostring(hour)
    end
    if minute < 10 then
        minute = "0" .. tostring(minute)
    end
    if month < 10 then
        month = "0" .. tostring(month)
    end
    if monthday < 10 then
        monthday = "0" .. tostring(monthday)
    end
    return "["..year.."-"..month.."-"..monthday.." "..hour..":"..minute.."]"
end