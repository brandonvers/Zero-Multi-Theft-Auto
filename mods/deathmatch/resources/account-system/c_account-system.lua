
function startAccountSystem()
    LoadScenairo();
    fadeCamera(true);
	toggleAllControls(false);
	setPlayerHudComponentVisible("all", false);

	ClearChat();
    outputChatBox("Kérlek regisztrálj vagy jelentkezz be!",0,255,0);

    local data = jsonGET("files/@save.json");
    saveJSON = data;
    if saveJSON["AutoLogin"] then
        triggerServerEvent("attemptLogin", getLocalPlayer(), saveJSON["Username"], hash("sha512",saveJSON["Password"]));
    else
    	CreateMainUI();
    end

    local cursor = isCursorShowing();
    if not (cursor) then
    	showCursor(true);
    end

    local chat = isChatVisible()
    if not (chat) then
        showChat(true);
    end

	addEventHandler("onClientRender", root, drawnDetails, true, "low-5")

    local screenW, screenH = guiGetScreenSize();
    if (screenW<800) and (screenH<600) then
        outputChatBox("FIGYELMEZTETÉS: Alacsony felbontáson fut. Javasoljuk, a legalább 800x600 képernyot.", 255, 0, 0);
    end
end
addEventHandler("onClientResourceStart", resourceRoot, startAccountSystem);

function ClearChat()
	clearChatBox();
end

function LoadScenairo()
    local random = math.random(1,4);
    setCameraInterior(0);

    if (random == 1) then
        setCameraMatrix(-266.41470336914,  -1636.9976806641, 19.694910049438, -299.54403686523, -1731.0089111328, 11.674066543579);
    elseif (random == 2) then	
        setCameraMatrix(1913.0233154297,  -1520.1419677734, 69.260650634766, 1844.9996337891, -1461.9838867188, 24.646472930908);
    elseif (random == 3) then	
        setCameraMatrix(1478.359375,  -1598.4383544922, 66.061477661133, 1505.2705078125, -7559.108695983887, -2993.615604400635);
    elseif (random == 4) then	
        setCameraMatrix(1848.7145996094,  -1260.2722167969, 74.357635498047, 1911.1743164063, -1192.513671875, 35.530269622803);
    end 
end

function jsonGET(file)
    local fileHandle;
    local jsonDATA = {};
    if not fileExists(file) then
        fileHandle = fileCreate(file);
        fileWrite(fileHandle, toJSON({["Username"] = "", ["Password"] = "", ["Clicked"] = false, ["HaveAccount"] = false, ["AutoLogin"] = false, ["HaveTour"] = false}));
        fileClose(fileHandle);
        fileHandle = fileOpen(file);
    else
        fileHandle = fileOpen(file);
    end
    if fileHandle then
        local buffer;
        local allBuffer = "";
        while not fileIsEOF(fileHandle) do
            buffer = fileRead(fileHandle, 500);
            allBuffer = allBuffer..buffer;
        end
        jsonDATA = fromJSON(allBuffer);
        fileClose(fileHandle);
    end
    return jsonDATA;
end

function jsonSAVE(file, data)
	if fileExists(file) then
		fileDelete(file);
	end
	local fileHandle = fileCreate(file);
	fileWrite(fileHandle, toJSON(data));
	fileFlush(fileHandle);
	fileClose(fileHandle);
	return true;
end

local saveJSON = {};

--local data = jsonGET("files/@save.json")
--saveJSON = data

function CreateMainUI()
    local data = jsonGET("files/@save.json");
    saveJSON = data;
    local labelFont_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 11);
    tabPanelMain = guiCreateTabPanel(0.40, 0.41, 0.20, 0.19, true);
    guiSetAlpha(tabPanelMain, 0.75);

    if saveJSON["HaveAccount"] then
        tabLogin = guiCreateTab("Bejelentkezés", tabPanelMain);
        tabRegister = guiCreateTab("Regisztráció", tabPanelMain);
        tabForgottPwd = guiCreateTab("Elfelejtett jelszó", tabPanelMain);
    else
        tabRegister = guiCreateTab("Regisztráció", tabPanelMain);
        tabLogin = guiCreateTab("Bejelentkezés", tabPanelMain);
        tabForgottPwd = guiCreateTab("Elfelejtett jelszó", tabPanelMain);
    end
    
    -- Registration --
    lRegUsername = guiCreateLabel(0.06, 0.14, 0.25, 0.10, "Felhasználónév:", true, tabRegister);
    guiSetFont(lRegUsername, labelFont_roboto);
    guiLabelSetHorizontalAlign(lRegUsername, "center", false);
    lRegUsernameNote = guiCreateLabel(0.00, 0.24, 1.00, 0.09, "Megjegyzés: ez nem a karaktered neve.", true, tabRegister);
    guiSetFont(lRegUsernameNote, "default-bold-small");
    guiLabelSetHorizontalAlign(lRegUsernameNote, "center", false);
    guiLabelSetVerticalAlign(lRegUsernameNote, "center");

    tRegUsername = guiCreateEdit(0.32, 0.14, 0.41, 0.10, "", true, tabRegister);
    guiEditSetMaxLength(tRegUsername, 25);

    lRegPassword = guiCreateLabel(0.08, 0.38, 0.19, 0.12, "Jelszó:", true, tabRegister);
    guiSetFont(lRegPassword, labelFont_roboto);
    guiLabelSetHorizontalAlign(lRegPassword, "center", false);
    guiLabelSetVerticalAlign(lRegPassword, "center");

    tRegPassword = guiCreateEdit(0.32, 0.40, 0.41, 0.10, "", true, tabRegister);
    guiEditSetMasked(tRegPassword, true);
    guiEditSetMaxLength(tRegPassword, 28);

    lRegPassword2 = guiCreateLabel(0.08, 0.54, 0.19, 0.12, "Jelszó(2x):", true, tabRegister);
    guiSetFont(lRegPassword2, labelFont_roboto);
    guiLabelSetHorizontalAlign(lRegPassword2, "center", false);
    guiLabelSetVerticalAlign(lRegPassword2, "center");

    tRegPassword2 = guiCreateEdit(0.32, 0.56, 0.41, 0.10, "", true, tabRegister);
    guiEditSetMasked(tRegPassword2, true);
    guiEditSetMaxLength(tRegPassword2, 28);

    bRegister = guiCreateButton(0.28, 0.77, 0.47, 0.18, "Regisztráció", true, tabRegister);
    guiSetAlpha(bRegister, 0.90);
    -- Registration Event Handler --
    addEventHandler("onClientGUIClick", bRegister, ValidateDetails);
    
    -- Login --
    lLogUsername = guiCreateLabel(0.09, 0.19, 0.24, 0.10, "Felhasználónév:", true, tabLogin);
    guiSetFont(lLogUsername, labelFont_roboto);
    guiLabelSetHorizontalAlign(lLogUsername, "center", false);
    guiLabelSetVerticalAlign(lLogUsername, "center");
    lLogUsernameNote = guiCreateLabel(0.00, 0.31, 1.00, 0.09, "Megjegyzés: ez nem a karaktered neve.", true, tabLogin);
    guiSetFont(lLogUsernameNote, "default-bold-small");
    guiLabelSetHorizontalAlign(lLogUsernameNote, "center", false);

    tLogUsername = guiCreateEdit(0.35, 0.19, 0.38, 0.10, saveJSON["Username"], true, tabLogin);
    guiEditSetMaxLength(tLogUsername, 25);

    lLogPassword = guiCreateLabel(0.11, 0.44, 0.20, 0.10, "Jelszó:", true, tabLogin);
    guiSetFont(lLogPassword, labelFont_roboto);
    guiLabelSetHorizontalAlign(lLogPassword, "center", false);

    tLogPassword = guiCreateEdit(0.35, 0.43, 0.38, 0.10, saveJSON["Password"], true, tabLogin);
    guiEditSetMasked(tLogPassword, true);
    guiEditSetMaxLength(tLogPassword, 28);

    if saveJSON["Clicked"] then
        chkRemember = guiCreateCheckBox(0.36, 0.57, 0.37, 0.09, "Jegyezz meg", true, true, tabLogin);
    else
    chkRemember = guiCreateCheckBox(0.36, 0.57, 0.37, 0.09, "Jegyezz meg", false, true, tabLogin);
    end
    if saveJSON["AutoLogin"] then
        chkAutoLogin = guiCreateCheckBox(0.36, 0.67, 0.37, 0.08, "Autómatikus bejelentkezés", true, true, tabLogin);
    else
    chkAutoLogin = guiCreateCheckBox(0.36, 0.67, 0.37, 0.08, "Autómatikus bejelentkezés", false, true, tabLogin);
    end
    bLogin = guiCreateButton(0.29, 0.77, 0.47, 0.17, "Bejelentkezés", true, tabLogin);
    guiSetAlpha(bLogin, 0.90);
    -- Login Event Handler --
    addEventHandler("onClientGUIClick", bLogin, ValidateDetails);

    -- Forgot Password --
    lLostPassword = guiCreateLabel(0.05, 0.15, 0.24, 0.13, "E-mail címed:", true, tabForgottPwd);
    guiSetFont(lLostPassword, labelFont_roboto);
    guiLabelSetHorizontalAlign(lLostPassword, "center", false);
    guiLabelSetVerticalAlign(lLostPassword, "center");

    tLostPassword = guiCreateEdit(0.32, 0.18, 0.57, 0.11, "", true, tabForgottPwd);
    guiEditSetMaxLength(tLostPassword, 48);

    lLostPassword2 = guiCreateLabel(0.05, 0.37, 0.27, 0.13, "E-mail címed(2x):", true, tabForgottPwd);
    guiSetFont(lLostPassword2, labelFont_roboto);
    guiLabelSetHorizontalAlign(lLostPassword2, "center", false);
    guiLabelSetVerticalAlign(lLostPassword2, "center");

    tLostPassword2 = guiCreateEdit(0.32, 0.39, 0.57, 0.11, "", true, tabForgottPwd);
    guiEditSetMaxLength(tLostPassword2, 48);

    lLostPasswordNote = guiCreateLabel(0.00, 0.54, 1.00, 0.11, "Megjegyzés: a felhasználónevedet is megkapod.", true, tabForgottPwd);
    guiSetFont(lLostPasswordNote, "default-bold-small");
    guiLabelSetHorizontalAlign(lLostPasswordNote, "center", false);
    guiLabelSetVerticalAlign(lLostPasswordNote, "center");

    bLostPassword = guiCreateButton(0.30, 0.75, 0.45, 0.18, "Küldés", true, tabForgottPwd);
    guiSetAlpha(bLostPassword, 0.90);
    -- Lost Password Event Handler --
    addEventHandler("onClientGUIClick", bLostPassword, ValidateDetails);

	setTimer(fadeWindow, 50, 20)

end

function ValidateDetails()
    if (source==bRegister) then
		local username = guiGetText(tRegUsername);
		local password1 = guiGetText(tRegPassword);
		local password2 = guiGetText(tRegPassword2);
		
		local password = password1 .. password2;
		
		clearChatBox();
		if (string.len(username)<4) then
			outputChatBox("A felhasználó nevednek minimum 4 karaktert kell tartalmaznia.", 255, 0, 0);
		elseif (string.find(username, ";", 0)) or (string.find(username, "'", 0)) or (string.find(username, "@", 0)) or (string.find(username, ",", 0)) then
			outputChatBox("A neved nem tartalmazhat ;,@'. szimbólumokat.", 255, 0, 0);
		elseif (string.len(password1)<6) then
			outputChatBox("A jelszavadnak minimum 6 karaktert kell tartalmaznia.", 255, 0, 0);
		elseif (string.len(password1)>=30) then
			outputChatBox("A jelszavad maximálisan 30 karakter lehet.", 255, 0, 0);
        elseif (string.len(password2)<6) then
			outputChatBox("A második jelszavadnak is minimum 6 karaktert kell tartalmaznia.", 255, 0, 0);
		elseif (string.len(password2)>=30) then
			outputChatBox("A második jelszavad is maximálisan 30 karakter lehet.", 255, 0, 0);
		elseif (string.find(password, ";", 0)) or (string.find(password, "'", 0)) or (string.find(password, "@", 0)) or (string.find(password, ",", 0)) then
			outputChatBox("A jelszavad nem tartalmazhat ;,@'. szimbólumokat.", 255, 0, 0);
		elseif (password1~=password2) then
			outputChatBox("A két jelszó nem egyezik!", 255, 0, 0);
		else
			triggerServerEvent("attemptRegister", getLocalPlayer(), username, hash("sha512",password1));
		end

	elseif (source==bLogin) then
		local username = guiGetText(tLogUsername);
		local password = guiGetText(tLogPassword);
		
		clearChatBox();
		if (string.len(username)<3) then
			outputChatBox("A felhasználó nevednek minimum 3 karaktert kell tartalmaznia.", 255, 0, 0);
		elseif (string.find(username, ";", 0)) or (string.find(username, "'", 0)) or (string.find(username, "@", 0)) or (string.find(username, ",", 0)) then
			outputChatBox("A neved nem tartalmazhat ;,@'. szimbólumokat.", 255, 0, 0);
		elseif (string.len(password)<6) then
			outputChatBox("A jelszavadnak minimum 6 karaktert kell tartalmaznia.", 255, 0, 0);
		elseif (string.find(password, ";", 0)) or (string.find(password, "'", 0)) or (string.find(password, "@", 0)) or (string.find(password, ",", 0)) then
			outputChatBox("A jelszavad nem tartalmazhat ;,@'. szimbólumokat.", 255, 0, 0);
		else
			clearChatBox();
			local saveInfo = guiCheckBoxGetSelected(chkRemember);
			local autoLogin = guiCheckBoxGetSelected(chkAutoLogin);
			triggerServerEvent("attemptLogin", getLocalPlayer(), username, hash("sha512",password));

			local data2 = jsonGET("files/@save.json");
            saveJSON2 = data2;
			saveJSON2["HaveAccount"] = true;
            
            if (saveInfo) then
                local data = jsonGET("files/@save.json");
                saveJSON = data;
                saveJSON["Username"] = username;
                saveJSON["Password"] = password;
                saveJSON["Clicked"] = true;
				saveJSON["HaveAccount"] = true;
				
            end
            jsonSAVE("files/@save.json", saveJSON);

            if (autoLogin) then
					saveJSON["Username"] = username;
                	saveJSON["Password"] = password;
                    saveJSON["AutoLogin"] = true;
					saveJSON["HaveAccount"] = true;
            else
            end
            jsonSAVE("files/@save.json", saveJSON);
		end

    elseif (source==bLostPassword) then
        local email = guiGetText(tLostPassword);
        local email2x = guiGetText(tLostPassword2);

		clearChatBox();
        if (string.len(email)<5) then
            outputChatBox("Az email címednek minimum 5 karaktert kell tartalmaznia.", 255, 0, 0);
        elseif not (string.find(email, "@", 0)) then
            outputChatBox("Az email címednek tartalmaznia kell a @ karaktert.", 255, 0, 0);
        elseif (email~=email2x) then
            outputChatBox("A két email cím nem egyezik!", 255, 0, 0);
        else
            triggerServerEvent("attemptLostPassword", getLocalPlayer(), email);
    	end
	end
end

function fadeWindow()
	if (tabPanelMain) then
		local alpha = guiGetAlpha(tabPanelMain)
		local newalpha = alpha + 0.05
		guiSetAlpha(tabPanelMain, newalpha)
		
		if(newalpha>=0.7) then
			guiSetAlpha(tabPanelMain, 0.75)
			guiSetInputEnabled(true)
		end
	end
end

function hideUI(regged)

	--cleanupEmail()
	
	if (tabPanelMain) then
		destroyElement(tabPanelMain);
		tabPanelMain = nil
		showChat(false);
	end
	
	if (tabPanelCharacter) then
		destroyElement(tabPanelCharacter);
		tabPanelCharacter = nil
	end
	
	if (regged) then
		createMainUI();
	end
	
	if (bChangeAccount) then
		destroyElement(bChangeAccount)
		bChangeAccount = nil
	end
	
	if wDelConfirmation then
		destroyElement(wDelConfirmation)
		wDelConfirmation = nil
	end
end
addEvent("hideUI", true);
addEventHandler("hideUI", getRootElement(), hideUI);

sent = false;
function changedTab(tab)
	if (tab==tabAchievements) and not (sent) then
		sent = true;
		commingsoon = guiCreateLabel(0.00, 0.00, 1.00, 1.00, "Hamarosan...", true, tabAchievements)
        guiLabelSetHorizontalAlign(commingsoon, "center", false)
        guiLabelSetVerticalAlign(commingsoon, "center")  
		--triggerServerEvent("requestAchievements", getLocalPlayer())
	end
end

function loginChange()
    local data = jsonGET("files/@save.json");
    saveJSON = data;
    saveJSON["HaveAccount"] = true;
    jsonSAVE("files/@save.json", saveJSON);

    destroyElement(tabPanelMain);
    CreateMainUI();
end
addEvent("loginChange", true);
addEventHandler("loginChange", getRootElement(), loginChange);

-- Character Section --

function showCharacterUI(accounts, firstTime, needsEmail)
    local font0_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 11);
    local font1_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 12);

    if not (firstTime) then
		--showChat(false);
	end

	setElementInterior (getLocalPlayer(), 14);
	setCameraInterior(14);
	setCameraMatrix(257.20394897461, -40.330944824219, 1002.5234375, 260.32162475586, -41.565814971924, 1002.0234375);
    fadeCamera(true);

    toggleAllControls(false, true, false);

	tableAccounts = accounts;

    tabPanelCharacter = guiCreateTabPanel(0.00, 0.36, 0.19, 0.32, true);
    guiSetAlpha(tabPanelCharacter, 0.75);

    tabCharacter = guiCreateTab("Karakter választás", tabPanelCharacter);
    tabAccount = guiCreateTab("Információ", tabPanelCharacter);
    tabAchievements = guiCreateTab("Díjaim", tabPanelCharacter); 
    addEventHandler("onClientGUITabSwitched", tabPanelCharacter, changedTab) 

	displayAccountManagement();

	local charsDead, charsAlive = 0, 0
	
	for key, value in pairs(accounts) do
		if (tonumber(accounts[key][3])==1) then
			charsDead = charsDead + 1
		else
			charsAlive = charsAlive + 1
		end
	end
    
    lCharacters = guiCreateLabel(0.05, 0.02, 0.90, 0.06, "Karakterek: ".. #accounts ..".", true, tabCharacter);
    guiSetFont(lCharacters, font0_roboto);
    guiLabelSetVerticalAlign(lCharacters, "center");

    paneCharacters = guiCreateScrollPane(0.05, 0.11, 0.90, 0.76, true, tabCharacter);
    paneChars = { };
	local y = 0.0

    for key, value in pairs(accounts) do
		local charname = string.gsub(tostring(accounts[key][2]), "_", " ");
		local cked = tonumber(accounts[key][3]);
		local area = accounts[key][4];
		local age = accounts[key][5];
		local gender = tonumber(accounts[key][6]);
		local factionName = accounts[key][7];
		local factionRank = accounts[key][8];
		local skinID = tostring(accounts[key][9]);
		local difference = tonumber(accounts[key][10]);
		local login = "";

		if (not difference) then
			login = "Soha";
		else
			if (difference==0) then
				login = "ma";
			elseif (difference==1) then
				login = tostring(difference) .. " nappal ezelõtt";
			else
				login = tostring(difference) .. " nappal ezelõtt";
			end
		end

		if (string.len(skinID)==2) then
			skinID = "0" .. skinID;
		elseif (string.len(skinID)==1) then
			skinID = "00" .. skinID;
		end

		if (tonumber(gender)==0) then
			gender = "Ferfi";
		else
			gender = "No";
		end
        
		local font0_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 10);

		paneChars[key] = {};
        paneChars[key][7] = guiCreateScrollPane(0.00, y, 1.00, 0.23, true, paneCharacters)
        paneChars[key][1] = guiCreateStaticImage(0.00, 0.00, 1.00, 1.00, ":account-system/img/charbg0.png", true, paneChars[key][7])
		guiSetAlpha(paneChars[key][1], 0.90);
		paneChars[key][8] = cked;

		if (cked==nil) then
			paneChars[key][2] = guiCreateLabel(0.27, 0.00, 0.73, 0.25, tostring(charname), true, paneChars[key][7])
			guiLabelSetHorizontalAlign(paneChars[key][2], "center", false)
		else
			paneChars[key][2] = guiCreateLabel(0.27, 0.00, 0.73, 0.25, tostring(charname), true, paneChars[key][7])
			guiLabelSetHorizontalAlign(paneChars[key][2], "center", false)
		end

        paneChars[key][3] = guiCreateStaticImage(0.03, 0.00, 0.24, 1.00, ":account-system/img/" .. skinID .. ".png", true,  paneChars[key][7])
        guiSetFont(paneChars[key][3], font0_roboto);
        paneChars[key][4] = guiCreateLabel(0.27, 0.25, 0.73, 0.25, age .. " éves " .. gender .. ".", true, paneChars[key][7])
        guiSetFont(paneChars[key][4], font0_roboto);
		guiLabelSetHorizontalAlign(paneChars[key][4], "center", false)
		if (factionRank==nil) then
        	paneChars[key][5] = guiCreateLabel(0.27, 0.50, 0.73, 0.25, "Nincs frakcióban.", true, paneChars[key][7])
			guiLabelSetHorizontalAlign(paneChars[key][5], "center", false)
		else
			paneChars[key][5] = guiCreateLabel(0.27, 0.50, 0.73, 0.25, tostring(factionRank) .. " a '" .. tostring(factionName) .. "'.", true, paneChars[key][7])
			guiLabelSetHorizontalAlign(paneChars[key][5], "center", false)
		end
        guiSetFont(paneChars[key][5], font0_roboto)
		if (login~="Never") then
        	paneChars[key][6] = guiCreateLabel(0.27, 0.75, 0.73, 0.25, "Utoljára " .. login .. " a " .. area .. "-on látták.", true, paneChars[key][7])
			guiLabelSetHorizontalAlign(paneChars[key][6], "center", false)
		else
			paneChars[key][6] = guiCreateLabel(0.27, 0.75, 0.73, 0.25, "Még sehol nem látták.", true, paneChars[key][7])
			guiLabelSetHorizontalAlign(paneChars[key][6], "center", false)
		end
        guiSetFont(paneChars[key][6], font0_roboto);


		
		addEventHandler("onClientGUIClick", paneChars[key][1], selectedCharacter);
		addEventHandler("onClientGUIClick", paneChars[key][2], selectedCharacter);
		addEventHandler("onClientGUIClick", paneChars[key][3], selectedCharacter);
		addEventHandler("onClientGUIClick", paneChars[key][4], selectedCharacter);
		addEventHandler("onClientGUIClick", paneChars[key][5], selectedCharacter);
		addEventHandler("onClientGUIClick", paneChars[key][6], selectedCharacter);
		addEventHandler("onClientGUIClick", paneChars[key][7], selectedCharacter);
		
		addEventHandler("onClientGUIDoubleClick", paneChars[key][1], dcselectedCharacter);
		addEventHandler("onClientGUIDoubleClick", paneChars[key][2], dcselectedCharacter);
		addEventHandler("onClientGUIDoubleClick", paneChars[key][3], dcselectedCharacter);
		addEventHandler("onClientGUIDoubleClick", paneChars[key][4], dcselectedCharacter);
		addEventHandler("onClientGUIDoubleClick", paneChars[key][5], dcselectedCharacter);
		addEventHandler("onClientGUIDoubleClick", paneChars[key][6], dcselectedCharacter);
		addEventHandler("onClientGUIDoubleClick", paneChars[key][7], dcselectedCharacter);
		y = y + 0.305;
    end

	if #accounts < 2 then
		local font1_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 12);

		lCreateFakepane = guiCreateScrollPane(0.00, y-0.00, 1.00, 0.67, true, paneCharacters)
        lCreateBG = guiCreateStaticImage(0.00, 0.00, 1.00, 0.33, ":account-system/img/charbg0.png", true, lCreateFakepane)
        lCreateImage = guiCreateStaticImage(0.03, 0.00, 0.24, 1.00, ":account-system/img/newchar.png", true, lCreateBG)
        lCreateName = guiCreateLabel(0.27, 0.00, 0.73, 1.00, "Új karakter (2x katt)", true, lCreateBG)
        guiSetAlpha(lCreateBG, 0.90);
        guiSetFont(lCreateName, font1_roboto);
        guiLabelSetHorizontalAlign(lCreateName, "center", false);
        guiLabelSetVerticalAlign(lCreateName, "center");

		addEventHandler("onClientGUIClick", lCreateFakepane, selectedCharacter);

		addEventHandler("onClientGUIDoubleClick", lCreateFakepane, dcselectedCharacter);
		addEventHandler("onClientGUIDoubleClick", lCreateBG, dcselectedCharacter);
		addEventHandler("onClientGUIDoubleClick", lCreateName, dcselectedCharacter);
		addEventHandler("onClientGUIDoubleClick", lCreateImage, dcselectedCharacter);
	end



	bEditChar = guiCreateButton(0.05, 0.875, 0.9, 0.05, "Karakter módosítása", true, tabCharacter);
	addEventHandler("onClientGUIClick", bEditChar, editSelectedCharacter, false);

	bDeleteChar = guiCreateButton(0.05, 0.925, 0.9, 0.05, "Karakter törlése", true, tabCharacter);
	addEventHandler("onClientGUIClick", bDeleteChar, deleteSelectedCharacter, false);
	
	guiSetVisible(bEditChar, false);
	guiSetVisible(bDeleteChar, false);
	outputChatBox("Sikeres adat betöltés.",0,255,0);

    if (needsEmail) then
		promptEmail();
	end
end
addEvent("showCharacterSelection", true);
addEventHandler("showCharacterSelection", getRootElement(), showCharacterUI);

function selectedCharacter(button, state)
	if (button=="left") and (state=="up") then
		if (source~=lCreateFakepane) and (source~=lCreateBG) and (source~=lCreateName) and (source~=lCreateImage) then
			local chat = isChatVisible()
			if not (chat) then
				showChat(true);
			end
			local found = false;
			local key = 0;
			for i, j in pairs(paneChars) do
				local isthis = false;
				for k, v in pairs(paneChars[i]) do
					if (v==source) then
						isthis = true;
						found = true;
						key = i;
					end
				end

				guiBringToFront(paneChars[i][2]);
				guiBringToFront(paneChars[i][3]);
				guiBringToFront(paneChars[i][4]);
				guiBringToFront(paneChars[i][5]);
				guiBringToFront(paneChars[i][6]);
				guiBringToFront(paneChars[i][7]);

				if (#paneChars < 2) then
					guiBringToFront(lCreateBG);
					guiBringToFront(lCreateFakepane);
					guiBringToFront(lCreateName);
					guiBringToFront(lCreateImage);
				end

				if not (isthis) then
					guiStaticImageLoadImage(paneChars[i][1], "img/charbg0.png");
				end
			end

			if (found) then
				selectedChar = key;
				local skinID = tonumber(tableAccounts[key][9]);
				local cked = tonumber(tableAccounts[key][3]);

				triggerServerEvent("SpawnPlayerDashboard", getLocalPlayer(), found, skinID);

				if (cked==nil) then
					fading = true;
					if (isTimer(tmrFadeIn)) then killTimer(tmrFadeIn) end
					tmrFadeIn = setTimer(fadePlayerIn, 50, 10)
					
					guiSetVisible(bEditChar, true);
					guiSetVisible(bDeleteChar, true);
				else
					--local x, y, z = getElementPosition(getLocalPlayer())
					tmrFadeIn = setTimer(fadePlayerIn, 50, 10)
					--exports.global:applyAnimation(getLocalPlayer(), "WUZI", "CS_Dead_Guy", -1, true, false, true)

					guiSetVisible(bEditChar, false);
					guiSetVisible(bDeleteChar, false);
				end
			end
		else
			if (isTimer(tmrFadeIn)) then killTimer(tmrFadeIn) end
			for key, value in ipairs(paneChars) do
				--guiStaticImageLoadImage(paneChars[key][1], "img/charbg0.png")
			end
			selectedChar = nil;

			guiBringToFront(lCreateBG);
			guiBringToFront(lCreateFakepane);
			guiBringToFront(lCreateName);
			guiBringToFront(lCreateImage);
			--guiStaticImageLoadImage(lCreateBG, "img/charbg1.png")

			triggerServerEvent("SpawnPlayerDashboard", getLocalPlayer(), found, skinID);

			fading = true
			tmrFadeIn = setTimer(fadePlayerIn, 50, 10)

			guiSetVisible(bEditChar, false);
			guiSetVisible(bDeleteChar, false);
			end
		guiSetInputEnabled(true);
	end
end

fading = false
tmrHideMouse = nil

function fadePlayerIn(newChar)
	local alpha = getElementAlpha(getLocalPlayer())
	setElementAlpha(getLocalPlayer(), alpha+25)
	if ((alpha+25)>=250) then
		setElementAlpha(getLocalPlayer(), 255)
		fading = false
	end
end

function dcselectedCharacter(button, state)
	if (button=="left") and (state=="up") then
		if (source~=lCreateFakepane) and (source~=lCreateBG) and (source~=lCreateName) and (source~=lCreateImage) then

				local foundkey = nil;
				for key, value in pairs(paneChars) do
					for i, j in pairs(paneChars[key]) do
						if (j==source) then
							foundkey = key;
						end
					end
				end
	
				local charname = tostring(guiGetText(paneChars[foundkey][2]));
				local cked = string.find(charname, "(Halott)");


				if (cked==nil) then
					setCameraInterior(0);
					spawned = true;
					destroyElement(tabPanelCharacter);
					sent = false;
				triggerServerEvent("spawnCharacter", getLocalPlayer(), charname, getVersion().mta);
				toggleAllControls(true, true, true);
				local chat = isChatVisible();
				if not (chat) then
					showChat(true);
				end
				guiSetInputEnabled(false);

			
		end
	else
		if (creation==false) then
			creation = true;
			guiSetVisible(tabPanelCharacter, false);
			characterCreation();
			--local sound = playSound("menu.mp3", false)
			--setSoundVolume(sound, 1)
			guiSetEnabled(bNext, false);
			end
		end
	end
end

function promptEmail()
    local screenW, screenH = guiGetScreenSize();
    guiSetEnabled(tabPanelCharacter, false);
    local font0_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 11);

    wEmail = guiCreateWindow((screenW - 506) / 2, (screenH - 215) / 2, 506, 215, "E-Mail cím kötelezõ!", false);
    guiWindowSetSizable(wEmail, false);

    lEmailInfo = guiCreateLabel(0.00, 0.15, 1.00, 0.09, "Az email cím a karakter visszaszerzésére szolgál.", true, wEmail);

    guiSetFont(lEmailInfo, font0_roboto);
    guiLabelSetHorizontalAlign(lEmailInfo, "center", false);
    lEmail = guiCreateLabel(0.02, 0.33, 0.26, 0.12, "E-mail címed:", true, wEmail);
    guiSetFont(lEmail, font0_roboto);
    guiLabelSetHorizontalAlign(lEmail, "center", false);
    guiLabelSetVerticalAlign(lEmail, "center");
    lEmail2x = guiCreateLabel(0.02, 0.50, 0.26, 0.12, "E-mail címed(2x):", true, wEmail);
    guiSetFont(lEmail2x, font0_roboto);
    guiLabelSetHorizontalAlign(lEmail2x, "center", false);
    guiLabelSetVerticalAlign(lEmail2x, "center");
    tEmail = guiCreateEdit(0.30, 0.33, 0.63, 0.12, "", true, wEmail);
    guiEditSetMaxLength(tEmail, 54);
    tEmail2x = guiCreateEdit(0.30, 0.53, 0.63, 0.12, "", true, wEmail);
    guiEditSetMaxLength(tEmail2x, 54);
    addEventHandler("onClientGUIChanged", tEmail2x, checkEmail, false);
    bSubmitEmail = guiCreateButton(0.30, 0.74, 0.45, 0.14, "Mentés", true, wEmail);
    guiSetEnabled(bSubmitEmail, false);
    addEventHandler("onClientGUIClick", bSubmitEmail, submitEmail, false);
end

function submitEmail()
	local email = guiGetText(tEmail);
	cleanupEmail();
	guiSetAlpha(tabPanelCharacter, 0.7);
	guiSetEnabled(tabPanelCharacter, true);
	triggerServerEvent("storeEmail", getLocalPlayer(), email);
end

function checkEmail()
	local text = guiGetText(source);
	
	local length = text:len();
	local atSymbol = text:find("@");
	local dotSymbol = text:find(".");

	if ( length > 8 and atSymbol ~= nil and dotSymbol ~= nil) then
		guiSetEnabled(bSubmitEmail, true);
		guiSetAlpha(bSubmitEmail, 1.0);
	else
		guiSetEnabled(bSubmitEmail, false);
		guiSetAlpha(bSubmitEmail, 0.5);
	end
end

function cleanupEmail()
	if ( tabPanelCharacter ) then
		guiSetAlpha(tabPanelCharacter, 1.0);
		guiSetEnabled(tabPanelCharacter, true);
	end
	
	if ( wEmail ) then
		destroyElement(wEmail);
	end
end

tabPanelCreation, bCancel, bNext, lType, rNormal, rCJ = nil;
fatness = 0;
muscles = 0;
name = "";
tabCreationOne, lName, tName, lRestrictions, bRotate = nil;
creation = false;

function characterCreation()
    local font0_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 10);
    tabPanelCreation = guiCreateTabPanel(0.00, 0.36, 0.16, 0.28, true);
    guiSetAlpha(tabPanelCreation, 0.75);

    tabCreationOne = guiCreateTab("Új karater: 1. lépés", tabPanelCreation);

	addEventHandler("onClientRender", getRootElement(), moveCameraToCreation);

    lName = guiCreateLabel(0.05, 0.09, 0.30, 0.09, "Karaktered neve:", true, tabCreationOne);

    guiSetFont(lName, font0_roboto);
    guiLabelSetHorizontalAlign(lName, "center", false);
    guiLabelSetVerticalAlign(lName, "center");
    tName = guiCreateEdit(0.38, 0.11, 0.53, 0.08, "", true, tabCreationOne);
    guiEditSetMaxLength(tName, 23);
    addEventHandler("onClientGUIChanged", tName, checkName);
    lRestrictions = guiCreateLabel(0.00, 0.21, 0.99, 0.47, "Követelmények: \n\n - NEM tartalmazhat aláhúzást! Használj SPACE-t. \n - Valósághû név \n - Kevesebb legyen mint 23 karakter \n - 2 névbõl áljon: Vezetéknév Keresztnév \n - Nem tartalmazhat számokat \n - Nem tartalmazhat speciális karaktereket mint pl: $@';", true, tabCreationOne);
    guiSetFont(lRestrictions, font0_roboto);
    guiLabelSetColor(lRestrictions, 3, 253, 3);
    guiLabelSetHorizontalAlign(lRestrictions, "center", false);
    guiLabelSetColor(lRestrictions, 255, 0, 0);
    bNext = guiCreateButton(0.07, 0.70, 0.85, 0.13, "Tovább", true, tabCreationOne);
	
    addEventHandler("onClientGUIClick", bNext, loadNextPage, false);
    bCancel = guiCreateButton(0.07, 0.85, 0.85, 0.13, "Mégse", true, tabCreationOne);
    addEventHandler("onClientGUIClick", bCancel, cancelCreation, false);

    bRotate = guiCreateButton(0.84, 0.94, 0.15, 0.05, "Kamera leállítása", true);
    guiSetAlpha(bRotate, 0.75);
    addEventHandler("onClientGUIClick", bRotate, pauseCameraMovement, false);
    guiSetInputEnabled(true);
end

function pauseCameraMovement()
	if not (removeEventHandler("onClientRender", getRootElement(), moveCameraToCreation)) then
		addEventHandler("onClientRender", getRootElement(), moveCameraToCreation)
		guiSetText(bRotate, "Kamera leállítása");
	else
		guiSetText(bRotate, "Kamera forgatása");
	end
end

function checkName()
	if (source==tName) then
		local theText = guiGetText(source);
		
		local foundSpace, valid = false, true;
		local lastChar, current = ' ', '';
		for i = 1, #theText do
			local char = theText:sub( i, i );
			if char == ' ' then
				if i == #theText then
					valid = false;
					break;
				else
					foundSpace = true;
				end
				
				if #current < 3 then
					valid = false;
					break;
				end
				current = '';
			elseif lastChar == ' ' then
				if char < 'A' or char > 'Z' then
					valid = false;
					break;
				end
				current = current .. char;
			elseif ( char >= 'a' and char <= 'z' ) or ( char >= 'A' and char <= 'Z' ) then
				current = current .. char;
			else
				valid = false;
				break;
			end
			lastChar = char;
		end
		
		if valid and foundSpace and #theText < 22 and #current >= 2 then
			guiLabelSetColor(lRestrictions, 0, 255, 0);
			guiSetEnabled(bNext, true);
		else
			guiLabelSetColor(lRestrictions, 255, 0, 0);
			guiSetEnabled(bNext, false);
		end
	end
end


function cancelCreation(button, state)
    removeEventHandler("onClientRender", getRootElement(), moveCameraToCreation);
    
    if (isElement(bRotate)) then
        destroyElement(bRotate);
    end

    bRotate = nil;
    local playerid = getElementData(getLocalPlayer(), "acc:accid");
    setElementInterior(getLocalPlayer(), 14);
    setElementDimension(getLocalPlayer(), 65000+playerid);
    setElementPosition(getLocalPlayer(), 258.43417358398, -41.489139556885, 1002.0234375);
    setPedRotation(getLocalPlayer(), 268.19247436523);
    
    creation = false;
    
    if (isElement(tabPanelCreation)) then
        destroyElement(tabPanelCreation);
    end

    tabPanelCreation = nil;
    
    setCameraMatrix(257.20394897461, -40.330944824219, 1002.5234375, 260.32162475586, -41.565814971924, 1002.0234375);
    setCameraInterior(14);
    fadeCamera(true);
    guiSetVisible(tabPanelCharacter, true);
end

rot = 120.0;
function moveCameraToCreation()
	local pX, pY, pZ = getElementPosition(getLocalPlayer());
	local x = pX + math.cos(math.deg(rot))*2;
	local y = pY + math.sin(math.deg(rot))*2;

	local sight, eX, eY, eZ = processLineOfSight(pX, pY, pZ, x, y, pZ+1, true, true, false);
		
	if (sight) then
		setCameraMatrix(eX, eY, eZ, pX, pY, pZ+0.2);
	else
		setCameraMatrix(x, y, pZ+1, pX, pY, pZ+0.2);
	end
	rot = rot + 0.0001;
end


function loadNextPage(button, state)
	if (button=="left") and (state=="up") then
		triggerServerEvent("doesCharacterExist", getLocalPlayer(), guiGetText(tName));
	end
end


function nextPage(exists)
	if (exists) then
		guiSetText(tName, "Már létrehozva");
		guiLabelSetColor(lRestrictions, 255, 0, 0);
		guiSetEnabled(bNext, false);
	elseif not (exists) then
		name = guiGetText(tName);
		destroyElement(tabCreationOne);
		tabCreationOne = nil;
		destroyElement(tabPanelCreation);
		tabPanelCreation = nil;
		characterCreationStep2Normal();
	end
end
addEvent("characterNextStep", true );
addEventHandler("characterNextStep", getRootElement(), nextPage);

tabCreationTwo, fatInc, fatDec, lFat, lFatDesc, muscleInc, muscleDec, lMuscle, lMuscleDesc = nil;
lDescriptionNormal, lGender, rMale, rFemale, lSkinColour, rBlack, rWhite, rAsian, tempPane, lChangeSkin, nextSkin, prevSkin = nil;

blackMales = {16, 18, 21, 22, 24, 25, 35, 36, 66, 67, 84, 222, 253, 260 };
whiteMales = {303, 306, 23, 26, 29, 34, 37, 43, 44, 45, 52, 59, 61, 62, 68, 72, 99, 200, 204, 206, 209, 212, 213, 217, 230, 234, 235, 236, 247, 248, 250, 252, 254, 255 };
asianMales = {59, 203, 210, 227, 229};
blackFemales = {9, 10, 11, 12, 13, 40, 76, 139, 148, 190, 207, 215, 218, 219, 238, 243, 244, 245, 256 };
whiteFemales = {12, 31, 38, 39, 53, 54, 55, 56, 77, 85, 86, 87, 88, 89, 90, 91, 92, 201, 205, 214, 216, 224, 225, 226, 231, 232, 233, 237, 243, 246, 251, 257, 263 };
asianFemales = {38, 53, 54, 55, 56, 88, 224, 225, 226, 263};

function characterCreationStep2Normal()
    gender = 0;
	skincolour = 1;
	curskin = 0;

    local font0_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 29);
    local font1_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 12);

    tabPanelCreation = guiCreateTabPanel(0.00, 0.36, 0.16, 0.28, true);
    tabCreationTwo = guiCreateTab("Új karater: 2. lépés", tabPanelCreation);
    guiSetAlpha(tabPanelCreation, 0.75);

    lDescriptionNormal = guiCreateLabel(0.02, 0.02, 0.96, 0.16, "Karater kinézet", true, tabCreationTwo);
    guiSetFont(lDescriptionNormal, font0_roboto);
    guiLabelSetHorizontalAlign(lDescriptionNormal, "center", false);

    --/////////////
	-- GENDER
	--/////////////
    lGender = guiCreateLabel(0.06, 0.20, 0.21, 0.07, "Nemed:", true, tabCreationTwo);
    guiSetFont(lGender, font1_roboto);
    guiLabelSetHorizontalAlign(lGender, "center", false);
    guiLabelSetVerticalAlign(lGender, "center");

    rMale = guiCreateRadioButton(0.36, 0.21, 0.18, 0.05, "Férfi", true, tabCreationTwo);
    rFemale = guiCreateRadioButton(0.72, 0.21, 0.18, 0.05, "Nõ", true, tabCreationTwo);
   -- guiRadioButtonSetSelected(rMale, true);
    addEventHandler("onClientGUIClick", rMale, normalSetMale, false);
	addEventHandler("onClientGUIClick", rFemale, normalSetFemale, false);

    --/////////////
	-- SKIN COLOUR
	--/////////////
    lSkinColour = guiCreateLabel(0.06, 0.34, 0.21, 0.07, "Bõrszined:", true, tabCreationTwo);
    guiSetFont(lSkinColour, font1_roboto);
    guiLabelSetHorizontalAlign(lSkinColour, "center", false);
    guiLabelSetVerticalAlign(lSkinColour, "center");
    tempPane = guiCreateScrollPane(0.31, 0.35, 0.62, 0.10, true, tabCreationTwo);
    rBlack = guiCreateRadioButton(0.06, 0.26, 0.23, 0.47, "Fekete", true, tempPane);
    rWhite = guiCreateRadioButton(0.36, 0.26, 0.23, 0.47, "Fehér", true, tempPane);
    rAsian = guiCreateRadioButton(0.64, 0.26, 0.23, 0.47, "Ázsiai", true, tempPane);
	--guiRadioButtonSetSelected(rWhite, true);
	addEventHandler("onClientGUIClick", rBlack, normalSetBlack, false);
	addEventHandler("onClientGUIClick", rWhite, normalSetWhite, false);
	addEventHandler("onClientGUIClick", rAsian, normalSetAsian, false);

    --/////////////
	-- SKIN
	--/////////////
    lChangeSkin = guiCreateLabel(0.06, 0.50, 0.21, 0.07, "Skin:", true, tabCreationTwo);
    guiSetFont(lChangeSkin, font1_roboto);
    guiLabelSetHorizontalAlign(lChangeSkin, "center", false);
    guiLabelSetVerticalAlign(lChangeSkin, "center");
    prevSkin = guiCreateButton(0.35, 0.51, 0.19, 0.06, "<-", true, tabCreationTwo);
    addEventHandler("onClientGUIClick", prevSkin, adjustNormalSkin, false);
    nextSkin = guiCreateButton(0.70, 0.51, 0.19, 0.06, "->", true, tabCreationTwo);
    addEventHandler("onClientGUIClick", nextSkin, adjustNormalSkin, false);

	-- NEXT/BACK
    bNext = guiCreateButton(0.07, 0.70, 0.85, 0.13, "Tovább", true, tabCreationTwo);
    addEventHandler("onClientGUIClick", bNext, characterCreationStep5, false);

    bCancel = guiCreateButton(0.07, 0.85, 0.85, 0.13, "Mégse", true, tabCreationTwo);
    addEventHandler("onClientGUIClick", bCancel, cancelCreation, false);

end

function adjustNormalSkin(button, state)
	if (button=="left") and (state=="up") then
		if (source==nextSkin) then
			local array = nil;
			if (skincolour==0) then -- BLACK
				if (gender==0) then -- BLACK MALE
					array = blackMales;
				elseif (gender==1) then -- BLACK FEMALE
					array = blackFemales;
				end
			elseif (skincolour==1) then -- WHITE
				if (gender==0) then -- WHITE MALE
					array = whiteMales;
				elseif (gender==1) then -- WHITE FEMALE
					array = whiteFemales;
				end
			elseif (skincolour==2) then -- ASIAN
				if (gender==0) then -- ASIAN MALE
					array = asianMales;
				elseif (gender==1) then -- ASIAN FEMALE
					array = asianFemales;
				end
			end
			
			-- Get the next skin
			if (curskin==#array) then
				curskin = 1;
				skin = array[1];
				setElementModel(getLocalPlayer(), tonumber(skin));
			else
				curskin = curskin + 1
				skin = array[curskin]
				setElementModel(getLocalPlayer(), tonumber(skin));
			end
		elseif (source==prevSkin) then
			local array = nil
			if (skincolour==0) then -- BLACK
				if (gender==0) then -- BLACK MALE
					array = blackMales;
				elseif (gender==1) then -- BLACK FEMALE
					array = blackFemales;
				end
			elseif (skincolour==1) then -- WHITE
				if (gender==0) then -- WHITE MALE
					array = whiteMales;
				elseif (gender==1) then -- WHITE FEMALE
					array = whiteFemales;
				end
			elseif (skincolour==2) then -- ASIAN
				if (gender==0) then -- ASIAN MALE
					array = asianMales;
				elseif (gender==1) then -- ASIAN FEMALE
					array = asianFemales;
				end
			end
			
			-- Get the next skin
			if (curskin==1) then
				curskin = #array;
				skin = array[1];
				setElementModel(getLocalPlayer(), tonumber(skin));
			else
				curskin = curskin - 1;
				skin = array[curskin];
				setElementModel(getLocalPlayer(), tonumber(skin));
			end
		end
	end
end

function normalSetMale(button, state)
	if (source==rMale) and (button=="left") and (state=="up") then
		gender = 0;
		generateSkin();
	end
end

function normalSetFemale(button, state)
	if (source==rFemale) and (button=="left") and (state=="up") then
		gender = 1;
		generateSkin();
	end
end

function normalSetBlack(button, state)
	if (source==rBlack) and (button=="left") and (state=="up") then
		skincolour = 0;
		generateSkin();
	end
end

function normalSetWhite(button, state)
	if (source==rWhite) and (button=="left") and (state=="up") then
		skincolour = 1;
		generateSkin();
	end
end

function normalSetAsian(button, state)
	if (source==rAsian) and (button=="left") and (state=="up") then
		skincolour = 2;
		generateSkin();
	end
end

function generateSkin()
	local skinint = 0;
	if (gender==0) then -- MALE
		if (skincolour==0) then -- BLACK
			skinint = math.random(1, #blackMales);
			skin = blackMales[skinint];
			setElementModel(getLocalPlayer(), skin);
		elseif (skincolour==1) then -- WHITE
			skinint = math.random(1, #whiteMales);
			skin = whiteMales[skinint];
			setElementModel(getLocalPlayer(), skin);
		elseif (skincolour==2) then -- ASIAN
			skinint = math.random(1, #asianMales);
			skin = asianMales[skinint];
			setElementModel(getLocalPlayer(), skin);
		end
	elseif (gender==1) then -- FEMALE
		if (skincolour==0) then -- BLACK
			skinint = math.random(1, #blackFemales);
			skin = blackFemales[skinint];
			setElementModel(getLocalPlayer(), skin);
		elseif (skincolour==1) then -- WHITE
			skinint = math.random(1, #whiteFemales);
			skin = whiteFemales[skinint];
			setElementModel(getLocalPlayer(), skin);
		elseif (skincolour==2) then -- ASIAN
			skinint = math.random(1, #asianFemales);
			skin = asianFemales[skinint];
			setElementModel(getLocalPlayer(), skin);
		end
	end
	curskin = skinint;
end

function characterCreationStep5(button, state)
    local font0_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 28);
    local font1_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 10);
    if (button=="left") and (state=="up") and (source==bNext) then
        if (tabCreationFour) then
			destroyElement(tabCreationFour);
			tabCreationFour = nil;
		elseif (tabCreationTwo) then
			destroyElement(tabCreationTwo);
			tabCreationTwo = nil;
		end
		destroyElement(tabPanelCreation);

        tabPanelCreation = guiCreateTabPanel(0.00, 0.36, 0.16, 0.28, true);
        tabCreationFive = guiCreateTab("Új karater: Utolsó lépés!", tabPanelCreation);
        guiSetAlpha(tabPanelCreation, 0.75);


        lInformation = guiCreateLabel(0.02, 0.02, 0.96, 0.10, "Információ", true, tabCreationFive);
        guiSetFont(lInformation, font0_roboto);
        guiLabelSetHorizontalAlign(lInformation, "center", false);
        guiLabelSetVerticalAlign(lInformation, "center");


        --/////////////
		-- HEIGHT
		--/////////////
        lHeight = guiCreateLabel(0.02, 0.15, 0.61, 0.05, "Magasság (cm)(100 és 200 között):", true, tabCreationFive);
        guiSetFont(lHeight, font1_roboto);
        guiLabelSetColor(lHeight, 3, 253, 3);
        guiLabelSetHorizontalAlign(lHeight, "center", false);
        guiLabelSetVerticalAlign(lHeight, "center");

        tHeight = guiCreateEdit(0.63, 0.15, 0.23, 0.06, "178", true, tabCreationFive);
        guiEditSetMaxLength(tHeight, 3);
        addEventHandler("onClientGUIChanged", tHeight, checkInput);

        --/////////////
		-- WEIGHT
		--/////////////
        lWeight = guiCreateLabel(0.06, 0.25, 0.54, 0.06, "Súly (kg)(40 és 200 között):", true, tabCreationFive);
        guiSetFont(lWeight, font1_roboto);
        guiLabelSetColor(lWeight, 3, 253, 3);
        guiLabelSetHorizontalAlign(lWeight, "center", false);
        guiLabelSetVerticalAlign(lWeight, "center");

        tWeight = guiCreateEdit(0.63, 0.25, 0.23, 0.06, "95", true, tabCreationFive);
        guiEditSetMaxLength(tWeight, 3);
        addEventHandler("onClientGUIChanged", tWeight, checkInput);

        --/////////////
		-- AGE
		--/////////////
        lAge = guiCreateLabel(0.04, 0.35, 0.54, 0.06, "Életkor (18 és 80 között):", true, tabCreationFive);
        guiSetFont(lAge, font1_roboto);
        guiLabelSetColor(lAge, 3, 253, 3);
        guiLabelSetHorizontalAlign(lAge, "center", false);
        guiLabelSetVerticalAlign(lAge, "center");

        tAge = guiCreateEdit(0.63, 0.36, 0.23, 0.06, "28", true, tabCreationFive);
        guiEditSetMaxLength(tAge, 3);
        addEventHandler("onClientGUIChanged", tAge, checkInput);

        --/////////////
		-- DESCRIPTION
		--/////////////
        lCharDesc = guiCreateLabel(0.06, 0.44, 0.87, 0.06, "Karaktered leírása (30 és 100 karakter között):", true, tabCreationFive);
        guiSetFont(lCharDesc, font1_roboto);
        guiLabelSetColor(lCharDesc, 3, 253, 3);
        guiLabelSetHorizontalAlign(lCharDesc, "center", false);
        guiLabelSetVerticalAlign(lCharDesc, "center");

        tCharDesc = guiCreateMemo(0.07, 0.51, 0.86, 0.18, "Írd le a karaktered vizuális megjelenését. Ezt a többi játékos is látni fogja.", true, tabCreationFive) ;
        addEventHandler("onClientGUIChanged", tCharDesc, checkInput);

		--/////////////
		-- NEXT/BACK
		--/////////////
        bNext = guiCreateButton(0.07, 0.70, 0.85, 0.13, "Tovább", true, tabCreationFive);
        addEventHandler("onClientGUIClick", bNext, characterCreationStep6, false);

        bCancel = guiCreateButton(0.07, 0.85, 0.85, 0.13, "Mégse", true, tabCreationFive);
        addEventHandler("onClientGUIClick", bCancel, cancelCreation, false);
    end
end

heightvalid = true 
weightvalid = true
descvalid = true
agevalid = true
function checkInput()
	if (source==tHeight) then
		if not (tostring(type(tonumber(guiGetText(tHeight)))) == "number") then
			guiLabelSetColor(lHeight, 255, 0, 0);
			heightvalid = false;
		elseif (tonumber(guiGetText(tHeight))<100) or (tonumber(guiGetText(tHeight))>200) then
			guiLabelSetColor(lHeight, 255, 0, 0);
			heightvalid = false;
		else
			guiLabelSetColor(lHeight, 0, 255, 0);
			heightvalid = true;
		end
	elseif (source==tWeight) then
		if not (tostring(type(tonumber(guiGetText(tWeight)))) == "number") then
			guiLabelSetColor(lWeight, 255, 0, 0);
			weightvalid = false;
		elseif (tonumber(guiGetText(tWeight))<40) or (tonumber(guiGetText(tWeight))>200) then
			guiLabelSetColor(lWeight, 255, 0, 0);
			weightvalid = false;
		else
			guiLabelSetColor(lWeight, 0, 255, 0);
			weightvalid = true;
		end
	elseif (source==tAge) then
		if not (tostring(type(tonumber(guiGetText(tAge)))) == "number") then
			guiLabelSetColor(lAge, 255, 0, 0);
			agevalid = false;
		elseif (tonumber(guiGetText(tAge))<18) or (tonumber(guiGetText(tAge))>80) then
			guiLabelSetColor(lAge, 255, 0, 0);
			agevalid = false;
		else
			guiLabelSetColor(lAge, 0, 255, 0);
			agevalid = true;
		end
	elseif (source==tCharDesc) then
		if (string.len(guiGetText(tCharDesc))<30) or (string.len(guiGetText(tCharDesc))>100) then
			guiLabelSetColor(lCharDesc, 255, 0, 0);
			descvalid = false;
		else
			guiLabelSetColor(lCharDesc, 0, 255, 0);
			descvalid = true;
		end
	end
end

function characterCreationStep6(button, state)
    local font0_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 20);
    local font1_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 11);
    local font2_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 12);
    local font3_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 10);
    if (button=="left") and (state=="up") and (source==bNext) then
	    if (heightvalid) and (weightvalid) and (descvalid) and (agevalid) then
            height = guiGetText(tHeight);
			weight = guiGetText(tWeight);
			age = guiGetText(tAge);
			description = guiGetText(tCharDesc);

            destroyElement(bRotate);
            destroyElement(tabCreationFive);
			tabCreationFive = nil;
			destroyElement(tabPanelCreation);
			tabPanelCreation = nil;


            tabPanelCreation = guiCreateTabPanel(0.00, 0.36, 0.16, 0.28, true);
            tabCreationSix = guiCreateTab("Új karakter: Az utolsó lap!", tabPanelCreation);
            guiSetAlpha(tabPanelCreation, 0.75);


            lInformation = guiCreateLabel(0.02, 0.02, 0.96, 0.10, "Információ", true, tabCreationSix);
            guiSetFont(lInformation, font0_roboto);
            guiLabelSetHorizontalAlign(lInformation, "center", false);
            guiLabelSetVerticalAlign(lInformation, "center");

            --/////////////
			-- TRANSPORT
			--/////////////
            lTransport = guiCreateLabel(0.02, 0.12, 0.96, 0.10, "Hogyan érkeztél városunkba?", true, tabCreationSix);
            guiSetFont(lTransport, font1_roboto);
            guiLabelSetHorizontalAlign(lTransport, "center", false);
            guiLabelSetVerticalAlign(lTransport, "center");

            rBus = guiCreateRadioButton(0.37, 0.22, 0.31, 0.06, "Autóbusszal", true, tabCreationSix);
            rAeroplane = guiCreateRadioButton(0.37, 0.31, 0.31, 0.06, "Repülőgéppel", true, tabCreationSix);

            addEventHandler("onClientGUIClick", rBus, busEffect, false);
			addEventHandler("onClientGUIClick", rAeroplane, aeroplaneEffect, false);

            guiSetFont(rBus, font1_roboto);
            guiSetFont(rAeroplane, font1_roboto);

			--/////////////
			-- LANGUAGE
			--/////////////
            lLanguage = guiCreateLabel(0.01, 0.38, 0.96, 0.10, "Mi legyen a karaktered anyanyelve?", true, tabCreationSix);
            guiSetFont(lLanguage, font1_roboto);
            guiLabelSetHorizontalAlign(lLanguage, "center", false);
            guiLabelSetVerticalAlign(lLanguage, "center");

            lCharLanguage = guiCreateLabel(0.01, 0.48, 0.96, 0.10, "Angol", true, tabCreationSix);
            guiSetFont(lCharLanguage, font2_roboto);
            guiLabelSetHorizontalAlign(lCharLanguage, "center", false);
            guiLabelSetVerticalAlign(lCharLanguage, "center");
            language = 1;

            lLangPrevious = guiCreateButton(0.17, 0.50, 0.20, 0.06, "Vissza", true, tabCreationSix);
            lLangNext = guiCreateButton(0.66, 0.50, 0.20, 0.06, "Tovább", true, tabCreationSix);


			--[[
			
				addEventHandler("onClientGUIClick", lLangPrevious,
				function( button, state )
					if button == "left" and state == "up" then
						if language == 1 then
							language = call( getResourceFromName( "language-system" ), "getLanguageCount" )
						else
							language = language - 1
						end
						guiSetText(lCharLanguage, call( getResourceFromName( "language-system" ), "getLanguageName", language ))
					end
				end, false
			)
			
			addEventHandler("onClientGUIClick", lLangNext,
				function( button, state )
					if button == "left" and state == "up" then
						if language == call( getResourceFromName( "language-system" ), "getLanguageCount" ) then
							language = 1
						else
							language = language + 1
						end
						guiSetText(lCharLanguage, call( getResourceFromName( "language-system" ), "getLanguageName", language ))
					end
				end, false
			)

			]]--

            --- IDE KELL MAJD A NYELV VALTAS MEG ---

            Aszf = guiCreateCheckBox(0.25, 0.61, 0.70, 0.07, "Elfogadom a szerver szabalyzatat", false, true, tabCreationSix);
            guiSetFont(Aszf, font3_roboto);

			--/////////////
			-- NEXT/BACK
			--/////////////

            bNext = guiCreateButton(0.07, 0.70, 0.85, 0.13, "Új karakter befejezése", true, tabCreationSix);
			addEventHandler("onClientGUIClick", bNext, characterCreationFinal, false);
		
            bCancel = guiCreateButton(0.07, 0.85, 0.85, 0.13, "Mégse", true, tabCreationSix);
            addEventHandler("onClientGUIClick", bCancel, cancelCreation, false);
        end
    end
end

function busEffect(button, state)
	if (source==rBus) and (button=="left") and (state=="up") and not (lastSelected==rBus) and not (anim) then
		lastSelected = source; -- Avoid duplicates
		-- fadeCamera(false, 1, 0, 0, 0)
		setCameraInterior(0);
		
		setElementInterior(getLocalPlayer(), 0);
		setCameraInterior(0);
		setElementPosition(getLocalPlayer(), 1742.1884765625, -1861.3564453125, 13.577615737915);
		setPedRotation(getLocalPlayer(), 0.98605346679688);

		removeEventHandler("onClientRender", getRootElement(), moveCameraToCreation);
		setCameraMatrix(1742.623046875, -1847.7109375, 16.579560279846, 1742.1884765625, -1861.3564453125, 13.577615737915);
		
		fadeCamera(true);
	end
end

-- AEROPLANE EFFECT
function aeroplaneEffect(button, state)
	if (source==rAeroplane) and (button=="left") and (state=="up") and not (lastSelected==rAeroplane) and not (anim) then
		lastSelected = source; -- Avoid duplicates
		-- fadeCamera(false, 1, 0, 0, 0)
		setCameraInterior(0);
		
		setElementInterior(getLocalPlayer(), 0);
		setElementPosition(getLocalPlayer(), 1685.583984375, -2329.4443359375, 13.546875);
		setPedRotation(getLocalPlayer(), 0.79379272460938);
		setElementAlpha(getLocalPlayer(), 255);

		removeEventHandler("onClientRender", getRootElement(), moveCameraToCreation);
		setCameraMatrix(1685.3681640625, -2309.9150390625, 16.546875, 1685.583984375, -2329.4443359375, 13.546875);
		fadeCamera(true, 1);
	end
end

-- FINAL
function characterCreationFinal(button, state)
	if not (guiCheckBoxGetSelected(Aszf))then
		showChat(true)
		outputChatBox("Nem fogadtad el a szabalyzatot!", 255, 0, 0, true)
		return
	end
    if (source==bNext) and (button=="left") and (state=="up") and not (anim) then
		local bus = guiRadioButtonGetSelected(rBus);
		local aeroplane = guiRadioButtonGetSelected(rAeroplane);

        if (bus or aeroplane) then
			local transport;
			if (bus) then
				transport = 1;
			elseif (aeroplane) then
				transport = 2;
			end
			local skin = getElementModel(getLocalPlayer());
			creation = false;
			destroyElement(tabPanelCreation);
			tabPanelCreation = nil;
			
			-- cleanup
			removeEventHandler("onClientRender", getRootElement(), moveCameraToCreation);
			showChat(false)
			
			local playerid = getElementData(getLocalPlayer(), "acc:accid");
			setElementInterior(getLocalPlayer(), 14);
			setElementDimension(getLocalPlayer(), 65000+playerid);
			setElementPosition(getLocalPlayer(), 258.43417358398, -41.489139556885, 1002.0234375);
			setPedRotation(getLocalPlayer(), 268.19247436523);
			
			setCameraMatrix(257.20394897461, -40.330944824219, 1002.5234375, 260.32162475586, -41.565814971924, 1002.0234375);
			setCameraInterior(14);
			fadeCamera(true);
			
			if (skin==0) then
				local clothes = { curhair, curhat, curneck, curface, curupper, curwrist, curlower, curfeet, curcostume, luTattoo, llTattoo, ruTattoo, rlTattoo, bTattoo, lcTattoo, rcTattoo, sTattoo, lbTattoo }
				triggerServerEvent("createCharacter", getLocalPlayer(), name, gender, skincolour, weight, height, fatness, muscles, transport, description, age, skin, language, clothes);
			else
				triggerServerEvent("createCharacter", getLocalPlayer(), name, gender, skincolour, weight, height, fatness, muscles, transport, description, age, skin, language);
			end
		end

    end
end

--/////////////////////////////////////////////////////////////////
--DISPLAY ACCOUNT MANAGEMENT
--////////////////////////////////////////////////////////////////
function displayAccountManagement()

	-- ADMIN
	local admin = getElementData(getLocalPlayer(), "acc:adminlevel")
	lAdmin = guiCreateLabel(0.00, 0.04, 1.00, 0.07, "Admin: ", true, tabAccount)
	guiSetFont(lAdmin, "default-bold-small")
	guiLabelSetHorizontalAlign(lAdmin, "center", false)
	guiLabelSetVerticalAlign(lAdmin, "center")
	if (admin == 0) then
		guiSetText(lAdmin, "Admin: Nem")
	else
		guiSetText(lAdmin, "Admin: Igen (" .. tostring(admin) .. ")")
	end

	-- MUTED
	local muted = getElementData(getLocalPlayer(), "acc:muted")
	lMuted = guiCreateLabel(0.00, 0.12, 1.00, 0.07, "Némítva: ", true, tabAccount)
	guiSetFont(lMuted, "default-bold-small")
	guiLabelSetHorizontalAlign(lMuted, "center", false)
	guiLabelSetVerticalAlign(lMuted, "center")
	if (muted == 0) then
		guiSetText(lMuted, "Némítva: Nem")
	else
		guiSetText(lMuted, "Némítva: Igen")
	end

	--[[
	
		-- PlayedHours
	local playhour = getElementData(getLocalPlayer(), "acc:playhour")
	lPlayHour = guiCreateLabel(0.00, 0.19, 1.00, 0.07, "Jatszott orak: ", true, tabAccount)
	guiSetFont(lPlayHour, "default-bold-small")
	guiLabelSetHorizontalAlign(lPlayHour, "center", false)
	guiLabelSetVerticalAlign(lPlayHour, "center")
	if (playhour == 0) then
		guiSetText(lMuted, "Jatszott orak: 0")
	else
		guiSetText(lMuted, "Jatszott orak: (" .. tostring(playhour) .. ")")
	end

	
	-- Premium Points
	local premiumpoint = getElementData(getLocalPlayer(), "acc:pp")
	lPremiumPoint = guiCreateLabel(0.00, 0.26, 1.00, 0.07, "Premium pontok: ", true, tabAccount)
	guiSetFont(lPremiumPoint, "default-bold-small")
	guiLabelSetHorizontalAlign(lPremiumPoint, "center", false)
	guiLabelSetVerticalAlign(lPremiumPoint, "center")
	if (premiumpoint == 0) then
		guiSetText(lMuted, "Premium pontok: 0")
	else
		guiSetText(lMuted, "Premium pontok: (" .. tostring(premiumpoint) .. ")")
	end
	
	]]--


	-- CHANGE PASSWORD
	lChangePassword = guiCreateLabel(0.00, 0.36, 1.00, 0.07, "Jelszó váltás", true, tabAccount)
	guiSetFont(lChangePassword, "default-bold-small")
	guiLabelSetHorizontalAlign(lChangePassword, "center", false)
	guiLabelSetVerticalAlign(lChangePassword, "center")

	lCurrPassword = guiCreateLabel(0.02, 0.48, 0.24, 0.07, "Jelenlegi jelszavad:", true, tabAccount)
	guiSetFont(lCurrPassword, "default-bold-small")
	guiLabelSetHorizontalAlign(lCurrPassword, "right", false)
	guiLabelSetVerticalAlign(lCurrPassword, "center")

	tCurrPassword = guiCreateEdit(0.28, 0.48, 0.57, 0.07, "", true, tabAccount)
	guiEditSetMasked(tCurrPassword, true)
	guiEditSetMaxLength(tCurrPassword, 38)

	lNewPassword1 = guiCreateLabel(0.02, 0.57, 0.24, 0.07, "Új jelszó:", true, tabAccount)
	guiSetFont(lNewPassword1, "default-bold-small")
	guiLabelSetHorizontalAlign(lNewPassword1, "center", false)
	guiLabelSetVerticalAlign(lNewPassword1, "center")

	tNewPassword1 = guiCreateEdit(0.28, 0.58, 0.57, 0.07, "", true, tabAccount)
	guiEditSetMasked(tNewPassword1, true)
	guiEditSetMaxLength(tNewPassword1, 38)

	lNewPassword2 = guiCreateLabel(0.02, 0.67, 0.24, 0.07, "Új jelszó x2:", true, tabAccount)
	guiSetFont(lNewPassword2, "default-bold-small")
	guiLabelSetHorizontalAlign(lNewPassword2, "center", false)
	guiLabelSetVerticalAlign(lNewPassword2, "center")

	tNewPassword2 = guiCreateEdit(0.28, 0.67, 0.57, 0.07, "", true, tabAccount)
	guiEditSetMasked(tNewPassword2, true)
	guiEditSetMaxLength(tNewPassword2, 38)

	bSavePass = guiCreateButton(152, 342, 182, 46, "Mentés", false, tabAccount)
	addEventHandler("onClientGUIClick", bSavePass, savePassword, false)

end

function savePassword(button, state)
	if (source==bSavePass) and (button=="left") and (state=="up") then
		showChat(true)
		local password = guiGetText(tCurrPassword)
		local password1 = guiGetText(tNewPassword1)
		local password2 = guiGetText(tNewPassword2)
		
		
		if (string.len(password1)<6) or (string.len(password2)<6) then
			outputChatBox("Az új jelszavad túl rövid! Legalább 6 vagy több karakteresnek kell lennie.", 255, 0, 0)
		elseif (string.len(password)<6)  then
			outputChatBox("A jelenlegi jelszavad túl rövid! Legalább 6 vagy több karakteresnek kell lennie.", 255, 0, 0)
		elseif (string.find(password, ";", 0)) or (string.find(password, "'", 0)) or (string.find(password, "@", 0)) or (string.find(password, ",", 0)) then
			outputChatBox("A jelenlegi jelszavad nem tartalmazhat ;,@'. karaktereket.", 255, 0, 0)
		elseif (string.find(password1, ";", 0)) or (string.find(password1, "'", 0)) or (string.find(password1, "@", 0)) or (string.find(password1, ",", 0)) then
			outputChatBox("Az új jelszavad nem tartalmazhat ;,@'. karaktereket.", 255, 0, 0)
		elseif (password1~=password2) then
			outputChatBox("A két jelszó nem egyezik!.", 255, 0, 0)
		else
			triggerServerEvent("cguiSavePassword", getLocalPlayer(), password, password1)
		end
	end
end


local charGender = 0
function editSelectedCharacter(button, state)
	if button=="left" and state=="up" and selectedChar and paneChars[selectedChar] then
		triggerServerEvent("requestEditCharInformation", getLocalPlayer(), guiGetText(paneChars[selectedChar][2]))
	end
end

function editCharacter(height, weight, age, description, gender)
	if selectedChar and paneChars[selectedChar] then
		charGender = gender
		
		guiSetVisible(tabPanelCharacter, false)
		
		local screenW, screenH = guiGetScreenSize()
		
		tabPanelCreation = guiCreateTabPanel(0.00, 0.36, 0.19, 0.32, true)
        guiSetAlpha(tabPanelCreation, 0.75)
		tabCreationFive = guiCreateTab("Karakter módosítása", tabPanelCreation)
		

		lCharmodification = guiCreateLabel(0.00, 0.02, 1.00, 0.08, "Karakter módosítás", true, tabCreationFive)
        guiSetFont(lCharmodification, "default-bold-small")
        guiLabelSetHorizontalAlign(lCharmodification, "center", false)
        guiLabelSetVerticalAlign(lCharmodification, "center")

		lInformation = guiCreateLabel(0.00, 0.10, 1.00, 0.11, tostring(guiGetText(paneChars[selectedChar][2])), true, tabCreationFive)
        guiLabelSetHorizontalAlign(lInformation, "center", false)
        guiLabelSetVerticalAlign(lInformation, "center")

		--lInformation = guiCreateLabel(0.1, 0.025, 0.8, 0.15, tostring(guiGetText(paneChars[selectedChar][2])), true, tabCreationFive) 
		--guiSetFont(lInformation, "sa-header")
		
		--/////////////
		-- HEIGHT
		--/////////////
		lHeight = guiCreateLabel(0.02, 0.21, 0.43, 0.10, "Magasság (cm)(100 és 200 között):", true, tabCreationFive)
        guiLabelSetHorizontalAlign(lHeight, "center", false)
        guiLabelSetVerticalAlign(lHeight, "center")
		
		tHeight = guiCreateEdit(0.47, 0.23, 0.42, 0.07, "", true, tabCreationFive)
        guiEditSetMaxLength(tHeight, 3)
		addEventHandler("onClientGUIChanged", tHeight, checkInput)
		
		--/////////////
		-- WEIGHT
		--/////////////
		lWeight = guiCreateLabel(0.02, 0.31, 0.43, 0.10, "Súly (kg)(40 és 200 között):", true, tabCreationFive)
        guiLabelSetHorizontalAlign(lWeight, "center", false)
        guiLabelSetVerticalAlign(lWeight, "center")

        tWeight = guiCreateEdit(0.47, 0.33, 0.42, 0.07, "", true, tabCreationFive)
        guiEditSetMaxLength(tWeight, 3)
		addEventHandler("onClientGUIChanged", tWeight, checkInput)
		
		--/////////////
		-- AGE
		--/////////////
		lAge = guiCreateLabel(0.02, 0.41, 0.43, 0.10, "Életkor (18 és 80 között):", true, tabCreationFive)
        guiLabelSetHorizontalAlign(lAge, "center", false)
        guiLabelSetVerticalAlign(lAge, "center")

        tAge = guiCreateEdit(0.47, 0.42, 0.42, 0.07, "", true, tabCreationFive)
        guiEditSetMaxLength(tAge, 2)
		addEventHandler("onClientGUIChanged", tAge, checkInput)
		
		--/////////////
		-- DESCRIPTION
		--/////////////
		lCharDesc = guiCreateLabel(0.02, 0.51, 0.53, 0.08, "Karakter leírása(30 és 100 karakter között):", true, tabCreationFive)
        guiLabelSetHorizontalAlign(lCharDesc, "center", false)
        guiLabelSetVerticalAlign(lCharDesc, "center")

        tCharDesc = guiCreateMemo(0.02, 0.58, 0.90, 0.27, "", true, tabCreationFive)
		addEventHandler("onClientGUIChanged", tCharDesc, checkInput)
		
		--/////////////
		-- SAVE/CANCEL
		--/////////////
		bNext = guiCreateButton(0.51, 0.87, 0.39, 0.10, "Mentés", true, tabCreationFive)  
		--addEventHandler("onClientGUIClick", bNext, validatemodifydata, false)
		addEventHandler("onClientGUIClick", bNext, updateEditedCharacter, false)
		
		bCancel = guiCreateButton(0.04, 0.87, 0.39, 0.10, "Mégse", true, tabCreationFive)
		addEventHandler("onClientGUIClick", bCancel,
			function()
				destroyElement(tabPanelCreation)
				tabPanelCreation = nil
				guiSetVisible(tabPanelCharacter, true)
			end, false)
	end
end
addEvent("sendEditingInformation", true)
addEventHandler("sendEditingInformation", getLocalPlayer(), editCharacter)

function validatemodifydata()
	local screenW, screenH = guiGetScreenSize()
        modifyCheckGui = guiCreateWindow((screenW - 598) / 2, (screenH - 217) / 2, 598, 217, "Megerosites", false)
        guiWindowSetSizable(modifyCheckGui, false)

        lTextmodifycheck = guiCreateLabel(0.22, 0.41, 0.57, 0.18, "Biztosan szeretned megvaltoztani a karaktered adatait?", true, modifyCheckGui)
        guiLabelSetHorizontalAlign(lTextmodifycheck, "center", false)
        guiLabelSetVerticalAlign(lTextmodifycheck, "center")
        bCheckNo = guiCreateButton(0.22, 0.71, 0.21, 0.18, "Nem", true, modifyCheckGui)
		addEventHandler("onClientGUIClick", bCancel, checkremover, false)

        bCheckYes = guiCreateButton(0.55, 0.71, 0.21, 0.18, "Igen", true, modifyCheckGui)
		addEventHandler("onClientGUIClick", bCheckYes, updateEditedCharacter, false)
end

function checkremover()
	destroyElement(modifyCheckGui)
	modifyCheckGui = nil
	--outputDebugString("visszakene")
end

function updateEditedCharacter()
	if heightvalid and weightvalid and descvalid and agevalid and selectedChar then
		height = tonumber(guiGetText(tHeight))
		weight = tonumber(guiGetText(tWeight))
		age = tonumber(guiGetText(tAge))
		description = guiGetText(tCharDesc)
		
		triggerServerEvent("updateEditedCharacter", getLocalPlayer(), guiGetText(paneChars[selectedChar][2]), height, weight, age, description)
		
		destroyElement(tabPanelCreation)
		destroyElement(modifyCheckGui)
		tabPanelCreation = nil
		guiSetVisible(tabPanelCharacter, true)
		
		-- update character screen (avoids us from reloading all accounts)
		local gender = "Férfi" 
		if charGender == 1 then
			gender = "Nő"
		end
		guiSetText(paneChars[selectedChar][4], age .. " éves " .. gender .. ".", true)
	end
end

function deleteSelectedCharacter(button, state)
	if (button=="left") and (state=="up") and (source==bDeleteChar) then
		if (selectedChar) and not wDelConfirmation then
			local charname = tostring(guiGetText(paneChars[selectedChar][2]))
			local sx, sy = guiGetScreenSize() 
			wDelConfirmation = guiCreateWindow(sx/2 - 125,sy/2 - 50,250,100,"Törlés megerõsítése", false)
			local lQuestion = guiCreateLabel(0.05,0.25,0.9,0.3,"Biztosan törölni szeretnéd "..charname.."-t ?",true,wDelConfirmation)
							  guiLabelSetHorizontalAlign (lQuestion,"center",true)
			local bYes = guiCreateButton(0.1,0.65,0.37,0.23,"Igen",true,wDelConfirmation)
			local bNo = guiCreateButton(0.53,0.65,0.37,0.23,"Mégse",true,wDelConfirmation)
			addEventHandler("onClientGUIClick", getRootElement(), 
				function(button)
					if (button=="left") then
						if source == bYes then
							triggerServerEvent("deleteCharacter", getLocalPlayer(), charname)
							deleteCharacter(charname)
						elseif source == bNo then
							if wDelConfirmation then
								destroyElement(wDelConfirmation)
								wDelConfirmation = nil
							end
						end
					end
				end
			)
		end
	end
end

function deleteCharacter(charname)
	hideUI()
	tableAccounts[selectedChar] = nil
	showCharacterUI(tableAccounts, false)
end


function charCreateSuccess()
    outputChatBox("A karakteredet sikeresen letrehoztuk!", 0, 255, 0);
end
addEvent("charCreateSuccess", true );
addEventHandler("charCreateSuccess", getRootElement(), charCreateSuccess);

function drawnDetails()
	local time = getRealTime();
	local month = time.month + 1;
	local str = tostring(month);
	if month < 10 then
	    str = "0" .. str;
	end
	local monthday = time.monthday;
	local str2 = tostring(monthday);
	if monthday < 10 then
	    str2 = "0" .. str2;
	end
	local datum =  "2024."..str.."."..str2;
	local version = "2.0";

    local sx, sy = guiGetScreenSize();
	local id = getElementData(getLocalPlayer(), "acc:accid");
	if (id) then
    	dxDrawText("ZeroMta ["..version.."] -  AccountID: "..id.." - "..datum, sx - 85, sy - 12/2, sx - 85, sy - 12/2, tocolor(255, 255, 255, 100), 1, "default-bold", "right", "center", false, false, false, true)
	else
		dxDrawText("ZeroMta ["..version.."] -  AccountID:   - "..datum, sx - 85, sy - 12/2, sx - 85, sy - 12/2, tocolor(255, 255, 255, 100), 1, "default-bold", "right", "center", false, false, false, true)
	end
end

