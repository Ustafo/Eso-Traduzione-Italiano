local addonName = "TraduzioneItaESO"
TraduzioneItaESO = TraduzioneItaESO or {}
TraduzioneItaESO.name = addonName
TraduzioneItaESO.version = "3.5"  -- Aggiornato
TraduzioneItaESO.savedVars = {}
TraduzioneItaESO.Default = {
    language = "it",
    showNotifications = true,
    enableUI = true,
    hideDuringGameplay = true,
    bilingualMapNames = true,
    bilingualNPCNames = false,
    offsetX = 20,
    offsetY = 20,
    useEnglishNames = true,
    showRegions = true,
    bilingualPOI = true,
    bilingualNewLine = true,
    bilingualColor = "FFFFFF",
    hidePinsOnTamriel = true,
    opacity = 50  -- Nuova: opacità overlay da Votan's
}
local LAM = LibAddonMenu2
local translationTable = {}
local TAMRIEL_MAP_INDEX = 27
local AURBIS_MAP_INDEX = 439
d("[TraduzioneItaESO] Caricamento file TraduzioneItaESO.lua versione 3.5")
TraduzioneItaESO.locations = {
    [1] = { alliance = 999, cosmic = true, locationName = "Tamriel" },
    [2] = { alliance = 1, zoneOrder = 2, poi = 62, locationName = "Glenumbra" },
    [3] = { alliance = 1, zoneOrder = 4, poi = 55, labelY = -0.0125, locationName = "Stormhaven" },
    [4] = { alliance = 1, zoneOrder = 3, poi = 56, locationName = "Rivenspire" },
    [5] = { alliance = 1, zoneOrder = 5, poi = 43, labelX = 0.01, locationName = "Alik'r Desert" },
    [6] = { alliance = 1, zoneOrder = 6, poi = 33, labelY = 0.02, locationName = "Bangkorai" },
    [7] = { alliance = 2, zoneOrder = 3, poi = 214, labelX = -0.0125, labelY = -0.03, locationName = "Grahtwood" },
    [8] = { alliance = 2, zoneOrder = 5, poi = 102, locationName = "Malabal Tor" },
    [9] = { alliance = 3, zoneOrder = 4, poi = 48, locationName = "Shadowfen" },
    [10] = { alliance = 3, zoneOrder = 3, poi = 28, locationName = "Deshaan" },
    [11] = { alliance = 3, zoneOrder = 2, poi = 65, labelY = 0.035, locationName = "Stonefalls" },
    [12] = { alliance = 3, zoneOrder = 6, poi = 109, locationName = "The Rift" },
    [13] = { alliance = 3, zoneOrder = 5, poi = 87, labelY = 0.0125, locationName = "Eastmarch" },
    [14] = { alliance = 100, locationName = "Cyrodiil" },
    [15] = { alliance = 2, zoneOrder = 2, poi = 177, labelX = -0.0125, labelY = -0.025, locationName = "Auridon" },
    [16] = { alliance = 2, zoneOrder = 4, poi = 143, labelY = -0.025, locationName = "Greenshade" },
    [17] = { alliance = 2, zoneOrder = 6, poi = 162, locationName = "Reaper's March" },
    [18] = { alliance = 3, zoneOrder = 1, poi = 173, offsetX = -0.05, offsetY = -0.1, labelX = -0.0175, labelY = -0.03, locationName = "Bal Foyen" },
    [19] = { alliance = 1, zoneOrder = 1, poi = 138, offsetX = 0.1, offsetY = 0, locationName = "Stros M'Kai" },
    [20] = { alliance = 1, zoneOrder = 1, poi = 181, locationName = "Betnikh" },
    [21] = { alliance = 2, zoneOrder = 1, poi = 142, locationName = "Khenarthi's Roost" },
    [22] = { alliance = 3, zoneOrder = 1, poi = 172, offsetX = 0, offsetY = 0.2, labelY = -0.005, locationName = "Bleakrock Isle" },
    [23] = { alliance = 100, zoneLevel = 7, poi = 131, cosmic = true, locationName = "Coldharbour" },
    [24] = { alliance = 999, locationName = "Aurbis" },
    [25] = { alliance = 100, poi = 220, labelX = -0.0125, labelY = -0.025, locationName = "Craglorn" },
    [26] = { alliance = 100, labelX = -0.025, locationName = "Imperial City" },
    [27] = { alliance = 1, poi = 244, labelX = 0.0125, labelY = -0.0125, locationName = "Wrothgar" },
    [28] = { alliance = 1, poi = 255, offsetX = 0.1, offsetY = 0, locationName = "Abah's Landing" },
    [29] = { alliance = 100, poi = 251, labelX = 0.0125, labelY = -0.0125, locationName = "Gold Coast" },
    [30] = { alliance = 3, poi = 284, offsetX = 0.005, offsetY = 0.005, locationName = "Vvardenfell" },
    [31] = { alliance = 3, poi = 337, cosmic = true, locationName = "Clockwork City" },
    [32] = { alliance = 2, poi = 355, locationName = "Summerset" },
    [33] = { alliance = 100, poi = 360, cosmic = true, locationName = "Artaeum" },
    [34] = { alliance = 3, poi = 374, locationName = "Murkmire" },
    [35] = { alliance = 3, hidden = true, locationName = "Norg-Tzel" },
    [36] = { alliance = 2, poi = 382, labelY = 0.0125, locationName = "Northern Elsweyr" },
    [37] = { alliance = 2, poi = 402, labelY = -0.0125, locationName = "Southern Elsweyr" },
    [38] = { alliance = 3, poi = 426, offsetX = 0.05, offsetY = -0.05, locationName = "Western Skyrim" },
    [39] = { alliance = 3, locationName = "Blackreach: Greymoor Caverns" },
    [40] = { alliance = 999, locationName = "Blackreach" },
    [41] = { alliance = 3, locationName = "Blackreach: Arkthzand Cavern" },
    [42] = { alliance = 3, poi = 449, labelX = 0.025, locationName = "The Reach" },
    [43] = { alliance = 999, poi = 458, locationName = "Blackwood" },
    [44] = { alliance = 999, cosmic = true, locationName = "Fargrave" },
    [45] = { alliance = 999, cosmic = true, locationName = "Deadlands" },
    [46] = { alliance = 1, poi = 513, locationName = "High Isle" },
    [47] = { alliance = 999, hidden = true, locationName = "Fargrave City" },
    [48] = { alliance = 1, poi = 529, locationName = "Galen" },
    [49] = { alliance = 3, poi = 536, labelX = 0.0125, labelY = -0.005, locationName = "Telvanni Peninsula" },
    [50] = { alliance = 999, cosmic = true, locationName = "Apocrypha" },
    [51] = { alliance = 999, poi = 558, cosmic = false, locationName = "West Weald" }
}
TraduzioneItaESO.color = {
    [1] = ZO_ColorDef:New(-1, 0.25, 1, 0.2),
    [2] = ZO_ColorDef:New(1, 1, -1, 0.15),
    [3] = ZO_ColorDef:New(1, -1, -1, 0.15)
}
TraduzioneItaESO.defaultColor = ZO_ColorDef:New(0, 0, 0, 0.25)
TraduzioneItaESO.transparentColor = ZO_ColorDef:New(0, 0, 0, 0)
TraduzioneItaESO.baseGameColor = ZO_ColorDef:New(0.5, 1, 0.5, 0.25)
TraduzioneItaESO.dlcGameColor = ZO_ColorDef:New(0.25, 0.25, 0.75, 0.35)
function TraduzioneItaESO:ApplyOpacity()
    local opacity = self.savedVars.opacity / 100
    self.color[1]:SetAlpha(opacity * 1.25)
    self.color[2]:SetAlpha(opacity)
    self.color[3]:SetAlpha(opacity)
    self.defaultColor:SetAlpha(opacity)
    self.transparentColor:SetAlpha(opacity)
    self.baseGameColor:SetAlpha(opacity)
    self.dlcGameColor:SetAlpha(opacity * 1.2)
end
local function LoadTranslationTable()
    translationTable = {}
    TraduzioneItaESO.reverseTable = {}
    local count = 0
    local zoneTranslations = TraduzioneItaESO.ZoneTranslations or {}
    for name_it, name_en in pairs(zoneTranslations) do
        if name_it and name_en then
            translationTable[name_it] = name_en
            TraduzioneItaESO.reverseTable[name_en] = name_it
            count = count + 1
            d("[TraduzioneItaESO] Traduzione zona: " .. tostring(name_it) .. " -> " .. tostring(name_en))
        end
    end
    d("[TraduzioneItaESO] Caricate " .. count .. " traduzioni")
    -- Test specifici
    local testKeys = {"Santuario di Vivec", "Abbazia delle Lame", "Abbazia di Zenithar"}
    for _, key in ipairs(testKeys) do
        if translationTable[key] then
            d("[TraduzioneItaESO] Test OK: " .. key .. " -> " .. translationTable[key])
        else
            d("[TraduzioneItaESO] Test FALLITO: Traduzione non trovata per " .. key)
        end
    end
end
local function SetLanguage(lang)
    if lang ~= GetCVar("language.2") then
        SetCVar("IgnorePatcherLanguageSetting", 1)
        SetCVar("language.2", lang)
        d("[TraduzioneItaESO] Cambio lingua a: " .. lang .. ", ricarico UI")
        ReloadUI()
    else
        d("[TraduzioneItaESO] Lingua già impostata su: " .. lang)
    end
end
local function ShowLanguageNotification(lang)
    if not TraduzioneItaESO.savedVars.showNotifications then return end
    local texturePath = lang == "en" and "/TraduzioneItaESO/textures/flag_en.dds" or "/TraduzioneItaESO/textures/flag_it.dds"
    local message = lang == "en" and "Lingua impostata su Inglese" or "Lingua impostata su Italiano"
    ZO_Alert(UI_ALERT_CATEGORY_ALERT, nil, string.format("|t24:24:%s|t %s", texturePath, message))
end
local function UpdateMapName()
    d("[TraduzioneItaESO] Funzione UpdateMapName chiamata")
    if not TraduzioneItaESO.savedVars.bilingualMapNames and not TraduzioneItaESO.savedVars.useEnglishNames then
        d("[TraduzioneItaESO] Nomi bilingui e nomi inglesi disabilitati")
        return
    end
    local currentLang = GetCVar("language.2")
    local mapName = GetMapName()
    if mapName == "Tamriel" then
        mapName = GetUnitZone("player")
    end
    local mapNameNoSuffix = mapName:gsub("%^%a+$", "")
    local englishName = translationTable[mapNameNoSuffix] or mapNameNoSuffix
    d("[TraduzioneItaESO] Lingua: " .. currentLang .. ", MapName: " .. mapName .. ", Traduzione: " .. englishName)
    local nativeLabel = ZO_WorldMapZoneNameLabel
    if nativeLabel then
        local newText = mapName
        if currentLang == "it" then
            if TraduzioneItaESO.savedVars.bilingualMapNames then
                newText = TraduzioneItaESO.savedVars.bilingualNewLine and zo_strformat("<<1>>\n<<2>>", mapName, ColorizeEnglish(englishName)) or zo_strformat("<<1>> (<<2>>)", mapName, ColorizeEnglish(englishName))
            elseif TraduzioneItaESO.savedVars.useEnglishNames and GetCurrentMapIndex() == TAMRIEL_MAP_INDEX then
                newText = englishName
            end
        end
        nativeLabel:SetText(newText)
    end
end
local function UpdateNPCName()
    if not TraduzioneItaESO.savedVars.bilingualNPCNames then return end
    local currentLang = GetCVar("language.2")
    local unitName = GetUnitName("interact")
    local unitNoSuffix = unitName:gsub("%^%a+$", "")
    local englishName = translationTable[unitNoSuffix] or unitNoSuffix
    local npcLabel = WINDOW_MANAGER:GetControlByName("TraduzioneItaESO_NPCNameLabel")
    if npcLabel then
        local newText = unitName
        if currentLang == "it" then
            newText = string.format("%s / %s", unitName, englishName)
        end
        npcLabel:SetText(newText)
    end
end
local function UpdateUIVisibility(hidden)
    if not TraduzioneItaESO.savedVars.enableUI then return end
    local uiControl = WINDOW_MANAGER:GetControlByName("TraduzioneItaESOUI")
    if uiControl then
        if TraduzioneItaESO.savedVars.hideDuringGameplay then
            uiControl:SetHidden(not hidden)
        else
            uiControl:SetHidden(false)
        end
    end
end
local function RefreshUI()
    local uiControl = WINDOW_MANAGER:GetControlByName("TraduzioneItaESOUI")
    if not uiControl then
        uiControl = WINDOW_MANAGER:CreateTopLevelWindow("TraduzioneItaESOUI")
        uiControl:SetDimensions(68, 32)
        uiControl:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, TraduzioneItaESO.savedVars.offsetX, TraduzioneItaESO.savedVars.offsetY)
        uiControl:SetMovable(true)
        uiControl:SetMouseEnabled(true)
        uiControl:SetHandler("OnMoveStop", function()
            TraduzioneItaESO.savedVars.offsetX = uiControl:GetLeft()
            TraduzioneItaESO.savedVars.offsetY = uiControl:GetTop()
        end)
        d("[TraduzioneItaESO] Creato controllo TraduzioneItaESOUI")
    end
    local flags = {"en", "it"}
    for i, flagCode in ipairs(flags) do
        local flagControl = WINDOW_MANAGER:GetControlByName("TraduzioneItaESO_FlagControl_" .. flagCode)
        if not flagControl then
            flagControl = WINDOW_MANAGER:CreateControl("TraduzioneItaESO_FlagControl_" .. flagCode, uiControl, CT_BUTTON)
            flagControl:SetDimensions(24, 24)
            flagControl:SetAnchor(LEFT, uiControl, LEFT, 8 + (i-1) * 32, 4)
            flagControl:SetNormalTexture("/TraduzioneItaESO/textures/flag_" .. flagCode .. ".dds")
            flagControl:SetPressedTexture("/TraduzioneItaESO/textures/flag_" .. flagCode .. ".dds")
            flagControl:SetMouseOverTexture("/TraduzioneItaESO/textures/flag_" .. flagCode .. ".dds")
            flagControl:SetDisabledTexture("/TraduzioneItaESO/textures/flag_" .. flagCode .. ".dds")
            flagControl:SetClickSound("Click")
            flagControl:SetHandler("OnClicked", function(self, button)
                if button == MOUSE_BUTTON_INDEX_LEFT then
                    d("[TraduzioneItaESO] Clic su bandiera: " .. flagCode)
                    TraduzioneItaESO.savedVars.language = flagCode
                    ShowLanguageNotification(flagCode)
                    SetLanguage(flagCode)
                end
            end)
        end
        flagControl:SetHidden(false)
        flagControl:SetAlpha(TraduzioneItaESO.savedVars.language == flagCode and 1.0 or 0.7)
    end
    UpdateUIVisibility(IsReticleHidden())
end
local function ColorizeEnglish(text)
    local color = TraduzioneItaESO.savedVars.bilingualColor or "FFFFFF"
    return "|c" .. color .. text .. "|r"
end
local function HookPoiTooltips()
    local function AddBilingualName(pin)
        if not TraduzioneItaESO.savedVars.bilingualPOI then return end
        local localizedName = ZO_WorldMapMouseoverName:GetText()
        local localizedNoSuffix = localizedName:gsub("%^%a+$", "")
        local englishName = translationTable[localizedNoSuffix] or localizedNoSuffix  -- Fallback a IT se non trovato
        local locString = TraduzioneItaESO.savedVars.bilingualNewLine and zo_strformat("<<1>>\n<<2>>", localizedName, ColorizeEnglish(englishName)) or zo_strformat("<<1>> (<<2>>)", localizedName, ColorizeEnglish(englishName))
        ZO_WorldMapMouseoverName:SetText(locString)
        d("[TraduzioneItaESO] Bilingue applicato per POI: " .. locString)
        if not translationTable[localizedNoSuffix] then
            d("[TraduzioneItaESO] Traduzione non trovata per POI: " .. localizedNoSuffix .. " - Usato fallback IT")
        end
    end
    local CreatorPOISeen = ZO_MapPin.TOOLTIP_CREATORS[MAP_PIN_TYPE_POI_SEEN].creator
    ZO_MapPin.TOOLTIP_CREATORS[MAP_PIN_TYPE_POI_SEEN].creator = function(...)
        CreatorPOISeen(...)
        AddBilingualName(...)
    end
    local CreatorPOIComplete = ZO_MapPin.TOOLTIP_CREATORS[MAP_PIN_TYPE_POI_COMPLETE].creator
    ZO_MapPin.TOOLTIP_CREATORS[MAP_PIN_TYPE_POI_COMPLETE].creator = function(...)
        CreatorPOIComplete(...)
        AddBilingualName(...)
    end
end
local function HookShrineTooltips()
    local function AddBilingualShrineName(pin)
        if not TraduzioneItaESO.savedVars.bilingualPOI then return end
        local localizedName = ZO_WorldMapMouseoverName:GetText()
        local localizedNoSuffix = localizedName:gsub("%^%a+$", "")
        local englishName = translationTable[localizedNoSuffix] or localizedNoSuffix  -- Fallback a IT se non trovato
        local locString = TraduzioneItaESO.savedVars.bilingualNewLine and zo_strformat("<<1>>\n<<2>>", localizedName, ColorizeEnglish(englishName)) or zo_strformat("<<1>> (<<2>>)", localizedName, ColorizeEnglish(englishName))
        ZO_WorldMapMouseoverName:SetText(locString)
        d("[TraduzioneItaESO] Bilingue applicato per Shrine: " .. locString)
        if not translationTable[localizedNoSuffix] then
            d("[TraduzioneItaESO] Traduzione non trovata per Shrine: " .. localizedNoSuffix .. " - Usato fallback IT")
        end
    end
    local creatorFTWS = ZO_MapPin.TOOLTIP_CREATORS[MAP_PIN_TYPE_FAST_TRAVEL_WAYSHRINE].creator
    ZO_MapPin.TOOLTIP_CREATORS[MAP_PIN_TYPE_FAST_TRAVEL_WAYSHRINE].creator = function(...)
        creatorFTWS(...)
        AddBilingualShrineName(...)
    end
end
local function HookKeepTooltips()
    local function AnchorTo(control, anchorTo)
        local isValid, point, _, relPoint, offsetX, offsetY = control:GetAnchor(0)
        if isValid then
            control:ClearAnchors()
            control:SetAnchor(point, anchorTo, relPoint, offsetX, offsetY)
        end
    end
    local function ModifyKeepTooltip(self, keepId)
        if not TraduzioneItaESO.savedVars.bilingualPOI then return end
        local keepName = GetKeepName(keepId)
        local keepNoSuffix = keepName:gsub("%^%a+$", "")
        local englishKeepName = translationTable[keepNoSuffix] or keepNoSuffix  -- Fallback a IT se non trovato
        local nameLabel = self:GetNamedChild("Name")
        local displayText = TraduzioneItaESO.savedVars.bilingualNewLine and zo_strformat("<<1>>\n<<2>>", keepName, ColorizeEnglish(englishKeepName)) or zo_strformat("<<1>> (<<2>>)", keepName, ColorizeEnglish(englishKeepName))
        nameLabel:SetText(displayText)
        d("[TraduzioneItaESO] Bilingue applicato per Keep: " .. displayText)
        if not translationTable[keepNoSuffix] then
            d("[TraduzioneItaESO] Traduzione non trovata per Keep: " .. keepNoSuffix .. " - Usato fallback IT")
        end
    end
    local SetKeep = ZO_KeepTooltip.SetKeep
    ZO_KeepTooltip.SetKeep = function(self, keepId, ...)
        SetKeep(self, keepId, ...)
        ModifyKeepTooltip(self, keepId)
    end
    local RefreshKeep = ZO_KeepTooltip.RefreshKeepInfo
    ZO_KeepTooltip.RefreshKeepInfo = function(self, ...)
        RefreshKeep(self, ...)
        if self.keepId and self.battlegroundContext and self.historyPercent then
            ModifyKeepTooltip(self, self.keepId)
        end
    end
end
local MapBlobManager = ZO_ObjectPool:Subclass()
TraduzioneItaESO.MapBlobManager = MapBlobManager
local function MapOverlayControlFactory(pool, controlNamePrefix, templateName, parent)
    local overlayControl = ZO_ObjectPool_CreateNamedControl(controlNamePrefix, templateName, pool, parent)
    overlayControl:SetAlpha(0)
    ZO_AlphaAnimation:New(overlayControl)
    overlayControl.label = overlayControl:GetNamedChild("Location")
    overlayControl.city = overlayControl:GetNamedChild("City")
    overlayControl:SetInsets(4, 1, 1, 1, 1)
    overlayControl:SetInsets(3, -1, -1, -1, -1)
    overlayControl:SetInsets(1, 2, 2, 2, 2)
    return overlayControl
end
function MapBlobManager:New(blobContainer)
    local blobFactory = function(pool)
        return MapOverlayControlFactory(pool, "TraduzioneItaESOTamrielMapBlob", "VotansTamrielBlobControl", blobContainer)
    end
    return ZO_ObjectPool.New(self, blobFactory, ZO_ObjectPool_DefaultResetControl)
end
local function NormalizedLabelDataToUI(x, y)
    local w, h = ZO_WorldMapContainer:GetDimensions()
    return (x or 0) * w, (y or 0) * h
end
local function NormalizedBlobDataToUI(blobWidth, blobHeight, blobXOffset, blobYOffset)
    local w, h = ZO_WorldMapContainer:GetDimensions()
    return blobWidth * w, blobHeight * h, blobXOffset * w, blobYOffset * h
end
local g_mapPanAndZoom = ZO_WorldMap_GetPanAndZoom()
local function ShowMapTexture(textureControl, textureName, width, height, offsetX, offsetY)
    textureControl:SetTexture(textureName)
    textureControl:SetDimensions(width, height)
    textureControl:SetSimpleAnchorParent(offsetX, offsetY)
    textureControl:SetAlpha(1)
    textureControl:SetHidden(false)
end
function MapBlobManager:Update(normalizedMouseX, normalizedMouseY)
    local locationName, textureFile, widthN, heightN, locXN, locYN = GetMapMouseoverInfo(normalizedMouseX, normalizedMouseY)
    local textureUIWidth, textureUIHeight, textureXOffset, textureYOffset = NormalizedBlobDataToUI(widthN, heightN, locXN, locYN)
    self.m_zoom = g_mapPanAndZoom:GetCurrentCurvedZoom()
    if textureFile ~= "" then
        local blob = self:AcquireObject(textureFile)
        if blob then
            ShowMapTexture(blob, textureFile, textureUIWidth, textureUIHeight, textureXOffset, textureYOffset)
            blob.label:SetFont(TraduzioneItaESO.titleFont or "$(ANTIQUE_FONT)|18|soft-shadow-thick")
            blob.label:SetText(ZO_CachedStrFormat(SI_WORLD_MAP_LOCATION_NAME, locationName))
            blob.label:SetAlpha(math.max(0, 3 - self.m_zoom * 2.2))
            return blob
        end
    end
end
function TraduzioneItaESO:RenderMap(isTamriel)
    local positions = self.positions or {}
    local bm = self.blobManager
    local gps = LibGPS3
    local hidePins = not ZO_WorldMap_IsPinGroupShown(MAP_FILTER_WAYSHRINES)
    local showCities = TraduzioneItaESO.savedVars.showRegions
    local showLocations = TraduzioneItaESO.savedVars.showRegions
    for i, pos in pairs(positions) do
        local x, y = pos:GetOffset()
        local w, h = pos:GetScale()
        x, y = x + w / 2, y + h / 2
        x, y = gps:GlobalToLocal(x, y)
        if x > 0 and x < 1 and y > 0 and y < 1 then
            local location = self.locations[i]
            if location and (not location.cosmic) == isTamriel then
                local blob = bm:Update(location.blobX or x, location.blobY or y)
                if blob then
                    blob.label:SetHidden(not showLocations)
                    if showLocations then
                        local locXN, locYN = NormalizedLabelDataToUI(location.labelX, location.labelY)
                        blob.label:SetAnchor(CENTER, nil, CENTER, locXN, locYN)
                    end
                    local color = TraduzioneItaESO.color[location.alliance] or TraduzioneItaESO.defaultColor
                    local r, g, b, a = color:UnpackRGBA()
                    blob:SetColor(1, 1, 1, 1, a)
                    blob:SetColor(2, r, g, b, a)
                    blob:SetColor(3, r, g, b, a)
                    blob:SetColor(4, r, g, b, a)
                    if location.hidden then
                        blob.label:SetText("")
                    end
                    blob.city:SetFont(self.cityFont or "$(ANTIQUE_FONT)|12|soft-shadow-thick")
                    local zoneEnglish = location.locationName
                    local zoneItalian = TraduzioneItaESO.reverseTable[zoneEnglish] or zoneEnglish
                    local cityText = zoneEnglish
                    local currentLang = GetCVar("language.2")
                    if currentLang == "it" then
                        if TraduzioneItaESO.savedVars.bilingualMapNames then
                            cityText = TraduzioneItaESO.savedVars.bilingualNewLine and zo_strformat("<<1>>\n<<2>>", zoneItalian, ColorizeEnglish(zoneEnglish)) or zo_strformat("<<1>> (<<2>>)", zoneItalian, ColorizeEnglish(zoneEnglish))
                        elseif TraduzioneItaESO.savedVars.useEnglishNames then
                            cityText = zoneEnglish
                        else
                            cityText = zoneItalian
                        end
                    end
                    blob.city:SetText(ZO_CachedStrFormat("<<!AC:1>>", cityText))
                    if location.poi and showCities then
                        local locationName, locXN, locYN = select(2, GetFastTravelNodeInfo(location.poi))
                        x, y = x + (location.labelX or 0), y + (location.labelY or 0)
                        x, y = NormalizedLabelDataToUI(x, y)
                        locYN = locYN + (hidePins and -6 or 13)
                        local w, h1 = blob.label:GetDimensions()
                        local h1, h2 = h1 * 2 / 3, h1 / 3
                        if showLocations and blob.label:GetAlpha() > 0.1 and ((y - h1) < locYN and (y + h2) > locYN) and ((x - 64) < locXN and (x + 64) > locXN) then
                            blob.city:SetAnchor(TOP, blob.label, BOTTOM, 0, -3)
                        else
                            blob.city:SetAnchor(TOP, ZO_WorldMapContainer, TOPLEFT, locXN, locYN)
                        end
                    else
                        blob.city:ClearAnchors()
                    end
                    blob.city:SetHidden(not location.poi or not showCities)
                    local currentText = blob.label:GetText()
                    local currentNoSuffix = currentText:gsub("%^%a+$", "")
                    local englishName = translationTable[currentNoSuffix] or currentNoSuffix  -- Fallback a IT se non trovato
                    local bilingualString = TraduzioneItaESO.savedVars.bilingualNewLine and zo_strformat("<<1>>\n<<2>>", currentText, ColorizeEnglish(englishName)) or zo_strformat("<<1>> (<<2>>)", currentText, ColorizeEnglish(englishName))
                    if currentLang == "it" then
                        if TraduzioneItaESO.savedVars.bilingualMapNames then
                            blob.label:SetText(bilingualString)
                            d("[TraduzioneItaESO] Bilingue applicato su mappa per: " .. bilingualString)
                        elseif TraduzioneItaESO.savedVars.useEnglishNames then
                            blob.label:SetText(ColorizeEnglish(englishName))
                        else
                            blob.label:SetText(currentText)
                        end
                    else
                        blob.label:SetText(currentText)
                    end
                    if GetCurrentMapIndex() == TAMRIEL_MAP_INDEX and TraduzioneItaESO.savedVars.hidePinsOnTamriel then
                        ZO_WorldMap_GetPinManager():SetPinGroupShown(MAP_FILTER_WAYSHRINES, false)
                    end
                    if not translationTable[currentNoSuffix] then
                        d("[TraduzioneItaESO] Traduzione non trovata per regione mappa: " .. currentNoSuffix .. " - Usato fallback IT")
                    end
                end
            end
        end
    end
end
function TraduzioneItaESO:HideTamrielMap()
    self.blobManager:ReleaseAllObjects()
end
local function InitializeAddon()
    d("[TraduzioneItaESO] Inizializzazione addon")
    TraduzioneItaESO.savedVars = ZO_SavedVars:NewAccountWide(addonName .. "_Vars", 1, nil, TraduzioneItaESO.Default)
    LoadTranslationTable()
    d("[TraduzioneItaESO] Lingua corrente: " .. GetCVar("language.2"))
    RefreshUI()
    TraduzioneItaESO:ApplyOpacity()
    local gps = LibGPS3
    TraduzioneItaESO.positions = {}
    gps:PushCurrentMap()
    local currentLang = GetCVar("language.2")
    for i = 1, GetNumMaps() do
        SetMapToMapListIndex(i)
        local measurement = gps:GetCurrentMapMeasurement()
        if measurement then
            TraduzioneItaESO.positions[i] = measurement
            local location = TraduzioneItaESO.locations[i]
            if location and location.poi then
                local normalizedMouseX, normalizedMouseY = select(3, GetFastTravelNodeInfo(location.poi))
                local locationName = GetMapMouseoverInfo(normalizedMouseX, normalizedMouseY)
                local locNoSuffix = locationName:gsub("%^%a+$", "")
                if locationName ~= "" then
                    location.locationName = (currentLang == "it" and translationTable[locNoSuffix] or locNoSuffix) or locNoSuffix
                elseif location.offsetX then
                    locationName = GetMapMouseoverInfo(normalizedMouseX + location.offsetX, normalizedMouseY + location.offsetY)
                    locNoSuffix = locationName:gsub("%^%a+$", "")
                    if locationName ~= "" then
                        location.locationName = (currentLang == "it" and translationTable[locNoSuffix] or locNoSuffix) or locNoSuffix
                    end
                end
            end
            if location then
                location.index = i
            end
        end
    end
    gps:PopCurrentMap()
    local blobContainer = ZO_WorldMapContainer
    TraduzioneItaESO.blobManager = MapBlobManager:New(blobContainer)
    EVENT_MANAGER:RegisterForEvent(addonName, EVENT_RETICLE_HIDDEN_UPDATE, function(eventCode, hidden)
        UpdateUIVisibility(hidden)
    end)
    if TraduzioneItaESO.savedVars.bilingualMapNames or TraduzioneItaESO.savedVars.useEnglishNames then
        d("[TraduzioneItaESO] Registrazione eventi mappa")
        EVENT_MANAGER:RegisterForEvent(addonName, EVENT_ZONE_UPDATE, UpdateMapName)
        EVENT_MANAGER:RegisterForEvent(addonName, EVENT_MAP_CHUNK_INFO_RECEIVED, UpdateMapName)
        EVENT_MANAGER:RegisterForEvent(addonName, EVENT_MAP_CHANGED, function()
            local currentIndex = GetCurrentMapIndex()
            if currentIndex == TAMRIEL_MAP_INDEX then
                TraduzioneItaESO:RenderMap(TraduzioneItaESO.savedVars.showRegions)
            else
                TraduzioneItaESO:HideTamrielMap()
            end
        end)
        ZO_PreHook(ZO_WorldMap, "OnShow", function()
            d("[TraduzioneItaESO] ZO_WorldMap OnShow")
            UpdateMapName()
            if GetCurrentMapIndex() == TAMRIEL_MAP_INDEX then
                TraduzioneItaESO:RenderMap(TraduzioneItaESO.savedVars.showRegions)
            end
        end)
        ZO_PreHook(ZO_WorldMap, "OnHidden", function()
            TraduzioneItaESO:HideTamrielMap()
        end)
        TraduzioneItaESO.lastZoom = g_mapPanAndZoom:GetCurrentCurvedZoom()
        EVENT_MANAGER:RegisterForUpdate(addonName .. "_MapUpdate", 50, function()
            if ZO_WorldMap:IsHidden() then return end
            if GetCurrentMapIndex() ~= TAMRIEL_MAP_INDEX then return end
            local currentZoom = g_mapPanAndZoom:GetCurrentCurvedZoom()
            if math.abs(currentZoom - TraduzioneItaESO.lastZoom) > 0.001 then
                TraduzioneItaESO.lastZoom = currentZoom
                TraduzioneItaESO:RenderMap(TraduzioneItaESO.savedVars.showRegions)
            end
        end)
    end
    if TraduzioneItaESO.savedVars.bilingualPOI then
        HookPoiTooltips()
        HookShrineTooltips()
        HookKeepTooltips()
    end
    local panelData = {
        type = "panel",
        name = "Traduzione Italiana ESO",
        displayName = "|cFFD700Traduzione Italiana ESO|r",
        author = "Muflonebarbuto",
        version = TraduzioneItaESO.version,
        slashCommand = "/itaeso",
        registerForRefresh = true,
        registerForDefaults = true
    }
    local optionsData = {
        {
            type = "dropdown",
            name = "Seleziona Lingua",
            choices = {"Italiano", "Inglese"},
            choicesValues = {"it", "en"},
            getFunc = function() return TraduzioneItaESO.savedVars.language end,
            setFunc = function(value)
                TraduzioneItaESO.savedVars.language = value
                ShowLanguageNotification(value)
                SetLanguage(value)
            end,
            tooltip = "Scegli la lingua del gioco.",
            requiresReload = true
        },
        {
            type = "checkbox",
            name = "Mostra Notifiche",
            tooltip = "Abilita/disabilita notifiche con bandierina al cambio lingua.",
            getFunc = function() return TraduzioneItaESO.savedVars.showNotifications end,
            setFunc = function(value) TraduzioneItaESO.savedVars.showNotifications = value end
        },
        {
            type = "checkbox",
            name = "Mostra Bandierine UI",
            tooltip = "Abilita/disabilita le bandierine cliccabili sullo schermo.",
            getFunc = function() return TraduzioneItaESO.savedVars.enableUI end,
            setFunc = function(value)
                TraduzioneItaESO.savedVars.enableUI = value
                UpdateUIVisibility(IsReticleHidden())
            end
        },
        {
            type = "checkbox",
            name = "Nascondi Bandierine durante Gameplay",
            tooltip = "Nascondi le bandierine quando il mirino è attivo.",
            getFunc = function() return TraduzioneItaESO.savedVars.hideDuringGameplay end,
            setFunc = function(value)
                TraduzioneItaESO.savedVars.hideDuringGameplay = value
                UpdateUIVisibility(IsReticleHidden())
            end
        },
        {
            type = "checkbox",
            name = "Nomi Bilingui sulla Mappa",
            tooltip = "Mostra nomi delle zone in italiano e inglese (es. 'Deserto di Alik'r\nAlik'r Desert').",
            getFunc = function() return TraduzioneItaESO.savedVars.bilingualMapNames end,
            setFunc = function(value)
                TraduzioneItaESO.savedVars.bilingualMapNames = value
                if value or TraduzioneItaESO.savedVars.useEnglishNames then
                    EVENT_MANAGER:RegisterForEvent(addonName, EVENT_ZONE_UPDATE, UpdateMapName)
                    EVENT_MANAGER:RegisterForEvent(addonName, EVENT_MAP_CHANGED, function()
                        local currentIndex = GetCurrentMapIndex()
                        if currentIndex == TAMRIEL_MAP_INDEX then
                            TraduzioneItaESO:RenderMap(TraduzioneItaESO.savedVars.showRegions)
                        else
                            TraduzioneItaESO:HideTamrielMap()
                        end
                    end)
                    EVENT_MANAGER:RegisterForEvent(addonName, EVENT_MAP_CHUNK_INFO_RECEIVED, UpdateMapName)
                else
                    EVENT_MANAGER:UnregisterForEvent(addonName, EVENT_ZONE_UPDATE)
                    EVENT_MANAGER:UnregisterForEvent(addonName, EVENT_MAP_CHANGED)
                    EVENT_MANAGER:UnregisterForEvent(addonName, EVENT_MAP_CHUNK_INFO_RECEIVED)
                end
                UpdateMapName()
                TraduzioneItaESO:RenderMap(TraduzioneItaESO.savedVars.showRegions)
            end
        },
        {
            type = "checkbox",
            name = "Usa Nomi Inglesi su Tamriel",
            tooltip = "Mostra i nomi inglesi delle zone sulla mappa di Tamriel (stile Votan's Tamriel Map).",
            getFunc = function() return TraduzioneItaESO.savedVars.useEnglishNames end,
            setFunc = function(value)
                TraduzioneItaESO.savedVars.useEnglishNames = value
                if value or TraduzioneItaESO.savedVars.bilingualMapNames then
                    EVENT_MANAGER:RegisterForEvent(addonName, EVENT_ZONE_UPDATE, UpdateMapName)
                    EVENT_MANAGER:RegisterForEvent(addonName, EVENT_MAP_CHANGED, function()
                        local currentIndex = GetCurrentMapIndex()
                        if currentIndex == TAMRIEL_MAP_INDEX then
                            TraduzioneItaESO:RenderMap(TraduzioneItaESO.savedVars.showRegions)
                        else
                            TraduzioneItaESO:HideTamrielMap()
                        end
                    end)
                    EVENT_MANAGER:RegisterForEvent(addonName, EVENT_MAP_CHUNK_INFO_RECEIVED, UpdateMapName)
                else
                    EVENT_MANAGER:UnregisterForEvent(addonName, EVENT_ZONE_UPDATE)
                    EVENT_MANAGER:UnregisterForEvent(addonName, EVENT_MAP_CHANGED)
                    EVENT_MANAGER:UnregisterForEvent(addonName, EVENT_MAP_CHUNK_INFO_RECEIVED)
                end
                TraduzioneItaESO:RenderMap(TraduzioneItaESO.savedVars.showRegions)
            end
        },
        {
            type = "checkbox",
            name = "Mostra Regioni su Tamriel",
            tooltip = "Mostra i nomi delle regioni sulla mappa di Tamriel.",
            getFunc = function() return TraduzioneItaESO.savedVars.showRegions end,
            setFunc = function(value)
                TraduzioneItaESO.savedVars.showRegions = value
                TraduzioneItaESO:RenderMap(value)
            end
        },
        {
            type = "checkbox",
            name = "Nascondi Wayshrine su Tamriel",
            tooltip = "Nasconde i pin dei wayshrine sulla mappa di Tamriel (stile Votan's).",
            getFunc = function() return TraduzioneItaESO.savedVars.hidePinsOnTamriel end,
            setFunc = function(value)
                TraduzioneItaESO.savedVars.hidePinsOnTamriel = value
                if GetCurrentMapIndex() == TAMRIEL_MAP_INDEX then
                    ZO_WorldMap_GetPinManager():SetPinGroupShown(MAP_FILTER_WAYSHRINES, not value)
                end
            end
        },
        {
            type = "checkbox",
            name = "Nomi Bilingui nei Tooltips (POI/Keeps/Shrines)",
            tooltip = "Mostra nomi in italiano e inglese nei tooltips quando passi il mouse su POI, Keeps o Shrines.",
            getFunc = function() return TraduzioneItaESO.savedVars.bilingualPOI end,
            setFunc = function(value)
                TraduzioneItaESO.savedVars.bilingualPOI = value
                if value then
                    HookPoiTooltips()
                    HookShrineTooltips()
                    HookKeepTooltips()
                end
            end,
            requiresReload = true
        },
        {
            type = "checkbox",
            name = "Nome Inglese su Nuova Linea",
            tooltip = "Mostra il nome inglese su una nuova linea sotto quello italiano nei tooltips e mappe.",
            getFunc = function() return TraduzioneItaESO.savedVars.bilingualNewLine end,
            setFunc = function(value) TraduzioneItaESO.savedVars.bilingualNewLine = value end,
            disabled = function() return not TraduzioneItaESO.savedVars.bilingualPOI and not TraduzioneItaESO.savedVars.bilingualMapNames end
        },
        {
            type = "colorpicker",
            name = "Colore Nome Inglese",
            tooltip = "Colore per il nome inglese nei tooltips e mappe.",
            getFunc = function() return ZO_ColorDef:New(TraduzioneItaESO.savedVars.bilingualColor):UnpackRGBA() end,
            setFunc = function(r, g, b, a) TraduzioneItaESO.savedVars.bilingualColor = ZO_ColorDef:New(r, g, b, a):ToHex() end,
            default = ZO_ColorDef:New("FFFFFF"),
            disabled = function() return not TraduzioneItaESO.savedVars.bilingualPOI and not TraduzioneItaESO.savedVars.bilingualMapNames end
        },
        {
            type = "slider",
            name = "Opacità Overlay Mappa",
            tooltip = "Regola trasparenza overlay regioni su Tamriel (stile Votan's).",
            min = 0,
            max = 100,
            step = 1,
            getFunc = function() return TraduzioneItaESO.savedVars.opacity end,
            setFunc = function(value)
                TraduzioneItaESO.savedVars.opacity = value
                TraduzioneItaESO:ApplyOpacity()
                TraduzioneItaESO:RenderMap(TraduzioneItaESO.savedVars.showRegions)
            end,
            default = 50
        },
        {
            type = "texture",
            image = "/TraduzioneItaESO/textures/flag_it.dds",
            imageWidth = 24,
            imageHeight = 24,
            tooltip = "Bandiera italiana per il tuo addon!",
            width = "half"
        },
        {
            type = "texture",
            image = "/TraduzioneItaESO/textures/flag_en.dds",
            imageWidth = 24,
            imageHeight = 24,
            tooltip = "Bandiera inglese per il tuo addon!",
            width = "half"
        }
    }
    LAM:RegisterAddonPanel(addonName .. "Options", panelData)
    LAM:RegisterOptionControls(addonName .. "Options", optionsData)
end
EVENT_MANAGER:RegisterForEvent(addonName, EVENT_ADD_ON_LOADED, function(event, name)
    if name ~= addonName then return end
    d("[TraduzioneItaESO] Addon caricato: versione " .. TraduzioneItaESO.version)
    InitializeAddon()
    EVENT_MANAGER:UnregisterForEvent(addonName, EVENT_ADD_ON_LOADED)
end)
SLASH_COMMANDS["/itaesoit"] = function()
    TraduzioneItaESO.savedVars.language = "it"
    ShowLanguageNotification("it")
    SetLanguage("it")
end
SLASH_COMMANDS["/itaesoen"] = function()
    TraduzioneItaESO.savedVars.language = "en"
    ShowLanguageNotification("en")
    SetLanguage("en")
end
SLASH_COMMANDS["/itaeso"] = function()
    LibAddonMenu2:OpenToPanel(addonName .. "Options")
    d("[TraduzioneItaESO] Apertura pannello impostazioni")
end
SLASH_COMMANDS["/testitaeso"] = function()
    d("[TraduzioneItaESO] Test comando /testitaeso")
    UpdateMapName()
    TraduzioneItaESO:RenderMap(TraduzioneItaESO.savedVars.showRegions)
end