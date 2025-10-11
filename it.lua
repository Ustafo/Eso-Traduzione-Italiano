WritCreater = WritCreater or {}

-- Utility comune
local function proper(str)
    if type(str) == "string" then
        return zo_strformat("<<C:1>>", str)
    else
        return str
    end
end

-- Soggetti posta (Hireling) riconosciuti
-- Nota: il confronto è case-insensitive per maggiore robustezza
WritCreater.hirelingMailSubjects = WritCreater.hirelingMailSubjects or {}
WritCreater.hirelingMailSubjects["Materiali grezzi da sarto"] = true           -- Raw Clothier Materials
WritCreater.hirelingMailSubjects["Borsa del Sarto"] = true          -- Nuova variante aggiunta
WritCreater.hirelingMailSubjects["Borsa del Sarto (Stoffa) I"] = true          -- Nuova variante aggiunta
WritCreater.hirelingMailSubjects["Cassa del Fabbro"] = true            -- Nuova variante aggiunta
WritCreater.hirelingMailSubjects["Scrigno dell'Incantatore"] = true            -- Nuova variante aggiunta
WritCreater.hirelingMailSubjects["Valigetta del Falegname I"] = true            -- Nuova variante aggiunta
WritCreater.hirelingMailSubjects["POSTA DI SISTEMA"] = true                    -- Nuova variante aggiunta
WritCreater.hirelingMailSubjects["Ingredienti da cucina grezzi"] = true         -- Raw Provisioner Materials
WritCreater.hirelingMailSubjects["Materiali grezzi da incantatore"] = true    -- Raw Enchanter Materials
WritCreater.hirelingMailSubjects["Materiali grezzi da falegname"] = true      -- Raw Woodworker Materials
WritCreater.hirelingMailSubjects["Materiali grezzi da fabbro"] = true         -- Raw Blacksmith Materials

-- Funzione per normalizzare i soggetti delle email
local function normalizeMailSubject(subject)
    return type(subject) == "string" and subject:lower() or ""
end

-- Override della funzione di controllo dei soggetti per gestire case-insensitive
local originalHirelingMailCheck = WritCreater.hirelingMailSubjects
WritCreater.hirelingMailSubjects = setmetatable({}, {
    __index = function(t, key)
        local normalizedKey = normalizeMailSubject(key)
        for subject, value in pairs(originalHirelingMailCheck) do
            if normalizeMailSubject(subject) == normalizedKey then
                return value
            end
        end
        return nil
    end
})

-- Nominalizzazioni writ
function WritCreater.langWritNames()
    return {
        ["G"]                           = "Commissione",
        [CRAFTING_TYPE_ENCHANTING]      = "Incantatore",
        [CRAFTING_TYPE_BLACKSMITHING]   = "Fabbro",
        [CRAFTING_TYPE_CLOTHIER]        = "Sarto",
        [CRAFTING_TYPE_PROVISIONING]    = "Cuoco",
        [CRAFTING_TYPE_WOODWORKING]     = "Falegname",
        [CRAFTING_TYPE_ALCHEMY]         = "Alchimista",
        [CRAFTING_TYPE_JEWELRYCRAFTING] = "Gioielliere",
    }
end

-- Kernel craft
function WritCreater.langCraftKernels()
    return WritCreater.langWritNames()
end

-- Stringhe di completamento
function WritCreater.writCompleteStrings()
    return {
        ["place"]        = "Metti la merce nella cassa.", -- Testo principale del gioco
        ["sign"]         = "Firma il manifesto",
        -- Master writ: consegna e chiusura
        --["masterPlace"]  = "Ho terminato il lavoro", -- intercetta tutte le varianti professionali
		["masterPlace"]  = "Ho terminato", -- intercetta tutte le varianti professionali
        ["masterSign"]   = "Completa Missione.",     -- pulsante di conferma ricompensa
        ["masterStart"]  = {
            "<Accetta il contratto.>",  
            "Sei qui per consegnare il nostro piccolo 'contratto privato'?", 
        },
        ["Rolis Hlaalu"] = "Rolis Hlaalu",
        ["Deliver"]      = "Consegna",
        ["Acquire"]      = "ottieni",
    }
end

-- Eccezioni per gestire varianti di testo
function WritCreater.questExceptions(condition)
    local lowerCondition = condition and type(condition) == "string" and condition:lower() or ""
    -- Supporta la variante lunga per la consegna
    if lowerCondition:find("la cassa contiene ampio spazio per la consegne", 1, true) then
        return "Metti la merce nella cassa."
    end
    return string.gsub(condition, " ", " ")
end

-- Station names
function WritCreater.langStationNames()
    return {
        ["Postazione da fabbro"]      = 1,
        ["Postazione da sarto"]       = 2,
        ["Tavolo da incantamento"]    = 3,
        ["Postazione da alchimista"]  = 4,
        ["Focolare da cucina"]        = 5,
        ["Postazione da falegname"]   = 6,
        ["Postazione da gioielliere"] = 7,
    }
end

-- Impostazioni lingua
WritCreater.lang                      = "it"
WritCreater.langIsMasterWritSupported = true

-- Selezione e accettazione “one-by-one” per tutte le writ italiane
local function OnQuestOffered(eventCode)
    EVENT_MANAGER:UnregisterForEvent(WritCreater.name, EVENT_QUEST_OFFERED)
    AcceptOfferedQuest()
end

-- Callback chiamato ad apertura dialogo
local function OnChatterBegin(eventCode, optionCount)
    if optionCount == 0 or not WritCreater:GetSettings().autoAccept then
        return
    end

    for i = 1, optionCount do
        local text, optType = GetChatterOption(i)

        -- intercetta sia "commissione" (singolare) che "commissioni" (plurale)
        if text then
            local lower = text:lower()
            if lower:find("commissione", 1, true) or lower:find("commissioni", 1, true) then
                EVENT_MANAGER:RegisterForEvent(
                    WritCreater.name,
                    EVENT_QUEST_OFFERED,
                    OnQuestOffered
                )
                SelectChatterOption(i)
                return
            end
        end
    end
end

-- Registra l’hook su CHATTER_BEGIN una volta per tutte
EVENT_MANAGER:RegisterForEvent(
    WritCreater.name .. "_LangIt_AutoAccept",
    EVENT_CHATTER_BEGIN,
    OnChatterBegin
)

-- Nomi dei contenitori PER IL SISTEMA DI LOOT - devono corrispondere ESATTAMENTE
function WritCreater.GetContainerNames()
    return {
        -- Formato: [itemId] = {rank, craftType}
        -- Blacksmithing
        ["Cassa del Fabbro"] = {1, CRAFTING_TYPE_BLACKSMITHING},
        ["Cassa del Fabbro I"] = {1, CRAFTING_TYPE_BLACKSMITHING},
        ["Cassa del Fabbro II"] = {2, CRAFTING_TYPE_BLACKSMITHING},
        
        -- Clothier
        ["Borsa del Sarto"] = {1, CRAFTING_TYPE_CLOTHIER},
        ["Borsa del Sarto I"] = {1, CRAFTING_TYPE_CLOTHIER},
        ["Borsa del Sarto (Stoffa)I"] = {1, CRAFTING_TYPE_CLOTHIER},
		["Borsa del Sarto (Cuoio)I"] = {1, CRAFTING_TYPE_CLOTHIER},
        ["Borsa del Sarto (Cuoio) I"] = {1, CRAFTING_TYPE_CLOTHIER},
		
        
        -- Woodworking
        ["Valigetta del Falegname"] = {1, CRAFTING_TYPE_WOODWORKING},
        ["Valigetta del FalegnameI"] = {1, CRAFTING_TYPE_WOODWORKING},
		 ["Valigetta del Falegname I"] = {1, CRAFTING_TYPE_WOODWORKING},
		 
        
        -- Enchanting
        ["Scrigno dell'Incantatore"] = {1, CRAFTING_TYPE_ENCHANTING},
        ["Scrigno dell'Incantatore I"] = {1, CRAFTING_TYPE_ENCHANTING},
        
        -- Alchemy
        ["Recipiente dell'Alchimista"] = {1, CRAFTING_TYPE_ALCHEMY},
        ["Recipiente dell'Alchimista I"] = {1, CRAFTING_TYPE_ALCHEMY},
        
        -- Provisioning
        ["Borsa del Cuoco"] = {1, CRAFTING_TYPE_PROVISIONING},
        ["Borsa del Cuoco I"] = {1, CRAFTING_TYPE_PROVISIONING},
        
        -- Jewelry
        ["Cassa del Gioielliere"] = {1, CRAFTING_TYPE_JEWELRYCRAFTING},
        ["Cassa del Gioielliere I"] = {1, CRAFTING_TYPE_JEWELRYCRAFTING}
    }
end

-- Funzione di matching migliorata per l'italiano
function WritCreater.MatchContainerName(containerName)
    if not containerName or type(containerName) ~= "string" then
        return nil
    end
    
    local containerNames = WritCreater.GetContainerNames()
    
    -- Prima cerca corrispondenza esatta
    if containerNames[containerName] then
        return containerNames[containerName][2] -- restituisce il craftType
    end
    
    -- Poi cerca corrispondenze parziali (case-insensitive)
    local lowerContainerName = string.lower(containerName)
    for name, data in pairs(containerNames) do
        if string.find(string.lower(name:gsub("%s+", "")), lowerContainerName:gsub("%s+", ""), 1, true) then
		   
            return data[2] -- craftType
        end
    end
    
    return nil
end

-- Sostituisce la funzione boxNames per l'italiano
function WritCreater.GetBoxNames()
    local boxNames = {}
    local containerNames = WritCreater.GetContainerNames()
    
    for name, data in pairs(containerNames) do
        boxNames[name] = data
    end
    
    -- Aggiungi le varianti delle scatole evento
    boxNames["Scatola Regalo del Giubileo"] = {0, 0}
    boxNames["Scatola di Zenithar"] = {0, 0}
    boxNames["Scatola Gloriosa di Zenithar"] = {0, 0}
    
    return boxNames
end

-- INIZIALIZZAZIONE CRITICA - sostituisce le funzioni originali
local function InitializeItalianSupport()
    -- Sostituisci la funzione boxNames
    if not WritCreater.boxNames then
        WritCreater.boxNames = WritCreater.GetBoxNames()
    else
        -- Merge con i nomi italiani
        local italianBoxes = WritCreater.GetBoxNames()
        for name, data in pairs(italianBoxes) do
            WritCreater.boxNames[name] = data
        end
    end
    
    -- Sostituisci la funzione di matching se non esiste
    if not WritCreater.MatchContainerName then
        WritCreater.MatchContainerName = function(containerName)
            return WritCreater.MatchContainerName(containerName)
        end
    end
    
    d("[LazyWritCreator ITA] Supporto italiano inizializzato")
end

-- Esegui l'inizializzazione quando l'addon è caricato
EVENT_MANAGER:RegisterForEvent("WritCreatorItalian", EVENT_ADD_ON_LOADED, function(event, addonName)
    if addonName == "DolgubonsLazyWritCreator" then
        zo_callLater(InitializeItalianSupport, 2000) -- Ritardo per assicurarsi che tutto sia caricato
        EVENT_MANAGER:UnregisterForEvent("WritCreatorItalian", EVENT_ADD_ON_LOADED)
    end
end)

-- Patch per il sistema di loot
local function PatchLootSystem()
    -- Salva la funzione originale
    local originalOnLootUpdated = WritCreater.OnLootUpdated
    
    -- Sostituisci con la versione che supporta l'italiano
    WritCreater.OnLootUpdated = function(event)
        local lootInfo = {GetLootTargetInfo()}
        local lootName = lootInfo[1]
        
        if lootName and lootName ~= "" then
            -- Usa il nostro sistema di matching italiano
            local craftType = WritCreater.MatchContainerName(lootName)
            
            if craftType then
                d(string.format("[LazyWritCreator ITA] Riconosciuto: '%s' -> %s", lootName, craftType))
                -- Qui va la logica originale di loot...
                return originalOnLootUpdated(event)
            end
        end
        
        return originalOnLootUpdated(event)
    end
    
    -- Correggi anche la funzione boxNames nel sistema principale
    local originalBoxNames = WritCreater.boxNames
    WritCreater.boxNames = setmetatable({}, {
        __index = function(t, key)
            -- Prima controlla i nomi originali
            local originalValue = originalBoxNames[key]
            if originalValue then return originalValue end
            
            -- Poi controlla i nomi italiani
            local italianValue = WritCreater.GetBoxNames()[key]
            if italianValue then return italianValue end
            
            -- Infine prova il matching case-insensitive
            local lowerKey = string.lower(key)
            for name, data in pairs(originalBoxNames) do
                if string.lower(name) == lowerKey then
                    return data
                end
            end
            
            for name, data in pairs(WritCreater.GetBoxNames()) do
                if string.lower(name) == lowerKey then
                    return data
                end
            end
            
            return nil
        end
    })
end

-- Esegui il patch del loot system dopo l'inizializzazione
zo_callLater(PatchLootSystem, 3000)

-- Comandi debug per testare
SLASH_COMMANDS["/writit"] = function()
    d("=== TEST CONTENITORI ITALIANI ===")
    
    -- Testa tutti i nomi conosciuti
    local containerNames = WritCreater.GetContainerNames()
    d("Nomi contenitori riconosciuti:")
    for name, data in pairs(containerNames) do
        d(string.format("  %s -> %s (rank: %d)", name, data[2], data[1]))
    end
    
    -- Test matching
    local testNames = {
        "Valigetta del Falegname I",
        "Borsa del Sarto (Stoffa) I", 
        "Cassa del Fabbro",
        "Nome Sconosciuto"
    }
    
    d("Test matching:")
    for _, testName in ipairs(testNames) do
        local craftType = WritCreater.MatchContainerName(testName)
        if craftType then
            d(string.format("  ✅ '%s' -> %s", testName, craftType))
        else
            d(string.format("  ❌ '%s' -> NON RICONOSCIUTO", testName))
        end
    end
end

-- Comando per debug avanzato
SLASH_COMMANDS["/writdebug"] = function()
    d("=== DEBUG AVANZATO WRIT CREATOR ===")
    
    -- 1. Controlla lo stato del sistema
    d("1. STATO SISTEMA:")
    d("   WritCreater.boxNames: " .. tostring(WritCreater.boxNames ~= nil))
    d("   WritCreater.lang: " .. tostring(WritCreater.lang))
    
    -- 2. Mostra tutti i box names registrati
    d("2. BOX NAMES REGISTRATI:")
    local count = 0
    if WritCreater.boxNames then
        for name, data in pairs(WritCreater.boxNames) do
            if type(data) == "table" then
                d(string.format("   %s -> [%d, %d]", name, data[1] or 0, data[2] or 0))
            else
                d(string.format("   %s -> %s", name, tostring(data)))
            end
            count = count + 1
            if count > 20 then break end -- Limita l'output
        end
    end
    
    -- 3. Testa nomi specifici italiani
    d("3. TEST NOMI ITALIANI:")
    local testItems = {
        "Valigetta del Falegname I",
        "Borsa del Sarto (Stoffa) I",
        "Cassa del Fabbro I", 
        "Scrigno dell'Incantatore I",
        "Recipiente dell'Alchimista I",
        "Borsa del Cuoco I",
        "Cassa del Gioielliere I"
    }
    
    for _, itemName in ipairs(testItems) do
        local boxData = WritCreater.boxNames[itemName]
        if boxData then
            d(string.format("   ✅ '%s' -> RICONOSCIUTO", itemName))
        else
            d(string.format("   ❌ '%s' -> NON RICONOSCIUTO", itemName))
        end
    end
    
    d("=== FINE DEBUG ===")
end