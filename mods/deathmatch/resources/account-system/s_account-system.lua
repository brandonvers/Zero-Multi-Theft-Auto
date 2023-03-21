local mysql = exports.Connection;
local database = mysql:getConnection(getThisResource());

function JoinPlayer()
    --setElementDimension ( source, 0);
   -- setElementInterior ( source, 0 );
end
addEventHandler ( "onPlayerJoin", getRootElement(), JoinPlayer);

function Login(username, password, valami)
    local qh = dbQuery(database, "SELECT * FROM accounts WHERE username=? ", username);
	local user = dbPoll(qh, 500);
    
    if (user) then
        if (#user > 0) then
            if (user[1]["banned"] == 0) then
                if (user[1]["password"] == password) then
                    if (user[1]["serial"] == getPlayerSerial(source)) then
                        local playing = getElementData(source, "isPlaying");
                        if (playing==false) then
                            outputChatBox("Adatok betöltése folyamatban...",source,0,255,0);
                            setElementData(source, "isPlaying", true);
                            setElementData(source, "acc:charid", user[1]["id"]);
                            setElementData(source, "acc:uname", user[1]["username"]);
                                -- Ide meg elemendata
                            triggerClientEvent(source, "hideUI", source);
                            local accountid = getElementData(source, "acc:charid");
                            
                            sendAccounts(source, accountid);
                        else
                            outputChatBox("Be vagy jelentkezve",source, 255, 0, 0);
                        end
                    else
                        outputChatBox("Mas szerialhoz van tarsitva",source, 255, 0, 0);
                    end
                else
                outputChatBox("Rossz jelszo!",source, 255, 0, 0);
                end
            else
                outputChatBox("Ki vagy bannolva",source);
            end
        else
            outputChatBox("Nincs ilyen fiok!",source, 255, 165, 0);
        end
    else
        outputChatBox("Ismeretlen hiba tortent!",source, 255, 0, 0);
    end
    if (user) then
        dbFree(qh);
    end
end
addEvent("attemptLogin", true);
addEventHandler("attemptLogin", getRootElement(), Login);

function AccountRegistration(username, password, ip, serial, mtausername)
    local qh = dbQuery(database, "SELECT username FROM accounts WHERE username=? ", username);
    local user = dbPoll(qh, 500);
    local qh2 = dbQuery(database, "SELECT serial FROM accounts WHERE serial=? ", getPlayerSerial(source));
    local serial = dbPoll(qh2, 500);
    local ip = getPlayerIP(source);
    local localserial = getPlayerSerial(source);
    local mtausername = getPlayerName(source);

    if (user) then
        if not (#user > 0 ) then
            if (serial) then  
                if not (#serial > 0 ) then   
                dbExec(database, "INSERT INTO accounts SET username=?, password=?, email=?, ip=?, serial=?, mtausername=?", username, password, "", ip, localserial, mtausername);
                outputDebugString("[Account] "..username.." has successfully registered!", 4, 0, 255, 0);
                outputChatBox("A felhasználó sikeresen regisztrálva! Most már bejelentkezhetsz.",source,0,255,0);
                triggerClientEvent(source,"loginChange",source);
                else
                    outputChatBox("Ez a serial ("..localserial..") már társítva van egy felhasználóhoz!",source,255,0,0); 
                end
            end
        else
            outputChatBox("Ez a felhasználónév ("..username..") már regisztrálva van.",source,255,0,0);
        end
    end
    if (user) then
        dbFree(qh);
    end
    if (serial) then
        dbFree(qh2);
    end
end
addEvent("attemptRegister", true);
addEventHandler("attemptRegister", getRootElement(), AccountRegistration);

function LostPassword(username, password, valami)
    outputChatBox("Az email sikeresen kikuldve.",source, 0, 255, 0);
end
addEvent("attemptLostPassword", true);
addEventHandler("attemptLostPassword", getRootElement(), LostPassword);

function sendAccounts(thePlayer, id, isChangeChar)
    if (getElementData(source, "isPlaying")) then
        local qh = dbQuery(database, "SELECT * FROM characters WHERE accountid=? ", id);
        local character = dbPoll(qh, 500);
        local qh2 = dbQuery(database, "SELECT email FROM accounts WHERE id=? ", id);
        local email = dbPoll(qh2, 500);
        local accounts = { };

        --[[
        if (email) then
            if (#email > 0 ) then
                triggerClientEvent(thePlayer, "showCharacterSelection", thePlayer, accounts);
            else
                triggerClientEvent(thePlayer, "showCharacterSelection", thePlayer, accounts, false, true);
            end
        end
        ]]
        if (character) then
            if  (#character > 0 ) then
                local qh3 = dbQuery(database, "SELECT id, charactername, cked, lastarea, age, gender, faction_id, faction_rank, skin, DATEDIFF(NOW(), lastlogin) as llastlogin  FROM characters WHERE accountid=? ", id);
                local result = dbPoll(qh3, 500);

                local i = 1;

                if (result) then
                    local row = result[1];
                    accounts[i] = { };
                    accounts[i][1] = tonumber(row["id"]);
                    accounts[i][2] = row["charactername"];

                    --outputChatBox(tostring(accounts[i][1]))
                    
                    if (tonumber(row["cked"]) or 0) > 0 then
                        accounts[i][3] = 1;
                    end

                    accounts[i][4] = row["lastarea"];
                    accounts[i][5] = tonumber(row["age"]);
                    accounts[i][6] = tonumber(row["gender"]);
                    
                    local factionID = tonumber(row["faction_id"]);
                    local factionRank = tonumber(row["faction_rank"]);
                    
                    if (factionID<1) or not (factionID) then
                       accounts[i][7] = nil;
                        accounts[i][8] = nil;
                   else
                        --factionResult = mysql:query_fetch_assoc("SELECT name, rank_" .. mysql:escape_string(factionRank) .. " as rankname FROM factions WHERE id='" .. mysql:escape_string(tonumber(factionID)) .. "'")
        
                        --if (factionResult) then
                            --accounts[i][7] = factionResult["name"]
                           -- accounts[i][8] = factionResult["rankname"]
                            
                         --   if (string.len(accounts[i][7])>53) then
                                --accounts[i][7] = string.sub(accounts[i][7], 1, 32) .. "..."
                          --  end
                        --else
                            accounts[i][7] = nil;
                            accounts[i][8] = nil;
                        --end
                    end
                    accounts[i][9] = tonumber(row["skin"]);
                    accounts[i][10] = tonumber(row["llastlogin"]);
                    i = i + 1

                end
                triggerClientEvent(thePlayer, "showCharacterSelection", thePlayer, accounts);
            else
                triggerClientEvent(thePlayer, "showCharacterSelection", thePlayer, accounts);
            end
        end
    end
    if (character) then
        dbFree(qh);
    end
    if (email) then
        dbFree(qh2);
    end
    if (result) then
        dbFree(qh3);
    end
end

function storeEmail(email)
	local accountid = getElementData(source, "acc:charid");
    dbExec(database, "UPDATE accounts SET email=?", email, "WHERE accountid=?", accountid);
end
addEvent("storeEmail", true);
addEventHandler("storeEmail", getRootElement(), storeEmail);

function SpawnPlayerDashboard(found, skinID)
    local accountid = getElementData(source, "acc:charid");

    if (found) then

        spawnPlayer(source, 258.43417358398, -41.489139556885, 1002.0234375, 268.19247436523, skinID, 14, 65000+accountid);

        local rand = math.random(1,6);
        if (rand==1) then
            setPedAnimation(source, "PLAYIDLES", "shift", -1, true, true, true);
        elseif (rand==2) then
            setPedAnimation(source, "PLAYIDLES", "shldr", -1, true, true, true);
        elseif (rand==3) then
            setPedAnimation(source, "PLAYIDLES", "stretch", -1, true, true, true);
        elseif (rand==4) then
            setPedAnimation(source, "PLAYIDLES", "strleg", -1, true, true, true);
        elseif (rand==5) then
            setPedAnimation(source, "PLAYIDLES", "time", -1, true, true, true);
        elseif (rand==6) then
            setPedAnimation(source, "ON_LOOKERS", "wave_loop", -1, true, true, true);
        end	
    else

        spawnPlayer(source, 258.43417358398, -41.489139556885, 1002.0234375, 268.19247436523, math.random(1,312), 14, 65000+accountid);

        local rand = math.random(1,6)
        if (rand==1) then
            setPedAnimation(source, "PLAYIDLES", "shift", -1, true, false, true);
        elseif (rand==2) then
            setPedAnimation(source, "PLAYIDLES", "shldr", -1, true, false, true);
        elseif (rand==3) then
            setPedAnimation(source, "PLAYIDLES", "stretch", -1, true, false, true);
        elseif (rand==4) then
            setPedAnimation(source, "PLAYIDLES", "strleg", -1, true, false, true);
        elseif (rand==5) then
            setPedAnimation(source, "PLAYIDLES", "time", -1, true, false, true);
        elseif (rand==6) then
            setPedAnimation(source, "ON_LOOKERS", "wave_loop", -1, false, true, true);
        end	
    end
end
addEvent("SpawnPlayerDashboard", true);
addEventHandler("SpawnPlayerDashboard", getRootElement(), SpawnPlayerDashboard);

function doesCharacterExist(charname)
	charname = string.gsub(tostring(charname), " ", "_");
    local qh = dbQuery(database, "SELECT charactername FROM characters WHERE charactername=? ", charname);
    local character = dbPoll(qh, 500);

	if (#character > 0 ) then
		triggerClientEvent(client, "characterNextStep", source, true);
	else
		triggerClientEvent(client, "characterNextStep", source, false);
	end
	
    if (character) then
        dbFree(qh);
    end
end
addEvent("doesCharacterExist", true);
addEventHandler("doesCharacterExist", getRootElement(), doesCharacterExist);

function createCharacter(name, gender, skincolour, weight, height, fatness, muscles, transport, description, age, skin, language)
	source = client;
	local charname = string.gsub(tostring(name), " ", "_");
	description = string.gsub(tostring(description), "'", "");
	
    local qh = dbQuery(database, "SELECT charactername FROM characters WHERE charactername=? ", charname);
    local character = dbPoll(qh, 500);
    
	--local result = mysql:query("SELECT charactername FROM characters WHERE charactername='" .. safecharname .. "'")

	local accountID = getElementData(source, "acc:charid");
	local accountUsername = getElementData(source, "acc:uname");

	local npid = nil;

	if (#character > 0 ) then -- Name is already taken
		triggerEvent("onPlayerCreateCharacter", source, charname, gender, skincolour, weight, height, fatness, muscles, transport, description, age, skin, language, false);
		return
	else
		
		-- /////////////////////////////////////
		-- TRANSPORT
		-- /////////////////////////////////////
		local x, y, z, r, lastarea = 0, 0, 0, 0, "Unknown";
		
		if (transport==1) then
			x, y, z = 1742.1884765625, -1861.3564453125, 13.577615737915;
			r = 0.98605346679688;
			lastarea = "Unity Bus Station";
		else
			x, y, z = 1685.583984375, -2329.4443359375, 13.546875;
			r = 0.79379272460938;
			lastarea = "Los Santos International";
		end
		
		local salt = "fingerprintscotland";
		local fingerprint = md5(salt .. charname);
		--local id = mysql:query_insert_free("INSERT INTO characters SET charactername='" .. safecharname .. "', x='" .. mysql:escape_string(x) .. "', y='" .. mysql:escape_string(y) .. "', z='" .. mysql:escape_string(z) .. "', rotation='" .. mysql:escape_string(r) .. "', faction_id='-1', transport='" .. mysql:escape_string(transport) .. "', gender='" .. mysql:escape_string(gender) .. "', skincolor='" .. mysql:escape_string(skincolour) .. "', weight='" .. mysql:escape_string(weight) .. "', height='" .. mysql:escape_string(height) .. "', muscles='" .. mysql:escape_string(muscles) .. "', fat='" .. mysql:escape_string(fatness) .. "', description='" .. mysql:escape_string(description) .. "', account='" .. mysql:escape_string(accountID) .. "', skin='" .. mysql:escape_string(skin) .. "', lastarea='" .. mysql:escape_string(lastarea) .. "', age='" .. mysql:escape_string(age) .. "', fingerprint='" .. mysql:escape_string(fingerprint) .. "', lang1=" .. mysql:escape_string(language) .. ", lang1skill=100, currLang=1" )
        local id = dbExec(database, "INSERT INTO characters SET charactername=?, x=?, y=?, z=?, faction_id=?, transport=?, gender=?, skincolor=?, weight=?,  height=?, muscles=?, fat=?, description=?, accountid=?, skin=?, lastarea=?, age=?, fingerprint=?, lang1=?, lang1skill=?, currLang=?", charname, x, y, z, "-1", transport, gender, skincolour, weight, weight, muscles, fatness, description, accountID, skin, lastarea, age, fingerprint, language, "100", "1");

		if (id) then
			--exports['anticheat-system']:changeProtectedElementDataEx(source, "dbid", id, false)
			--exports.global:giveItem( source, 16, skin )
			--exports.global:giveItem( source, 17, 1 )
			--exports.global:giveItem( source, 18, 1 )
			--exports['anticheat-system']:changeProtectedElementDataEx(source, "dbid")

			-- CELL PHONE
			--local cellnumber = id+15000
			--local update = mysql:query_free("UPDATE characters SET cellnumber='" .. mysql:escape_string(cellnumber) .. "' WHERE charactername='" .. safecharname .. "'")
			local update = true;
			if (update) then
				triggerEvent("onPlayerCreateCharacter", source, charname, gender, skincolour, weight, height, fatness, muscles, transport, description, age, skin, language, true);
			else
				outputChatBox("Error 100003 - Report on forums.", source, 255, 0, 0);
			end
			npid = tonumber(id);

			triggerClientEvent(client, "charCreateSuccess", client, npid);
		else
			triggerEvent("onPlayerCreateCharacter", source, charname, gender, skincolour, weight, height, fatness, muscles, transport, description, age, skin, language, false);
		end
	end
	--exports.logs:logMessage("[CREATE CHARACTER] #" .. accountID .. "-" .. accountUsername .. " has created a character by the name " .. charname:gsub("_"," ") .. "-#" .. npid, 31)
	sendAccounts(source, accountID);

    if (character) then
        dbFree(qh);
    end
end
addEvent("onPlayerCreateCharacter", false);
addEvent("createCharacter", true);
addEventHandler("createCharacter", getRootElement(), createCharacter);

function spawnCharacter(charname, version)
	--exports.global:takeAllWeapons(client)
	--exports.global:takeAllWeapons(source)
	--takeAllWeapons(source)
	--takeAllWeapons(client)
	source = client
	
	local id = getElementData(client, "acc:charid")
	charname = string.gsub(tostring(charname), " ", "_")
	
	--local safecharname = mysql:escape_string(charname)
	
    local qh = dbQuery(database, "SELECT * FROM characters WHERE charactername=? ", charname);
    local data2 = dbPoll(qh, 500);

	--local data = mysql:query_fetch_assoc("SELECT * FROM characters WHERE charactername='" .. safecharname .. "' AND account='" .. mysql:escape_string(id) .. "' AND cked = 0")
	
    local data = data2[1]

	if (data) then
		local id = tonumber(data["acc:charid"])
		local currentid = getElementData(source, "acc:id")

		local x = tonumber(data["x"])
		local y = tonumber(data["y"])
		local z = tonumber(data["z"])
		local rot = tonumber(data["rotation"])

		local interior = tonumber(data["interior"])
		local dimension = tonumber(data["dimension"])
		local health = tonumber(data["health"])

		local skin = tonumber(data["skin"])
		local fingerprint = tostring(data["fingerprint"])

		local factionrank = tonumber(data["faction_rank"])
		local gender = tonumber(data["gender"])

		local age = data["age"]
		local race = tonumber(data["skincolor"])
		local weight = data["weight"]
		local height = data["height"]
		local desc = data["description"]

		setPlayerNametagShowing(source, true)


		setPlayerName(source, tostring(charname))
        local fixedName = string.gsub(tostring(charname), "_", " ")
        setPlayerNametagText(source, tostring(fixedName))
		-- Server message
		clearChatBox(source)
		outputChatBox("* " .. charname .. " karaktere sikeresen betöltve.", source, 0, 255, 0)

		outputChatBox("(( Segítségre van szükséged? Használd a '/helpme' parancsot! ))", source, 255, 194, 14)
		outputChatBox("(( Ha itt se találtad meg a választ, használd az interaktív menünket -> /? ))", source, 255, 194, 14)
		--triggerClientEvent (source, "LoginZeneStop")

		setPedGravity ( source,0.008 )
		--setElementData(source, "superman:flying", false)
		setPedAnimation(source, false)
		setElementVelocity(source, 0, 0, 0)
		

		setElementFrozen(source, false)
		
		-- Load the character info
		setElementHealth(source, health)
		--setPedArmor(source, armor)


        spawnPlayer(source, x, y, z, rot, skin)
        setCameraTarget(source, source);
        fadeCamera(source, true);
        showCursor(source, false);

		setElementDimension(source, dimension)
		setElementInterior(source, interior, x, y, z)
		setCameraInterior(source, interior)
		

		-- LAST LOGIN
        dbExec(database, "UPDATE characters SET lastlogin=NOW() WHERE id=?", id);
			
		triggerEvent("onCharacterLogin", source, charname, factionID)
		

		--triggerClientEvent(source, "updateHudClock", source)
	else
		outputDebugString( "Spawning Char failed: ")
	end
end
addEvent("onCharacterLogin", false)
addEvent("spawnCharacter", true)
addEventHandler("spawnCharacter", getRootElement(), spawnCharacter)







function quitPlayer()
	setElementData(source, "isPlaying", false);
end
addEventHandler ( "onPlayerQuit", getRootElement(), quitPlayer);