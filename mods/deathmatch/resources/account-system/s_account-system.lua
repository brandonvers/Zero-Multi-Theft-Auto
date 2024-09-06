local mysql = exports.Connection;
local database = mysql:getConnection(getThisResource());

function JoinPlayer()
    setElementDimension (source, 0);
    setElementInterior (source, 0 );
    clearChatBox(source);
end
addEventHandler ("onPlayerJoin", getRootElement(), JoinPlayer);

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
                            setElementData(source, "acc:accid", user[1]["id"]);
                            setElementData(source, "acc:uname", user[1]["username"]);
                            setElementData(source, "acc:adminlevel", 0);
                            setElementData(source, "acc:muted", 0);
                          --  setElementData(source, "acc:playhour", 0);
                           -- setElementData(source, "acc:pp", 0);
                                -- Ide meg elemendata
                            triggerClientEvent(source, "hideUI", source);
                            local accountid = getElementData(source, "acc:accid");
                            
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

function LostPassword(email, email2x, valami)
    local qh = dbQuery(database, "SELECT email FROM accounts WHERE email=? ", email);
    local email = dbPoll(qh, 500);
    if (user) then
        outputChatBox("Az email sikeresen kikuldve.",source, 0, 255, 0);
        --TODO: Itt ezt meg majd folytatni kell email kuldessel stb
    else
        outputChatBox("Hibas email cim vagy nincs felhasznalod.", source, 255, 0, 0);
    end
    if (email) then
        dbFree(qh);
    end
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

        if not (#tostring(email[1]["email"]) > 0) then
          triggerClientEvent(thePlayer, "showCharacterSelection", thePlayer, accounts, false, true);
        end
        
        if (character) then
            if  (#character > 0 ) then
                local qh3 = dbQuery(database, "SELECT id, charactername, cked, lastarea, age, gender, faction_id, faction_rank, skin, DATEDIFF(NOW(), lastlogin) as llastlogin  FROM characters WHERE accountid=? ", id);
                local result = dbPoll(qh3, 500);

                for i = 1, #character do
                    if (result) then
                        local row = result[i];
                        accounts[i] = { };
                        accounts[i][1] = tonumber(row["id"]);
                        accounts[i][2] = row["charactername"];
    
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
                end

               -- local i = 1;
               -- outputDebugString("result elott"..#character)

               --[[

                if (result) then
                    local row = result[1];
                    accounts[i] = { };
                    accounts[i][1] = tonumber(row["id"]);
                    accounts[i][2] = row["charactername"];

                    --outputChatBox(tostring(accounts[2][2]))
                    outputDebugString("resultba 1:"..#result)

                    
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

                ]]--
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
	local accountid = getElementData(source, "acc:accid");
    dbExec(database, "UPDATE accounts SET email=?", email, "WHERE accountid=?", accountid);
end
addEvent("storeEmail", true);
addEventHandler("storeEmail", getRootElement(), storeEmail);

function SpawnPlayerDashboard(found, skinID)
    local accountid = getElementData(source, "acc:accid");

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

       -- spawnPlayer(source, 258.43417358398, -41.489139556885, 1002.0234375, 268.19247436523, math.random(1,312), 14, 65000+accountid);
       spawnPlayer(source, 258.43417358398, -41.489139556885, 1002.0234375, 268.19247436523, 0, 14, 65000+accountid);

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

	local accountID = getElementData(source, "acc:accid");
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
        local id = dbExec(database, "INSERT INTO characters SET charactername=?, x=?, y=?, z=?, faction_id=?, transport=?, gender=?, skincolor=?, weight=?, height=?, muscles=?, fat=?, description=?, accountid=?, skin=?, lastarea=?, age=?, fingerprint=?, lang1=?, lang1skill=?, currLang=?", charname, x, y, z, "-1", transport, gender, skincolour, weight, weight, muscles, fatness, description, accountID, skin, lastarea, age, fingerprint, language, "100", "1");

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
	
	local id = getElementData(client, "acc:accid");
	charname = string.gsub(tostring(charname), " ", "_");
	
	--local safecharname = mysql:escape_string(charname)
	
    local qh = dbQuery(database, "SELECT * FROM characters WHERE charactername=? ", charname);
    local data2 = dbPoll(qh, 500);

	--local data = mysql:query_fetch_assoc("SELECT * FROM characters WHERE charactername='" .. safecharname .. "' AND account='" .. mysql:escape_string(id) .. "' AND cked = 0")
	
    local data = data2[1];

	if (data) then
		local id = tonumber(data["acc:accid"]);
		local currentid = getElementData(source, "acc:id");

		local x = tonumber(data["x"]);
		local y = tonumber(data["y"]);
		local z = tonumber(data["z"]);
		local rot = tonumber(data["rotation"]);

		local interior = tonumber(data["interior"]);
		local dimension = tonumber(data["dimension"]);
		local health = tonumber(data["health"]);

		local skin = tonumber(data["skin"]);
		local fingerprint = tostring(data["fingerprint"]);

		local factionrank = tonumber(data["faction_rank"]);
		local gender = tonumber(data["gender"]);

		local age = data["age"];
		local race = tonumber(data["skincolor"]);
		local weight = data["weight"];
		local height = data["height"];
		local desc = data["description"];

		setPlayerNametagShowing(source, true);


		setPlayerName(source, tostring(charname));
        local fixedName = string.gsub(tostring(charname), "_", " ");
        setPlayerNametagText(source, tostring(fixedName));
		-- Server message
		clearChatBox(source);
		outputChatBox("* " .. charname .. " karaktere sikeresen betöltve.", source, 0, 255, 0);

		outputChatBox("(( Segítségre van szükséged? Használd a '/helpme' parancsot! ))", source, 255, 194, 14);
		outputChatBox("(( Ha itt se találtad meg a választ, használd az interaktív menünket -> /? ))", source, 255, 194, 14);
		--triggerClientEvent (source, "LoginZeneStop")

		setPedGravity ( source,0.008 );
		--setElementData(source, "superman:flying", false)
		setPedAnimation(source, false);
		setElementVelocity(source, 0, 0, 0);
		

		setElementFrozen(source, false);
        -- blindfolds
		if (blindfold==1) then
			--exports['anticheat-system']:changeProtectedElementDataEx(source, "blindfold", 1)
			outputChatBox("Your character is blindfolded. If this was an OOC action, please contact an administrator via F2.", source, 255, 194, 15)
			--fadeCamera(player, false)
		else
			fadeCamera(source, true, 2)
			setTimer(blindfoldFix, 5000, 1, source)
		end
		
		-- Load the character info
		setElementHealth(source, health);
		--setPedArmor(source, armor)


        spawnPlayer(source, x, y, z, rot, skin);
        setCameraTarget(source, source);
        fadeCamera(source, true);
        showCursor(source, false);

		setElementDimension(source, dimension)
		setElementInterior(source, interior, x, y, z)
		setCameraInterior(source, interior)


		

		-- LAST LOGIN
        dbExec(database, "UPDATE characters SET lastlogin=NOW() WHERE id=?", id);
			
		triggerEvent("onCharacterLogin", source, charname, factionID);
		

		--triggerClientEvent(source, "updateHudClock", source)
	else
		outputDebugString( "Spawning Char failed: ");
	end
end
addEvent("onCharacterLogin", false);
addEvent("spawnCharacter", true);
addEventHandler("spawnCharacter", getRootElement(), spawnCharacter);

function blindfoldFix(player)
	fadeCamera(player, true, 2)
end

function sendEditingInformation(charname)
	local qh = dbQuery(database, "SELECT description, age, weight, height, gender FROM characters WHERE charactername=? ", charname);
    local result = dbPoll(qh, 500);

	local description = tostring(result["description"]);
	local age = tostring(result["age"]);
	local weight = tostring(result["weight"]);
	local height = tostring(result["height"]);
	local gender = tonumber(result["gender"]);
	
	triggerClientEvent(client, "sendEditingInformation", client, height, weight, age, description, gender)
end
addEvent("requestEditCharInformation", true);
addEventHandler("requestEditCharInformation", getRootElement(), sendEditingInformation);


function updateEditedCharacter(charname, height, weight, age, description)
    charname = string.gsub(tostring(charname), " ", "_");
    dbExec(database, "UPDATE characters SET description=?, height=?, weight=?, age=?", description, height, weight, age, "WHERE charactername=?", charname);
end
addEvent("updateEditedCharacter", true);
addEventHandler("updateEditedCharacter", getRootElement(), updateEditedCharacter);


function deleteCharacterByName(charname)
	
	--local fixedName = mysql:escape_string(string.gsub(tostring(charname), " ", "_"))
    local charname2 = string.gsub(tostring(charname), " ", "_");

	local accountID = getElementData(client, "acc:id");

	--local result = mysql:query_fetch_assoc("SELECT id FROM characters WHERE charactername='" .. fixedName .. "' AND account='" .. mysql:escape_string(accountID) .. "' LIMIT 1")
	local qh = dbQuery(database, "SELECT * FROM characters WHERE charactername=? ", charname2);
    local result = dbPoll(qh, 500);

    --outputDebugString(tostring(result[1]["id"]))
    local charid = tonumber(result[1]["id"]);
   -- outputDebugString("charid1lol:".. charid)
	if charid then -- not ck'ed
		-- delete all in-game vehicles
        --[[
		for key, value in pairs( getElementsByType( "vehicle" ) ) do
			if isElement( value ) then
				if getElementData( value, "owner" ) == charid then
					call( getResourceFromName( "item-system" ), "deleteAll", 3, getElementData( value, "dbid" ) )
					destroyElement( value )
				end
			end
		end
		mysql:query_free("DELETE FROM vehicles WHERE owner = " .. mysql:escape_string(charid) )

        

		-- logs the deletion of the characters
		local accountUsername = getElementData(client, "gameaccountusername")
		--exports.logs:logMessage("[DELETE CHARACTER] #" .. accountID .. "-" .. accountUsername .. " has deleted character #" .. charid .. "-" .. charname .. ".", 31)

		-- un-rent all interiors
		local old = getElementData( client, "dbid" )
		--exports['anticheat-system']:changeProtectedElementDataEx( client, "dbid", charid )
		local result = mysql:query("SELECT id FROM interiors WHERE owner = " .. mysql:escape_string(charid) .. " AND type != 2" )
		if result then
			while true do
				local row = mysql:fetch_assoc()
				if not row then break end
				
				local id = tonumber(row["id"])
				call( getResourceFromName( "interior-system" ), "publicSellProperty", client, id, false, false )
			end
		end
		--exports['anticheat-system']:changeProtectedElementDataEx( client, "dbid", old )
		
		-- get rid of all items
		mysql:query_free("DELETE FROM items WHERE type = 1 AND owner = " .. mysql:escape_string(charid) )


		]]-- ezt csak msot vesszuk ki

		-- finally delete the character
		--mysql:query_free("DELETE FROM characters WHERE id='" .. mysql:escape_string(charid) .. "' AND account='" .. mysql:escape_string(accountID) .. "' LIMIT 1")
        dbExec(database, "DELETE FROM characters WHERE id=?", charid);
    end
	--sendAccounts(client, accountID)
	--showChat(client, true)
    if (charid) then
        dbFree(qh);
    end
end
addEvent("deleteCharacter", true);
addEventHandler("deleteCharacter", getRootElement(), deleteCharacterByName);


function cguiSetNewPassword(oldPassword, newPassword)
	
	local gameaccountID = getElementData(source, "acc:accid");
    local safeoldpassword = hash("sha512", oldPassword);
	local safenewpassword = hash("sha512", newPassword);
	
    local qh = dbQuery(database, "SELECT username FROM accounts WHERE id=? ", gameaccountID, "AND password=?", safeoldpassword);
    local result = dbPoll(qh, 500);
	
	if not (result) or (#result==0) then
		outputChatBox("A beirt jelenlegi jelszavad hibas", client, 255, 0, 0);
	else
		local update = dbExec(database, "UPDATE accounts SET password=?", safenewpassword, "WHERE id=?", gameaccountID);

		if (update) then
			outputChatBox("Sikeresen lecserelted a jelszavad erre:'" .. newPassword .. "'", client, 0, 255, 0);
		else
			outputChatBox("Error 100004 - Report on forums.", client, 255, 0, 0);
		end
	end

    if (result) then
        dbFree(qh);
    end
end
addEvent("cguiSavePassword", true);
addEventHandler("cguiSavePassword", getRootElement(), cguiSetNewPassword);


function quitPlayer()
	setElementData(source, "isPlaying", false);
end
addEventHandler ( "onPlayerQuit", getRootElement(), quitPlayer);