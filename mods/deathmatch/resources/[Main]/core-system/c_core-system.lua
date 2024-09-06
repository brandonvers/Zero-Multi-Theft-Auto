function getPlayerDeveloper(player)
    if getElementData(player, "isPlaying") then
        local serial = getElementData(player, "mtaserial")
        if devSerials[serial] then
            return true, devNames[serial]
        else
            return false
        end
    end
end


bindKey("m", "down", 
    function()   
       -- if getElementData(localPlayer, "bar >> Use") then return end
       -- if getElementData(localPlayer, "score >> bar") then return end
        if not (getElementData(localPlayer, "isPlaying")) then return end
        if getElementData(localPlayer, "toggleCursor") then return end
        cursorState = isCursorShowing()
	    showCursor(not cursorState)
        cursorState = not cursorState
        setCursorAlpha(255)
	end
)

--[[
addEventHandler("onClientResourceStart", resourceRoot,
    function()
local screenW, screenH = guiGetScreenSize()
        wEmail = guiCreateWindow((screenW - 506) / 2, (screenH - 215) / 2, 506, 215, "E-Mail cím kötelezõ!", false)
        guiWindowSetSizable(wEmail, false)

        lEmailInfo = guiCreateLabel(0.00, 0.15, 1.00, 0.09, "Az email cím a karakter visszaszerzésére szolgál.", true, wEmail)
        local font0_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 11)
        guiSetFont(lEmailInfo, font0_roboto)
        guiLabelSetHorizontalAlign(lEmailInfo, "center", false)
        lEmail = guiCreateLabel(0.02, 0.33, 0.26, 0.12, "E-mail címed:", true, wEmail)
        guiSetFont(lEmail, font0_roboto)
        guiLabelSetHorizontalAlign(lEmail, "center", false)
        guiLabelSetVerticalAlign(lEmail, "center")
        lEmail2x = guiCreateLabel(0.02, 0.50, 0.26, 0.12, "E-mail címed(2x):", true, wEmail)
        guiSetFont(lEmail2x, font0_roboto)
        guiLabelSetHorizontalAlign(lEmail2x, "center", false)
        guiLabelSetVerticalAlign(lEmail2x, "center")
        tEmail = guiCreateEdit(0.30, 0.33, 0.63, 0.12, "", true, wEmail)
        guiEditSetMaxLength(tEmail, 54)
        tEmail2x = guiCreateEdit(0.30, 0.53, 0.63, 0.12, "", true, wEmail)
        guiEditSetMaxLength(tEmail2x, 54)
        bSubmitEmail = guiCreateButton(0.30, 0.74, 0.45, 0.14, "Mentés", true, wEmail)    
    end
)

]]

--[[

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        tabPanelCharacter = guiCreateTabPanel(0.00, 0.36, 0.19, 0.32, true)
        guiSetAlpha(tabPanelCharacter, 0.75)

        tabCharacter = guiCreateTab("Karakter választás", tabPanelCharacter)

        lCharacters = guiCreateLabel(0.05, 0.02, 0.31, 0.06, "Karakterek: 0.", true, tabCharacter)
        local font0_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 11)
        guiSetFont(lCharacters, font0_roboto)
        guiLabelSetVerticalAlign(lCharacters, "center")
        paneCharacters = guiCreateScrollPane(0.05, 0.11, 0.90, 0.80, true, tabCharacter)

        lCreateFakepane = guiCreateScrollPane(0.00, 0.00, 1.00, 0.35, true, paneCharacters)

        lCreateBG = guiCreateStaticImage(0.00, 0.04, 1.00, 0.53, ":account-system/img/charbg0.png", true, lCreateFakepane)
        guiSetAlpha(lCreateBG, 0.90)

        lCreateImage = guiCreateStaticImage(0.00, 0.00, 0.20, 1.00, ":account-system/img/newchar.png", true, lCreateBG)
        lCreateName = guiCreateLabel(0.20, 0.00, 0.80, 1.00, "Új karakter (2x katt)", true, lCreateBG)
        local font1_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 12)
        guiSetFont(lCreateName, font1_roboto)
        guiLabelSetHorizontalAlign(lCreateName, "center", false)
        guiLabelSetVerticalAlign(lCreateName, "center")




        tabAccount = guiCreateTab("Információ", tabPanelCharacter)
        tabAchievements = guiCreateTab("Díjaim", tabPanelCharacter)    
    end
)




addEventHandler("onClientResourceStart", resourceRoot,
    function()
        bRotate = guiCreateButton(0.84, 0.94, 0.15, 0.05, "Kamera leállítása", true)
        guiSetAlpha(bRotate, 0.75)


        tabPanelCreation = guiCreateTabPanel(0.00, 0.36, 0.16, 0.28, true)
        guiSetAlpha(tabPanelCreation, 0.75)

        tabCreationOne = guiCreateTab("Új karater: 1. lépés", tabPanelCreation)

        lName = guiCreateLabel(0.05, 0.09, 0.30, 0.09, "Karaktered neve:", true, tabCreationOne)
        local font0_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 10)
        guiSetFont(lName, font0_roboto)
        guiLabelSetHorizontalAlign(lName, "center", false)
        guiLabelSetVerticalAlign(lName, "center")
        tName = guiCreateEdit(0.38, 0.11, 0.53, 0.08, "", true, tabCreationOne)
        guiEditSetMaxLength(tName, 23)
        lRestrictions = guiCreateLabel(0.00, 0.21, 0.99, 0.47, "Követelmények: \n\n - NEM tartalmazhat aláhúzást! Használj SPACE-t. \n - Valósághû név \n - Kevesebb legyen mint 23 karakter \n - 2 névbõl áljon: Vezetéknév Keresztnév \n - Nem tartalmazhat számokat \n - Nem tartalmazhat speciális karaktereket mint pl: $@';", true, tabCreationOne)
        guiSetFont(lRestrictions, font0_roboto)
        guiLabelSetColor(lRestrictions, 3, 253, 3)
        guiLabelSetHorizontalAlign(lRestrictions, "center", false)
        bNext = guiCreateButton(0.07, 0.70, 0.85, 0.13, "Tovább", true, tabCreationOne)
        bCancel = guiCreateButton(0.07, 0.85, 0.85, 0.13, "Mégse", true, tabCreationOne)    
    end
)

]]




--[[
addEventHandler("onClientResourceStart", resourceRoot,
    function()
        tabPanelCreation = guiCreateTabPanel(0.00, 0.36, 0.16, 0.28, true)
        guiSetAlpha(tabPanelCreation, 0.75)

        tabCreationTwo = guiCreateTab("Új karater: 2. lépés", tabPanelCreation)

        bNext = guiCreateButton(0.07, 0.70, 0.85, 0.13, "Tovább", true, tabCreationTwo)
        bCancel = guiCreateButton(0.07, 0.85, 0.85, 0.13, "Mégse", true, tabCreationTwo)
        lDescriptionNormal = guiCreateLabel(0.02, 0.02, 0.96, 0.16, "Karater kinézet", true, tabCreationTwo)
        local font0_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 29)
        guiSetFont(lDescriptionNormal, font0_roboto)
        guiLabelSetHorizontalAlign(lDescriptionNormal, "center", false)
        lGender = guiCreateLabel(0.06, 0.20, 0.21, 0.07, "Nemed:", true, tabCreationTwo)
        local font1_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 12)
        guiSetFont(lGender, font1_roboto)
        guiLabelSetHorizontalAlign(lGender, "center", false)
        guiLabelSetVerticalAlign(lGender, "center")
        lSkinColour = guiCreateLabel(0.06, 0.34, 0.21, 0.07, "Bõrszined:", true, tabCreationTwo)
        guiSetFont(lSkinColour, font1_roboto)
        guiLabelSetHorizontalAlign(lSkinColour, "center", false)
        guiLabelSetVerticalAlign(lSkinColour, "center")
        lChangeSkin = guiCreateLabel(0.06, 0.50, 0.21, 0.07, "Skin:", true, tabCreationTwo)
        guiSetFont(lChangeSkin, font1_roboto)
        guiLabelSetHorizontalAlign(lChangeSkin, "center", false)
        guiLabelSetVerticalAlign(lChangeSkin, "center")
        rMale = guiCreateRadioButton(0.36, 0.21, 0.18, 0.05, "Férfi", true, tabCreationTwo)
        guiRadioButtonSetSelected(rMale, true)
        rFemale = guiCreateRadioButton(0.72, 0.21, 0.18, 0.05, "Nõ", true, tabCreationTwo)
        rBlack = guiCreateRadioButton(0.36, 0.36, 0.18, 0.05, "Fekete", true, tabCreationTwo)
        rWhite = guiCreateRadioButton(0.54, 0.36, 0.18, 0.05, "Fehér", true, tabCreationTwo)
        rAsian = guiCreateRadioButton(0.72, 0.36, 0.18, 0.05, "Ázsiai", true, tabCreationTwo)
        prevSkin = guiCreateButton(0.35, 0.51, 0.19, 0.06, "<-", true, tabCreationTwo)
        nextSkin = guiCreateButton(0.70, 0.51, 0.19, 0.06, "->", true, tabCreationTwo)    
    end
)

]]

--[[



addEventHandler("onClientResourceStart", resourceRoot,
    function()
        tabPanelCreation = guiCreateTabPanel(0.00, 0.36, 0.16, 0.28, true)
        guiSetAlpha(tabPanelCreation, 0.75)

        tabCreationFive = guiCreateTab("Új karater: Utolsó lépés!", tabPanelCreation)

        bNext = guiCreateButton(0.07, 0.70, 0.85, 0.13, "Tovább", true, tabCreationFive)
        bCancel = guiCreateButton(0.07, 0.85, 0.85, 0.13, "Mégse", true, tabCreationFive)
        lInformation = guiCreateLabel(0.02, 0.02, 0.96, 0.10, "Információ", true, tabCreationFive)
        local font0_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 28)
        guiSetFont(lInformation, font0_roboto)
        guiLabelSetHorizontalAlign(lInformation, "center", false)
        guiLabelSetVerticalAlign(lInformation, "center")
        lHeight = guiCreateLabel(0.02, 0.15, 0.61, 0.05, "Magasság (cm)(100 és 200 között):", true, tabCreationFive)
        local font1_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 10)
        guiSetFont(lHeight, font1_roboto)
        guiLabelSetColor(lHeight, 3, 253, 3)
        guiLabelSetHorizontalAlign(lHeight, "center", false)
        guiLabelSetVerticalAlign(lHeight, "center")
        tHeight = guiCreateEdit(0.63, 0.15, 0.23, 0.06, "182", true, tabCreationFive)
        guiEditSetMaxLength(tHeight, 3)
        lWeight = guiCreateLabel(0.06, 0.25, 0.54, 0.06, "Súly (kg)(40 és 200 között):", true, tabCreationFive)
        guiSetFont(lWeight, font1_roboto)
        guiLabelSetColor(lWeight, 3, 253, 3)
        guiLabelSetHorizontalAlign(lWeight, "center", false)
        guiLabelSetVerticalAlign(lWeight, "center")
        tWeight = guiCreateEdit(0.63, 0.25, 0.23, 0.06, "95", true, tabCreationFive)
        guiEditSetMaxLength(tWeight, 3)
        lAge = guiCreateLabel(0.04, 0.35, 0.54, 0.06, "Életkor (18 és 80 között):", true, tabCreationFive)
        guiSetFont(lAge, font1_roboto)
        guiLabelSetColor(lAge, 3, 253, 3)
        guiLabelSetHorizontalAlign(lAge, "center", false)
        guiLabelSetVerticalAlign(lAge, "center")
        tAge = guiCreateEdit(0.63, 0.36, 0.23, 0.06, "28", true, tabCreationFive)
        guiEditSetMaxLength(tAge, 3)
        lCharDesc = guiCreateLabel(0.06, 0.44, 0.87, 0.06, "Karaktered leírása (30 és 100 karakter között):", true, tabCreationFive)
        guiSetFont(lCharDesc, font1_roboto)
        guiLabelSetColor(lCharDesc, 3, 253, 3)
        guiLabelSetHorizontalAlign(lCharDesc, "center", false)
        guiLabelSetVerticalAlign(lCharDesc, "center")
        tCharDesc = guiCreateMemo(0.07, 0.51, 0.86, 0.18, "Írd le a karaktered vizuális megjelenését. Ezt a többi játékos is látni fogja.", true, tabCreationFive)    
    end
)


]]


--[[



addEventHandler("onClientResourceStart", resourceRoot,
    function()
        tabPanelCreation = guiCreateTabPanel(0.00, 0.36, 0.16, 0.28, true)
        guiSetAlpha(tabPanelCreation, 0.75)

        tabCreationSix = guiCreateTab("Új karakter: Az utolsó lap!", tabPanelCreation)

        bNext = guiCreateButton(0.07, 0.70, 0.85, 0.13, "Új karakter befejezése", true, tabCreationSix)
        bCancel = guiCreateButton(0.07, 0.85, 0.85, 0.13, "Mégse", true, tabCreationSix)
        lInformation = guiCreateLabel(0.02, 0.02, 0.96, 0.10, "Információ", true, tabCreationSix)
        local font0_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 20)
        guiSetFont(lInformation, font0_roboto)
        guiLabelSetHorizontalAlign(lInformation, "center", false)
        guiLabelSetVerticalAlign(lInformation, "center")
        lTransport = guiCreateLabel(0.02, 0.12, 0.96, 0.10, "Hogyan érkeztél városunkba?", true, tabCreationSix)
        local font1_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 11)
        guiSetFont(lTransport, font1_roboto)
        guiLabelSetHorizontalAlign(lTransport, "center", false)
        guiLabelSetVerticalAlign(lTransport, "center")
        rBus = guiCreateRadioButton(0.37, 0.22, 0.31, 0.06, "Autóbusszal", true, tabCreationSix)
        guiSetFont(rBus, font1_roboto)
        rAeroplane = guiCreateRadioButton(0.37, 0.31, 0.31, 0.06, "Repülőgéppel", true, tabCreationSix)
        guiSetFont(rAeroplane, font1_roboto)
        --guiRadioButtonSetSelected(rAeroplane, true)
        lLanguage = guiCreateLabel(0.01, 0.38, 0.96, 0.10, "Mi legyen a karaktered anyanyelve?", true, tabCreationSix)
        guiSetFont(lLanguage, font1_roboto)
        guiLabelSetHorizontalAlign(lLanguage, "center", false)
        guiLabelSetVerticalAlign(lLanguage, "center")
        lCharLanguage = guiCreateLabel(0.01, 0.48, 0.96, 0.10, "Angol", true, tabCreationSix)
        local font2_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 12)
        guiSetFont(lCharLanguage, font2_roboto)
        guiLabelSetHorizontalAlign(lCharLanguage, "center", false)
        guiLabelSetVerticalAlign(lCharLanguage, "center")
        lLangPrevious = guiCreateButton(0.17, 0.50, 0.20, 0.06, "Vissza", true, tabCreationSix)
        lLangNext = guiCreateButton(0.66, 0.50, 0.20, 0.06, "Tovább", true, tabCreationSix)
        Aszf = guiCreateCheckBox(0.25, 0.61, 0.70, 0.07, "Elfogadom a szerver szabalyzatat", false, true, tabCreationSix)
        local font3_roboto = guiCreateFont(":core-system/fonts/roboto.ttf", 10)
        guiSetFont(Aszf, font3_roboto)    
    end
)



]]