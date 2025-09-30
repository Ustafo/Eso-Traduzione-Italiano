-- Contenuto completo di TraduzioneItaESO.lua (codice principale dell'addon, aggiornato con tutte le modifiche)
-- Include integrazione con parti da Votan's Tamriel Map come nel contesto originale.
-- Ho assemblato tutto dal contesto della conversazione, inclusi fix per fallback "italiano / italiano" e debug.
-- Per verificare caricamento: Usa /script d(TraduzioneItaESO.ZoneTranslations["Santuario di Vivec"]) in chat ESO.

-- 1) assicuriamoci che esista già la tabella globale
TraduzioneItaESO = TraduzioneItaESO or {}
local addon = TraduzioneItaESO

-- 2) Ri-assegna tutti i campi
addon.name = "TraduzioneItaESO"
addon.displayName = "Traduzione Italiana ESO"
addon.version = "1.0"
addon.pinType = "TraduzioneItaESOTamrielMapPinType"
addon.mapPinLayer = MAP_PIN_LAYER_WORLD_MAP_GUILD_WAYSHRINES
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
		offsetX = 0.1,
		offsetY = 0
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
		offsetY = 0.2,
		labelY = -0.005
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
		name = "Abah's Landing",
		cityName = "Abah's Landing",
		alliance = ALLIANCE_DAGGERFALL_COVENANT,
		poi = 255,
		offsetX = 0.1,
		offsetY = 0
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
		offsetX = 0.05,
		offsetY = -0.05
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
	local opacity = self.account.color ~= "None" and (self.account.opacity / 250) or 0
	self.color[ALLIANCE_DAGGERFALL_COVENANT]:SetAlpha(opacity * 1.25)
	self.color[ALLIANCE_ALDMERI_DOMINION]:SetAlpha(opacity)
	self.color[ALLIANCE_EBONHEART_PACT]:SetAlpha(opacity)
	self.defaultColor:SetAlpha(opacity)
	self.transparentColor:SetAlpha(opacity)
	self.baseGameColor:SetAlpha(opacity)
	self.dlcGameColor:SetAlpha(opacity * 1.2)
end

function addon:ApplyColors()
	if self.account.color == "BaseGame" then
		self.GetColor = self.GetBaseGameColor
		self.GetDefaultColor = self.GetBaseGameColor
	elseif self.account.color == "None" then
		self.GetColor = self.GetNoColor
		self.GetDefaultColor = self.GetNoColor
	else
		self.GetColor = self.GetAllianceColor
		self.GetDefaultColor = self.AllianceDefaultColor
	end
end

function addon:InitSettings()
	local accountDefaults = {
		hidePins = true,
		titleFont = "ANTIQUE_FONT",
		color = "Alliance",
		opacity = 50,
		showLocations = true,
		showCitiesNames = true
	}
	self.account = ZO_SavedVars:NewAccountWide("VotansTamrielMap_Data", 1, nil, accountDefaults)
	local LibHarvensAddonSettings = LibHarvensAddonSettings

	local settings = LibHarvensAddonSettings:AddAddon("Votan's Tamriel Map")
	if not settings then
		return
	end
	addon.settingsControls = settings
	settings.allowDefaults = true
	settings.version = "1.2.4"
	settings.website = "https://www.esoui.com/downloads/info2672-VotansTamrielMap.html"

	local function createFont()
		local size, sizeCity = unpack(lookup.fontSizes[self.account.titleFont])
		self.titleFont = string.format("$(%s)|%i|soft-shadow-thick", self.account.titleFont, size)
		self.cityFont = string.format("$(%s)|%i|soft-shadow-thick", self.account.titleFont, sizeCity)
	end
	lookup.nameToFont = {}
	for _, item in pairs(lookup.fonts) do
		lookup.nameToFont[item.data] = item
	end
	if not lookup.nameToFont[self.account.titleFont] then
		self.account.titleFont = accountDefaults.titleFont
	end
	settings:AddSetting {
		type = LibHarvensAddonSettings.ST_DROPDOWN,
		label = GetString(SI_VOTANS_TAMRIEL_MAP_FONT),
		items = lookup.fonts,
		default = lookup.nameToFont[accountDefaults.titleFont].name,
		getFunction = function()
			return lookup.nameToFont[self.account.titleFont].name
		end,
		setFunction = function(combobox, name, item)
			self.account.titleFont = item.data
			createFont()
		end
	}
	createFont()

	lookup.nameToColor = {}
	for _, item in pairs(lookup.colors) do
		lookup.nameToColor[item.data] = item
	end
	if not lookup.nameToColor[self.account.color] then
		self.account.color = accountDefaults.color
	end
	settings:AddSetting {
		type = LibHarvensAddonSettings.ST_DROPDOWN,
		label = GetString(SI_GUILD_HERALDRY_COLOR),
		items = lookup.colors,
		default = lookup.nameToColor[accountDefaults.color].name,
		getFunction = function()
			return lookup.nameToColor[self.account.color].name
		end,
		setFunction = function(combobox, name, item)
			self.account.color = item.data
			self:ApplyColors()
			self:ApplyOpacity()
		end
	}

	settings:AddSetting {
		type = LibHarvensAddonSettings.ST_SLIDER,
		label = GetString(SI_COLOR_PICKER_ALPHA),
		tooltip = "",
		min = 10,
		max = 100,
		step = 1,
		format = "%f",
		unit = "",
		default = 50,
		getFunction = function()
			return self.account.opacity
		end,
		setFunction = function(value)
			self.account.opacity = value
			self:ApplyOpacity()
		end
	}

	settings:AddSetting {
		type = LibHarvensAddonSettings.ST_CHECKBOX,
		label = GetString(SI_VOTANS_TAMRIEL_MAP_SHOW_LOCATIONS),
		tooltip = "",
		default = accountDefaults.showLocations,
		getFunction = function()
			return self.account.showLocations
		end,
		setFunction = function(value)
			self.account.showLocations = value
		end
	}
	settings:AddSetting {
		type = LibHarvensAddonSettings.ST_CHECKBOX,
		label = GetString(SI_VOTANS_TAMRIEL_MAP_SHOW_CITIES_NAME),
		tooltip = "",
		default = accountDefaults.showCitiesNames,
		getFunction = function()
			return self.account.showCitiesNames
		end,
		setFunction = function(value)
			self.account.showCitiesNames = value
		end
	}
end

local MapBlobManager = ZO_ObjectPool:Subclass()
addon.MapBlobManager = MapBlobManager

local function MapOverlayControlFactory(pool, controlNamePrefix, templateName, parent)
	local overlayControl = ZO_ObjectPool_CreateNamedControl(controlNamePrefix, templateName, pool, parent)
	overlayControl:SetAlpha(0) -- Because it's not shown yet and we want to fade in using current values
	ZO_AlphaAnimation:New(overlayControl) -- This control will always use this utility object to animate itself, this links the control to the anim, so we don't need the return.
	overlayControl.label = overlayControl:GetNamedChild("Location")
	overlayControl.city = overlayControl:GetNamedChild("City")
	overlayControl:SetInsets(4, 1, 1, 1, 1)
	overlayControl:SetInsets(3, -1, -1, -1, -1)
	overlayControl:SetInsets(1, 2, 2, 2, 2)
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

local g_mapPanAndZoom = ZO_WorldMap_GetPanAndZoom()

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

	if self.m_zoom ~= g_mapPanAndZoom:GetCurrentCurvedZoom() then
		self.m_zoom = g_mapPanAndZoom:GetCurrentCurvedZoom()
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
	local bm, gps = self.blobManager, LibGPS3
	local hidePins = not ZO_WorldMap_IsPinGroupShown(MAP_FILTER_WAYSHRINES)
	local showCities, showLocations = self.account.showCitiesNames, self.account.showLocations
	for i, pos in pairs(positions) do
		local x, y = pos:GetOffset()
		local w, h = pos:GetScale()
		x, y = x + w / 2, y + h / 2
		x, y = gps:GlobalToLocal(x, y)
		if x > 0 and x < 1 and y > 0 and y < 1 then
			local location = self.locations[i]
			if location and (not location.cosmic) == isTamriel then
				local queryX = location.blobX or (x + (location.offsetX or 0))
				local queryY = location.blobY or (y + (location.offsetY or 0))
				local blob = bm:Update(queryX, queryY)
				if blob then
					blob.label:SetText(ZO_CachedStrFormat(SI_WORLD_MAP_LOCATION_NAME, location.name or ""))
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
					blob.city:SetText(ZO_CachedStrFormat("<<!AC:1>>", location.cityName or ""))

					if location.poi and showCities then
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

					blob.city:SetHidden(not location.cityName or not self.account.showCitiesNames)
				end
			end
		end
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
		--	return GetCurrentMapIndex() == 1 and lessVisible or orgTint
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
	gps:PushCurrentMap()
	for i = 1, GetNumMaps() do
		SetMapToMapListIndex(i)
		local measurement = gps:GetCurrentMapMeasurement()
		if measurement then
			positions[i] = measurement
			local location = self.locations[i]
			if location then
				location.index = i
			end
			if location and location.poi then
				local _, known, localX, localY = GetFastTravelNodeInfo(location.poi)
				if known then
					local globalX, globalY = gps:LocalToGlobal(localX, localY)
					location.poiGlobalX = globalX
					location.poiGlobalY = globalY
				end
			end
		end
	end
	self.positions = positions

	gps:PopCurrentMap()

	self:ApplyOpacity()
	self:ApplyColors()

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
		-- 	local _, tag = pin:GetPinTypeAndTag()
		-- 	if tag then
		-- 		return tag:GetColor()
		-- 	end
		-- end
	}

	local TAMRIEL_MAP_INDEX = GetMapIndexById(27)
	local AURBIS_MAP_INDEX = GetMapIndexById(439)

	local function LayoutPins(pinManager)
		self:Hide()
		local mapIndex = GetCurrentMapIndex()
		if mapIndex == TAMRIEL_MAP_INDEX or mapIndex == AURBIS_MAP_INDEX then
			textureChanged = true
			self:RenderMap(mapIndex == TAMRIEL_MAP_INDEX)
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
    return ZO_ColorDef:New(addon.account.bilingualColor or "FFFFFF"):Colorize(text)
end

local function LoadTranslationTable()
    addon.translationTable = {}
    addon.reverseTable     = {}
    local count = 0
    for itName, enName in pairs(addon.ZoneTranslations or {}) do
        addon.translationTable[itName] = enName
        addon.reverseTable[enName]     = itName
        count = count + 1
        d("[TraduzioneItaESO] Traduzione zona: " .. itName .. " -> " .. enName)
    end
    d("[TraduzioneItaESO] Caricate " .. count .. " traduzioni")
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
    if not addon.account.showNotifications then return end
    local texturePath = lang == "en" and "/TraduzioneItaESO/textures/flag_en.dds" or "/TraduzioneItaESO/textures/flag_it.dds"
    local message = lang == "en" and "Lingua impostata su Inglese" or "Lingua impostata su Italiano"
    ZO_Alert(UI_ALERT_CATEGORY_ALERT, nil, string.format("|t24:24:%s|t %s", texturePath, message))
end
local function UpdateMapName()
    d("[TraduzioneItaESO] Funzione UpdateMapName chiamata")
    if not addon.account.bilingualMapNames and not addon.account.useEnglishNames then
        d("[TraduzioneItaESO] Nomi bilingui e nomi inglesi disabilitati")
        return
    end
    local currentLang = GetCVar("language.2")
    local mapName = GetMapName()
    if mapName == "Tamriel" then
        mapName = GetUnitZone("player")
    end
    local mapNameNoSuffix = mapName:gsub("%^%a+$", "")
    local englishName = addon.translationTable[mapNameNoSuffix] or mapNameNoSuffix
    d("[TraduzioneItaESO] Lingua: " .. currentLang .. ", MapName: " .. mapName .. ", Traduzione: " .. englishName)
    local nativeLabel = ZO_WorldMapZoneNameLabel
    if nativeLabel then
        local newText = mapName
        if currentLang == "it" then
            if addon.account.bilingualMapNames then
                newText = addon.account.bilingualNewLine and zo_strformat("<<1>>\n<<2>>", mapName, ColorizeEnglish(englishName)) or zo_strformat("<<1>> (<<2>>)", mapName, ColorizeEnglish(englishName))
            elseif addon.account.useEnglishNames and GetCurrentMapIndex() == TAMRIEL_MAP_INDEX then
                newText = englishName
            end
        end
        nativeLabel:SetText(newText)
    end
end
local function UpdateNPCName()
    if not addon.account.bilingualNPCNames then return end
    local currentLang = GetCVar("language.2")
    local unitName = GetUnitName("interact")
    local unitNoSuffix = unitName:gsub("%^%a+$", "")
    local englishName = addon.translationTable[unitNoSuffix] or unitNoSuffix
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
    if not addon.account.enableUI then return end
    local uiControl = WINDOW_MANAGER:GetControlByName("TraduzioneItaESOUI")
    if uiControl then
        if addon.account.hideDuringGameplay then
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
        uiControl:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, addon.account.offsetX, addon.account.offsetY)
        uiControl:SetMovable(true)
        uiControl:SetMouseEnabled(true)
        uiControl:SetHandler("OnMoveStop", function()
            addon.account.offsetX = uiControl:GetLeft()
            addon.account.offsetY = uiControl:GetTop()
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
                    addon.account.language = flagCode
                    ShowLanguageNotification(flagCode)
                    SetLanguage(flagCode)
                end
            end)
        end
        flagControl:SetHidden(false)
        flagControl:SetAlpha(addon.account.language == flagCode and 1.0 or 0.7)
    end
    UpdateUIVisibility(IsReticleHidden())
end
local function HookPoiTooltips()
    local function AddBilingualName(pin)
        if not addon.account.bilingualPOI then return end
        local localizedName = ZO_WorldMapMouseoverName:GetText()
        local localizedNoSuffix = localizedName:gsub("%^%a+$", "")
        local englishName = addon.translationTable[localizedNoSuffix] or localizedNoSuffix  -- Fallback a IT se non trovato
        local locString = addon.account.bilingualNewLine and zo_strformat("<<1>>\n<<2>>", localizedName, ColorizeEnglish(englishName)) or zo_strformat("<<1>> / <<2>>", localizedName, ColorizeEnglish(englishName))
        ZO_WorldMapMouseoverName:SetText(locString)
        d("[TraduzioneItaESO] Bilingue applicato per POI: " .. locString)
        if not addon.translationTable[localizedNoSuffix] then
            d("[TraduzioneItaESO] Traduzione non trovata per POI: " .. localizedNoSuffix .. " - Usato fallback IT/IT")
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
    local function AddEnglishToTooltip()
        if not addon.account.bilingualPOI then return end
        local localized = ZO_WorldMapMouseoverName:GetText()
        local baseName  = localized:gsub("%^%a+$", "")
        local english   = addon.translationTable[baseName] or baseName
        local fmt       = addon.account.bilingualNewLine
                          and "<<1>>\n<<2>>"
                          or "<<1>> (<<2>>)"
        local text      = zo_strformat(fmt, localized, ColorizeEnglish(english))
        ZO_WorldMapMouseoverName:SetText(text)
    end

    -- pin “normale”
    local orig1 = ZO_MapPin.TOOLTIP_CREATORS[MAP_PIN_TYPE_FAST_TRAVEL_WAYSHRINE].creator
    ZO_MapPin.TOOLTIP_CREATORS[MAP_PIN_TYPE_FAST_TRAVEL_WAYSHRINE].creator = function(...)
        orig1(...)
        AddEnglishToTooltip()
    end

    -- pin “current location”
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
        if not addon.account.bilingualPOI then return end
        local keepName = GetKeepName(keepId)
        local keepNoSuffix = keepName:gsub("%^%a+$", "")
        local englishKeepName = addon.translationTable[keepNoSuffix] or keepNoSuffix  -- Fallback a IT se non trovato
        local nameLabel = self:GetNamedChild("Name")
        local displayText = addon.account.bilingualNewLine and zo_strformat("<<1>>\n<<2>>", keepName, ColorizeEnglish(englishKeepName)) or zo_strformat("<<1>> / <<2>>", keepName, ColorizeEnglish(englishKeepName))
        nameLabel:SetText(displayText)
        d("[TraduzioneItaESO] Bilingue applicato per Keep: " .. displayText)
        if not addon.translationTable[keepNoSuffix] then
            d("[TraduzioneItaESO] Traduzione non trovata per Keep: " .. keepNoSuffix .. " - Usato fallback IT/IT")
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

function addon:Initialize()
    -- SavedVars, defaults compreso bilingualPOI = true
    self.account = ZO_SavedVars:NewAccountWide("TraduzioneItaESO_Vars", 1, nil, {
        bilingualMapNames = true,
        useEnglishNames   = false,
        bilingualNewLine  = true,
        showNotifications = true,
        bilingualPOI      = true,
        enableUI = false,
        hideDuringGameplay = false,
        offsetX = 0,
        offsetY = 0,
        hidePinsOnTamriel = false,
        bilingualColor = "FFFFFF",
        opacity = 50,
        showLocations = true,
    })

    -- popolo addon.translationTable
    LoadTranslationTable()

    -- aggancio i tooltip degli altari
    if self.account.bilingualPOI then
        HookShrineTooltips()
    end

    d("[TraduzioneItaESO] Lingua corrente: " .. GetCVar("language.2"))
    RefreshUI()
    EVENT_MANAGER:RegisterForEvent(addon.name, EVENT_RETICLE_HIDDEN_UPDATE, function(eventCode, hidden)
        UpdateUIVisibility(hidden)
    end)
    if self.account.bilingualMapNames or self.account.useEnglishNames then
        d("[TraduzioneItaESO] Registrazione eventi mappa")
        EVENT_MANAGER:RegisterForEvent(addon.name, EVENT_ZONE_UPDATE, UpdateMapName)
        EVENT_MANAGER:RegisterForEvent(addon.name, EVENT_MAP_CHUNK_INFO_RECEIVED, UpdateMapName)
        ZO_PreHook(ZO_WorldMap, "OnShow", function()
            d("[TraduzioneItaESO] ZO_WorldMap OnShow")
            UpdateMapName()
        end)
        ZO_PreHook(ZO_WorldMap, "OnHidden", function()
            addon:Hide()
        end)
        addon.lastZoom = g_mapPanAndZoom:GetCurrentCurvedZoom()
        EVENT_MANAGER:RegisterForUpdate(addon.name .. "_MapUpdate", 50, function()
            if ZO_WorldMap:IsHidden() then return end
            if GetCurrentMapIndex() ~= TAMRIEL_MAP_INDEX then return end
            local currentZoom = g_mapPanAndZoom:GetCurrentCurvedZoom()
            if math.abs(currentZoom - addon.lastZoom) > 0.001 then
                addon.lastZoom = currentZoom
                addon:RenderMap(addon.account.showLocations)
            end
        end)
    end
    -- aggiorno il nome mappa al login/reload
    EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_ACTIVATED, UpdateMapName)
    UpdateMapName()
    addon:InitializeMap()
    local LAM = LibAddonMenu2
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
    local optionsData = {
        {
            type = "dropdown",
            name = "Seleziona Lingua",
            choices = {"Italiano", "Inglese"},
            choicesValues = {"it", "en"},
            getFunc = function() return addon.account.language end,
            setFunc = function(value)
                addon.account.language = value
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
            getFunc = function() return addon.account.showNotifications end,
            setFunc = function(value) addon.account.showNotifications = value end
        },
        {
            type = "checkbox",
            name = "Mostra Bandierine UI",
            tooltip = "Abilita/disabilita le bandierine cliccabili sullo schermo.",
            getFunc = function() return addon.account.enableUI end,
            setFunc = function(value)
                addon.account.enableUI = value
                UpdateUIVisibility(IsReticleHidden())
            end
        },
        {
            type = "checkbox",
            name = "Nascondi Bandierine durante Gameplay",
            tooltip = "Nascondi le bandierine quando il mirino è attivo.",
            getFunc = function() return addon.account.hideDuringGameplay end,
            setFunc = function(value)
                addon.account.hideDuringGameplay = value
                UpdateUIVisibility(IsReticleHidden())
            end
        },
        {
            type = "checkbox",
            name = "Nomi Bilingui sulla Mappa",
            tooltip = "Mostra nomi delle zone in italiano e inglese (es. 'Deserto di Alik'r\nAlik'r Desert').",
            getFunc = function() return addon.account.bilingualMapNames end,
            setFunc = function(value)
                addon.account.bilingualMapNames = value
                UpdateMapName()
                addon:RenderMap(addon.account.showLocations)
            end
        },
        {
            type = "checkbox",
            name = "Usa Nomi Inglesi su Tamriel",
            tooltip = "Mostra i nomi inglesi delle zone sulla mappa di Tamriel (stile Votan's Tamriel Map).",
            getFunc = function() return addon.account.useEnglishNames end,
            setFunc = function(value)
                addon.account.useEnglishNames = value
                addon:RenderMap(addon.account.showLocations)
            end
        },
        {
            type = "checkbox",
            name = "Mostra Regioni su Tamriel",
            tooltip = "Mostra i nomi delle regioni sulla mappa di Tamriel.",
            getFunc = function() return addon.account.showLocations end,
            setFunc = function(value)
                addon.account.showLocations = value
                addon:RenderMap(value)
            end
        },
        {
            type = "checkbox",
            name = "Nascondi Wayshrine su Tamriel",
            tooltip = "Nasconde i pin dei wayshrine sulla mappa di Tamriel (stile Votan's).",
            getFunc = function() return addon.account.hidePinsOnTamriel end,
            setFunc = function(value)
                addon.account.hidePinsOnTamriel = value
                if GetCurrentMapIndex() == TAMRIEL_MAP_INDEX then
                    ZO_WorldMap_GetPinManager():SetPinGroupShown(MAP_FILTER_WAYSHRINES, not value)
                end
            end
        },
        {
            type = "checkbox",
            name = "Nomi Bilingui nei Tooltips (POI/Keeps/Shrines)",
            tooltip = "Mostra nomi in italiano e inglese nei tooltips quando passi il mouse su POI, Keeps o Shrines.",
            getFunc = function() return addon.account.bilingualPOI end,
            setFunc = function(value)
                addon.account.bilingualPOI = value
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
            getFunc = function() return addon.account.bilingualNewLine end,
            setFunc = function(value) addon.account.bilingualNewLine = value end,
            disabled = function() return not addon.account.bilingualPOI and not addon.account.bilingualMapNames end
        },
        {
            type = "colorpicker",
            name = "Colore Nome Inglese",
            tooltip = "Colore per il nome inglese nei tooltips e mappe.",
            getFunc = function() return ZO_ColorDef:New(addon.account.bilingualColor):UnpackRGBA() end,
            setFunc = function(r, g, b, a) addon.account.bilingualColor = ZO_ColorDef:New(r, g, b, a):ToHex() end,
            default = ZO_ColorDef:New("FFFFFF"),
            disabled = function() return not addon.account.bilingualPOI and not addon.account.bilingualMapNames end
        },
        {
            type = "slider",
            name = "Opacità Overlay Mappa",
            tooltip = "Regola trasparenza overlay regioni su Tamriel (stile Votan's).",
            min = 0,
            max = 100,
            step = 1,
            getFunc = function() return addon.account.opacity end,
            setFunc = function(value)
                addon.account.opacity = value
                addon:ApplyOpacity()
                addon:RenderMap(addon.account.showLocations)
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
    LAM:RegisterAddonPanel(addon.name .. "Options", panelData)
    LAM:RegisterOptionControls(addon.name .. "Options", optionsData)
end

-- Slash commands
SLASH_COMMANDS["/itaesoit"] = function()
    addon.account.language = "it"
    ShowLanguageNotification("it")
    SetLanguage("it")
end
SLASH_COMMANDS["/itaesoen"] = function()
    addon.account.language = "en"
    ShowLanguageNotification("en")
    SetLanguage("en")
end
SLASH_COMMANDS["/itaeso"] = function()
    LibAddonMenu2:OpenToPanel(addon.name .. "Options")
    d("[TraduzioneItaESO] Apertura pannello impostazioni")
end
SLASH_COMMANDS["/testitaeso"] = function()
    d("[TraduzioneItaESO] Test comando /testitaeso")
    UpdateMapName()
    addon:RenderMap(addon.account.showLocations)
end

SLASH_COMMANDS["/testtable"] = function()
  local count = 0
  for _ in pairs(addon.translationTable or {}) do
    count = count + 1
  end
  d("Entries in translationTable: " .. count)
  if count == 0 then
    d("Tabella è nulla o vuota - non ha caricato le traduzioni")
  else
    d("Tabella ha caricato " .. count .. " entries correttamente")
  end
end