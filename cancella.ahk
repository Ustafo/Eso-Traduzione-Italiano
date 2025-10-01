preparafile:
;————————————————————————————
; FASE 1/5 – Selezione file
;————————————————————————————
Tooltip, Fase 1/5: Selezione file…, 0, 0
configFile := A_ScriptDir "\config.ini"
IniRead, fileDaAgg, %configFile%, Percorsi, fileDaAggiornare, NOT_FOUND
if (fileDaAgg = "NOT_FOUND" || !FileExist(fileDaAgg)) {
FileSelectFile, fileDaAgg, 3,, Seleziona il file da aggiornare (inglese en.lang)
if (!fileDaAgg)
{
Tooltip
return
}
IniWrite, %fileDaAgg%, %configFile%, Percorsi, fileDaAggiornare
}
IniRead, fileTrad, %configFile%, Percorsi, fileTraduzioni, NOT_FOUND
if (fileTrad = "NOT_FOUND" || !FileExist(fileTrad)) {
FileSelectFile, fileTrad, 3,, Seleziona il file delle traduzioni (italiano)
if (!fileTrad)
{
Tooltip
return
}
IniWrite, %fileTrad%, %configFile%, Percorsi, fileTraduzioni
}
;————————————————————————————
; FASE 2/5 – Lettura e caricamento in array
;————————————————————————————
Tooltip, Fase 2/5: Lettura file…, 0, 0
dataOld := caricafileinarraymulticolonna(fileDaAgg, totalOld, 0)
dataNew := caricafileinarraymulticolonna(fileTrad, totalNew, 0)
;MsgBox, Caricati %totalOld% record da fileDaAgg e %totalNew% record da fileTrad ; Debug
; --- Aggiunta: Generazione dei file Lua per l'addon ESO ---
; File zone_it.lua: Traduzioni delle località (ID campo 1 = 162658389, 10860933, 28666901)
; File npc_it.lua: Traduzioni degli NPC (ID campo 1 = 8290981)
zoneTranslations := {} ; Tabella per le località
npcTranslations := {} ; Tabella per gli NPC
zoneCount := 0 ; Contatore per debug
npcCount := 0 ; Contatore per debug




target := {1: "10860933", 2: "0", 3: "1783", 4: "FR1771275251", 5: "Santuario di Tel Mora"}
found := 0
for i, row in dataNew
{
    f1 := Normalize(row[1] "")
    f2 := Normalize(row[2] "")
    f3 := Normalize(row[3] "")
    f4 := Normalize(row[4] "")
    f5 := Normalize(row[5] "")
    if (f1 = target[1] && f2 = target[2] && f3 = target[3] && f4 = target[4] && f5 = target[5]) {
        MsgBox, 64, RIGA TROVATA, Trovata esatta in dataNew riga %i%`n%f1% , %f2% , %f3% , %f4% , %f5%
        found := 1
        break
    }
}
if (!found)
    MsgBox, 48, NON TROVATA, La riga esatta non è presente in dataNew dopo normalizzazione.





for i, row in dataOld
{
if (row[1] = 162658389 || row[1] = 10860933 || row[1] = 28666901) ; Località estese
{
key := row[2] . row[3] ; Chiave composta per il merge
zoneTranslations[key] := { "en": row[5] } ; Salva il nome inglese
}
else if (row[1] = 8290981) ; NPC
{
key := row[2] . row[3] ; Chiave composta per il merge
npcTranslations[key] := { "en": row[5] } ; Salva il nome inglese
}
}
; Aggiungi i nomi italiani e associa ai nomi inglesi
for i, row in dataNew
{
if (row[1] = 162658389 || row[1] = 10860933 || row[1] = 28666901) ; Località estese
{
key := row[2] . row[3] ; Chiave composta
if (zoneTranslations[key]) ; Controlla se esiste in inglese
{
zoneTranslations[key].it := row[5] ; Aggiungi il nome italiano
zoneCount++ ; Incrementa contatore
}
}
else if (row[1] = 8290981) ; NPC
{
key := row[2] . row[3] ; Chiave composta
if (npcTranslations[key]) ; Controlla se esiste in inglese
{
npcTranslations[key].it := row[5] ; Aggiungi il nome italiano
npcCount++ ; Incrementa contatore
}
}
}
; Elimina doppioni per zone: tabella unica con chiave itName, tenendo solo una riga per valore del 5° campo (it)
uniqueZoneTranslations := {}
for key, data in zoneTranslations
{
if (data.it && data.en && data.it != data.en)
{
if (!uniqueZoneTranslations.HasKey(data.it))
{
uniqueZoneTranslations[data.it] := data.en
}
}
}
zoneCount := uniqueZoneTranslations.Count() ; Aggiorna contatore dopo deduplicazione
; Genera zone_it.lua (variabile unica, con n per newline)
outputZoneLua := "TraduzioneItaESO = TraduzioneItaESO or {`n"
outputZoneLua .= " ZoneTranslations = {`n"
if (zoneCount > 0) ; Scrivi solo se ci sono traduzioni
{
current := 0
for itName, enName in uniqueZoneTranslations
{
current++
; Escaping delle virgolette nei nomi
itEsc := StrReplace(itName, """", "\""")
enEsc := StrReplace(enName, """", "\""")
outputZoneLua .= "[ """ . itEsc . """ ] = """ . enEsc . """"
if (current < zoneCount)
outputZoneLua .= ","
outputZoneLua .= "`n"
}
}
else
{
outputZoneLua .= " -- Nessuna traduzione per le località`n"
}
outputZoneLua .= " }`n}`n"
outputZoneFile := A_ScriptDir "\zone_it.lua"
FileDelete, %outputZoneFile%
sleep 100 
;msgbox % outputZoneFile " -- " outputZoneLua
FileAppend, %outputZoneLua%, %outputZoneFile%, UTF-8
sleep 100 
; Genera npc_it.lua (variabile unica, con n per newline)
outputNPCLua := "TraduzioneItaESO = TraduzioneItaESO or {`n"
outputNPCLua .= " NPCTranslations = {`n"
if (npcCount > 0) ; Scrivi solo se ci sono traduzioni
{
current := 0
for key, data in npcTranslations
{
if (data.it && data.en && data.it != data.en) ; Include solo traduzioni valide e diverse
{
current++
; Escaping delle virgolette nei nomi
itName := data.it
enName := data.en
itEsc := StrReplace(itName, """", "\""")
enEsc := StrReplace(enName, """", "\""")
outputNPCLua .= "[ """ . itEsc . """ ] = """ . enEsc . """"
if (current < npcCount)
outputNPCLua .= ","
outputNPCLua .= "`n"
}
}
}
else
{
outputNPCLua .= " -- Nessuna traduzione per gli NPC`n"
}
outputNPCLua .= " }`n}`n"
outputNPCFile := A_ScriptDir "\npc_it.lua"
FileDelete, %outputNPCFile%
sleep 100 
FileAppend, %outputNPCLua%, %outputNPCFile%, UTF-8
sleep 100 
; Debug: Log del contenuto per verifica
debugLog := A_ScriptDir "\debug_lua.txt"
FileDelete, %debugLog%
FileAppend, Contenuto di zone_it.lua:`n%outputZoneLua%`n`nContenuto di npc_it.lua:`n%outputNPCLua%, %debugLog%, UTF-8
; Debug: Mostra il numero di traduzioni generate
MsgBox, 64, File Lua Generati, Generati %zoneCount% traduzioni per zone_it.lua e %npcCount% traduzioni per npc_it.lua`n`nControlla %debugLog% per il contenuto esatto.
;————————————————————————————
; FASE 3/5 – Lettura opzione preparatestopergioco
;————————————————————————————
IniRead, prepStr, %configFile%, Opzioni, preparatestopergioco
; Se ErrorLevel=1 → la chiave non esiste
; Se ErrorLevel=0 ma prepStr="" → esiste senza valore
if (ErrorLevel || prepStr = "")
{
; Chiedi all’utente
MsgBox, 4, Sostituzioni extra, (LTrim Join`n Vuoi attivare le sostituzioni extra per il gioco? (Sì = ON / No = OFF)
IfMsgBox Yes
prep := 1
else
prep := 0
; Scrivi nel file INI
IniWrite, %prep%, %configFile%, Opzioni, preparatestopergioco
}
else
{
; Altrimenti la chiave c’è e contiene “0” o “1”
prep := prepStr + 0
}
; A questo punto preparatestopergioco è un numero: 0 o 1
preparatestopergioco := prep
;————————————————————————————
; FASE 4/5 – Merge-join con progress tooltip
;————————————————————————————
output := ""
contotltip := 0
outputCount := 0 ; Contatore per debug
iOld := 1
iNew := 1
tipInterval := 5000
varconfronto := ""
while (iOld <= totalOld && iNew <= totalNew) {
contotltip++
if (contotltip > tipInterval) {
ToolTip, Merge-join: riga %iOld% di %totalOld% iOld %iOld% iNew %iNew% o1 %o1% o2 %o2% o3 %o3% n1 %n1% n2 %n2% n3 %n3% outputCount %outputCount%, 0, 0
contotltip := 0
}
o1 := dataOld[iOld][1]
o2 := dataOld[iOld][2]
o3 := dataOld[iOld][3]
n1 := dataNew[iNew][1]
n2 := dataNew[iNew][2]
n3 := dataNew[iNew][3]
if (o1 = n1)
if (o2 = n2)
if (o3 = n3)
{
var1 := n1
var2 := n2
var3 := n3
var4 := dataNew[iNew][4]
var5 := dataNew[iNew][5]
varconfronto := dataOld[iOld][5]
Gosub BuildRow
outputCount++ ; Incrementa contatore
iOld++
iNew++
continue
}
if (o1 < n1)
{
var1 := o1
var2 := o2
var3 := o3
var4 := dataOld[iOld][4]
var5 := dataOld[iOld][5]
varconfronto := ""
Gosub BuildRow
outputCount++ ; Incrementa contatore
iOld++
continue
}
if (o1 = n1)
if (o2 < n2)
{
var1 := o1
var2 := o2
var3 := o3
var4 := dataOld[iOld][4]
var5 := dataOld[iOld][5]
varconfronto := ""
Gosub BuildRow
outputCount++ ; Incrementa contatore
iOld++
continue
}
if (o1 = n1)
if (o2 = n2)
if (o3 < n3)
{
var1 := o1
var2 := o2
var3 := o3
var4 := dataOld[iOld][4]
var5 := dataOld[iOld][5]
varconfronto := ""
Gosub BuildRow
outputCount++ ; Incrementa contatore
iOld++
continue
}
if (o1 > n1)
{
iNew++
continue
}
if (o1 = n1)
if (o2 > n2)
{
iNew++
continue
}
if (o1 = n1)
if (o2 = n2)
if (o3 > n3)
{
iNew++
continue
}
}
; Gestione restanti record “old”
while (iOld <= totalOld)
{
var1 := dataOld[iOld][1]
var2 := dataOld[iOld][2]
var3 := dataOld[iOld][3]
var4 := dataOld[iOld][4]
var5 := dataOld[iOld][5]
varconfronto := ""
Gosub BuildRow
outputCount++ ; Incrementa contatore
iOld++
}
ToolTip ; rimuove il tooltip finale
;————————————————————————————
; FASE 5/5 – Scrittura su disco
;————————————————————————————
Tooltip, Fase 5/5: Scrittura su disco…, 0, 0
outputFile := A_ScriptDir "\output.csv"
FileDelete, %outputFile%
FileAppend, %output%, %outputFile%, UTF-8
MsgBox, 64, Fatto, Ho generato %outputFile% con %outputCount% record controlla il file daconttrollare.txt .
return
BuildRow:
; Applico le sostituzioni extra
if (Trim(var5) = "SALTA TRADUZIONE" || Trim(var5) = "NON TRADUCIBILE")
{
var5 := varconfronto
}
if (varconfronto <> "")
{
v := """"
itaQ := StrReplace(var5, v, v, 0, -1) ; Conteggio su italiano (il quarto param è limit, -1 per all; ma StrReplace non ha conteggio built-in in v1, fix con workaround
itaQ := (StrLen(var5) - StrLen(StrReplace(var5, v))) ; Workaround per conteggio occorrenze
engQ := (StrLen(varconfronto) - StrLen(StrReplace(varconfronto, v))) ; Conteggio su inglese
if (itaQ != engQ)
{
logFile := A_ScriptDir "\daconttrollare.txt"
SplitPath, logFile, , logDir
FileCreateDir, %logDir%
FileAppend, %var5%`n%varconfronto%`n, %logFile%, UTF-8
var5 := varconfronto
}
if (Trim(var5) = "")
var5 := varconfronto
}
if (preparatestopergioco) {
var5chesost := var5
var5chesost := StrReplace(var5chesost, "battlefield", "Campo di battaglia - Battleground Match")
var5chesost := StrReplace(var5chesost, "Summerset", "Isola del Tramonto - Summerset")
var5chesost := StrReplace(var5chesost, "Reaper’s March", "Marcia del Mietitore - Reaper’s March")
var5chesost := StrReplace(var5chesost, "Coldharbour", "Porto Gelido - Coldharbour")
var5chesost := StrReplace(var5chesost, "Artaeum", "Artaeum")
var5chesost := StrReplace(var5chesost, "Greenshade", "OmbraVerde - Greenshade")
var5chesost := StrReplace(var5chesost, "Reaper's March", "Passo del Mietitore - Reaper's March")
var5chesost := StrReplace(var5chesost, "Stormhaven", "Rifugiodallatempesta - Stormhaven")
var5chesost := StrReplace(var5chesost, "Rivenspire", "GugliaSquarciata - Rivenspire")
var5chesost := StrReplace(var5chesost, "Glenumbra", "Valle d'Ombra - Glenumbra")
var5chesost := StrReplace(var5chesost, "Shadowfen", "PaludeOmbrosa - Shadowfen")
var5chesost := StrReplace(var5chesost, "Stonefalls", "Ghiaionefranante - Stonefalls")
var5chesost := StrReplace(var5chesost, "Grahtwood", "Bosco di Graht - Grahtwood")
var5chesost := StrReplace(var5chesost, "Craglorn", "FalesiaPerduta - Craglorn")
var5chesost := StrReplace(var5chesost, "Evermore", "Perpetuamente - Evermore")
var5chesost := StrReplace(var5chesost, "The black wood", "Bosco Nero - Black Wood")
var5chesost := StrReplace(var5chesost, "black wood", "Bosco Nero - Black Wood")
var5chesost := StrReplace(var5chesost, "Eastmarch", "Frontiera Orientale - Eastmarch")
var5chesost := StrReplace(var5chesost, "The Rift", "Fenditura Spaccata - The Rift")
var5chesost := StrReplace(var5chesost, "Deeshan", "Mostra Cammino - Deeshan")
var5chesost := StrReplace(var5chesost, "High Isle", "Isola Alta - High Isle")
var5chesost := StrReplace(var5chesost, "West Weald", "Selva di Ponente - West Weald")
var5chesost := StrReplace(var5chesost, "Wrothgar", "Terre di Rothgar - Wrothgar")
var5chesost := StrReplace(var5chesost, "The Reach", "Le Terre Alte - The Reach")
var5chesost := StrReplace(var5chesost, "Murkmire", "Fosca Palude - Murkmire")
var5chesost := StrReplace(var5chesost, "Malabal Tor", "Terra Oscura - Malabal Tor")
var5chesost := StrReplace(var5chesost, "White-Gold Tower", "Torre d'Oro Bianco - White-Gold Tower")
var5chesost := StrReplace(var5chesost, "Selene's Web", "Ragnatele di Selene - Selene's Web")
var5chesost := StrReplace(var5chesost, "Blackheart Haven", "Rifugio di Cuorenero - Blackheart Haven")
var5chesost := StrReplace(var5chesost, "Direfrost Keep", "Prigione di ghiaccio - Direfrost Keep")
var5chesost := StrReplace(var5chesost, "Banished Cells", "Dungeon del Divieto - Banished Cells")
var5chesost := StrReplace(var5chesost, "Vaults of Madness", "Volte della Follia - Vaults of Madness")
var5chesost := StrReplace(var5chesost, "Moon Hunter Bailey", "Baia del Cacciatore di Luna - Moon Hunter Bailey")
var5chesost := StrReplace(var5chesost, "Moon Hunter Keep", "Torrione del Cacciatore di Luna - Moon Hunter Keep")
var5chesost := StrReplace(var5chesost, "Elden Hollow", "Cava degli anziani - Elden Hollow")
var5chesost := StrReplace(var5chesost, "Blessed Crucible", "Il Crogiolo benedetto - Blessed Crucible")
var5chesost := StrReplace(var5chesost, "Fungal Grotto ", "Grotta dei funghi - Fungal Grotto")
var5chesost := StrReplace(var5chesost, "The Crypt of Hearts", "La Cripta dei cuori - The Crypt of Hearts")
var5chesost := StrReplace(var5chesost, "Crypt of Hearts ", "Cripta dei cuori - Crypt of Hearts")
var5chesost := StrReplace(var5chesost, "City of Ash", "Città della Cenere - City of Ash")
var5chesost := StrReplace(var5chesost, "Darkshade Caverns", "Oscure Caverne - Darkshade Caverns")
var5chesost := StrReplace(var5chesost, "Spindleclutch", "Bozzolointrecciato - Spindleclutch")
var5chesost := StrReplace(var5chesost, "Tempest Island", "Isola della Tempesta - Tempest Island")
var5chesost := StrReplace(var5chesost, "Wayrest Sewers", "Fogne di Wayrest - Wayrest Sewers")
var5chesost := StrReplace(var5chesost, "Stone Garden", "Giardino di roccia - Stone Garden")
var5chesost := StrReplace(var5chesost, "Balarel Ruins", "Rovine di Balarel - Balarel Ruins")
var5chesost := StrReplace(var5chesost, "Silaseli Ruins", "Rovine di Silaseli - Silaseli Ruins")
var5chesost := StrReplace(var5chesost, "Root Sunder Ruins", "Rovine di radici spezzate - Root Sunder Ruins")
var5chesost := StrReplace(var5chesost, "Icereach", "Gelodistesa - Icereach")
var5chesost := StrReplace(var5chesost, "Cradle of Shadows", "Culla di ombre - Cradle of Shadows")
var5chesost := StrReplace(var5chesost, "Scalecaller Peak", "Picco del scalatore - Scalecaller Peak")
var5chesost := StrReplace(var5chesost, "Bloodroot Forge", "Forgia delle radici sanguinanti - Bloodroot Forge")
var5 := var5chesost
}
; Ricostruisco la riga e la accodo a output
v := """"
v1 := ""","""
rowLine := v . var1 . v1 . var2 . v1 . var3 . v1 . var4 . v1 . var5 . v . "`n"
output .= rowLine
return

Normalize(value) {
    value := Trim(value)
    if (SubStr(value,1,1) = """") && (SubStr(value,0) = """")
        value := SubStr(value, 2, StrLen(value) - 2)
    ; rimuovi BOM iniziale se presente
    if (StrLen(value) >= 3 && Asc(SubStr(value,1,1)) = 239)
        value := SubStr(value, 4)
    return value
}