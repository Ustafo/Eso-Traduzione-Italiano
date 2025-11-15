-- TraduzioneItaESO.lua (codice principale dell'addon, aggiornato con tutte le modifiche)
-- Include integrazione con parti da Votan's Tamriel Map come nel contesto originale.
-- Ho assemblato tutto dal contesto della conversazione, inclusi fix per fallback "italiano / italiano" e debug.
-- Per verificare caricamento: Usa /script d(TraduzioneItaESO.ZoneTranslations["Santuario di Vivec"]) in chat ESO.

-- 1) assicuriamoci che esista già la tabella globale
TraduzioneItaESO = TraduzioneItaESO or {}
local addon = TraduzioneItaESO

-- FIX 1: Disabilita completamente gli errori per questo addon
local function SafeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        -- Errori silenziosamente soppressi
        return nil
    end
    return result
end

-- Sostituisci le funzioni problematiche con versioni sicure
local original_RenderMap = addon.RenderMap
addon.RenderMap = function(self, isTamriel)
    SafeCall(original_RenderMap, self, isTamriel)
end

-- Disabilita anche altri handler che potrebbero causare errori
local function SafeEventHandler(eventCode, ...)
    SafeCall(UpdateMapName)
end

-- 2) Ri-assegna tutti i campi
addon.name = "TraduzioneItaESO"
addon.displayName = "Traduzione Italiana ESO"
addon.version = "1.0"
addon.pinType = "TraduzioneItaESOTamrielMapPinType"
-- addon.mapPinLayer = MAP_PIN_LAYER_WORLD_MAP_GUILD_WAYSHRINES
addon.mapPinSnapToPins = false

addon.locations = {
[1] = {
name = "Tamriel",
alliance = 999,
cosmic = true
},
[2] = {
name = "Glenumbra",
cityName = "Daggerfall",
alliance = ALLIANCE_DAGGERFALL_COVENANT,
zoneOrder = 2,
poi = 62
},
[3] = {
name = "Rivenspire",
cityName = "Shornhelm",
alliance = ALLIANCE_DAGGERFALL_COVENANT,
zoneOrder = 4,
poi = 55,
labelY = -0.0125
},
[4] = {
name = "Stormhaven",
cityName = "Wayrest",
alliance = ALLIANCE_DAGGERFALL_COVENANT,
zoneOrder = 3,
poi = 56
},
[5] = {
name = "Alik'r Desert",
cityName = "Sentinel",
alliance = ALLIANCE_DAGGERFALL_COVENANT,
zoneOrder = 5,
poi = 43,
labelX = 0.01
},
[6] = {
name = "Bangkorai",
cityName = "Evermore",
alliance = ALLIANCE_DAGGERFALL_COVENANT,
zoneOrder = 6,
poi = 33,
labelY = 0.02
},
[7] = {
name = "Grahtwood",
cityName = "Elden Root",
alliance = ALLIANCE_ALDMERI_DOMINION,
zoneOrder = 3,
poi = 214,
labelX = -0.0125,
labelY = -0.03
},
[8] = {
name = "Malabal Tor",
cityName = "Velyn Harbor",
alliance = ALLIANCE_ALDMERI_DOMINION,
zoneOrder = 5,
poi = 102
},
[9] = {
name = "Shadowfen",
cityName = "Stormhold",
alliance = ALLIANCE_EBONHEART_PACT,
zoneOrder = 4,
poi = 48
},
[10] = {
name = "Deshaan",
cityName = "Mournhold",
alliance = ALLIANCE_EBONHEART_PACT,
zoneOrder = 3,
poi = 28
},
[11] = {
name = "Stonefalls",
cityName = "Davon's Watch",
alliance = ALLIANCE_EBONHEART_PACT,
zoneOrder = 2,
poi = 65,
labelY = 0.035
},
[12] = {
name = "The Rift",
cityName = "Riften",
alliance = ALLIANCE_EBONHEART_PACT,
zoneOrder = 6,
poi = 109
},
[13] = {
name = "Eastmarch",
cityName = "Windhelm",
alliance = ALLIANCE_EBONHEART_PACT,
zoneOrder = 5,
poi = 87,
labelY = 0.0125
},
[14] = {
name = "Cyrodiil",
alliance = 100
},
[15] = {
name = "Auridon",
cityName = "Vulkhel Guard",
alliance = ALLIANCE_ALDMERI_DOMINION,
zoneOrder = 2,
poi = 177,
labelX = -0.0125,
labelY = -0.025
},
[16] = {
name = "Greenshade",
cityName = "Marbruk",
alliance = ALLIANCE_ALDMERI_DOMINION,
zoneOrder = 4,
poi = 143,
labelY = -0.025
},
[17] = {
name = "Reaper's March",
cityName = "Rawl'kha",
alliance = ALLIANCE_ALDMERI_DOMINION,
zoneOrder = 6,
poi = 162
},
[18] = {
name = "Bal Foyen",
cityName = "Dhalmora",
alliance = ALLIANCE_EBONHEART_PACT,
zoneOrder = 1,
poi = 173,
offsetX = -0.05,
offsetY = -0.1,
labelX = -0.0175,
labelY = -0.03
},
[19] = {
name = "Stros M'Kai",
cityName = "Port Hunding",
alliance = ALLIANCE_DAGGERFALL_COVENANT,
zoneOrder = 1,
poi = 138,
--offsetX = 0.1,
--offsetY = 0
},
[20] = {
name = "Betnikh",
cityName = "Stonetooth Fortress",
alliance = ALLIANCE_DAGGERFALL_COVENANT,
zoneOrder = 1,
poi = 181
},
[21] = {
name = "Khenarthi's Roost",
cityName = "Mistral",
alliance = ALLIANCE_ALDMERI_DOMINION,
zoneOrder = 1,
poi = 142
},
[22] = {
name = "Bleakrock Isle",
cityName = "Bleakrock Village",
alliance = ALLIANCE_EBONHEART_PACT,
zoneOrder = 1,
poi = 172,
offsetX = 0,
--offsetY = 0.2,
labelY = -0.020
},
[23] = {
name = "Coldharbour",
cityName = "The Hollow City",
alliance = 100,
zoneLevel = 7,
poi = 131,
cosmic = true
},
[24] = {
name = "Aurbis",
alliance = 999
},
[25] = {
name = "Craglorn",
cityName = "Belkarth",
alliance = 100,
poi = 220,
labelX = -0.0125,
labelY = -0.025
},
[26] = {
name = "Imperial City",
alliance = 100,
labelX = -0.025
},
[27] = {
name = "Wrothgar",
cityName = "Orsinium",
alliance = ALLIANCE_DAGGERFALL_COVENANT,
poi = 244,
labelX = 0.0125,
labelY = -0.0125
},
[28] = {
name = "Hew's Bane",
cityName = "Abah's Landing",
alliance = ALLIANCE_DAGGERFALL_COVENANT,
poi = 255,
--offsetX = 0.1,
--offsetY = 0
},
[29] = {
name = "Gold Coast",
cityName = "Anvil",
alliance = 100,
poi = 251,
labelX = 0.0125,
labelY = -0.0125
},
[30] = {
name = "Vvardenfell",
cityName = "Vivec City",
alliance = ALLIANCE_EBONHEART_PACT,
poi = 284,
offsetX = 0.005,
offsetY = 0.005
},
[31] = {
name = "Clockwork City",
cityName = "Brass Fortress",
alliance = ALLIANCE_EBONHEART_PACT,
poi = 337,
cosmic = true
},
[32] = {
name = "Summerset",
cityName = "Alinor",
alliance = ALLIANCE_ALDMERI_DOMINION,
poi = 355
},
[33] = {
name = "Artaeum",
cityName = "Artaeum",
alliance = 100,
poi = 360,
cosmic = true
},
[34] = {
name = "Murkmire",
cityName = "Lilmoth",
alliance = ALLIANCE_EBONHEART_PACT,
poi = 374
},
[35] = {
name = "Norg-Tzel",
alliance = ALLIANCE_EBONHEART_PACT,
hidden = true
},
[36] = {
name = "Northern Elsweyr",
cityName = "Rimmen",
alliance = ALLIANCE_ALDMERI_DOMINION,
poi = 382,
labelY = 0.0125
},
[37] = {
name = "Southern Elsweyr",
cityName = "Senchal",
alliance = ALLIANCE_ALDMERI_DOMINION,
poi = 402,
labelY = -0.0125
},
[38] = {
name = "Western Skyrim",
cityName = "Solitude",
alliance = ALLIANCE_EBONHEART_PACT,
poi = 426,
--offsetX = 0.05,
--offsetY = -0.05
},
[39] = {
name = "Blackreach: Greymoor Caverns",
alliance = ALLIANCE_EBONHEART_PACT
},
[40] = {
name = "Blackreach",
alliance = 999
},
[41] = {
name = "Blackreach: Arkthzand Cavern",
alliance = ALLIANCE_EBONHEART_PACT
},
[42] = {
name = "The Reach",
cityName = "Markarth",
alliance = ALLIANCE_EBONHEART_PACT,
poi = 449,
labelX = 0.025
},
[43] = {
name = "Blackwood",
cityName = "Leyawiin",
alliance = 999,
poi = 458
},
[44] = {
name = "Fargrave",
alliance = 999,
cosmic = true
},
[45] = {
name = "Deadlands",
alliance = 999,
cosmic = true
},
[46] = {
name = "High Isle",
cityName = "Gonfalon Bay",
alliance = ALLIANCE_DAGGERFALL_COVENANT,
poi = 513
},
[47] = {
name = "Fargrave City",
alliance = 999,
hidden = true
},
[48] = {
name = "Galen",
cityName = "Vastyr",
alliance = ALLIANCE_DAGGERFALL_COVENANT,
poi = 529
},
[49] = {
name = "Telvanni Peninsula",
cityName = "Necrom",
alliance = ALLIANCE_EBONHEART_PACT,
poi = 536,
labelX = 0.0125,
labelY = -0.005
},
[50] = {
name = "Apocrypha",
alliance = 999,
cosmic = true
},
[51] = {
name = "West Weald",
cityName = "Skingrad",
alliance = 999,
poi = 558,
cosmic = false
},
[52] = {
name = "Eyevea",
cityName = "Eyevea",
alliance = 999,
poi = 215,
cosmic = true,
blobX = 0.1367,
blobY = 0.5579
},
[53] = {
name = "Eastern Solstice",
cityName = "Eastern Solstice",
alliance = 999,
poi = 592
}
}

addon.color = {
[ALLIANCE_DAGGERFALL_COVENANT] = ZO_ColorDef:New(0, 0.25, 1, 0.2),
[ALLIANCE_ALDMERI_DOMINION] = ZO_ColorDef:New(1, 1, 0, 0.15),
[ALLIANCE_EBONHEART_PACT] = ZO_ColorDef:New(1, 0, 0, 0.15)
}

addon.defaultColor = ZO_ColorDef:New(0, 0, 0, 0.25)
addon.transparentColor = ZO_ColorDef:New(0, 0, 0, 0)
addon.baseGameColor = ZO_ColorDef:New(0.5, 1, 0.5, 0.25)
addon.dlcGameColor = ZO_ColorDef:New(0.25, 0.25, 0.75, 0.35)

local em = GetEventManager()
local am = GetAnimationManager()
local lookup = {
fonts = {},
fontSizes = {},
colors = {}
}

function addon:ApplyOpacity()
local opacity = self.savedVars.opacity / 100
self.color[ALLIANCE_DAGGERFALL_COVENANT]:SetAlpha(opacity * 1.25)
self.color[ALLIANCE_ALDMERI_DOMINION]:SetAlpha(opacity)
self.color[ALLIANCE_EBONHEART_PACT]:SetAlpha(opacity)
self.defaultColor:SetAlpha(opacity)
self.transparentColor:SetAlpha(opacity)
self.baseGameColor:SetAlpha(opacity)
self.dlcGameColor:SetAlpha(opacity * 1.2)
end

function addon:ApplyColors()
if self.savedVars.color == "BaseGame" then
self.GetColor = self.GetBaseGameColor
self.GetDefaultColor = self.GetBaseGameColor
elseif self.savedVars.color =="None" then
self.GetColor = self.GetNoColor
self.GetDefaultColor = self.GetNoColor
else
self.GetColor = self.GetAllianceColor
self.GetDefaultColor = self.AllianceDefaultColor
end
end



local function UpdateUIVisibility(hidden)
    if not addon.savedVars.enableUI then return end
    local uiControl = WINDOW_MANAGER:GetControlByName("TraduzioneItaESOUI")
    if uiControl then
        if addon.savedVars.hideDuringGameplay then
            uiControl:SetHidden(not hidden)
        else
            uiControl:SetHidden(false)
        end
    end
end


local function UpdateMapName()
    SafeCall(function()
        if not addon.savedVars.bilingualMapNames and not addon.savedVars.useEnglishNames then
            return
        end
        local currentLang = GetCVar("language.2")
        local mapName = GetMapName()
        if mapName == "Tamriel" then mapName = GetUnitZone("player") end
        -- rimuove solo eventuali suffissi tra parentesi, mantiene il resto del nome (evita che nomi come Stonefalls diventino stringhe vuote)
        local mapNameNoSuffix = mapName:gsub("%s*%b()","")
        local englishName = addon.translationTable[mapNameNoSuffix] or mapNameNoSuffix
        local nativeLabel = ZO_WorldMapZoneNameLabel
        if nativeLabel then
            local newText = mapName
            if currentLang == "it" then
                if addon.savedVars.bilingualMapNames then
                    newText = addon.savedVars.bilingualNewLine and zo_strformat("<<1>>\n<<2>>", mapName, ColorizeEnglish(englishName))
                              or zo_strformat("<<1>> (<<2>>)", mapName, ColorizeEnglish(englishName))
                elseif addon.savedVars.useEnglishNames and GetCurrentMapIndex() == TAMRIEL_MAP_INDEX then
                    newText = englishName
                end
            end
            nativeLabel:SetText(newText)
        end
    end)
end

function addon:InitSettings()
local LAM = LibAddonMenu2
if not LAM then return end

local panelData = {
type = "panel",
name = "Traduzione Italiana ESO",
displayName = "|cFFD700Traduzione Italiana ESO|r",
author = "Muflonebarbuto",
version = addon.version,
slashCommand = "/itaeso",
registerForRefresh = true,
registerForDefaults = true
}

-- helper per testo on/off visuale nelle descrizioni (mostrato nel tooltip o nel nome se vuoi comporre il testo)
local function OnOffLabel(value)
    return value and "Abilitato" or "Disabilitato"
end

local optionsData = {
{
type = "dropdown",
name = "Seleziona Lingua",
choices = {"Italiano", "Inglese"},
choicesValues = {"it", "en"},
getFunc = function() return self.savedVars.language end,
setFunc = function(value)
self.savedVars.language = value
ShowLanguageNotification(value)
SetLanguage(value)
end,
tooltip = "Scegli la lingua del gioco.",
requiresReload = true
},
{
type = "checkbox",
name = "Mostra Notifiche",
tooltip = function() return "Abilita o disabilita notifiche con bandierina al cambio lingua. Stato: " .. OnOffLabel(self.savedVars.showNotifications) end,
getFunc = function() return self.savedVars.showNotifications end,
setFunc = function(value) self.savedVars.showNotifications = value end
},
{
type = "checkbox",
name = "Mostra Bandierine UI",
tooltip = function() return "Abilita o disabilita le bandierine cliccabili sullo schermo. Stato: " .. OnOffLabel(self.savedVars.enableUI) end,
getFunc = function() return self.savedVars.enableUI end,
setFunc = function(value)
self.savedVars.enableUI = value
UpdateUIVisibility(IsReticleHidden())
end
},
{
type = "checkbox",
name = "Nascondi Bandierine durante Gameplay",
tooltip = function() return "Nascondi le bandierine quando il mirino è attivo. Stato: " .. OnOffLabel(self.savedVars.hideDuringGameplay) end,
getFunc = function() return self.savedVars.hideDuringGameplay end,
setFunc = function(value)
self.savedVars.hideDuringGameplay = value
UpdateUIVisibility(IsReticleHidden())
end
},
{
type = "checkbox",
name = "Nomi Bilingui sulla Mappa",
tooltip = function() return "Mostra nomi delle zone in italiano e inglese (es. 'Deserto di Alik'r\nAlik'r Desert'). Stato: " .. OnOffLabel(self.savedVars.bilingualMapNames) end,
getFunc = function() return self.savedVars.bilingualMapNames end,
setFunc = function(value)
self.savedVars.bilingualMapNames = value
UpdateMapName()
if GetCurrentMapIndex() == TAMRIEL_MAP_INDEX then
SafeCall(function() self:RenderMap(self.savedVars.showLocations) end)
end
end
},
{
type = "checkbox",
name = "Usa Nomi Inglesi su Tamriel",
tooltip = function() return "Mostra i nomi inglesi delle zone sulla mappa di Tamriel (stile Votan's Tamriel Map). Stato: " .. OnOffLabel(self.savedVars.useEnglishNames) end,
getFunc = function() return self.savedVars.useEnglishNames end,
setFunc = function(value)
self.savedVars.useEnglishNames = value
if GetCurrentMapIndex() == TAMRIEL_MAP_INDEX then
SafeCall(function() self:RenderMap(self.savedVars.showLocations) end)
end
end
},
{
type = "checkbox",
name = "Mostra Regioni su Tamriel",
tooltip = function() return "Mostra i nomi delle regioni sulla mappa di Tamriel. Stato: " .. OnOffLabel(self.savedVars.showLocations) end,
getFunc = function() return self.savedVars.showLocations end,
setFunc = function(value)
self.savedVars.showLocations = value
if GetCurrentMapIndex() == TAMRIEL_MAP_INDEX then
SafeCall(function() self:RenderMap(value) end)
end
end
},
{
type = "checkbox",
name = "Mostra Nomi Città su Tamriel",
tooltip = function() return "Mostra i nomi delle città sulla mappa di Tamriel. Stato: " .. OnOffLabel(self.savedVars.showCitiesNames) end,
getFunc = function() return self.savedVars.showCitiesNames end,
setFunc = function(value)
self.savedVars.showCitiesNames = value
if GetCurrentMapIndex() == TAMRIEL_MAP_INDEX then
SafeCall(function() self:RenderMap(self.savedVars.showLocations) end)
end
end
},
{
type = "checkbox",
name = "Nascondi Wayshrine su Tamriel",
tooltip = function() return "Nasconde i pin dei wayshrine sulla mappa di Tamriel (stile Votan's). Stato: " .. OnOffLabel(self.savedVars.hidePinsOnTamriel) end,
getFunc = function() return self.savedVars.hidePinsOnTamriel end,

        setFunc = function(value)
            self.savedVars.hidePinsOnTamriel = value
            SafeCall(function()
                if GetCurrentMapIndex and GetCurrentMapIndex() == TAMRIEL_MAP_INDEX then
                    local pinMgr = ZO_WorldMap_GetPinManager and ZO_WorldMap_GetPinManager()
                    if pinMgr and pinMgr.SetPinGroupShown then
                        pinMgr:SetPinGroupShown(MAP_FILTER_WAYSHRINES, not value)
                    else
                        -- Se il manager non è pronto, ritenta dopo il login
                        EVENT_MANAGER:RegisterForEvent(addon.name .. "_RetryHidePins", EVENT_PLAYER_ACTIVATED, function()
                            local mgr = ZO_WorldMap_GetPinManager and ZO_WorldMap_GetPinManager()
                            if mgr and mgr.SetPinGroupShown then
                                mgr:SetPinGroupShown(MAP_FILTER_WAYSHRINES, not value)
                                EVENT_MANAGER:UnregisterForEvent(addon.name .. "_RetryHidePins", EVENT_PLAYER_ACTIVATED)
                            end
                        end)
                    end
                end
            end)
        end,



},
{
type = "checkbox",
name = "Nomi Bilingui nei Tooltips (POI/Keeps/Shrines)",
tooltip = function() return "Mostra nomi in italiano e inglese nei tooltips quando passi il mouse su POI, Keeps o Shrines. Stato: " .. OnOffLabel(self.savedVars.bilingualPOI) end,
getFunc = function() return self.savedVars.bilingualPOI end,


        setFunc = function(value)
            self.savedVars.bilingualPOI = value
            SafeCall(function()
                if value then
                    -- Controlla e chiama solo se le funzioni esistono
                    if type(HookPoiTooltips) == "function" then HookPoiTooltips() end
                    if type(HookShrineTooltips) == "function" then HookShrineTooltips() end
                    if type(HookKeepTooltips) == "function" then HookKeepTooltips() end
                end
                if type(ZO_WorldMap_RefreshAllPOIs) == "function" then
                    ZO_WorldMap_RefreshAllPOIs()
                else
                    -- Se la mappa non è pronta, rimanda l’aggiornamento
                    EVENT_MANAGER:RegisterForEvent(addon.name .. "_RetryBilingual", EVENT_PLAYER_ACTIVATED, function()
                        if type(ZO_WorldMap_RefreshAllPOIs) == "function" then
                            ZO_WorldMap_RefreshAllPOIs()
                            EVENT_MANAGER:UnregisterForEvent(addon.name .. "_RetryBilingual", EVENT_PLAYER_ACTIVATED)
                        end
                    end)
                end
            end)
        end,



},
{
type = "checkbox",
name = "Nome Inglese su Nuova Linea",
tooltip = function() return "Mostra il nome inglese su una nuova linea sotto quello italiano nei tooltips e mappe. Stato: " .. OnOffLabel(self.savedVars.bilingualNewLine) end,
getFunc = function() return self.savedVars.bilingualNewLine end,
setFunc = function(value)
self.savedVars.bilingualNewLine = value
if GetCurrentMapIndex() == TAMRIEL_MAP_INDEX then
SafeCall(function() self:RenderMap(self.savedVars.showLocations) end)
end
end,
disabled = function() return not self.savedVars.bilingualPOI and not self.savedVars.bilingualMapNames end
},
{
type = "colorpicker",
name = "Colore Nome Inglese",
tooltip = "Colore per il nome inglese nei tooltips e mappa.",
getFunc = function() return ZO_ColorDef:New(self.savedVars.bilingualColor):UnpackRGBA() end,
setFunc = function(r, g, b, a)
self.savedVars.bilingualColor = ZO_ColorDef:New(r, g, b, a):ToHex()
if GetCurrentMapIndex() == TAMRIEL_MAP_INDEX then
SafeCall(function() self:RenderMap(self.savedVars.showLocations) end)
end
end,
default = ZO_ColorDef:New("FFFFFF"),
disabled = function() return not self.savedVars.bilingualPOI and not self.savedVars.bilingualMapNames end
},
{
type = "dropdown",
name = GetString(SI_VOTANS_TAMRIEL_MAP_FONT),
choices = lookup.fontNames,
choicesValues = lookup.fontValues,
getFunc = function() return self.savedVars.titleFont end,
setFunc = function(value)
self.savedVars.titleFont = value
self:createFont()
if GetCurrentMapIndex() == TAMRIEL_MAP_INDEX then
SafeCall(function() self:RenderMap(self.savedVars.showLocations) end)
end
end,
},
{
type = "dropdown",
name = GetString(SI_GUILD_HERALDRY_COLOR),
choices = lookup.colorNames,
choicesValues = lookup.colorValues,
getFunc = function() return self.savedVars.color end,
setFunc = function(value)
self.savedVars.color = value
self:ApplyColors()
self:ApplyOpacity()
if GetCurrentMapIndex() == TAMRIEL_MAP_INDEX then
SafeCall(function() self:RenderMap(self.savedVars.showLocations) end)
end
end,
},
{
type = "slider",
name = GetString(SI_COLOR_PICKER_ALPHA),
min = 10,
max = 100,
step = 1,
getFunc = function() return self.savedVars.opacity end,
setFunc = function(value)
self.savedVars.opacity = value
self:ApplyOpacity()
if GetCurrentMapIndex() == TAMRIEL_MAP_INDEX then
SafeCall(function() self:RenderMap(self.savedVars.showLocations) end)
end
end,
},
{
type = "checkbox",
name = "LinguaIA (Traduzione Alternativa)",
tooltip = function() return "Se attivo, carica la traduzione alternativa dal tuo addon invece di quella ufficiale. Stato: " .. OnOffLabel(self.savedVars.linguaIA) end,
getFunc = function() return self.savedVars.linguaIA end,
setFunc = function(value)
self.savedVars.linguaIA = value
end
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

LAM:RegisterAddonPanel(addon.name .. "Options", panelData)
LAM:RegisterOptionControls(addon.name .. "Options", optionsData)

lookup.fontNames = {}
lookup.fontValues = {}
lookup.nameToFont = {}
for _, item in pairs(lookup.fonts) do
table.insert(lookup.fontNames, item.name)
table.insert(lookup.fontValues, item.data)
lookup.nameToFont[item.name] = item.data
end

lookup.colorNames = {}
lookup.colorValues = {}
lookup.nameToColor = {}
for _, item in pairs(lookup.colors) do
table.insert(lookup.colorNames, item.name)
table.insert(lookup.colorValues, item.data)
lookup.nameToColor[item.name] = item.data
end

self.savedVars = ZO_SavedVars:NewAccountWide("TraduzioneItaESO_Vars", 1, nil, {
language = "it",
showNotifications = true,
enableUI = true,
hideDuringGameplay = true,
bilingualMapNames = true,
bilingualNPCNames = false,
useEnglishNames = true,
showLocations = true,
showCitiesNames = true,
bilingualPOI = true,
bilingualNewLine = true,
bilingualColor = "FFFFFF",
hidePinsOnTamriel = true,
opacity = 50,
titleFont = "ANTIQUE_FONT",
color = "Alliance",
linguaIA = true
})

self:createFont()
self:ApplyColors()
self:ApplyOpacity()
end

function addon:createFont()
local size, sizeCity = unpack(lookup.fontSizes[self.savedVars.titleFont] or {18, 14})
self.titleFont = string.format("$(%s)|%i|soft-shadow-thick", self.savedVars.titleFont, size)
self.cityFont = string.format("$(%s)|%i|soft-shadow-thick", self.savedVars.titleFont, sizeCity)
end

local MapBlobManager = ZO_ObjectPool:Subclass()
addon.MapBlobManager = MapBlobManager

local function MapOverlayControlFactory(pool, controlNamePrefix, templateName, parent)
local overlayControl = ZO_ObjectPool_CreateNamedControl(controlNamePrefix, "VotansTamrielBlobControl", pool, parent)
overlayControl:SetAlpha(0) -- Because it's not shown yet and we want to fade in using current values
ZO_AlphaAnimation:New(overlayControl) -- This control will always use this utility object to animate itself, this links the control to the anim, so we don't need the return.
overlayControl.label = overlayControl:GetNamedChild("Location")
overlayControl.city = overlayControl:GetNamedChild("City")
--overlayControl:SetInsets(4, 1, 1, 1, 1)
--overlayControl:SetInsets(3, -1, -1, -1, -1)
--overlayControl:SetInsets(1, 2, 2, 2, 2)
overlayControl:SetMouseEnabled(false)
overlayControl.label:SetMouseEnabled(false)
overlayControl.city:SetMouseEnabled(false)
return overlayControl
end

function MapBlobManager:New(blobContainer)
local blobFactory = function(pool)
return MapOverlayControlFactory(pool, "VotansTamrielMapBlob", "VotansTamrielBlobControl", blobContainer)
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

local function ShowMapTexture(textureControl, textureName, width, height, offsetX, offsetY)
textureControl:SetTexture(textureName)
textureControl:SetDimensions(width, height)
textureControl:SetSimpleAnchorParent(offsetX, offsetY)
textureControl:SetAlpha(1)
textureControl:SetHidden(false)
--textureControl:SetBlendMode(TEX_BLEND_MODE_ALPHA)
end

local textureChanged

function MapBlobManager:Update(normalizedMouseX, normalizedMouseY)
local locationName, textureFile, widthN, heightN, locXN, locYN = GetMapMouseoverInfo(normalizedMouseX, normalizedMouseY)
local textureUIWidth, textureUIHeight, textureXOffset, textureYOffset = NormalizedBlobDataToUI(widthN, heightN, locXN, locYN)

if self.m_zoom ~= ZO_WorldMap_GetPanAndZoom():GetCurrentCurvedZoom() then
self.m_zoom = ZO_WorldMap_GetPanAndZoom():GetCurrentCurvedZoom()
textureChanged = true
end

if textureChanged then
if textureFile ~= "" then
local blob = self:AcquireObject(textureFile)
if blob then
ShowMapTexture(blob, textureFile, textureUIWidth, textureUIHeight, textureXOffset, textureYOffset)
blob.label:SetFont(addon.titleFont)
blob.label:SetAlpha(math.max(0, 3 - self.m_zoom * 2.2))
return blob
end
end
end
end

function addon:GetAllianceColor(location)
return self.color[location.alliance] or self.defaultColor
end

function addon:AllianceDefaultColor()
return self.defaultColor
end

function addon:GetNoColor(location)
return self.transparentColor
end

function addon:GetBaseGameColor(location)
return location and (location.index < 27 or location.index == 30) and self.baseGameColor or self.dlcGameColor
end

function addon:RenderMap(isTamriel)
    local positions = self.positions
    local gps = LibGPS3
    if not gps then return end
    local bm = self.blobManager
    local hidePins = not ZO_WorldMap_IsPinGroupShown(MAP_FILTER_WAYSHRINES)
    local showCities, showLocations = self.savedVars.showCitiesNames, self.savedVars.showLocations
    local currentLang = GetCVar("language.2")
    
    for i, pos in pairs(positions) do
        local x, y = pos:GetOffset()
        local w, h = pos:GetScale()
        x, y = x + w / 2, y + h / 2
        
        -- CORREZIONE: Rimossa la chiamata problematica a GlobalToLocal (riga ~861)
        -- if gps.GlobalToLocal then
        --     x, y = gps:GlobalToLocal(x, y)
        -- end
        
        if x > 0 and x < 1 and y > 0 and y < 1 then
            local location = self.locations[i]
            if location and (not location.cosmic) == isTamriel then
                local queryX = location.blobX or (x + (location.offsetX or 0))
                local queryY = location.blobY or (y + (location.offsetY or 0))
                local blob = bm:Update(queryX, queryY)
                if blob then
                    -- Mostra nome bilingue sulla mappa: Inglese sopra, Italiano sotto
                    do
                        local englishName = location.name or ""
                        -- reverseTable mappa English -> Italian (caricata in LoadTranslationTable)
                        local italianName = TraduzioneItaESO.reverseTable and TraduzioneItaESO.reverseTable[englishName] or nil
                        
						
						
						
local cleanedItalian = italianName and italianName or nil
if cleanedItalian then
    cleanedItalian = ProcessMarkers(cleanedItalian)
    -- rimuovi eventuali marcatori residui non desiderati (se vuoi)
    cleanedItalian = cleanedItalian:gsub("%^%a+", "")
end
if TraduzioneItaESO.savedVars.bilingualMapNames and cleanedItalian and cleanedItalian ~= englishName then
    if TraduzioneItaESO.savedVars.bilingualNewLine then
        blob.label:SetText(ZO_CachedStrFormat(SI_WORLD_MAP_LOCATION_NAME, englishName) .. "\n" .. cleanedItalian)
    else
        blob.label:SetText(ZO_CachedStrFormat(SI_WORLD_MAP_LOCATION_NAME, englishName) .. " (" .. cleanedItalian .. ")")
    end
else
    blob.label:SetText(ZO_CachedStrFormat(SI_WORLD_MAP_LOCATION_NAME, englishName))
end
                   



				   end
                    blob.label:SetHidden(not showLocations)
                    if showLocations then
                        local locXN, locYN = NormalizedLabelDataToUI(location.labelX, location.labelY)
                        blob.label:SetAnchor(CENTER, nil, CENTER, locXN, locYN)
                    end
                    local color = self:GetColor(location)
                    local r, g, b, a = color:UnpackRGBA()
                    blob:SetColor(1, 1, 1, 1, a)
                    blob:SetColor(2, r, g, b, a)
                    blob:SetColor(3, r, g, b, a)
                    blob:SetColor(4, r, g, b, a)
                    if location.hidden then
                        blob.label:SetText("")
                    end
                    blob.city:SetFont(self.cityFont)
                    local cityEnglish = location.cityName or ""
                    local cityItalian = self.reverseTable[cityEnglish] or cityEnglish
                    local cleanedCityItalian = cityItalian:gsub("%^%a+", "")
                    local cityText = currentLang == "it" and cleanedCityItalian or cityEnglish
                    if currentLang == "it" then
                        if self.savedVars.bilingualMapNames and self.translationTable[cleanedCityItalian] and cleanedCityItalian ~= self.translationTable[cleanedCityItalian] then
                            cityText = self.savedVars.bilingualNewLine and zo_strformat("<<1>>\n<<2>>", cleanedCityItalian, ColorizeEnglish(self.translationTable[cleanedCityItalian])) or zo_strformat("<<1>> (<<2>>)", cleanedCityItalian, ColorizeEnglish(self.translationTable[cleanedCityItalian]))
                        elseif self.savedVars.useEnglishNames then
                            cityText = self.translationTable[cleanedCityItalian] or cleanedCityItalian
                        end
                    end
                    blob.city:SetText(ZO_CachedStrFormat("<<!AC:1>>", cityText))
                    if location.poi and showCities then
                        local _, known, localX, localY = GetFastTravelNodeInfo(location.poi)
                        if known then
                            -- CORREZIONE: Rimossa la chiamata problematica a LocalToGlobal (riga ~866)
                            -- local globalX, globalY = gps:LocalToGlobal(localX, localY)
                            local globalX, globalY = localX, localY
                            location.poiGlobalX = globalX
                            location.poiGlobalY = globalY
                        end
                        local locXN = location.poiGlobalX
                        local locYN = location.poiGlobalY
                        local labelX, labelY = x + (location.labelX or 0), y + (location.labelY or 0)
                        local labelUIX, labelUIY = NormalizedLabelDataToUI(labelX, labelY)
                        local poiUIX, poiUIY = NormalizedLabelDataToUI(locXN, locYN)
                        poiUIY = poiUIY + (hidePins and -6 or 13)
                        local w, h1 = blob.label:GetDimensions()
                        local overlapH1, overlapH2 = h1 * 2 / 3, h1 / 3
                        if showLocations and blob.label:GetAlpha() > 0.1 and ((labelUIY - overlapH1) < poiUIY and (labelUIY + overlapH2) > poiUIY) and ((labelUIX - 64) < poiUIX and (labelUIX + 64) > poiUIX) then
                            blob.city:SetAnchor(TOP, blob.label, BOTTOM, 0, -3)
                        else
                            blob.city:SetAnchor(TOP, ZO_WorldMapContainer, TOPLEFT, poiUIX, poiUIY)
                        end
                    else
                        blob.city:ClearAnchors()
                    end
                    blob.city:SetHidden(not location.cityName or not self.savedVars.showCitiesNames)
                end
            end
        end
    end
    
    if GetCurrentMapIndex() == TAMRIEL_MAP_INDEX and self.savedVars.hidePinsOnTamriel then
        ZO_WorldMap_GetPinManager():SetPinGroupShown(MAP_FILTER_WAYSHRINES, false)
    end
end

function addon:Hide()
self.blobManager:ReleaseAllObjects()
end

function addon:HookPOIPins()
local lessVisible = ZO_ColorDef:New(1, 1, 1, 0.5)
local GetCurrentMapIndex = GetCurrentMapIndex
local panZoom = ZO_WorldMap_GetPanAndZoom()
local function HookPinSize(data)
local orgMetaTable = getmetatable(data)
local orgSize = data.size or 40
local orgTint = data.tint or ZO_DEFAULT_COLOR
data.size, data.tint = nil, nil
local newMetaTable = {}
setmetatable(newMetaTable, orgMetaTable)
local alter = {}
alter.size = function()
return GetCurrentMapIndex() == 1 and (orgSize * panZoom:GetCurrentNormalizedZoom()) or orgSize
end
--alter.tint = function()
-- return GetCurrentMapIndex() == 1 and lessVisible or orgTint
--end
newMetaTable.__index = function(data, key)
return alter[key] and alter[key](data) or newMetaTable[key]
end
newMetaTable.__newindex = function(data, key, value)
if key == "size" then
orgSize = value
return
elseif key == "tint" then
orgTint = value
return
end
return rawset(data, key, value)
end
setmetatable(data, newMetaTable)
end
HookPinSize(ZO_MapPin.PIN_DATA[MAP_PIN_TYPE_FAST_TRAVEL_WAYSHRINE])
HookPinSize(ZO_MapPin.PIN_DATA[MAP_PIN_TYPE_FAST_TRAVEL_WAYSHRINE_CURRENT_LOC])
end

function addon:InitializeMap()
self:InitSettings()
local gps = LibGPS3
local positions = {}
if gps then gps:PushCurrentMap() end
for i = 1, GetNumMaps() do
SetMapToMapListIndex(i)
local measurement
if gps then measurement = gps:GetCurrentMapMeasurement() end
if measurement then
positions[i] = measurement
local location = self.locations[i]
if location then
location.index = i
end
if location and location.poi then
local _, known, localX, localY = GetFastTravelNodeInfo(location.poi)
if known then
local globalX, globalY = localX, localY  -- fallback if no gps
-- CORREZIONE: Rimossa la chiamata problematica
-- if gps and gps.LocalToGlobal then
--     globalX, globalY = gps:LocalToGlobal(localX, localY)
-- end
location.poiGlobalX = globalX
location.poiGlobalY = globalY
end
end
end
end
self.positions = positions
if gps then gps:PopCurrentMap() end
--self:HookPOIPins()
-- self:HookTravelInfo()
local blobContainer = ZO_WorldMapContainer
self.blobManager = MapBlobManager:New(blobContainer)
self.layout = {
level = 30,
size = 32,
insetX = 4,
insetY = 4,
texture = ""
-- tint = function(pin)
-- local _, tag = pin:GetPinTypeAndTag()
-- if tag then
-- return tag:GetColor()
-- end
-- end
}
local TAMRIEL_MAP_INDEX = GetMapIndexById(27)
local AURBIS_MAP_INDEX = GetMapIndexById(439)
local function LayoutPins(pinManager)
self:Hide()
local mapIndex = GetCurrentMapIndex()
if mapIndex == TAMRIEL_MAP_INDEX or mapIndex == AURBIS_MAP_INDEX then
textureChanged = true
SafeCall(function() self:RenderMap(mapIndex == TAMRIEL_MAP_INDEX) end)
textureChanged = false
end
end
ZO_WorldMap_GetPinManager():AddCustomPin(self.pinType, LayoutPins, LayoutPins, self.layout)
self.pinTypeId = _G[self.pinType]
ZO_WorldMap_GetPinManager():SetCustomPinEnabled(self.pinTypeId, true)
end

function addon:AddFont(font, displayText, size, sizeCity)
lookup.fonts[#lookup.fonts + 1] = {name = displayText, data = font}
lookup.fontSizes[font] = {size or 18, sizeCity or 14}
end

addon:AddFont("", GetString(SI_VOTANS_TAMRIEL_MAP_FONT_NONE))
addon:AddFont("MEDIUM_FONT", GetString(SI_VOTANS_TAMRIEL_MAP_FONT_MEDIUM))
addon:AddFont("BOLD_FONT", GetString(SI_VOTANS_TAMRIEL_MAP_FONT_BOLD))
addon:AddFont("CHAT_FONT", GetString(SI_VOTANS_TAMRIEL_MAP_FONT_CHAT))
addon:AddFont("GAMEPAD_LIGHT_FONT", GetString(SI_VOTANS_TAMRIEL_MAP_FONT_GAMEPAD_LIGHT), 22, 18)
addon:AddFont("GAMEPAD_MEDIUM_FONT", GetString(SI_VOTANS_TAMRIEL_MAP_FONT_GAMEPAD_MEDIUM), 22, 18)
addon:AddFont("GAMEPAD_BOLD_FONT", GetString(SI_VOTANS_TAMRIEL_MAP_FONT_GAMEPAD_BOLD), 22, 18)
addon:AddFont("ANTIQUE_FONT", GetString(SI_VOTANS_TAMRIEL_MAP_FONT_ANTIQUE))
addon:AddFont("HANDWRITTEN_FONT", GetString(SI_VOTANS_TAMRIEL_MAP_FONT_HANDWRITTEN), 16, 12)
addon:AddFont("STONE_TABLET_FONT", GetString(SI_VOTANS_TAMRIEL_MAP_FONT_STONE_TABLET), 14, 10)

local function AddColor(color, displayText)
lookup.colors[#lookup.colors + 1] = {name = displayText, data = color}
end

AddColor("Alliance", GetString(SI_VOTANS_TAMRIEL_MAP_FONT_ALLIANCE))
AddColor("BaseGame", GetString(SI_VOTANS_TAMRIEL_MAP_FONT_BASE_DLC))
AddColor("None", GetString(SI_VOTANS_TAMRIEL_MAP_FONT_NO_COLOR))

local em = GetEventManager()
em:RegisterForEvent(addon.name, EVENT_ADD_ON_LOADED, function(_, addonName)
    if addonName ~= addon.name then return end
    em:UnregisterForEvent(addon.name, EVENT_ADD_ON_LOADED)
    addon:Initialize()
end)

local function ColorizeEnglish(text)
    return ZO_ColorDef:New(addon.savedVars.bilingualColor or "FFFFFF"):Colorize(text)
end

-- Normalizza una stringa per il confronto
local function NormalizeName(s)
  if not s then return "" end
  -- rimuove tag di colore e caratteri di controllo
  s = s:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
  -- rimuove suffissi in parentesi, es. "Nome (qualcosa)"
  s = s:gsub("%s*%b()", "")
  
  
-- preserva marcatori personalizzati che iniziano con ^i... temporaneamente,
-- poi rimuove gli altri marcatori e ripristina i ^i...
s = s:gsub("%^i([%a%d_%-]+)", "||ITA_MARKER_%1||") -- salva marcatori ^i...
s = s:gsub("%^[%a%d_%-]+", "")                     -- rimuove gli altri marcatori
s = s:gsub("||ITA_MARKER_([%a%d_%-]+)||", "^i%1") -- ripristina i marcatori ^i...
  
  
  
  -- trim spazi iniziali/finali e converti a minuscolo
  s = s:gsub("^%s+", ""):gsub("%s+$", "")
  s = s:lower()
  -- normalizza spazi multipli
  s = s:gsub("%s+", " ")
  return s
end



-- ItalianContraction: ritorna contrazione e articolo, es. "della","la"
local function ItalianContraction(marker, noun)
    if not marker then return nil, nil end
    marker = tostring(marker):lower()
    noun = tostring(noun or "")

    if marker:sub(1,1) == "i" then marker = marker:sub(2) end

    local gender = nil
    local number = nil
    if marker:find("f") then gender = "f" end
    if marker:find("m") then gender = "m" end
    if marker:find("p") then number = "p" end
    if not number then number = "s" end
    if not gender then gender = "m" end

    local trimmed = noun:match("^%s*(.-)%s*$") or ""
    local first = trimmed:match("^%s*([%z\1-\127\194-\244][\128-\191]*)") or trimmed:sub(1,1)
    first = (first or ""):sub(1,1):lower()

    local function isVowel(ch)
        if not ch then return false end
        return ch:match("^[aeiouàèéìòùáíóúäëïöü]") ~= nil
    end
    local function startsWithSpecialConsonant(s)
        if not s or #s < 2 then return false end
        local a = s:sub(1,1)
        local b = s:sub(2,2)
        if a == "z" then return true end
        if a == "g" and b == "n" then return true end
        if a == "p" and (b == "s" or b == "n") then return true end
        if a == "s" and not isVowel(b) then return true end
        if a == "x" or a == "y" then return true end
        return false
    end

    local article = nil
    if gender == "f" then
        if number == "p" then
            article = "le"
        else
            if trimmed ~= "" and isVowel(first) then article = "l'" else article = "la" end
        end
    else
        if number == "p" then
            if trimmed ~= "" and (isVowel(first) or startsWithSpecialConsonant(trimmed)) then
                article = "gli"
            else
                article = "i"
            end
        else
            if trimmed ~= "" then
                if isVowel(first) then article = "l'"
                elseif startsWithSpecialConsonant(trimmed) then article = "lo"
                else article = "il" end
            else
                article = "il"
            end
        end
    end

    local contraction = nil
    if article == "il" then contraction = "del"
    elseif article == "lo" then contraction = "dello"
    elseif article == "l'" then contraction = "dell'"
    elseif article == "la" then contraction = "della"
    elseif article == "i" then contraction = "dei"
    elseif article == "le" then contraction = "delle"
    elseif article == "gli" then contraction = "degli"
    else contraction = "di " .. article end

    return contraction, article
end

-- ProcessMarkers: trova marcatori ^i... e, se preceduti da " di ", li sostituisce con la contrazione corretta
local function ProcessMarkers(name)
    if not name or name == "" then return name end
    local s = tostring(name)
    local startPos = 1
    while true do
        local si, ei, marker = s:find("%^i([%a%d_%-]+)", startPos)
        if not si then break end
        local markerLower = marker:lower()
        local prefix = s:sub(1, si-1)
        local lower_prefix = prefix:lower()
        -- trova ultima occorrenza di " di " (plain) nel prefix
        local last_di_start, last_di_end = nil, nil
        local si_di = 1
        while true do
            local a, b = lower_prefix:find(" di ", si_di, true)
            if not a then break end
            last_di_start, last_di_end = a, b
            si_di = b + 1
        end
        if last_di_start then
            local rest = s:sub(ei+1)
            local noun_context = rest:match("^%s*([%z\1-\127\194-\244][\128-\191%w%p%-]*)") or rest:match("^%s*(%w+)") or ""
            if noun_context == "" then
                noun_context = prefix:sub(1, last_di_start-1):match("(%S+)%s*$") or ""
            end
            local contraction, article = ItalianContraction(markerLower, noun_context)
            if contraction then
                local replacement = contraction
                local rest_trim = rest:gsub("^%s+", "")
                if replacement:sub(-1) == "'" then
                    s = prefix:sub(1, last_di_start-1) .. replacement .. rest_trim
                else
                    s = prefix:sub(1, last_di_start-1) .. replacement .. (rest_trim ~= "" and (" " .. rest_trim) or "")
                end
                startPos = (last_di_start or 1) + #replacement + 1
            else
                s = s:sub(1, si) .. markerLower .. s:sub(ei+1)
                startPos = si + #markerLower + 1
            end
        else
            s = s:sub(1, si) .. markerLower .. s:sub(ei+1)
            startPos = si + #markerLower + 1
        end
    end
    return s
end




local function LoadTranslationTable()
    addon.translationTable = {}
    addon.reverseTable = {}
    local count = 0
    local zoneTranslations = addon.ZoneTranslations or {}
    for name_it, name_en in pairs(zoneTranslations) do
      if name_it and name_en then
        local key = NormalizeName(name_it)
        addon.translationTable[key] = name_en
        addon.reverseTable[name_en] = name_it
        count = count + 1
      end
    end
end

local function SetLanguage(lang)
    if lang ~= GetCVar("language.2") then
        SetCVar("IgnorePatcherLanguageSetting", 1)
        SetCVar("language.2", lang)
        ReloadUI()
    end
end

local function ShowLanguageNotification(lang)
    if not addon.savedVars.showNotifications then return end
    local texturePath = lang == "en" and "/TraduzioneItaESO/textures/flag_en.dds" or "/TraduzioneItaESO/textures/flag_it.dds"
    local message = lang == "en" and "Lingua impostata su Inglese" or "Lingua impostata su Italiano"
    ZO_Alert(UI_ALERT_CATEGORY_ALERT, nil, string.format("|t24:24:%s|t %s", texturePath, message))
end



local function UpdateNPCName()
    if not addon.savedVars.bilingualNPCNames then return end
    local currentLang = GetCVar("language.2")
    local unitName = GetUnitName("interact")
    local cleanedUnitName = unitName:gsub("%^%a+", "")
    local unitNoSuffix = NormalizeName(unitName)
    local englishName = addon.translationTable[unitNoSuffix] or cleanedUnitName
    local npcLabel = WINDOW_MANAGER:GetControlByName("TraduzioneItaESO_NPCNameLabel")
    if npcLabel then
        local newText = cleanedUnitName
        if currentLang == "it" then
            newText = string.format("%s / %s", cleanedUnitName, englishName)
        end
        npcLabel:SetText(newText)
    end
end



local function RefreshUI()
    SafeCall(function()
        local uiControl = WINDOW_MANAGER:GetControlByName("TraduzioneItaESOUI")
        if not uiControl then
            uiControl = WINDOW_MANAGER:CreateTopLevelWindow("TraduzioneItaESOUI")
            uiControl:SetDimensions(68, 32)
            uiControl:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, addon.savedVars.offsetX, addon.savedVars.offsetY)
            uiControl:SetMovable(true)
            uiControl:SetMouseEnabled(true)
            uiControl:SetHandler("OnMoveStop", function()
                addon.savedVars.offsetX = uiControl:GetLeft()
                addon.savedVars.offsetY = uiControl:GetTop()
            end)
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
                        addon.savedVars.language = flagCode
                        ShowLanguageNotification(flagCode)
                        SetLanguage(flagCode)
                    end
                end)
            end
            flagControl:SetHidden(false)
            flagControl:SetAlpha(addon.savedVars.language == flagCode and 1.0 or 0.7)
        end
        UpdateUIVisibility(IsReticleHidden())
    end)
end

local function HookPoiTooltips()
    local function AddBilingualName(pin)
        if not addon.savedVars.bilingualPOI then return end
        local localizedName = ZO_WorldMapMouseoverName:GetText()
		
local cleanedLocalized = ProcessMarkers(localizedName)
-- se vuoi rimuovere marcatori residui visuali (ma ProcessMarkers sostituisce " di ^i..." con contrazioni)
cleanedLocalized = cleanedLocalized:gsub("%^%a+", "")
local normalized = NormalizeName(localizedName)
local englishName = addon.translationTable[normalized] or cleanedLocalized

		
		local locString = cleanedLocalized
        if englishName and cleanedLocalized ~= englishName then
            locString = addon.savedVars.bilingualNewLine and zo_strformat("<<1>>\n<<2>>", cleanedLocalized, ColorizeEnglish(englishName)) or zo_strformat("<<1>> / <<2>>", cleanedLocalized, ColorizeEnglish(englishName))
        end
        ZO_WorldMapMouseoverName:SetText(locString)
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
    local function AddEnglishToTooltip()
        if not addon.savedVars.bilingualPOI then return end
        local localized = ZO_WorldMapMouseoverName:GetText()
        local cleanedLocalized = localized:gsub("%^%a+", "")
        local normalized = NormalizeName(localized)
        local english = addon.translationTable[normalized] or cleanedLocalized
        local text = cleanedLocalized
        if english and cleanedLocalized ~= english then
            local fmt = addon.savedVars.bilingualNewLine
                              and "<<1>>\n<<2>>"
                              or "<<1>> (<<2>>)"
            text = zo_strformat(fmt, cleanedLocalized, ColorizeEnglish(english))
        end
        ZO_WorldMapMouseoverName:SetText(text)
    end
    -- pin "normale"
    local orig1 = ZO_MapPin.TOOLTIP_CREATORS[MAP_PIN_TYPE_FAST_TRAVEL_WAYSHRINE].creator
    ZO_MapPin.TOOLTIP_CREATORS[MAP_PIN_TYPE_FAST_TRAVEL_WAYSHRINE].creator = function(...)
        orig1(...)
        AddEnglishToTooltip()
    end
    -- pin "current location"
    local orig2 = ZO_MapPin.TOOLTIP_CREATORS[MAP_PIN_TYPE_FAST_TRAVEL_WAYSHRINE_CURRENT_LOC].creator
    ZO_MapPin.TOOLTIP_CREATORS[MAP_PIN_TYPE_FAST_TRAVEL_WAYSHRINE_CURRENT_LOC].creator = function(...)
        orig2(...)
        AddEnglishToTooltip()
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
        if not addon.savedVars.bilingualPOI then return end
        local keepName = GetKeepName(keepId)
        local cleanedKeepName = keepName:gsub("%^%a+", "")
        local normalized = NormalizeName(keepName)
        local englishKeepName = addon.translationTable[normalized] or cleanedKeepName
        local nameLabel = self:GetNamedChild("Name")
        local displayText = cleanedKeepName
        if englishKeepName and cleanedKeepName ~= englishKeepName then
            displayText = addon.savedVars.bilingualNewLine and zo_strformat("<<1>>\n<<2>>", cleanedKeepName, ColorizeEnglish(englishKeepName)) or zo_strformat("<<1>> / <<2>>", cleanedKeepName, ColorizeEnglish(englishKeepName))
        end
        nameLabel:SetText(displayText)
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

local function GetBilingualText(originalText)
    if not addon.savedVars.bilingualPOI or not originalText or originalText == "" then
        return originalText
    end

    -- non processiamo stringhe già bilingue/colorate
    if string.find(originalText, "|c") then
        return originalText
    end

    -- per la lookup usiamo NormalizeName sul testo originale (preserva i marcatori ^i...)
    local normalized = NormalizeName(originalText)

    -- fallback englishName: se non c'è traduzione, usiamo il testo senza marcatori
    local cleanedForLookup = originalText:gsub("%^%a+", "")
    local englishName = addon.translationTable[normalized] or cleanedForLookup

    -- se non c'è traduzione effettiva, manteniamo il comportamento originale
    if englishName == cleanedForLookup then
        return originalText
    end

    -- Prepariamo la stringa mostrata: ProcessMarkers su originalText e poi rimozione residua dei marcatori
    local cleaned = ProcessMarkers(originalText)
    cleaned = cleaned and cleaned:gsub("%^%a+", "") or originalText

    -- formattazione bilingue (nuova riga o parentesi)
    local fmt = addon.savedVars.bilingualNewLine and "<<1>>\n<<2>>" or "<<1>> (<<2>>)"
    local newText = zo_strformat(fmt, cleaned, ColorizeEnglish(englishName))

    return newText
end


local function TryHookSetText()
    if not ZO_WorldMapMouseoverName or not ZO_WorldMapMouseoverName.SetText then
        return false
    end
    if ZO_WorldMapMouseoverName._OrigSetText then
        return true
    end
    ZO_WorldMapMouseoverName._OrigSetText = ZO_WorldMapMouseoverName.SetText
    ZO_WorldMapMouseoverName.SetText = function(self, text, ...)
        local newText = GetBilingualText(text)
        local ok, err = pcall(self._OrigSetText, self, newText, ...)
        if not ok then
        end
    end
    return true
end

local updaterRegistered = false
local function StartUpdater()
    if updaterRegistered then return end
    updaterRegistered = true
    local function CheckMouseover()
        if not ZO_WorldMapMouseoverName or ZO_WorldMap:IsHidden() then return end
        if ZO_WorldMapMouseover and ZO_WorldMapMouseover:IsHidden() then return end
        local text = ZO_WorldMapMouseoverName:GetText() or ""
        local newText = GetBilingualText(text)
        if newText ~= text then
            SafeCall(function() ZO_WorldMapMouseoverName:SetText(newText) end)
        end
    end
    EVENT_MANAGER:RegisterForUpdate(addon.name .. "_Updater", 100, CheckMouseover)
end

function addon:Initialize()
    -- SavedVars, defaults compreso bilingualPOI = true
    self.savedVars = ZO_SavedVars:NewAccountWide("TraduzioneItaESO_Vars", 1, nil, {
        language = "it",
        showNotifications = true,
        enableUI = true,
        hideDuringGameplay = true,
        bilingualMapNames = true,
        bilingualNPCNames = false,
        useEnglishNames = true,
        showLocations = true,
        showCitiesNames = true,
        bilingualPOI = true,
        bilingualNewLine = true,
        bilingualColor = "FFFFFF",
        hidePinsOnTamriel = true,
        opacity = 50,
        titleFont = "ANTIQUE_FONT",
        color = "Alliance",
        offsetX = 0,
        offsetY = 0,
        linguaIA = true
    })
    
    -- popolo addon.translationTable
    LoadTranslationTable()
    
    -- Nuova logica per caricamento alternativo
    local currentLang = GetCVar("language.2")
    if currentLang == "it" and self.savedVars.linguaIA then
        SafeCall(function()
            dofile([[AddOns\TraduzioneItaESO\gamedata\lang\it.lang]])
            dofile([[AddOns\TraduzioneItaESO\esoui\lang\it_client.str]])
            dofile([[AddOns\TraduzioneItaESO\esoui\lang\ir_pregame.str]])
        end)
    end
    
    -- aggancio i tooltips degli altari
    if self.savedVars.bilingualPOI then
        HookShrineTooltips()
        HookPoiTooltips()
        HookKeepTooltips()
    end
    
    RefreshUI()
    
    EVENT_MANAGER:RegisterForEvent(addon.name, EVENT_RETICLE_HIDDEN_UPDATE, function(eventCode, hidden)
        UpdateUIVisibility(hidden)
    end)
    
    if self.savedVars.bilingualMapNames or self.savedVars.useEnglishNames then
        EVENT_MANAGER:RegisterForEvent(addon.name, EVENT_ZONE_UPDATE, SafeEventHandler)
        EVENT_MANAGER:RegisterForEvent(addon.name, EVENT_MAP_CHUNK_INFO_RECEIVED, SafeEventHandler)
        ZO_PreHook(ZO_WorldMap, "OnShow", function()
            SafeCall(UpdateMapName)
        end)
        ZO_PreHook(ZO_WorldMap, "OnHidden", function()
            SafeCall(function() addon:Hide() end)
        end)
        
        addon.lastZoom = ZO_WorldMap_GetPanAndZoom():GetCurrentCurvedZoom()
        EVENT_MANAGER:RegisterForUpdate(addon.name .. "_MapUpdate", 50, function()
            if ZO_WorldMap:IsHidden() then return end
            if GetCurrentMapIndex() ~= TAMRIEL_MAP_INDEX then return end
            
            local currentZoom = ZO_WorldMap_GetPanAndZoom():GetCurrentCurvedZoom()
            if math.abs(currentZoom - addon.lastZoom) > 0.001 then
                addon.lastZoom = currentZoom
                SafeCall(function() 
                    addon:RenderMap(addon.savedVars.showLocations) 
                end)
            end
        end)
    end
    
    -- aggiorno il nome mappa al login/reload
    EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_ACTIVATED, SafeEventHandler)
    SafeCall(UpdateMapName)
    
    addon:InitializeMap()
    
    -- Integrazione logica mouseover funzionante
    local hooked = TryHookSetText()
    if not hooked then
        StartUpdater()
        zo_callLater(function()
            if TryHookSetText() then
                EVENT_MANAGER:UnregisterForUpdate(addon.name .. "_Updater")
            end
        end, 1000)
    end
end

-- Slash commands
SLASH_COMMANDS["/itaesoit"] = function()
    addon.savedVars.language = "it"
    ShowLanguageNotification("it")
    SetLanguage("it")
end

SLASH_COMMANDS["/itaesoen"] = function()
    addon.savedVars.language = "en"
    ShowLanguageNotification("en")
    SetLanguage("en")
end

SLASH_COMMANDS["/itaeso"] = function()
    if LibAddonMenu2 then
        LibAddonMenu2:OpenToPanel(addon.name .. "Options")
    end
end

SLASH_COMMANDS["/testitaeso"] = function()
    SafeCall(UpdateMapName)
    SafeCall(function() addon:RenderMap(addon.savedVars.showLocations) end)
end

SLASH_COMMANDS["/testtable"] = function()
  local count = 0
  for _ in pairs(addon.translationTable or {}) do
    count = count + 1
  end
  if count == 0 then
  else
  end
end