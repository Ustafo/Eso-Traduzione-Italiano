#NoEnv
#SingleInstance Force
#Persistent
SetWorkingDir %A_ScriptDir%               ; tutti i file su questa cartella

FileEncoding, UTF-8
SendMode Input
#MaxMem 256
configFile := "impostazioni.ini"
MaxBlockSize := 30000
MaxBlockSize := 10000
valorizzarighevuote := 0     ; se =1, duplica le righe mancanti fino a 4


menu, tray, add,traduce file it.lang,traduce
menu, tray, add,prepara file it.lang,preparafile

blockText := ""
blockNumber := 1
blockNumberPrev := 0
allBlocks := ""

processasolofiletempfinali := 0  ; da abilitare solo per prerare il file finale con i nomi misti
processasolofileunione := 0

CoordMode, ToolTip, Screen  

;global debugBuffer := ""
;global qCallCount := 
;msgbox 
return

traduce:

controlloversionihash := 1  ; controlla hash della stringa per vedere se e corrispondente alla versione francese

filedelete,righenonordinate.txt

; — array di lingue e nomi di variabili —
langNames := ["SPAGNOLO", "FRANCESE", "INGLESE", "ITALIANO"]
langVars  := ["fileES"   , "fileFR"    , "fileEN"   , "fileIT"   ]





; Legge percorso file correzione
IniRead, fileCorrezione, %configFile%, Percorsi, filecorrezione, NOT_FOUND
if (fileCorrezione = "NOT_FOUND" || !FileExist(fileCorrezione)) {
    FileSelectFile, fileCorrezione, 3,, Seleziona il file con le correzioni
    if (!fileCorrezione)
        ExitApp
    IniWrite, %fileCorrezione%, %configFile%, Percorsi, filecorrezione
}

; Legge percorso file consolidata
IniRead, fileConsolidata, %configFile%, Percorsi, CONSOLIDATA, NOT_FOUND
if (fileConsolidata = "NOT_FOUND" || !FileExist(fileConsolidata)) {
    FileSelectFile, fileConsolidata, 3,, Seleziona il file di traduzione consolidata
    if (!fileConsolidata)
        ExitApp
    IniWrite, %fileConsolidata%, %configFile%, Percorsi, CONSOLIDATA
}

; --- Selezione/file ini per le 4 lingue ---
Loop, % langNames.MaxIndex() {
    name    := langNames[A_index]   ; SPAGNOLO, FRANCESE, …
    varName := langVars[A_index]    ; "fileES", "fileFR", …

    ; leggo il percorso da INI
    IniRead, tmp, %configFile%, Percorsi, %name%, NOT_FOUND

    ; se non esiste o non valido, lo chiedo all’utente
    if (tmp = "NOT_FOUND" || !FileExist(tmp)) {
        FileSelectFile, tmp, 3,, % "Seleziona file " . name
        if (!tmp)
            ExitApp
        IniWrite, %tmp%, %configFile%, Percorsi, %name%
    }

    ; assegno a fileES/fileFR/... usando variabile dinamica
    %varName% := tmp
}

; --- Verifica veloce ---
;MsgBox, %     "fileES = " fileES "`n"  . "fileFR = " fileFR "`n"  . "fileEN = " fileEN "`n"  . "fileIT = " fileIT

; ora fileES,fileFR,fileEN,fileIT contengono i quattro percorsi
; e puoi costruire:
filesFinali := [ fileES, fileFR, fileEN, fileIT ]


IniRead, fileCopilot, %configFile%, Percorsi, COPILOT, NOT_FOUND
if (fileCopilot = "NOT_FOUND" or !FileExist(fileCopilot)) {
    FileSelectFile, fileCopilot, 3,, Seleziona il file Copilot
    if (!fileCopilot) {
        MsgBox, Operazione annullata.
        ExitApp
    }
    IniWrite, %fileCopilot%, %configFile%, Percorsi, COPILOT
}





if (processasolofileunione = 1)
goto,vai

if (processasolofiletempfinali = 1)
goto,filefinalitemp



; === Opreparazione array multidimensionale francese ===
tooltip,Opreparazione array multidimensionale francese,0,0

modificato := false  ; Flag per sapere se è stato cambiato qualche hash

arrayFR := []
contaFR := 0


FileRead, contenuto, %fileFR%



; Normalizza: tutti i CRLF diventano solo LF
contenuto := StrReplace(contenuto, "`r`n", "`n")

rows := StrSplit(contenuto, "`n")
contaFR := 0

for index, row in rows {
    if (row = "")
        continue

      v = "ID","Unknown","Index"
      if instr(row,v)
        {
         ;MSGBOX TROVATO
         continue          
        }   


    ; parsing CSV (5 campi, separati da "," e racchiusi da virgolette)
    fields := StrSplit(SubStr(row, 2, -1), """,""")
    if (fields.MaxIndex() = 5) {
        id1 := fields[1] + 0
        id2 := fields[2] + 0
        id3 := fields[3] + 0
        codice := fields[4]
        testo := fields[5]

        if !(SubStr(codice, 1, 2) = "FR") {
            hash := JSHash(testo)
            codice := "FR" . hash
            modificato := true
        }

        arrayFR[++contaFR, 1] := id1
        arrayFR[contaFR, 2] := id2
        arrayFR[contaFR, 3] := id3
        arrayFR[contaFR, 4] := codice
        arrayFR[contaFR, 5] := testo
    }
    
    
  

; X DEBUG
;righe := a_index
;if (righe  <> contaFR)
 ;  msgbox % clipboard :=  righe " " contaFR " " id1 " " id2 " " id3 " " codice " " testo " ---- " id1p " " id2p " " id3p " " codicep " " testop

 ;       id1p := id1
 ;       id2p := id2
 ;       id3p := id3
 ;       codicep := codice
 ;       testop := testo


}

;msgbox % "fre4 " righe "--" contaFR

;-----------------------------------------
;tooltip quicksort array francese ,0,0
;righe := arrayFR.Length()
;SortPseudoMatrixAssoc(arrayFR, righe) ;--------------------------------------------------
;modificato := 1
;-----------------------------------------


;arrayFR := QuickSort(arrayFR, True, 3)
;arrayFR := QuickSort(arrayFR, True, 2)
;arrayFR := QuickSort(arrayFR, True, 1)




if (modificato) {
    tooltip SCRITTURA array francese ,0,0
    contenutoFR = "ID","Unknown","Index","Offset","Text"`n
    N1 := contaFR // 100
    if (N1 < 1)
    N1 := 1 
    Loop % contaFR 
    {
     if (Mod(A_Index, N1) = 0)

        Tooltip,  SCRITTURA array francese %A_INDEX% di %contaFR% righe…, 10, 10 
    
         contenutoFR .= FormatCsvRow(arrayFR[A_index, 1], arrayFR[A_index, 2], arrayFR[A_index, 3], arrayFR[A_index, 4], arrayFR[A_index, 5])
    righe := a_index
    }
    


    FileDelete, %fileFR%
    Sleep 500
    FileAppend, %contenutoFR%, %fileFR%
       
      ; msgbox % "fre5 " righe
 
RemoveCsvHeader(arrayFR)

;LiberaMemoria(contenutoFR)

 
    
    
    
}





; === ORDINAMENTO FILE COPILOT ===
cancella:                                        ;-------------------------------------------------------------
tooltip,Ordinamento Copilot,0,0





; === ORDINAMENTO COPILOT ===
;array_ordinamento := caricafileinarraymulticolonna(fileCopilot,numerocolonne,1)  ; controlla il file per trovare errori


array_ordinamento := caricafileinarraymulticolonna(fileCopilot,numerocolonne,1)
RemoveCsvHeader(array_ordinamento)
;goto, cancella1
;msgbox %  "as3 " array_ordinamento.Length()

tooltip,Ordinamento Copilot quicksort,0,0


righe := array_ordinamento.Length()
;SortPseudoMatrixAssoc(array_ordinamento, righe) 
;array_ordinamento := QuickSort(array_ordinamento, True, 3)
;array_ordinamento := QuickSort(array_ordinamento, True, 2)
;array_ordinamento := QuickSort(array_ordinamento, True, 1)
;array_ordinamento := SortPseudoMatrixAssoc(array_ordinamento, righe)

;goto scrivi
sleep 1000

;msgbox % "as6 " array_ordinamento.Length()



arrayConsolidata := caricafileinarraymulticolonna(fileConsolidata, numerototrighe,0)


arrayEN := caricafileinarraymulticolonna(fileEN, numerototrighe,0)


tooltip,Ordinamento Copilot rimuoviDuplicatiConConflitti,0,0
;msgbox % "dw1 "  array_ordinamento.Length()

array_ordinamento := RimuoviDuplicatiConConflitti(array_ordinamento) ;---------------------------------------------------
;msgbox % "dw2 "  array_ordinamento.Length()



;msgbox % "dw1 "  array_ordinamento.Length()
sleep 100
;msgbox %  array_ordinamento.Length()

;array_ordinamento := QuickSort(array_ordinamento, True, 3)
;array_ordinamento := QuickSort(array_ordinamento, True, 2)
;array_ordinamento := QuickSort(array_ordinamento, True, 1)
righe := array_ordinamento.Length()
SortPseudoMatrixAssoc(array_ordinamento, righe) ;--------------------------------------------------

;msgbox % "dw3 "  array_ordinamento.Length()
sleep 100



tooltip,Ordinamento Copilot controlloversionihash,0,0
if (controlloversionihash = 1) {
    ;array_ordinamento := ConfrontaArrayPerChiavi(arrayFR, array_ordinamento, controllohash := 0, forzascritturahashsuarrayord := 1, saltaVuote := 0, salvaFix := 1)
    array_ordinamento := ConfrontaArrayPerChiavi(arrayFR, array_ordinamento, controllohash := 1, forzascritturahashsuarrayord := 0, saltaVuote := 0, salvaFix := 1)
    ;(arrayFR, arrayOrd, controllohash := 1, saltaVuote := 0, salvaFix := 0)    
    ;array_ordinamento := ConfrontaArrayPerChiavi(arrayFR, array_ordinamento,1,0,1) -----------------------------------------------------

}

;msgbox % "dw4 "  array_ordinamento.Length()
sleep 100


righe := array_ordinamento.Length()
;SortPseudoMatrixAssoc(array_ordinamento, righe) ;---------------------------------------------------------




cancella1:




tooltip,creazione array consolidata,0,0
;caricafileinarraymulticolonna(fileConsolidata,ByRef numerototrighe) {
arrayConsolidata := caricafileinarraymulticolonna(fileConsolidata, numerototrighe,0)

;RemoveCsvHeader(arrayConsolidata)

;msgbox % "dc2 consolidata "  arrayConsolidata.Length()


;SortPseudoMatrixAssoc(array_ordinamento, righe)                                  
                                          ; controllohash=1, forzascritturahashsuarrayord := 1, saltaVuote=1, salvaFix=1
arrayConsolidata := ConfrontaArrayPerChiavi(arrayFR, arrayConsolidata, 1, 0,0,1)


;righe := arrayConsolidata.Length()
;SortPseudoMatrixAssoc(arrayConsolidata, righe) ;--------------------------------------------------


;msgbox controlla



idxCons := 1
maxCons := arrayConsolidata.MaxIndex()


;msgbox % "dw5 prima salta traduzione "  array_ordinamento.Length()

tooltip, Applico filtro “SALTA_TRADUZIONE”…,0,0
array_ordinamento := ApplicaFiltroSaltaTraduzione(arrayFR, array_ordinamento, arrayConsolidata)

;msgbox % "dw6 sopo sata traduzione "  array_ordinamento.Length()

sleep 100


 numeroRighe := array_ordinamento.Length()
 
SortPseudoMatrixAssoc(array_ordinamento, numeroRighe)
 
 ;msgbox % "dw6 "  array_ordinamento.Length()
; tooltip,Fill Salta Traduzione Con Precedente,0,0
;array_ordinamento := FillSaltaTraduzioneConPrecedente(array_ordinamento)   ; prob non serve a niente

tooltip,Ordinamento Copilot preparazione variabile unita,0,0
sleep 100



scrivi:


contenuto := ""
for idx, riga in array_ordinamento {
    if (riga[1] != "")
        contenuto .= FormatCsvRow(riga[1], riga[2], riga[3], riga[4], riga[5])
}

if (contenuto = "") {
    MsgBox, 16, Errore, Il file Copilot è vuoto o non preparato correttamente.
    ExitApp
}

tooltip,Ordinamento Copilot scrittura su file  variabile unita,0,0


FileDelete, %fileCopilot%
Sleep 500
FileAppend, %contenuto%, %fileCopilot%

msgbox salvato file copilot

LiberaMemoria(contenuto)
;LiberaMemoria(array_ordinamento)


filefinalitemp:
; === Identifica chiavi comuni escludendo quelle già tradotte ===
tooltip,lavoro sui total finale Identifica chiavi comuni escludendo quelle già tradotte ,0,0

;msgbox % "rt4 " arrayFR[5,5]
;msgbox % "rt5 " array_ordinamento[5,5]






;msgbox % "bebe arrayConsolidata.MaxIndex "   arrayConsolidata.MaxIndex() " "   fileConsolidata
;msgbox % "bebe arrayFR.MaxIndex "   arrayFR.MaxIndex()
;msgbox % "bebe array_ordinamento.MaxIndex "   array_ordinamento.MaxIndex()

; 1) crei il filtered‐array

;msgbox % "d2t1 "  arrayFR.Length()



;arrayFRfiltrato := ConfrontaLinguaEscludendoArray(arrayFR, array_ordinamento, arrayConsolidata)
arrayFRfiltrato := ElaboraLinguaSingola(fileFR, "tempFRfinale.txt", array_ordinamento, arrayConsolidata,"arrayFR")

;msgbox % "d2t0 "  arrayFRfiltrato.Length()

;msgbox % "bebi arrayFRfiltrato.MaxIndex "   arrayFRfiltrato.MaxIndex()
;msgbox % righe := arrayFRfiltrato.MaxIndex()
;colonne := 5

;msgbox % "bebi arrayFRfiltrato.MaxIndex "   arrayFRfiltrato.MaxIndex()
;arrayFRfiltrato := QuickSort2D(arrayFRfiltrato, righe, colonne, [3,2,1])
; 1) ordina per campo 3 (terziario)


;arrayFRfiltrato := SortMulti(arrayFRfiltrato, [3, 2, 1])
;msgbox % "bebi3 arrayFRfiltrato.MaxIndex "   arrayFRfiltrato.MaxIndex()
; 2) ordina per campo 2 (secondario)
;arrayFRfiltrato := SortMerge(arrayFRfiltrato, 2)
;msgbox % "bebi2 arrayFRfiltrato.MaxIndex "   arrayFRfiltrato.MaxIndex()
; 3) ordina per campo 1 (primario)
;arrayFRfiltrato := SortMerge(arrayFRfiltrato, 1)
;msgbox % "bebi1 arrayFRfiltrato.MaxIndex "   arrayFRfiltrato.MaxIndex()


;righe := arrayFRfiltrato.MaxIndex()
;arrayFRfiltrato := SortPseudoMatrixAssoc(arrayFRfiltrato, righe)






; 2) ordini
;arrayFRfiltrato := QuickSort(arrayFRfiltrato, True, 3)
;msgbox % "dwt2 "  arrayFRfiltrato.Length()
;arrayFRfiltrato := QuickSort(arrayFRfiltrato, True, 2)
;msgbox % "dwt1 "  arrayFRfiltrato.Length()
;arrayFRfiltrato := QuickSort(arrayFRfiltrato, True, 1)
;msgbox % "dwt0 "  arrayFRfiltrato.Length()

;msgbox % "bebi arrayFRfiltrato.MaxIndex "   arrayFRfiltrato.MaxIndex()

; 3) scrivi su file
ScriviArrayFinale("tempFRfinale.txt", arrayFRfiltrato)

; 4) sostituisci l’array “vecchio” con il “nuovo”
arrayFR := arrayFRfiltrato
contaFR := ""




;msgbox spagnolo

arrayES := ElaboraLinguaSingola(fileES, "tempESfinale.txt", array_ordinamento, arrayConsolidata,"arrayES")

arrayEN := ElaboraLinguaSingola(fileEN, "tempENfinale.txt", array_ordinamento, arrayConsolidata,"arrayEN")

arrayIT := ElaboraLinguaSingola(fileIT, "tempITfinale.txt", array_ordinamento, arrayConsolidata,"arrayIT")





LiberaMemoria(array_ordinamento)
LiberaMemoria(arrayConsolidata)

  tooltip,lavoro sui total finale ScriviArrayFinale ,0,0 
    ScriviArrayFinale(fileTemp, arrayFinale)
    LiberaMemoria(arrayFinale)  ; 💨 Libera RAM occupata
    Sleep 500



if (commonKeys.Length() = 0) {
    MsgBox, 48, Nessuna corrispondenza!, Nessuna chiave utile trovata (o tutte già nel file di traduzioni consolidate con contenuto pieno).
    ExitApp
}



vai:
    tooltip, Preparazione file finale a blocchi…, 0, 0
    
    FileAppend, % "[DBG vai:] prima di CreaBlocchiFrammentabili`n", %debugFile%
    MsgBox, 64, DEBUG, Invoco CreaBlocchiFrammentabili ora

   

    ; --- 2) Oppure, se preferisci il wrapper che carica array in memoria prima ---
CreaBlocchiFrammentabili(arrayFR, arrayES, arrayEN, arrayIT, "unionetraduzioni.txt", MaxBlockSize)




    ExitApp

; === Funzioni ===








;------------------------------------------------------------------------------  
; Funzione CSV di utilità  
;------------------------------------------------------------------------------  
FormatCsvRow(id1,id2,id3,v4,v5) {
    return """" id1 """,""" id2 """,""" id3 """,""" v4 """,""" v5 """`r`n"
}




; crea la riga con chiave composta
CreateRow(r) {
    id1 := r[1]+0, id2 := r[2]+0, id3 := r[3]+0
    Key := id1 * 1000000 + id2 * 1000 + id3
    Return [ Key, id1, id2, id3, r[4], r[5] ]
}

; confronta solo le chiavi (sempre numeriche)
CompareKey(a, b) {
    Return a[1] < b[1] ? -1 : (a[1] > b[1] ? 1 : 0)
}



;===============================================================================
; ApplicaFiltroSaltaTraduzione – filtra con “SALTA TRADUZIONE”, genera raw file
;                    e mostra tooltip di avanzamento su entrambi i cicli
;
; arrayLingua : matrice [idx][1..5] con i dati “francese”
; arrayOrd    : matrice [idx][1..5] con i dati da popolare (traduzioni)
; Restituisce arrayFiltrato e crea rawtraduzionecopilot.txt
;===============================================================================
ApplicaFiltroSaltaTraduzione(arrayLingua, arrayOrd, arrayConsolidata)
{
;LogArray("INIZIO SALTA", arrayConsolidata)

    global arrayhashord 
    filecorrezione := "filecorrezioni.txt"
     numerocolonneCorrez := 5  
    arrayScartate := [] 
    rielabora := 0
 
    
     Tooltip,  pre processa per eliminare tutte le righe con SaltaTraduzione…,0,0

    ; === Preprocessing: rimuovo righe SALTA TRADUZIONE da arrayOrd ===
    arrayOrdPulito := []
    for i, row in arrayOrd {
        if (row[5] != "SALTA TRADUZIONE")
            arrayOrdPulito.Push(row)
    }
    arrayOrd := arrayOrdPulito  

   Tooltip,   Applica Filtro SaltaTraduzione…,0,0

    ;--- 0) Carica file correzioni e costruisci hashCorrezioni e arrayConsolidata ---
    arrayCorrezioni := caricafileinarraymulticolonna(filecorrezione,numerototrighe,0)
    RemoveCsvHeader(arrayCorrezioni)
    
   numeroRighe := arrayCorrezioni.MaxIndex()
    arrayCorrezioni := SortPseudoMatrixAssoc(arrayCorrezioni, numeroRighe)
    
    
   


    ; inizializza strutture di appoggio
    
    ;arrayConsolidata := []   ; matrice con id1,id2,id3
    
    ; === Confronto incrociato con arrayLingua (francese) ===
    idxCorr := 1
    idxFr   := 1
    maxCorr := arrayCorrezioni.MaxIndex()
    maxFr   := arrayLingua.MaxIndex()
    correzioniModificate := false
    arrayCorrezioniPulito := []


; === Allinea correzioni con arrayLingua e completa eventuali ID FR mancanti ===


while (idxCorr <= maxCorr && idxFr <= maxFr)
{
    ; --- valori della riga correzioni ---
    c1 := arrayCorrezioni[idxCorr,1]
    c2 := arrayCorrezioni[idxCorr,2]
    c3 := arrayCorrezioni[idxCorr,3]

    ; --- valori della riga lingua ---
    f1 := arrayLingua[idxFr,1]
    f2 := arrayLingua[idxFr,2]
    f3 := arrayLingua[idxFr,3]

    ;--- confronto per ordinamento tipo merge sort ---
    if (c1+0 < f1+0 
     || (c1+0 = f1+0 && c2+0 < f2+0) 
     || (c1+0 = f1+0 && c2+0 = f2+0 && c3+0 < f3+0))
    {
        idxCorr++
        correzioniModificate := true
    }
    else if (c1+0 > f1+0 
          || (c1+0 = f1+0 && c2+0 > f2+0) 
          || (c1+0 = f1+0 && c2+0 = f2+0 && c3+0 > f3+0))
    {
        idxFr++
    }
    else
    {
        ; stesso record → controllo codice FR
        frKey      := Trim(arrayLingua[idxFr,4])
        corrKey    := Trim(arrayCorrezioni[idxCorr,4])

        ; normalizza (solo cifre) per l’array pulito
        corrKeyNum := StrReplace(corrKey, "FR")
        frKeyNum   := StrReplace(frKey, "FR")

        if (corrKey = "" || !RegExMatch(corrKey, "^FR[0-9]+$")) {
            ; se manca o non valido → aggiorno con quello da lingua
            arrayCorrezioni[idxCorr,4] := frKey
            correzioniModificate := true
            arrayCorrezioniPulito.Push([c1, c2, c3, frKeyNum, arrayCorrezioni[idxCorr,5]])
        }
        else if (corrKey = frKey) {
            arrayCorrezioniPulito.Push([c1, c2, c3, corrKeyNum, arrayCorrezioni[idxCorr,5]])
        }
        else {
            correzioniModificate := true
        }

        idxCorr++
        idxFr++
    }
}

; se modificato → riscrivo file correzioni
if (correzioniModificate) {
    ScriviArrayFinale(filecorrezione, arrayCorrezioni)
}

; === Riempimento arrayConsolidata (prime 3 colonne originali) ===
;Loop % arrayCorrezioni.MaxIndex()
;{
;    arrayConsolidata[A_Index,1] := arrayCorrezioni[A_Index,1]
;    arrayConsolidata[A_Index,2] := arrayCorrezioni[A_Index,2]
;    arrayConsolidata[A_Index,3] := arrayCorrezioni[A_Index,3]
;}


if !IsObject(arrayhashord)
    arrayhashord := Object()
Loop % arrayCorrezioniPulito.MaxIndex()
{
    ; Forzo la chiave a stringa per preservare eventuali zeri iniziali
    hash := "" . arrayCorrezioniPulito[A_Index,4]
    
 ;   if (hash = "1046933902") {
 ;   MsgBox, 64, Debug Correzione, % "Trovato hash in correzioniPulito!`nHash: " hash "`nTesto: " arrayCorrezioniPulito[A_Index,5]
;}  ;cancellaaa
    
    
    ; Scrivo nella mappa
    arrayhashord[hash] := arrayCorrezioniPulito[A_Index,5]
}
 
 
 
    
    totalerighe          := arrayLingua.MaxIndex()
    massimerighea        := arrayOrd.MaxIndex()
  

    ;--- 1) Costruisco arrayhashord con traduzioni valide + correzioni ---
    n1 := massimerighea // 30
    if (n1 < 1) n1 := 1

    ;arrayhashord := Object()
    Loop % massimerighea
    {
        ;if (Mod(A_Index, n1) = 0)
        if (n = "")
        n:= 0
        
        n := n + 1
        
        if (n = 4000)
         {
         Tooltip, Filtro1: %A_Index% di %massimerighea% traduzioni…, 10, 10
         n := 0
         }

        raw4 := "" . StrReplace(arrayOrd[A_Index,4], "FR")
     
        txt  := arrayOrd[A_Index,5]      
        
        
  ;if (raw4 = "1046933902") {
  ;  MsgBox, 64, Debug da arrayOrd, % "Trovato hash in arrayOrd!`nRaw4: " raw4 "`nTesto originale: " txt "`nValore attuale in arrayhashord (prima): " arrayhashord[raw4] "`nSe sovrascrive: " (txt != "" && txt != "SALTA TRADUZIONE" ? "Sì" : "No")
;}  ;cancellaaa     
        
        
        
        txt  := arrayOrd[A_Index,5]
        


;if (txt != "" && txt != "SALTA TRADUZIONE") {
;    arrayhashord[raw4] := txt
;}
    
if (txt != "" && txt != "SALTA TRADUZIONE") {
    if (!arrayhashord.HasKey(raw4)) {  ; <--- Aggiungi questa if
        arrayhashord[raw4] := txt
    }  ; <--- e chiudi qui
}    
    
    
    
    
    }
    Tooltip, Filtro salta traduzione attivo,0,0



;chiaveTest := "1411589532"

;if (arrayhashord.HasKey(chiaveTest)) {
;    MsgBox, 64, Debug, % "✅ In arrayhashord esiste la chiave %chiaveTest% con testo:`n" arrayhashord[chiaveTest]
;} else {
;    MsgBox, 48, Debug,   Nessuna chiave %chiaveTest% trovata in arrayhashord
;}

    
  PuntoMerge:  
  


    ;--- Preparazione output e indici di merge + SALTA_TRADUZIONE ---
    arrayFiltrato       := []
    indicearrayFiltrato := 1



    seenMissing := Object()
    idxCons      := 1
    maxCons      := arrayConsolidata.MaxIndex()



    indicearray  := 1
    indicearraya := 1

  nProg := totalerighe // 100
if (nProg < 1)
    nProg := 1 
   
   
   
   ;=== 2) Loop principale: merge + SALTA_TRADUZIONE + raccolta raw ===
    Loop
    {
        if (indicearray > totalerighe)
            break
            
 if (indicearraya > massimerighea || indicearrayb > massimerigheb)
    break           

    ; ogni nProg righe aggiorno il tooltip
    if (Mod(indicearray, nProg) = 0)
        Tooltip, Merge: %indicearray% di %totalerighe% righe…, 10, 10


        ;--- Prelievo dalla lingua ---
        var1   := arrayLingua[indicearray,1]
        var2   := arrayLingua[indicearray,2]
        var3   := arrayLingua[indicearray,3]
        raw4f  := arrayLingua[indicearray,4]
        raw4   := "" . StrReplace(raw4f, "FR")
        keyFR  := "FR" . raw4

;if (raw4 = "1046933902") {
;    info := "Trovato hash in merge!`nRaw4: " raw4 "`nHasKey in arrayhashord: " (arrayhashord.HasKey(raw4) ? "Sì, testo: " arrayhashord[raw4] : "No") "`nConsolidata? " (idxCons <= maxCons && arrayConsolidata[idxCons,1]=var1 && arrayConsolidata[idxCons,2]=var2 && arrayConsolidata[idxCons,3]=var3 ? "Sì" : "No")
;    MsgBox, 64, Debug Merge, %info%
;}


/*/

; --- DEBUG mirato SOLO per hash ---
hash_chk := "1411589532"  ; sostituisci con l'hash della riga problematica

if (raw4 = hash_chk)  ; confronto diretto con la chiave
{
    info := ""
    info .= "Match su hash!`n"
    info .= "ID1=" var1 " (tipo: " (var1+0 = var1 ? "Integer" : "String") ")`n"
    info .= "ID2=" var2 " (tipo: " (var2+0 = var2 ? "Integer" : "String") ")`n"
    info .= "ID3=" var3 " (tipo: " (var3+0 = var3 ? "Integer" : "String") ")`n"
    info .= "raw4=" raw4 " (tipo: " (raw4+0 = raw4 ? "Integer" : "String") ")`n"
    info .= "HasKey(raw4): " (arrayhashord.HasKey(raw4) ? "Sì" : "No") "`n"
    info .= "Valore in mappa: " arrayhashord[raw4] "`n"
    info .= "Tipo chiave mappa attesa: " (hash_chk+0 = hash_chk ? "Integer" : "String")

    MsgBox, 64, Debug hash, %info%
}



*/



        ;--- Prelievo da arrayOrd (o valori “finti” oltre il limite) ---
        if (indicearraya > massimerighea)
        {
            vara1 := 99999999999999
            vara2 := ""
            vara3 := ""
            vara4 := ""
            vara5 := ""
        }
        else
        {
            vara1 := arrayOrd[indicearraya,1]
            vara2 := arrayOrd[indicearraya,2]
            vara3 := arrayOrd[indicearraya,3]
            vara4 := "" . StrReplace(arrayOrd[indicearraya,4], "FR")
            vara5 := arrayOrd[indicearraya,5]
        
        
        
        
        
        
        
      if (vara4 != "" && vara5 != "" && (Trim(vara5) != "SALTA TRADUZIONE") && (Trim(vara5) != "Salta traduzione"))
       {
        if (!arrayhashord.HasKey(vara4)) 
        {
            arrayhashord[vara4] := vara5
        }
        ; Se prima l’avevamo segnata mancante, ora sappiamo che esiste: rifai il giro
        if (seenMissing.HasKey(vara4))
            rielabora := true
       }
     
    }    
        
        
        
        

        ;--- Confronto stile “merge sort” su colonne 1–3 ---
        if ( var1+0 < vara1+0
          || (var1+0 = vara1+0 && var2+0 < vara2+0)
          || (var1+0 = vara1+0 && var2+0 = vara2+0 && var3+0 < vara3+0)
          || (var1+0 = vara1+0 && var2+0 = vara2+0 && var3+0 = vara3+0) )
        {
            ; 2.1) Skip delle già “consolidate”
            Loop
            {
                if (idxCons > maxCons)
                    break
                c1 := arrayConsolidata[idxCons,1]
                c2 := arrayConsolidata[idxCons,2]
                c3 := arrayConsolidata[idxCons,3]
                if (c1+0 > var1+0
                 || (c1+0 = var1+0 && c2+0 > var2+0)
                 || (c1+0 = var1+0 && c2+0 = var2+0 && c3+0 >= var3+0))
                    break
                idxCons++
            }





/*/


; >>> QUI BLOCCO 1 <<<
; --- DEBUG ramo per hash specifico ---
hash_chk := "1411589532"   ; il tuo hash
if (raw4 = hash_chk) {
    c1 := (idxCons <= maxCons) ? arrayConsolidata[idxCons,1] : ""
    c2 := (idxCons <= maxCons) ? arrayConsolidata[idxCons,2] : ""
    c3 := (idxCons <= maxCons) ? arrayConsolidata[idxCons,3] : ""
    isCons := (idxCons <= maxCons && c1 = var1 && c2 = var2 && c3 = var3)

    info := ""
    info .= "HASH=" raw4 "`n"
    info .= "Consolidata? " (isCons ? "Sì" : "No") "`n"
    info .= "Cons idx=" idxCons " di " maxCons "`n"
    info .= "Cons tripletta: [" c1 "," c2 "," c3 "]`n"
    info .= "Lingua tripletta: [" var1 "," var2 "," var3 "]"
    MsgBox, 64, RamoMerge, %info%
}

*/




            if (idxCons <= maxCons
             && arrayConsolidata[idxCons,1]=var1
             && arrayConsolidata[idxCons,2]=var2
             && arrayConsolidata[idxCons,3]=var3)
            {
              arrayScartate.Push([var1, var2, var3, keyFR, "SCARTATA_CONSOLIDATA"])
            
            
                           if (raw4 = hash_chk)
                    MsgBox, 64, Esito, % "HASH=" raw4 " → SALTATA perché già consolidata"
   
   
   
   
   
                idxCons++
            }
            else
            {
                ; 2.2) Traduzione valida → inserimento semplice
            
            
        
                
                if (arrayhashord.HasKey(raw4))
                {
                
                
                
                      if (raw4 = hash_chk)
                        MsgBox, 64, Esito, % "HASH=" raw4 " → INSERITA da arrayhashord con testo:`n" arrayhashord[raw4]             
                
                
                
               
                    arrayFiltrato[indicearrayFiltrato,1] := var1
                    arrayFiltrato[indicearrayFiltrato,2] := var2
                    arrayFiltrato[indicearrayFiltrato,3] := var3
                    arrayFiltrato[indicearrayFiltrato,4] := keyFR
                    arrayFiltrato[indicearrayFiltrato,5] := arrayhashord[raw4]
                    indicearrayFiltrato++
                    
       ; SE ERA UNA CHIAVE PRIMA MARCATA MANCANTE → setta il flag di rielaborazione
    if (seenMissing.HasKey(raw4)) {
        rielabora := true
    }                 
                    
                    
                }
                else
                {
                
                
                     if (raw4 = hash_chk)
                        MsgBox, 48, Esito, % "HASH=" raw4 " → MANCANTE, va su SALTA_TRADUZIONE"              
                
                
                
                    ; 2.3) Traduzione mancante:
                    ;      prima occorrenza → solo raw,
                    ;      seconda+ → SALTA_TRADUZIONE
                    if (!seenMissing.HasKey(raw4))
                        seenMissing[raw4] := true
                    else
                    {
                        arrayFiltrato[indicearrayFiltrato,1] := var1
                        arrayFiltrato[indicearrayFiltrato,2] := var2
                        arrayFiltrato[indicearrayFiltrato,3] := var3
                        arrayFiltrato[indicearrayFiltrato,4] := keyFR
                        arrayFiltrato[indicearrayFiltrato,5] := "SALTA TRADUZIONE"
                        indicearrayFiltrato++
                    }
                }
            }

            ; avanzamento indici
            if (var1 = vara1 && var2 = vara2 && var3 = vara3)
                indicearraya++
            indicearray++
        }
        else
        {
            ; arrayOrd precede → avanzo solo indicearraya
            indicearraya++
        }
    }
    Tooltip  ; nasconde eventuale tooltip residuo





   ; Se sono emerse traduzioni nuove, ricalcolo l'hash e rifaccio il merge
    if (rielabora) {
    goto PuntoMerge  ; etichetta subito prima del loop principale
    }








;LogArray("FINE SALTA", arrayConsolidata)
; === Scrittura finale RAW (solo all’ultima passata) ===
fileRaw := "rawtraduzionecopilot.txt"
arrayRawFinal := []

for i, row in arrayFiltrato
{
    if (Trim(row[5]) != "SALTA TRADUZIONE")
        arrayRawFinal.Push(row)
}

if (arrayRawFinal.Length() > 0)
    ScriviArrayFinale(fileRaw, arrayRawFinal)
else
    MsgBox, ⚠️ Nessuna traduzione trovata per %fileRaw%


fileDebugScartate := "righe_scartate.txt"
filedelete, %fileDebugScartate%
if (arrayScartate.Length() > 0) {
    ScriviArrayFinale(fileDebugScartate, arrayScartate)
} 


    Tooltip, Filtro salta traduzione applicato, 0, 0
    return arrayFiltrato
}





LogArray(titolo, arr) {
    out := titolo . " (" . arr.Length() . " righe):"
    for i, r in arr
        out .= "`n" . i . ": " . r[1] . "," . r[2] . "," . r[3]
    FileAppend, %out%`n`n, debug_log.txt
}


ConfrontaLinguaEscludendoArray(arrayLingua, arrayOrd, arrayConsolidata) {
  tooltip, % "Confronta Lingua Escludendo  Array " arrayLingua.MaxIndex() "--" arrayOrd.MaxIndex() "-- " arrayConsolidata.MaxIndex() ,0,0
  
    arrayFiltrato := []
    indicearray := 1
    indicearraya := 1
    indicearrayb := 1
    indicearrayfiltrato := 1
    oka := 0
    okb := 0  
    totalerighe := arrayLingua.MaxIndex()
    massimerighea := arrayOrd.MaxIndex()
    massimerigheb := arrayConsolidata.MaxIndex()
    indicetooltip := 0
    controllaa := 0
    controllab := 0
    scartariga := 0 
    

  logBuffer := ""
  
  
  Loop
   {
       ;msgbox % indicearray ">" totalerighe
       if (indicearray > totalerighe)
         break
        
        var1 := arrayLingua[indicearray,1] + 0
        var2 := arrayLingua[indicearray,2] + 0
        var3 := arrayLingua[indicearray,3] + 0
        var4 := arrayLingua[indicearray,4] 
        var5 := arrayLingua[indicearray,5] 

  ; Controllo ordinamento in arrayLingua

if (indicearray > 1)
{
    if ((var1+0 < var1_prev+0) or (var1+0 = var1_prev+0 and var2+0 < var2_prev+0)  or (var1+0 = var1_prev+0 and var2+0 = var2_prev+0 and var3+0 < var3_prev+0))
    {
    fileappend, Errore Ordinamento arrayLingua non ordinato alla riga %indicearray% var1 %var1% var2 %var2% var3 %var3% var4 %var4% var5 %var5% var1_prev %var1_prev% var2_prev %var2_prev% var3_prev %var3_prev%,righenonordinate.txt
        
    }
}
var1_prev := var1+0
var2_prev := var2+0
var3_prev := var3+0   
        
if  (indicearraya <= massimerighea)    
   {     
       
        
        vara1 := arrayOrd[indicearraya,1] + 0
        vara2 := arrayOrd[indicearraya,2] + 0
        vara3 := arrayOrd[indicearraya,3] + 0
        vara4 := arrayOrd[indicearraya,4] 
        vara5 := arrayOrd[indicearraya,5]     
  
  
if (indicearraya > 1) 
{
    if ((vara1 < vara1_prev) or (vara1 = vara1_prev and vara2 < vara2_prev) or (vara1 = vara1_prev and vara2 = vara2_prev and vara3 < vara3_prev))
    {
        fileappend, Errore Ordinamento arrayOrd non ordinato alla riga %indicearraya% var1 %vara1% var2 %vara2% var3 %vara3% var4 %vara4% var5 %vara5% var1_prev %vara1_prev% var2_prev %vara2_prev% var3_prev %vara3_prev%,righenonordinate.txt
        
    }
}
vara1_prev := vara1
vara2_prev := vara2
vara3_prev := vara3
    }
  else  
     oka := 1   
    
    
    
 if (indicearrayb <= massimerigheb )   
    {
    
    
        varb1 := arrayConsolidata[indicearrayb,1] + 0
        varb2 := arrayConsolidata[indicearrayb,2] + 0
        varb3 := arrayConsolidata[indicearrayb,3] + 0
        varb4 := arrayConsolidata[indicearrayb,4] 
        varb5 := arrayConsolidata[indicearrayb,5]     
        
if (indicearrayb > 1)
{
    if ((varb1 < varb1_prev)  or (varb1 = varb1_prev and varb2 < varb2_prev)  or (varb1 = varb1_prev and varb2 = varb2_prev and varb3 < varb3_prev))
    {
        fileappend, Errore Ordinamento arrayConsolidata non ordinato alla riga %indicearrayb% varb1 %varb1% var2 %varb2% varb3 %varb3% varb4 %varb4% varb5 %varb5% varb1_prev %varb1_prev% varb2_prev %varb2_prev% varb3_prev %varb3_prev%,righenonordinate.txt
        
    }
}
varb1_prev := varb1 
varb2_prev := varb2 
varb3_prev := varb3 

}
else
  okb := 1
;if ((var1+0 <> var1_prev+0) or (var1+0 = var1_prev+0 and var2+0 <> var2_prev+0)  or (var1+0 = var1_prev+0 and var2+0 = var2_prev+0 and var3+0 <> var3_prev+0))
;     {
;       oka := 0
;       okb := 0
;     }
     
     
            ;   if ((var1 = "101034709") and (var2 = "0") and (var3 = "1"))
            ;  msgbox %  "  oka " oka "okb " okb    "var1  " var1  "var2  " var2   "var3  " var3 "vara1  " vara1  "vara2  " vara2   "vara3  " vara3  "varb1  " varb1  "varb2  " varb2   "varb3  " varb3 

             ;  if ((var1 = "99527054") and (var2 = "0") and (var3 = "129043"))
            ;  msgbox %  "  oka " oka "okb " okb    "var1  " var1  "var2  " var2   "var3  " var3 "vara1  " vara1  "vara2  " vara2   "vara3  " vara3  "varb1  " varb1  "varb2  " varb2   "varb3  " varb3 


        

         ;   if  (indicearraya > massimerighea)
         ;   {
            ;msgbox %indicearraya% > %massimerighea%) or ( %vara1% = "")
        ;    vara1 := 99999999999
        ;    oka := 1
            ;msgbox % "massimerighea" massimerighea "vara1 " vara1
        ;    }
            
            
          ;if ((indicearrayb > massimerigheb) or (varb1 = ""))
        ;  if (indicearrayb > massimerigheb )
        ;    {
             ;msgbox %indicearrayb% > %massimerighea%) or ( %varb1% = "")
        ;    varb1 := 99999999999  
        ;    okb := 1
            ;msgbox % "massimerigheb" massimerigheb "varb1 " varb1
        ;    }     
  

  
       if ((oka = 0) and (scartariga  = 0))
        {
               ;if ((var1 = "101034709") and (var2 = "0") and (var3 = "1"))
              ;msgbox %  "1  oka " oka "okb " okb      
        
        
        if (vara1 < var1)
           {
            indicearraya := indicearraya + 1
            ;continue
           } 
          else
        ;msgbox vara1 > var1  -  %vara1% > %var1% "------ " vara3 > var3 - %vara3% > %var3% -- indicearray  %indicearray% > %totalerighe% -- indicearraya %indicearraya% -- indicearrayb  %indicearrayb% 
          if (vara1 > var1)
           {
           ;msgbox oka = 1
           oka := 1
           }
           else
        if (vara1 = var1 ) 
           controlloa := 2
         
 if  (controlloa = 2)      
      {   
             ;if ((var1 = "101034709") and (var2 = "0") and (var3 = "1"))
             ; msgbox %  "2  oka " oka "okb " okb
              
        if (vara2 < var2)
           {
            indicearraya := indicearraya + 1
            controlloa := ""
            ;continue
           } 
          else
          if (vara2 > var2)           
           oka := 1
        
        else
        if (vara2 = var2 ) 
           controlloa := 3
      
     }   
       
  if  (controlloa = 3)      
      {   
         
        if (vara3 < var3)
           {
            indicearraya := indicearraya + 1
           controlloa := ""
            ;continue
           } 
         else
          if (vara3 > var3)
           oka := 1
        
         else
        if (vara3 = var3 ) 
           {
            ;if ((var1 = "101034709") and (var2 = "0") and (var3 = "1"))
              ;msgbox %  "3  oka " oka "okb " okb
            oka := 0
            okb := 0
            scartariga := 1
            ;goto salta
           }
     }         
       
    }   
       
           
       
      if ((okb = 0) and (scartariga  = 0))
        {          
           if (varb1 < var1 )
           {
            indicearrayb := indicearrayb + 1
            
            ;continue
           }    
           else       
       
            ;msgbox   varb1 > var1  -  %varb1% > %var1% "------ " varb3 > var3  -  %varb3% > %var3% -- indicearray  %indicearray% > %totalerighe% -- indicearraya %indicearraya% -- indicearrayb  %indicearrayb% 
            if (varb1 > var1 )
             {
             ;msgbox okb = 1
             okb := 1     
             } 
             else
       
           if (varb1 = var1 ) 
           controllob := 2           
       
  if  (controllob = 2)      
      {   
         
        if (varb2 < var2)
           {
            indicearrayb := indicearrayb + 1
            controllob := ""
            ;continue
           }    
           else
          if (varb2 > var2)
           okb := 1
         else
        
        if (varb2 = var2 ) 
           controllob := 3
      
     }   
       
       
  if  (controllob = 3)      
      {   
         
        if (varb3+0 < var3+0)
           {
            indicearrayb := indicearrayb + 1
            controllob := ""
            ;continue
           }    
          else
          if (varb3 > var3)
           okb := 1
        else
        
        if (varb3 = var3 ) 
           {
            oka := 0
            okb := 0
            scartariga := 1
            
           }
     }  
     
    } 
    
  ;salta:  
  ;msgbox vara1 > var1  -  %vara1% > %var1% "------ " vara3 > var3 - %vara3% > %var3% -- varb1 > var1  -  %varb1% > %var1% "------ " varb3 > var3  -  %varb3% > %var3% indicearray  %indicearray% > %totalerighe% -- indicearraya %indicearraya% -- indicearrayb  %indicearrayb%  oka %oka%  okb %okb% controlloa %controlloa% controllob %controllob% scartariga %scartariga%
  
  
 ; --- BLOCCO SCARTO / COPIA CON PRIORITÀ ALLO SCARTO ---
 
 ; DEBUG: stato prima di decidere scarto/copia
 
; Log solo se la riga è da scartare o se è quella specifica da monitorare

  
;if ( scartariga = 1  or var1 = "101034709" )  ; qui il primo campo della riga problematica
;if (( var1 = "101034709" ) or (vara1 = "101034709") or (varb1 = "101034709"))
;{
;    logBuffer .= "DEBUG → i=" indicearray
;        . " oka=" oka
;        . " okb=" okb
;        . " scartariga=" scartariga
;        . " ia=" indicearraya
;        . " ib=" indicearrayb
;        . " → " var1 "," var2 "," var3 "," var4 "," var5 "vara1 "  vara1 " vara2 "  vara2 " vara3 "  vara3   " varb1 " varb1 " varb2 " varb2 " varb3 " varb3 " `n"
;}

if (indlogbuf = "")
    indlogbuf := 0

   indlogbuf := indlogbuf + 1

if (indlogbuf > 0)
   {
   FileAppend, %logBuffer%, debugLog.txt
   logBuffer := ""
   }


; 2️⃣ Controllo copia
if ( (oka = 1) and (okb = 1) )
{
    ; Copia la riga filtrata nell’array di output
    arrayFiltrato[indicearrayfiltrato,1] := var1
    arrayFiltrato[indicearrayfiltrato,2] := var2
    arrayFiltrato[indicearrayfiltrato,3] := var3
    arrayFiltrato[indicearrayfiltrato,4] := var4
    arrayFiltrato[indicearrayfiltrato,5] := var5

    ; Avanza indici
    indicearrayfiltrato := indicearrayfiltrato + 1
    indicearray := indicearray + 1

    ; Reset flag di controllo
    oka := 0
    okb := 0
    controlloa := 0
    controllob := 0

    ; Prossima iterazione
    
    
}
else

; 1️⃣ Controllo scarto
if ( (oka = 0 and okb = 0) or (scartariga = 1) )
{
    ; Avanza indice principale
    indicearray := indicearray + 1

    ; Reset flag di controllo
    controlloa := 0
    controllob := 0
    scartariga := 0   
    oka := 0
    okb := 0
    ; Passa direttamente alla prossima iterazione
    
    
}


          
;if ((previndicearraya = indicearraya) and (previndicearrayb = indicearrayb)   and (previndicearray = indicearray) )
;stallo := 0

;if ((indicearraya > massimerighea + 1 ) and ( indicearrayb > massimerigheb + 1)   and (indicearray > totalerighe + 1) )
;stallo := 0  
    
 
  
  
         indicetooltip := indicetooltip + 1
         if ((indicetooltip = 5000) or (stallo = 1))
           {
             tooltip, ho scritto %indicearray% di %totalerighe% righe oka %oka% okb %okb% vara1 %vara1% varb1 %varb1% var1 %var1% indicearray %indicearray% indicearraya %indicearraya% indicearrayb %indicearrayb% %arrayLingua% vara2 %vara2% varb2 %varb2% var2 %var2% vara3 %vara3% varb3 %varb3% var3 %var3%  ,0,0
             indicetooltip := 0
             stallo := 0
           }
           
       previndicearraya :=  indicearraya  
       previndicearrayb := indicearrayb 
       previndicearray  := indicearray
           
           
                  ;msgbox % var1 " " var2 " " var3 " " var4 " " var5 " " vara1 " " vara2 " " vara3 " " vara4 " " vara5 " " varb1 " " varb2 " " varb3 " " varb4 " " varb5  " indicearray " indicearray " indicearraya " indicearraya " indicearrayb " indicearrayb
                  ;sleep 1000
           
    }
    
    tooltip
    
    
    ;msgbox vedi563
    return arrayFiltrato
}









ElaboraLinguaSingola(pathFileLingua, fileFinale, array_ordinamento, arrayConsolidata,nomearraylingua) {
     global arrayFR,arrayEN,arrayES,arrayIT,fileConsolidata,fileCopilot
    
    tooltip, 📖 Caricamento file lingua %pathFileLingua%...,0,0

    ; 1) Carica tutti i record in memoria
    
  ;  msgbox % fileCopilot
    
     if !IsObject(array_ordinamento) 
       array_ordinamento := caricafileinarraymulticolonna(fileCopilot, numerototrighe,0)
       
 ;msgbox % "lung array_ordinamento " array_ordinamento.Length()   
       

     if !IsObject(arrayConsolidata) 
       arrayConsolidata := caricafileinarraymulticolonna(fileConsolidata, numerototrighe,0)

;msgbox % "lung arrayconsolidata " arrayConsolidata.Length()



     if !IsObject(nomearraylingua) 
       arrayLingua := caricafileinarraymulticolonna(pathFileLingua, numerototrighe,0)
     
    
 ;msgbox % "lung arrayLingua " arrayLingua.Length()   
    
    

RemoveCsvHeader(arrayLingua)



    arrayFiltrato := ConfrontaLinguaEscludendoArray(arrayLingua,array_ordinamento,arrayConsolidata)
  
    frMap := {}
    Loop % arrayFR.MaxIndex() {
        rFR := arrayFR[A_Index]
        id1 := rFR[1], id2 := rFR[2], id3 := rFR[3]
        if !frMap.HasKey(id1)
            frMap[id1] := {}
        if !frMap[id1].HasKey(id2)
            frMap[id1][id2] := {}
        frMap[id1][id2][id3] := rFR
    }  

    ; --- 🔹 Aggiorna campo 4 di arrayFiltrato usando frMap ---
    Loop % arrayFiltrato.MaxIndex() {
        riga := arrayFiltrato[A_Index]
        id1 := riga[1], id2 := riga[2], id3 := riga[3]
        if (frMap.HasKey(id1) && frMap[id1].HasKey(id2) && frMap[id1][id2].HasKey(id3)) {
            riga[4] := frMap[id1][id2][id3][4]
            arrayFiltrato[A_Index] := riga
        }
    }

righe := arrayFiltrato.MaxIndex()
arrayFiltrato := SortPseudoMatrixAssoc(arrayFiltrato, righe)

    ; 4) Scrivi su disco
    if (arrayFiltrato.Length() > 0)
        ScriviArrayFinale(fileFinale, arrayFiltrato)
    else
        MsgBox, ⚠️ Nessuna riga da scrivere per %fileFinale%

    ; 5) Restituisci l’array filtrato
    return arrayFiltrato
}


; -----------------------------------------------------------------------------
; Funzione: caricafileinarraymulticolonna
; Parametri:
;   fileConsolidata       – percorso del CSV di input
;   ByRef numerototrighe  – restituisce il numero di righe valide caricate
;   doChecks := 0/1       – 1 abilita controlli + skip/log righe scartate
;                           0 disabilita controlli per massima velocità
;
; Azioni interne (con doChecks=1):
;   • crea/log errori in "<fileConsolidata>_errorLog.txt"  
;   • salva righe scartate in "<fileConsolidata>_skippedRows.txt"  
;   • crea/log debug in "<fileConsolidata>_debugLog.txt" se debugEnabled=1
;   • parsing CSV RFC4180-compliant con gestione virgolette, escape doppie
;   • collasso sequenze di 3+ virgolette
;   • auto-rilevamento delimitatore ("," o ";") sulle prime 10 righe
;   • gestione record multilinea basata sul conteggio virgolette
;   • validazione numero di colonne (5) e conteggio delimitatori
;   • controllo numerico di id1, id2, id3
;   • rilevazione righe fuse (ripetizione di id1;id2 o delimitatori in eccesso)
;   • conversione in numeri dei primi 3 campi
;   • tooltip di progresso ogni 5000 righe valide
;
; Restituisce:
;   Associative array data[riga, colonna]
; -----------------------------------------------------------------------------



caricafileinarraymulticolonna(fileConsolidata, ByRef numerototrighe, doChecks := 0)
{
    updateInt := 10000
    
    ; 1) Legge l’intero contenuto del file in una variabile
    FileRead, fileContent, %fileConsolidata%
    
    
    
    
    if ErrorLevel
        return {}  ; ritorna matrice vuota se fallisce la lettura

    ; 2) Normalizza newline doppi e CRLF → LF
     fileContent := StrReplace(fileContent, "`r`n", "`n")
    fileContent := StrReplace(fileContent, "`n`n", "`n")
  
  ;msgbox % fileContent

    ; 3) Inizializza contatori e matrice
    numerototrighe := 1
    ordinato := 1
prev1 := prev2 := prev3 := -1
    
    
    
    matrice := []

    ; 4) Cicla su ogni riga (split su LF)
    
    lines := StrSplit(fileContent, "`n")
    nrighe := lines.Length()
    for rowIndex, line in lines
    {
        
         if (Mod(A_index, updateInt) = 0)
        {
           
            ToolTip, % "riga " A_index " di " nrighe, 0, 0
            Sleep, 0
        }      
       
       
       
       
       if (line = "")
            continue
            
      v = "ID","Unknown","Index"
      if instr(line,v)
        {
         ;msgbox % line
         continue          
        }     
            
                  
            
         saltariga := 0
         

         
        ; 4.1) Sostituisce tutte le virgole con un delimitatore temporaneo
        v = ","
        temp := StrReplace(line, v, "`n")

        ; 4.2) Divide in colonne
        cols := StrSplit(temp, "`n")

        ; 4.3) Check facoltativo sul numero di colonne
        if (cols.Length() != 5)
            continue

        ; 4.4) Popola la matrice (1–5)
 
  if (cols[1] = "" or cols[2] = "" or cols[3] = "")
{
    continue   ; salta righe vuote nei primi 3 campi
}  
 
 
 
        Loop 5
        {
            val := cols[A_Index]
           
            if (A_Index = 1)  ; togli la virgoletta iniziale
                {
                val1 := SubStr(val, 2)
                val := val1
                }
                
            if (A_Index < 4)
                if val is not number
                {
                    saltariga := 1
                    break
                }

            if (A_Index = 2)  ; togli la virgoletta iniziale
            {
                val2 := val
                continue
            }

            if (A_Index = 3)  ; togli la virgoletta iniziale
            {
                val3 := val
                continue
            }

            if (A_Index = 4)  ; togli la virgoletta iniziale
            {
                val4 := val
                continue
            }

            if (A_Index = 5)
            {
                val5 := SubStr(val, 1, -1)  ; togli la virgoletta finale
                matrice[numerototrighe, 1] := val1 + 0
                matrice[numerototrighe, 2] := val2 + 0
                matrice[numerototrighe, 3] := val3 + 0
                matrice[numerototrighe, 4] := val4 
                matrice[numerototrighe, 5] := val5
            }
        }









    if (saltariga = 0)
    {
        ; Verifica ordinamento numerico crescente sui primi 3 campi
        curr1 := val1 + 0
        curr2 := val2 + 0
        curr3 := val3 + 0

        if ((curr1 < prev1) or (curr1 = prev1 and curr2 < prev2) or (curr1 = prev1 and curr2 = prev2 and curr3 < prev3))
        {
            ordinato := 0
        }

        prev1 := curr1
        prev2 := curr2
        prev3 := curr3

        numerototrighe++
    }


          ;msgbox % val1 " " val2 " " val3

;          If (val1 = 3952276)
;      if (val2 = 0)
;       if (val3 = 2763)      
;       msgbox %  val1 val2 val3 val4 val5    
    
    }
    
  if (!ordinato && doChecks)
{
    ; MsgBox, Ordinamento non rispettato: avvio sort...
    matrice := SortPseudoMatrixAssoc(matrice, numerototrighe - 1)
}  
    
    

    return matrice
}



/*/
;===============================================================================
; ConfrontaArrayPerChiavi – nuova versione, O(n), senza infinite loop
;   arrayFR  : matrice di righe [idx][1..5] contenente i dati “FR…”
;   arrayOrd : matrice di righe [idx][1..5] da filtrare
; Restituisce un nuovo array con:
;   • tutte le righe in cui codiceOrd NON inizia con “FR” (passano libere)  
;   • le righe con codiceOrd che inizia “FR” solo se c’è  
;     un match su id1|id2|id3 e codiceFR=codiceOrd  
;===============================================================================
;===============================================================================
; ConfrontaArrayPerChiavi_NoConcat
;   • arrayFR  : matrice [idx][1..5] con i dati FR
;   • arrayOrd : matrice [idx][1..5] con i dati da popolare
;   • controllohash (opzionale): 
;       1 = controllo campo[4] “FR…” e applico match come prima
;       0 = ignoro “FR…” e sovrascrivo sempre o[4] con rFR[4]
;===============================================================================
;===============================================================================
; ConfrontaArrayPerChiavi con tooltip di progresso
;===============================================================================
ConfrontaArrayPerChiavi(arrayFR, arrayOrd, controllohash)
{
    if (controllohash = "")
        controllohash := 1

    ; Rimuovo eventuale header “ID…Text”
    if ( arrayFR.MaxIndex() && arrayFR[1][1] = "ID" )
        arrayFR.RemoveAt(1)
    if ( arrayOrd.MaxIndex() && arrayOrd[1][1] = "ID" )
        arrayOrd.RemoveAt(1)

    ; Costruisco frMap annidato
    frMap := {}
    Loop, % arrayFR.MaxIndex()
    {
        rFR := arrayFR[A_index]
        id1 := rFR[1], id2 := rFR[2], id3 := rFR[3]
        if !frMap.HasKey(id1)
            frMap[id1] := {}
        if !frMap[id1].HasKey(id2)
            frMap[id1][id2] := {}
        frMap[id1][id2][id3] := rFR
    }

    ; Parametri per tooltip
    total := arrayOrd.MaxIndex()
    updateInt := total / 50
    if (updateInt = 0)
        updateInt := 1

    ToolTip, Confronta Hash … 0, 0, 0
    Sleep, 0

    ; Scorro arrayOrd e applico regole
    result := []
    Loop, % total
    {
        o := arrayOrd[A_index]
        id1 := o[1], id2 := o[2], id3 := o[3]

        ; Cerco riga FR corrispondente
        rFR := ""
        if frMap.HasKey(id1)
           && frMap[id1].HasKey(id2)
           && frMap[id1][id2].HasKey(id3)
            rFR := frMap[id1][id2][id3]

        isHashRow := ( SubStr(o[4],1,2) = "FR" )
        forceOverwrite := ( controllohash = 0 )

        if ( forceOverwrite || !isHashRow )
        {
            if IsObject(rFR)
                o[4] := rFR[4]
            result.Push(o)
        }
        else
        {
            if IsObject(rFR) && o[4] = rFR[4]
                result.Push(o)
        }

        ; Aggiorno tooltip
        if (Mod(A_index, updateInt) = 0)
        {
            pct := Round(A_index * 100 / total)
            ToolTip, % "Confronta: " pct "%% – riga " A_index " di " total, 0, 0
            Sleep, 0
        }
    }

    ToolTip  ; nasconde il tooltip
    return result
}






ConfrontaArrayPerChiavi(arrayFR, arrayOrd, controllohash := 1, saltaVuote := 0, salvaFix := 0) {

    
     if (forzascritturahashsuarrayord == 1 && controllohash == 1)
        controllohash := 0   
    
    
    if (controllohash == "")
        controllohash := 1

    ; Rimuovo eventuale header "ID..."
    if (arrayFR.MaxIndex() && arrayFR[1][1] == "ID")
        arrayFR.RemoveAt(1)
    if (arrayOrd.MaxIndex() && arrayOrd[1][1] == "ID")
        arrayOrd.RemoveAt(1)

    ; Costruisco frMap annidato
    frMap := {}
    Loop % arrayFR.MaxIndex() {
        rFR := arrayFR[A_Index]
        id1 := rFR[1], id2 := rFR[2], id3 := rFR[3]
        if !frMap.HasKey(id1)
            frMap[id1] := {}
        if !frMap[id1].HasKey(id2)
            frMap[id1][id2] := {}
        frMap[id1][id2][id3] := rFR
    }

    total := arrayOrd.MaxIndex()
    updateInt := Floor(total / 50)
    if (updateInt < 1)
        updateInt := 1

    ToolTip, Confronta..., 0, 0
    Sleep, 0

    result := []
    modificato := 0

    ; Array per debug
    scartate_hash_diverso := []
    scartate_testo_vuoto := []

    Loop % total {
        o := arrayOrd[A_Index]

        ; Salta righe vuote se richiesto
        if (saltaVuote == 1 && Trim(o[5], " `t") == "") {
            scartate_testo_vuoto.Push(o)
            modificato := 1
            continue
        }

        id1 := o[1], id2 := o[2], id3 := o[3]
        rFR := ""
        if (frMap.HasKey(id1) && frMap[id1].HasKey(id2) && frMap[id1][id2].HasKey(id3))
            rFR := frMap[id1][id2][id3]

        if (controllohash == 0) {
            ; Ignora completamente la gestione hash e NON toccare il testo
            ; - non aggiorna o[4]
            ; - non aggiorna o[5]
            result.Push(o)
        }
        else {
            isHashRow := (SubStr(o[4], 1, 2) == "FR")
            if (!isHashRow) {
                if (IsObject(rFR)) {
                    if (o[4] != rFR[4]) {
                        o[4] := rFR[4]  ; aggiorna hash con quello francese
                        modificato := 1
                    }
                    ; NON tocco o[5] → resta il testo originale di arrayOrd
                }
                result.Push(o)  ; sempre in output
            } else {
                if (IsObject(rFR) && o[4] == rFR[4]) {
                    result.Push(o)
                } else {
                    scartate_hash_diverso.Push(o)
                }
            }
        }

        if (Mod(A_Index, updateInt) == 0) {
            pct := Round(A_Index * 100 / total)
            ToolTip, % "Confronta: " pct "%% – riga " A_Index " di " total, 0, 0
            Sleep, 0
        }
    }

    ToolTip

    ; Salvataggi debug
    SalvaArrayCSV(scartate_hash_diverso, "scartate_hash_diverso.txt")
    SalvaArrayCSV(scartate_testo_vuoto, "scartate_testo_vuoto.txt")


;msgbox % modificato

    ; Salvataggio file fix se richiesto
    if (salvaFix == 1 && modificato == 1) {
        SalvaArrayCSV(result, "nomearrayord_fix.txt")
    }

    return result
}

*/

ConfrontaArrayPerChiavi(arrayFR, arrayOrd, controllohash := 0, forzascritturahashsuarrayord := 1, saltaVuote := 0, salvaFix := 0) {
    ; Se forzascritturahashsuarrayord = 1 e controllohash = 1 -> forza controllohash a 0
    if (forzascritturahashsuarrayord == 1 && controllohash == 1)
        controllohash := 0

    if (controllohash == "")
        controllohash := 1

    ; Rimuovo eventuale header "ID..."
    if (arrayFR.MaxIndex() && arrayFR[1][1] == "ID")
        arrayFR.RemoveAt(1)
    if (arrayOrd.MaxIndex() && arrayOrd[1][1] == "ID")
        arrayOrd.RemoveAt(1)

    ; Costruisco frMap annidato
    frMap := {}
    Loop % arrayFR.MaxIndex() {
        rFR := arrayFR[A_Index]
        id1 := rFR[1], id2 := rFR[2], id3 := rFR[3]
        if !frMap.HasKey(id1)
            frMap[id1] := {}
        if !frMap[id1].HasKey(id2)
            frMap[id1][id2] := {}
        frMap[id1][id2][id3] := rFR
    }

    total := arrayOrd.MaxIndex()
    updateInt := Floor(total / 50)
    if (updateInt < 1)
        updateInt := 1

    ToolTip, Confronta..., 0, 0
    Sleep, 0

    result := []
    modificato := 0
    scartate_hash_diverso := []
    scartate_testo_vuoto := []

    Loop % total {
        o := arrayOrd[A_Index]

        ; Salta righe vuote se richiesto
        if (saltaVuote == 1 && Trim(o[5], " `t") == "") {
            scartate_testo_vuoto.Push(o)
            modificato := 1
            continue
        }

        id1 := o[1], id2 := o[2], id3 := o[3]
        rFR := ""
        if (frMap.HasKey(id1) && frMap[id1].HasKey(id2) && frMap[id1][id2].HasKey(id3))
            rFR := frMap[id1][id2][id3]

        ; Se è attivo forzascritturahashsuarrayord e la riga FR esiste -> copia sempre hash FR
        if (forzascritturahashsuarrayord == 1 && IsObject(rFR)) {
            o[4] := rFR[4]
            modificato := 1
        }

        if (controllohash == 0) {
            ; Ignora completamente il controllo hash
            result.Push(o)
        }
        else {
            isHashRow := (SubStr(o[4], 1, 2) == "FR")
            if (!isHashRow) {
                if (IsObject(rFR)) {
                    if (o[4] != rFR[4]) {
                        o[4] := rFR[4]  ; aggiorna hash con quello francese
                        modificato := 1
                    }
                }
                result.Push(o)
            } else {
                if (IsObject(rFR) && o[4] == rFR[4]) {
                    result.Push(o)
                } else {
                    scartate_hash_diverso.Push(o)
                }
            }
        }

        if (Mod(A_Index, updateInt) == 0) {
            pct := Round(A_Index * 100 / total)
            ToolTip, % "Confronta: " pct "%% – riga " A_Index " di " total, 0, 0
            Sleep, 0
        }
    }

    ToolTip
    SalvaArrayCSV(scartate_hash_diverso, "scartate_hash_diverso.txt")
    SalvaArrayCSV(scartate_testo_vuoto, "scartate_testo_vuoto.txt")

    if (salvaFix == 1 && modificato == 1) {
        SalvaArrayCSV(result, "nomearrayord_fix.txt")
    }

    return result
}


; Funzione di utilità per salvare un array in CSV
SalvaArrayCSV(arr, filename) {
    if !IsObject(arr) || arr.MaxIndex() = ""
        return
    text := ""
    for _, row in arr {
        line := ""
        Loop % row.MaxIndex() {
            val := row[A_Index]
            val := StrReplace(val, """", """""")
            line .= """" val """" (A_Index < row.MaxIndex() ? "," : "")
        }
        text .= line "`r`n"
    }
    FileDelete, %filename%
    FileAppend, %text%, %filename%
}







ForEachLine(path, ByRef dict) {
    first := true
    Loop, Read, %path%
    {
        line := A_LoopReadLine

        ; Salta la prima riga se contiene "Text"
        if (first) {
            first := false
            if InStr(line, "Text")
                continue
        }

        if RegExMatch(line, "^""([^""]+)"",""([^""]+)"",""([^""]+)"",""([^""]+)"",""(.*)", match) {
            key := """" match1 """,""" match2 """,""" match3 """"
            obj := {}
            obj.id1 := match1
            obj.id2 := match2
            obj.id3 := match3
            obj.codice := match4
            obj.testo := match5
            dict[key] := obj
        } else {
            FileAppend, Riga non valida:`n%line%`n`n, log_righe_non_match.txt
        }
    }
}

ForEachLineConsolidata(path, ByRef dict) {
    Loop, Read, %path%
    {
        line := A_LoopReadLine
        if RegExMatch(line, "^""([^""]+)"",""([^""]+)"",""([^""]+)"",""([^""]+)"",""(.*)", match) {
            key := """" match1 """,""" match2 """,""" match3 """"
            obj := {}
            obj.id1 := match1
            obj.id2 := match2
            obj.id3 := match3
            obj.codice := match4
            obj.testo := match5
            dict[key] := obj
        } else {
            FileAppend, Riga non valida (consolidata):`n%line%`n`n, log_righe_non_match.txt
        }
    }
}



ScriviArrayFinale(filePath, array) {
    contenuto := ""
    for idx, row in array {
        contenuto .= FormatCsvRow(row[1], row[2], row[3], row[4], row[5])
    }

    FileDelete, %filePath%
    FileAppend, %contenuto%, %filePath%
}

JSHash(str)
{
    h := 0x4E67C6A7
    loop, parse, str
        h ^= ((h << 5) + Asc(A_LoopField) + (h >> 2))
    return (h & 0x7FFFFFFF)
}

RimuoviDuplicati(array) {
    arrayPulito := []
    gruppoCorrente := []
    chiavePrecedente := ""

    for _, riga in array {
        chiave := riga[1] . "|" . riga[2] . "|" . riga[3]

        ; Se cambiamo gruppo, aggiungiamo la prima riga del gruppo precedente
        if (chiave != chiavePrecedente && gruppoCorrente.Length() > 0) {
            arrayPulito.Push(gruppoCorrente[1])
            gruppoCorrente := []
        }

        gruppoCorrente.Push(riga)
        chiavePrecedente := chiave
    }

    ; Aggiunge la prima riga dell’ultimo gruppo
    if (gruppoCorrente.Length() > 0)
        arrayPulito.Push(gruppoCorrente[1])

    return arrayPulito
}






  ; deve essere già popolato prima di chiamare la funzione

RimuoviDuplicatiConConflitti(array) {
    global arrayEN
    arrayPulito      := []
    gruppoCorrente   := []
    chiavePrecedente := ""
    idx              := 0
    total            := array.MaxIndex()
    debugFile        := "debug_scartati.txt"

    FileDelete, %debugFile%

    for riga in array {
        idx++
        if (Mod(idx, 5000) = 0) {
            ToolTip, % "RimuoviDuplicati: " idx " di " total " righe…", 0, 0
        }

        ; Prelevo chiave e testo
        id1    := array[riga,1]
        id2    := array[riga,2]
        id3    := array[riga,3]
        testo  := array[riga,5]

        ; --- 1. Sostituzione virgolette « e » con "" ---
        StringReplace, testo, testo, «, "", All
        StringReplace, testo, testo, », "", All
        array[riga,5] := testo

        ; --- 2. Sincronizzazione con arrayEN ---
        chiave := id1 . "|" . id2 . "|" . id3
        if (arrayEN.HasKey(chiave)) {
            testoEN := arrayEN[chiave]
            countIT := StrLen(testo) - StrLen(StrReplace(testo, """"))
            countEN := StrLen(testoEN) - StrLen(StrReplace(testoEN, """"))

            if (countIT < countEN) {
                ; Mancano virgolette → scarta riga
                FileAppend, % FormatRiga(array[riga], "Scartata: mancano virgolette rispetto a EN") "`n", %debugFile%
                continue
            } else if (countIT > countEN) {
                ; Troppe virgolette → rimuovi in eccesso
                diff := countIT - countEN
                Loop, % diff {
                    StringReplace, testo, testo, ", , UseErrorLevel
                }
                array[riga,5] := testo
            }
        }

        ; Se cambio chiave, processo il gruppo precedente
        if (chiave != chiavePrecedente && gruppoCorrente.Length() > 0) {
            rigaDaTenere := ProcessaGruppo(gruppoCorrente, debugFile)
            arrayPulito.Push(rigaDaTenere)
            gruppoCorrente := []
        }

        ; Copio la riga corrente nel gruppo
        rigaCorrente := []
        for col, _ in array[riga]
            rigaCorrente[col] := array[riga, col]
        gruppoCorrente.Push(rigaCorrente)
        chiavePrecedente := chiave
    }

    ; Processa l'ultimo gruppo
    if (gruppoCorrente.Length() > 0) {
        rigaDaTenere := ProcessaGruppo(gruppoCorrente, debugFile)
        arrayPulito.Push(rigaDaTenere)
    }

    ToolTip
    return arrayPulito
}

ProcessaGruppo(gruppoCorrente, debugFile) {
    if (gruppoCorrente.Length() = 1) {
        return gruppoCorrente[1]
    }
    primoTesto := gruppoCorrente[1][5]
    allIdentico := true
    for i, row in gruppoCorrente {
        if (row[5] != primoTesto) {
            allIdentico := false
            break
        }
    }
    if (allIdentico) {
        rigaDaTenere := gruppoCorrente[1]
    } else {
        longestLen := 0
        idxLongest := 1
        for i, row in gruppoCorrente {
            len := StrLen(row[5])
            if (len > longestLen) {
                longestLen := len
                idxLongest := i
            }
        }
        rigaDaTenere := gruppoCorrente[idxLongest]
    }

    for i, row in gruppoCorrente {
        if (row != rigaDaTenere) {
            motivo := allIdentico ? "Duplicato con testo identico" : "Conflitto: testo più corto"
            FileAppend, % FormatRiga(row, motivo) "`n", %debugFile%
        }
    }
    return rigaDaTenere
}

FormatRiga(riga, motivo := "") {
    testo := ""
    for col, val in riga {
        testo .= val . "`t"
    }
    testo .= motivo
    return testo
}







/*/



RimuoviDuplicatiConConflitti(array) {
    arrayPulito      := []
    gruppoCorrente   := []
    chiavePrecedente := ""
    idx              := 0
    total            := array.MaxIndex()
    debugFile        := "debug_scartati.txt"

    FileDelete, %debugFile%  ; cancella il file se esiste

    for riga in array {
        idx++
        if (Mod(idx, 5000) = 0) {
            ToolTip, % "RimuoviDuplicati: " idx " di " total " righe…", 0, 0
        }

        ; Prelevo chiave e testo
        id1    := array[riga,1]
        id2    := array[riga,2]
        id3    := array[riga,3]
        testo  := array[riga,5]
        chiave := id1 . "|" . id2 . "|" . id3

        ; Se cambio chiave, processo il gruppo precedente
        if (chiave != chiavePrecedente && gruppoCorrente.Length() > 0) {
            rigaDaTenere := ""
            if (gruppoCorrente.Length() = 1) {
                rigaDaTenere := gruppoCorrente[1]
            } else {
                primoTesto := gruppoCorrente[1][5]
                allIdentico := true
                for i, row in gruppoCorrente {
                    if (row[5] != primoTesto) {
                        allIdentico := false
                        break
                    }
                }
                if (allIdentico) {
                    rigaDaTenere := gruppoCorrente[1]
                } else {
                    longestLen := 0
                    idxLongest := 1
                    for i, row in gruppoCorrente {
                        len := StrLen(row[5])
                        if (len > longestLen) {
                            longestLen := len
                            idxLongest := i
                        }
                    }
                    rigaDaTenere := gruppoCorrente[idxLongest]
                }
            }

            ; Aggiungo la riga da tenere
            arrayPulito.Push(rigaDaTenere)

            ; Scrivo le righe scartate nel file di debug
            for i, row in gruppoCorrente {
                if (row != rigaDaTenere) {
                    FileAppend, % FormatRiga(row) "`n", %debugFile%
                }
            }

            gruppoCorrente := []  ; reset del gruppo
        }

        ; Copio la riga corrente nel gruppo
        rigaCorrente := []
        for col, _ in array[riga]
            rigaCorrente[col] := array[riga, col]
        gruppoCorrente.Push(rigaCorrente)
        chiavePrecedente := chiave
    }

    ; Processa l'ultimo gruppo rimasto
    if (gruppoCorrente.Length() > 0) {
        rigaDaTenere := ""
        if (gruppoCorrente.Length() = 1) {
            rigaDaTenere := gruppoCorrente[1]
        } else {
            primoTesto := gruppoCorrente[1][5]
            allIdentico := true
            for i, row in gruppoCorrente {
                if (row[5] != primoTesto) {
                    allIdentico := false
                    break
                }
            }
            if (allIdentico) {
                rigaDaTenere := gruppoCorrente[1]
            } else {
                longestLen := 0
                idxLongest := 1
                for i, row in gruppoCorrente {
                    len := StrLen(row[5])
                    if (len > longestLen) {
                        longestLen := len
                        idxLongest := i
                    }
                }
                rigaDaTenere := gruppoCorrente[idxLongest]
            }
        }

        arrayPulito.Push(rigaDaTenere)

        for i, row in gruppoCorrente {
            if (row != rigaDaTenere) 
            {
                ;FileAppend, % FormatRiga(row) "`n", %debugFile%
  motivo := allIdentico ? "Duplicato con testo identico" : "Conflitto: testo più corto"
if (row != rigaDaTenere) {
    FILEDELETE, %debugFile%
    FileAppend, % FormatRiga(row, motivo) "`n", %debugFile%
}          
            
            
            }
        }
    }

    ToolTip
    return arrayPulito
}





FormatRiga(riga, motivo := "") {
    testo := ""
    for col, val in riga {
        testo .= val . "`t"
    }
    testo .= motivo
    return testo
}
*/



/*
RimuoviDuplicatiConConflitti(array) {
    arrayPulito      := []
    gruppoCorrente   := []
    chiavePrecedente := ""
    idx              := 0
    total            := array.MaxIndex()

    for riga in array {
        idx++
        if (Mod(idx, 5000) = 0) {
            ToolTip, % "RimuoviDuplicati: " idx " di " total " righe…", 0, 0
        }

        ; Prelevo chiave e testo
        id1    := array[riga,1]
        id2    := array[riga,2]
        id3    := array[riga,3]
        testo  := array[riga,5]
        chiave := id1 . "|" . id2 . "|" . id3

        ; Se cambio chiave, processo il gruppo precedente
        if (chiave != chiavePrecedente && gruppoCorrente.Length() > 0) {
            if (gruppoCorrente.Length() = 1) {
                ; Unico elemento, lo mantengo
                arrayPulito.Push(gruppoCorrente[1])
            } else {
                ; Verifico se tutti i testi siano identici
                primoTesto := gruppoCorrente[1][5]
                allIdentico := true
                for i, row in gruppoCorrente {
                    if (row[5] != primoTesto) {
                        allIdentico := false
                        break
                    }
                }
                if (allIdentico) {
                    ; Nessun conflitto: mantengo la prima riga
                    arrayPulito.Push(gruppoCorrente[1])
                } else {
                    ; Conflitto: scelgo la riga col testo più lungo
                    longestLen := 0
                    idxLongest := 1
                    for i, row in gruppoCorrente {
                        len := StrLen(row[5])
                        if (len > longestLen) {
                            longestLen := len
                            idxLongest := i
                        }
                    }
                    arrayPulito.Push(gruppoCorrente[idxLongest])
                }
            }
            gruppoCorrente := []  ; reset del gruppo
        }

        ; Copio la riga corrente nel gruppo
        rigaCorrente := []
        for col, _ in array[riga]
            rigaCorrente[col] := array[riga, col]
        gruppoCorrente.Push(rigaCorrente)
        chiavePrecedente := chiave
    }

    ; Processa l'ultimo gruppo rimasto
    if (gruppoCorrente.Length() > 0) {
        if (gruppoCorrente.Length() = 1) {
            arrayPulito.Push(gruppoCorrente[1])
        } else {
            primoTesto := gruppoCorrente[1][5]
            allIdentico := true
            for i, row in gruppoCorrente {
                if (row[5] != primoTesto) {
                    allIdentico := false
                    break
                }
            }
            if (allIdentico) {
                arrayPulito.Push(gruppoCorrente[1])
            } else {
                longestLen := 0
                idxLongest := 1
                for i, row in gruppoCorrente {
                    len := StrLen(row[5])
                    if (len > longestLen) {
                        longestLen := len
                        idxLongest := i
                    }
                }
                arrayPulito.Push(gruppoCorrente[idxLongest])
            }
        }
    }

    ToolTip  ; nasconde eventuale tooltip residuo
    return arrayPulito
}

/*
; x debug
RimuoviDuplicatiConConflitti(array) {
    arrayPulito      := []            ; array di output
    gruppoCorrente   := []            ; gruppo di righe con stessa chiave
    chiavePrecedente := ""             ; chiave del gruppo corrente
    idx              := 0
    total            := array.MaxIndex()

    ; Inizializza file di log
    FileDelete, debug_righe.txt
    FileAppend, % "AZIONE`tID1`tID2`tID3`tTESTO`n", debug_righe.txt

    for riga in array {
        idx++
        if (Mod(idx, 5000) = 0) {
            ToolTip, % "RimuoviDuplicati: " idx " di " total " righe…", 0, 0
        }

        ; Estrazione dati
        id1    := array[riga,1]
        id2    := array[riga,2]
        id3    := array[riga,3]
        testo  := array[riga,5]
        chiave := id1 . "|" . id2 . "|" . id3

        ; Cambio chiave → processo gruppo
        if (chiave != chiavePrecedente && gruppoCorrente.Length() > 0) {
            Gosub, ProcessaGruppo
            gruppoCorrente := []  ; reset
        }

        ; Copia riga corrente nel gruppo
        rigaCorrente := []
        for col, _ in array[riga]
            rigaCorrente[col] := array[riga, col]
        gruppoCorrente.Push(rigaCorrente)

        chiavePrecedente := chiave
    }

    ; Processo ultimo gruppo
    if (gruppoCorrente.Length() > 0) {
        Gosub, ProcessaGruppo
    }

    ToolTip
    return arrayPulito

    ; ----------------------------------------------------
    ProcessaGruppo:
    if (gruppoCorrente.Length() = 1) {
        arrayPulito.Push(gruppoCorrente[1])
        FileAppend, % "TENUTA`t" gruppoCorrente[1,1] "`t" gruppoCorrente[1,2] "`t" gruppoCorrente[1,3] "`t" gruppoCorrente[1,5] "`n", debug_righe.txt
    } else {
        primoTesto := gruppoCorrente[1][5]
        allIdentico := true
        for i, row in gruppoCorrente {
            if (row[5] != primoTesto) {
                allIdentico := false
                break
            }
        }
        if (allIdentico) {
            arrayPulito.Push(gruppoCorrente[1])
            FileAppend, % "TENUTA`t" gruppoCorrente[1,1] "`t" gruppoCorrente[1,2] "`t" gruppoCorrente[1,3] "`t" gruppoCorrente[1,5] "`n", debug_righe.txt
            Loop % gruppoCorrente.Length()-1 {
                r := gruppoCorrente[A_Index+1]
                FileAppend, % "SCARTATA`t" r[1] "`t" r[2] "`t" r[3] "`t" r[5] "`n", debug_righe.txt
            }
        } else {
            longestLen := 0
            idxLongest := 1
            for i, row in gruppoCorrente {
                len := StrLen(row[5])
                if (len > longestLen) {
                    longestLen := len
                    idxLongest := i
                }
            }
            arrayPulito.Push(gruppoCorrente[idxLongest])
            FileAppend, % "TENUTA`t" gruppoCorrente[idxLongest,1] "`t" gruppoCorrente[idxLongest,2] "`t" gruppoCorrente[idxLongest,3] "`t" gruppoCorrente[idxLongest,5] "`n", debug_righe.txt
            for i, row in gruppoCorrente {
                if (i != idxLongest)
                    FileAppend, % "SCARTATA`t" row[1] "`t" row[2] "`t" row[3] "`t" row[5] "`n", debug_righe.txt
            }
        }
    }
    Return
}

RimuoviDuplicatiConConflitti1(array) {          ; questa versione in caso di duplicati con testi diversi li elimina tutti                     
    arrayPulito := []
    gruppoCorrente := []
    chiavePrecedente := ""

    for riga in array {
    
         idx++
    
           ; Aggiorna il Tooltip ogni 5000 iterazioni
        if (Mod(idx, 5000) = 0) {
            ToolTip, % "RimuoviDuplicati: " idx " di " total " righe…", 0, 0
        }
    
        id1 := array[riga, 1]
        id2 := array[riga, 2]
        id3 := array[riga, 3]
        testo := array[riga, 5]  ; Presumo che la colonna 5 sia il testo

        chiave := id1 . "|" . id2 . "|" . id3

        if (chiave != chiavePrecedente && gruppoCorrente.Length() > 0) {
            testi := []
            for r in gruppoCorrente
                testi.Push(r[5])

            if (testi.Length = 1 || (testi.MaxIndex() = testi.MinIndex() && testi[1] = testi[2])) {
                arrayPulito.Push(gruppoCorrente[1])  ; Nessun conflitto, mantiene solo una riga
            }
            ; Altrimenti, scarta tutte le righe del gruppo
            gruppoCorrente := []
        }

        rigaCorrente := []
        for col in array[riga]
            rigaCorrente[col] := array[riga, col]

        gruppoCorrente.Push(rigaCorrente)
        chiavePrecedente := chiave
    }

    ; Gestione dell’ultimo gruppo
    if (gruppoCorrente.Length() > 0) {
        testi := []
        for r in gruppoCorrente
            testi.Push(r[5])

        if (testi.Length = 1 || (testi.MaxIndex() = testi.MinIndex() && testi[1] = testi[2])) {
            arrayPulito.Push(gruppoCorrente[1])
        }
    }

    return arrayPulito
}
*/


LiberaMemoria(ByRef variabile) {
    try {
        if IsObject(variabile)
            variabile := []  ; resetta oggetti e array
        else
            variabile := ""  ; svuota stringhe normali
    } catch e {
        ; opzionale: log dell'errore se vuoi tenere traccia
        ; FileAppend, Errore liberazione memoria: %e.Message%`n, log_memoria.txt
    }
}


;————————————————————————————— 
; CreaBlocchiFrammentabili:
;   - carica i temp*.txt in array se non già presenti  
;   - imposta i default fileOutput/maxSize  
;   - chiama CreaBlocchiSincronizzati  
;—————————————————————————————

CreaBlocchiFrammentabili(arrayFR, arrayES, arrayEN, arrayIT, fileOutput, maxSize) {
    ; 1) default
    if (fileOutput = "")
        fileOutput := "unionetraduzioni.txt"
    if (!maxSize || maxSize < 1)
        maxSize := 4000

    ; 2) carico da disco se gli array non esistono (o file mancanti)
    if !IsObject(arrayES)
    {
        if FileExist("tempESfinale.txt")
        {
            arrayES := caricafileinarraymulticolonna("tempESfinale.txt", numrighe)
            RemoveCsvHeader(arrayES)
        }
        else
            arrayES := []
    }

    if !IsObject(arrayFR)
    {
        if FileExist("tempFRfinale.txt")
        {
            arrayFR := caricafileinarraymulticolonna("tempFRfinale.txt", numrighe)
            RemoveCsvHeader(arrayFR)
        }
        else
            arrayFR := []
    }

    if !IsObject(arrayEN)
    {
        if FileExist("tempENfinale.txt")
        {
            arrayEN := caricafileinarraymulticolonna("tempENfinale.txt", numrighe)
            RemoveCsvHeader(arrayEN)
        }
        else
            arrayEN := []
    }

    if !IsObject(arrayIT)
    {
        if FileExist("tempITfinale.txt")
        {
            arrayIT := caricafileinarraymulticolonna("tempITfinale.txt", numrighe)
            RemoveCsvHeader(arrayIT)
        }
        else
            arrayIT := []
    }

    ; 3) preparo la sorgente in ordine ES, FR, EN, IT
    source := [ arrayES, arrayFR, arrayEN, arrayIT ]

    ; 4) invoco il “core”
    CreaBlocchiSincronizzati(source, fileOutput, maxSize)

}


; =====================================================================
; SplitLongRow – spezza una riga > maxLen su punteggiatura o spazio
; (serve al “percorso frammentato”)
; =====================================================================
SplitLongRow(text, maxLen) {
    parts := []
    seps  := [".", ",", ";", ":", "!", "?"]
    while (StrLen(text) > maxLen) 
    {
        chunk := SubStr(text, 1, maxLen)
        cutPos := 0
        for i, sep in seps 
        {
            pos := InStr(chunk, sep)
            if pos > cutPos
                cutPos := pos
        }
        if !cutPos 
        {
            pos := InStr(chunk, " ")
            cutPos := pos ? pos : maxLen
        }
        parts.Push( RTrim(SubStr(text, 1, cutPos)) )
        text := LTrim(SubStr(text, cutPos + 1))
    }
    if (StrLen(text))
        parts.Push(text)
    return parts
}


; =====================================================================
; CreaBlocchiSincronizzati – compatibile AHK v1, 3 parametri
; Modificato per splittare l'output in due file: unionetraduzioni.txt (main) e unionenomipropritraduzioni.txt (special)
; =====================================================================
CreaBlocchiSincronizzati(source, fileOutput, maxSize)
{
    ; DEFAULT PARAMETRI
    if (fileOutput = "")
    {
        fileOutput := "unionetraduzioni.txt"
    }
    if (!maxSize || maxSize < 1)
    {
        maxSize := 4000
    }
    maxLines       := 10000
    writeThreshold := 100
    

    controlloFile := "dacoontrollare.txt"
    FileDelete, %controlloFile%    

    ; SETUP FILE OUTPUT
    mainFile := "unionetraduzioni.txt"
    specialFile := "unionenomipropritraduzioni.txt"
    FileDelete, %mainFile%
    FileDelete, %specialFile%

    ; SETUP SPECIAL IDs (usa stringa per "if in" poiché gli ID sono numerici ma trattati come stringhe)
    specialIDList := "4330293,10860933,162658389,28666901,49656629,121975845"

    ; SETUP VARIABILI PER MAIN E SPECIAL
    mainBuffer := ""
    mainBufferCount := 0
    mainBlockNumber := 1
    mainFragmentText := "= BLOCCO " . mainBlockNumber . " =`r`n`r`n"
    mainCurrentSize := StrLen(mainFragmentText)
    mainCurrentLines := 2

    specialBuffer := ""
    specialBufferCount := 0
    specialBlockNumber := 1
    specialFragmentText := "= BLOCCO " . specialBlockNumber . " =`r`n`r`n"
    specialCurrentSize := StrLen(specialFragmentText)
    specialCurrentLines := 2

    ; SETUP LINGUE E MAPPA
    lingue := ["ES","FR","EN","IT"]
    mappa  := {}


    ; POPOLA MAPPA DA FILE O ARRAY
    isFiles := IsObject(source) && ! IsObject(source[1])
    if (isFiles)
    {
        Loop, % source.MaxIndex()
        {
            path := source[A_index]
            L    := lingue[A_index]
            Loop, Read, %path%
            {
                line := A_LoopReadLine
                if !line || InStr(line, "Text")
                    continue


v = ","
StrReplace(line,v, v, count)
if (count > 4) {
    FileAppend, % line . "`r`n", %controlloFile%
    continue
}
                
                
                

; --- costruzione della chiave numerica usando '","' ---
cols := StrSplit(line, v)
k1   := Trim(cols[1], """ ")
k2   := Trim(cols[2], """ ")
k3   := Trim(cols[3], """ ")
key  := k1 . "|" . k2 . "|" . k3

if ! IsObject(mappa[key])
    mappa[key] := {}
mappa[key][L] := line
            
            
            
            }
        }
    }
    else
    {
        for idx, arr in source
        {
            L := lingue[idx]
            for _, row in arr
            {
                
                ;key := row[1] . "|" . row[2] . "|" . row[3]
                key := Trim(row[1], """ ") . "|" . Trim(row[2], """ ") . "|" . Trim(row[3], """ ")
                
                if ! IsObject(mappa[key])
                {
                    mappa[key] := {}
                }
                mappa[key][L] := FormatCsvRow(row*)
            }
        }
    }

    ; ORDINA LE CHIAVI
    keys := []
    for k, _ in mappa
        keys.Push(k)

    ; QuickSort in-place usando CompareTripleNumeric
    QuickSortKeys(keys, 1, keys.MaxIndex())

    ; Debug opzionale, poi prosegui con la scrittura dei blocchi…
  ;  debugOut := ""
  ;  Loop, % keys.MaxIndex()
  ;  {
  ;      k := keys[A_Index]
  ;      if RegExMatch(k, "\|1335$")
  ;          debugOut .= A_Index . ": '" . k . "'`n"
  ;      if RegExMatch(k, "\|13349$")
  ;          debugOut .= A_Index . ": '" . k . "'`n"
  ;  }
  ;  MsgBox, 64, Debug 1335/13349, % debugOut




    ; CICLO PRINCIPALE
    Loop, % keys.MaxIndex()
    {
        key := keys[A_index]

        ; DETERMINA SE SPECIAL
        keyParts := StrSplit(key, "|")
        id := keyParts[1]
        if id in %specialIDList%
        {
            prefix := "special"
            fileToUse := specialFile
        }
        else
        {
            prefix := "main"
            fileToUse := mainFile
        }

        ; RACCOGLI LE RIGHE
        groupRows := []
        Loop, % lingue.MaxIndex()
        {
            L := lingue[A_index]
            if mappa.HasKey(key) && mappa[key].HasKey(L)
            {
                groupRows.Push(mappa[key][L])
            }
        }
        if ! groupRows.Length()
            continue

        ; CALCOLA sbLines ed estLen
        sbLines := 0
        estLen  := StrLen("=sbloc=`r`n") + StrLen("=finsbloc=`r`n`r`n")
        Loop, % groupRows.MaxIndex()
        {
            raw := groupRows[A_index]
            txt := RTrim(raw, "`r`n")
            len := StrLen(txt)
            if (len > maxSize)
            {
                parts := SplitLongRow(txt, maxSize)
                sbLines += parts.Length()
                for _, p in parts
                {
                    estLen += StrLen(p) + StrLen("`r`n")
                }
            }
            else
            {
                sbLines++
                estLen += len + StrLen("`r`n")
            }
        }

        ; PERCORSO ATOMICO
        if (sbLines <= maxLines
            && %prefix%CurrentSize + estLen      <= maxSize
            && %prefix%CurrentLines + sbLines + 2 <= maxLines)
        {
            if (%prefix%CurrentSize + estLen > maxSize
                || %prefix%CurrentLines + sbLines + 2 > maxLines)
            {
                %prefix%Buffer      .= %prefix%FragmentText
                %prefix%BlockNumber++
                %prefix%FragmentText := "= BLOCCO " . %prefix%BlockNumber . " =`r`n`r`n"
                %prefix%CurrentSize  := StrLen(%prefix%FragmentText)
                %prefix%CurrentLines := 2
            }
            %prefix%FragmentText .= "=sbloc=`r`n"
            Loop, % groupRows.MaxIndex()
            {
                raw  := groupRows[A_index]
                line := RTrim(raw, "`r`n")
                %prefix%FragmentText .= line . "`r`n"
            }
            %prefix%FragmentText .= "=finsbloc=`r`n`r`n"
            modalitaframmentato := 0
            %prefix%CurrentSize  += estLen
            %prefix%CurrentLines += sbLines + 2
        }
        else
        {
            ; PERCORSO FRAMMENTATO
        modalitaframmentato := 0

        if (%prefix%CurrentLines > 2)
        {
            %prefix%Buffer      .= %prefix%FragmentText
            %prefix%BlockNumber++
            %prefix%FragmentText := "= BLOCCO " . %prefix%BlockNumber . " =`r`n`r`n"
            %prefix%CurrentSize  := StrLen(%prefix%FragmentText)
            %prefix%CurrentLines := 2
        }
            

    ; INIZIO SOTTOBLOCCO (una sola volta per ogni frammento)
    ;if (!modalitaframmentato)
    if (!modalitaframmentato)
    {
        ;fragmentText  .= "da qui memorizza e manda =SALTA123= `r`n"
        modalitaframmentato := 1
    }


            ; inizio sottoblocco (una sola volta)
            ;if (modalitaframmentato = 1)
            ;fragmentText := fragmentText "da qui memorizza e manda =SALTA123= `r`n"
            
            %prefix%FragmentText .= "=sbloc=`r`n"
            %prefix%CurrentSize   += StrLen("=sbloc=`r`n")
            %prefix%CurrentLines  += 1

            Loop, % groupRows.MaxIndex()
            {
                raw := groupRows[A_index]
                txt := RTrim(raw, "`r`n")
                if (StrLen(txt) > maxSize)
                    parts := SplitLongRow(txt, maxSize)
                else
                    parts := [ txt ]

                for _, part in parts
                {
                    if ! part
                        continue
                    neededChars := StrLen(part) + StrLen("`r`n")
                    neededLines := 1

                    if (%prefix%CurrentSize + neededChars > maxSize
                        || %prefix%CurrentLines + neededLines > maxLines)
                    {
                        %prefix%Buffer      .= %prefix%FragmentText
                        ;blockNumber++
                        %prefix%BlockNumber++
                        %prefix%FragmentText := "= BLOCCO " . %prefix%BlockNumber . " =`r`n`r`n"
                        ;modalitaframmentato := 1
                                                
                        %prefix%CurrentSize  := StrLen(%prefix%FragmentText)
                        %prefix%CurrentLines := 2
                    }
                    
                    
                    %prefix%FragmentText .= part . "`r`n"
                    
                    
                    %prefix%CurrentSize   += neededChars
                    %prefix%CurrentLines  += neededLines
                }
            }

            ; chiusura sottoblocco (una sola volta)

            
            %prefix%FragmentText .= "=finsbloc=`r`n"
            ;if (modalitaframmentato = 1)
            ;fragmentText .= "ora puoi tradurre e mandare nella finestra nera`r`n`r`n"
 
            ;modalitaframmentato := 0
            
            %prefix%CurrentSize   += StrLen("=finsbloc=`r`n`r`n")  
            
            ;currentSize   += StrLen("ora puoi tradurre e mandare nella finestra nera`r`n`r`n")            
            %prefix%CurrentLines  += 3
       
        }

; FLUSH PERIODICO
        %prefix%BufferCount++
        if (%prefix%BufferCount > writeThreshold)
        {
            if (prefix = "main")
                FileAppend, %mainBuffer%, %mainFile%
            else if (prefix = "special")
                FileAppend, %specialBuffer%, %specialFile%
           
            %prefix%Buffer := ""
            %prefix%BufferCount := 0
        }
    
    }

    ; FLUSH FINALE PER MAIN
    if mainFragmentText
    {
        mainBuffer .= mainFragmentText
    }
    if mainBuffer
    {
        FileAppend, %mainBuffer%, %mainFile%
    }

    ; FLUSH FINALE PER SPECIAL
    if specialFragmentText
    {
        specialBuffer .= specialFragmentText
    }
    if specialBuffer
    {
        FileAppend, %specialBuffer%, %specialFile%
    }

    MsgBox, 64, Fatto, File scritti in:`n%A_ScriptDir%\%mainFile%`ne`n%A_ScriptDir%\%specialFile%
}





;––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
; QuickSortKeys: ordina un array di stringhe “a|b|c” usando
; CompareTripleNumeric per il confronto
QuickSortKeys(arrRef, lo, hi)
{
    if (lo >= hi)
        return

    pivotIndex := (lo + hi) >> 1
    pivot      := arrRef[pivotIndex]

    i := lo
    j := hi
    while (i <= j)
    {
        while ( CompareTripleNumeric(arrRef[i], pivot) < 0 )
            i++
        while ( CompareTripleNumeric(arrRef[j], pivot) > 0 )
            j--
        if (i <= j)
        {
            tmp            := arrRef[i]
            arrRef[i]      := arrRef[j]
            arrRef[j]      := tmp
            i++
            j--
        }
    }

    if (lo < j)
        QuickSortKeys(arrRef, lo, j)
    if (i < hi)
        QuickSortKeys(arrRef, i, hi)
}

;––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
; Confronto sulle triple numeriche “a|b|c”
CompareTripleNumeric(a, b)
{
    pa := StrSplit(a, "|")
    pb := StrSplit(b, "|")
    Loop, 3
    {
        va := pa[A_Index] + 0
        vb := pb[A_Index] + 0
        if (va < vb)
            return -1
        if (va > vb)
            return 1
    }
    return 0
}







;------------------------------------------------------------------------------  
; SplitLongString: spezza in parti ≤ maxSize  
;------------------------------------------------------------------------------  

SplitLongString(str, maxSize) {
    parts := []
    pos   := 1
    len   := StrLen(str)
    while pos<=len {
        parts.Push(SubStr(str,pos,maxSize))
        pos += maxSize
    }
    return parts
}





;/*

;******************************************************************************
;                          QuickSort
; Sort array using QuickSort algorithm 
;     ARR - Array to be sorted or Matrix to be sorted (By Column)
;     ASCEND is TRUE if sort is in ascending order
;     *M => VET1,VET2, - Optional arrays of same size to be sorted accordingly
;           or NCOL - Column number in ARR to be sorted if ARR is a matrix
;
; Limitation: Don't check if arrays are sparse arrays. 
;             Assume dense arrays or matrices with integer indices starting from 1.
;******************************************************************************
QuickSort(Arr, Ascend = True, M*) 
{
Local I, V, Out, L,  Rasc, N, LI, Multi, ComprM, NCol, Ind

if (Arr.Length() <= 1) ; Array with size <= 1 is already sorted
	return Arr

If (Not Isobject(Arr)) 
	return "First parameter needs to be a array"

LenM := M.Length()    ; Number of parameters after ASCEND
NCol := 0               ; Assumes initially no matrix
HasOtherArrays := ( LenM > 0 )   ; TRUE if has other arrays or column number

Multi := False
IF HasOtherArrays {
   Multi := Not IsObject(M[1])  ; True if ARR is bidimensional
   If (Multi) {
     NCol := M[1]                 ; Column number of bidimensional array
 	 HasOtherArrays :=  False        

     If NCol is Not Integer 
		return "Third parameter needs to be a valid column number"
     If (Not IsObject(Arr[1])) 
	    return "First parameter needs to be a multidimensional array"
     If ( (NCol<=0) or (NCol > Arr[1].Length()) ) 
        return "Third parameter needs to be a valid column number"
   } 
}

If (Not Multi)  {
   If (IsObject(Arr[1])) 
	 return "If first parameter is a bidimensional array, it demands a column number"
}


LI := 0   
N := 0       
IF (HasOtherArrays)  { 
   Loop % LenM {    ; Scan aditional array parameters
	 Ind := A_index
     V := M[Ind] 
	 If (IsObject(V[1])) 
		return  (Ind+2) . "o. parameter needs to be a single array"
   }
  
   LI := 1   ; Assumes 1 as the array/matrix start
   N := Arr.Clone()   ; N : Array with same size than Array to be sorted
   L := Arr.Length()  ; L : Array Size

   Loop % L 
	   N[A_index] := A_index  ; Starts with index number of each element from array
}


 ; Sort ARR with ASCEND, N is array with elements positions and
 ;  LI is 1 if has additional arrays to be sorted
 ;  NCOL is column number to be sorted if ARR is a bidimensional array
Out :=  QuickAux(Arr, Ascend, N, LI, NCol)  

; Scan additional arrays storing the original position in sorted array
If (HasOtherArrays)  {
	Loop % ComprM {
	   V := M[A_index]  ; Current aditional array
	   Rasc := V.Clone()
	   Loop % L     ; Put its elements in the sorted order based on position of sorted elements in the original array
		   V[A_index] := Rasc[N[A_index]]
	}   
}

Return Out
}




;=================================================================
;                       QuickAux
; Auxiliary recursive function to make a Quicksort in a array ou matrix
;    ARR - Array or Matrix to be sorted
;    ASCEND - TRUE if sort is ascending
;    N   - Array with original elements position
;    LI  - Position of array ARR in the array from parent recursion
;    NCOL - Column number in Matrix to be sorted. O in array case.
;===================================================================
QuickAux(Arr,Ascend, N, LI, NCol)

{
Local Bef, Aft, Mid
Local Before, Middle, After
Local Pivot, kInd, vElem, LAr, Met
Local LB := 0, LM := 0, LM := 0

LAr := Arr.Length()

if (LAr <= 1)
	return Arr

IF (LI>0) {    ; Has Another Arrays
   Bef := [],  Aft := [], Mid := []
}

Before := [], Middle := [], After := []


Met := LAr // 2    ; Regarding speed, halfway is the Best pivot element for almost sorted array and matrices

If (NCol > 0)
   Pivot := Arr[Met,NCol]
else
   Pivot := Arr[Met]  ; PIVOT is Random  element in array

; Classify array elems in 3 groups: Greater than PIVOT, Lower Than PIVOT and equal
for kInd, vElem in Arr     {
	if (NCol > 0) 
		Ch := vElem[NCol]
	else
		Ch := vElem
	
	if ( Ascend ? Ch < Pivot : Ch > Pivot )  {
			Before.Push(vElem)    ; Append vElem at BEFORE
			IF (LI>0)             ; if has another arrays
		       Bef.Push(N[kInd+LI-1])     ; Append index to original element at BEF
		} else if ( Ascend ? Ch > Pivot : Ch < Pivot ) {
		    After.Push(vElem)    
  		    IF (LI>0) 
               Aft.Push(N[kInd+LI-1])
		} else  {
			Middle.Push(vElem)    
  			IF (LI>0) 
   		       Mid.Push(N[kInd+LI-1])
  	    }
}

;  Put pieces of array with index to elements together in N
IF (LI>0) {
	LB := Bef.Length()
	LM := Mid.Length()
	LA := Aft.Length()

	Loop % LB 
	  N[LI + A_index - 1] := Bef[A_index]

	Loop % LM 
	  N[LI + LB +  A_index - 1] := Mid[A_index]

	Loop % LA
	  N[LI + LB + LM + A_index - 1] := Aft[A_index]
}

; Concat BEFORE, MIDDLE and AFTER Arrays
; BEFORE and AFTER arrays need to be sorted before
; N stores the array position to be sorted in the original array
return Cat(QuickAux(Before,Ascend,N,LI,NCol), Middle, QuickAux(After,Ascend,N,LI+LB+LM,NCol)) ; So Concat the sorted BEFORE, MIDDLE and sorted AFTER arrays
}

;*************************************************************
;                       Cat
; Concat 2 or more arrays or matrices by rows
;**************************************************************
Cat(Vet*)
{
Local VRes := [] , L, i, V
For I , V in Vet {
	L := VRes.Length()+1  
	If ( V.Length() > 0 )
        VRes.InsertAt(L,V*)
}
Return VRes
}

;***************************************************************************
;                       CatCol
; Concat 2 or more matrices by columns
; Is a aditional function no used directly in QuickSort, but akin with Cat
;*************************************************************************
CatCol(Vet*)
{
Local VRes := [] , L, I, V, VAux, NLins, NL, Aux, NC, NV, NCD

NVets := Vet.Length()          ; Number of parameters
NLins := Vet[1].Length()       ; Number of rows from matrix

VRes := []

Loop % NLins  {
	NL := A_index      ; Current Row
    ColAcum := 0    
    Loop % NVets  {
		NV := A_index  ; Current Matrix
		NCols := Vet[NV,1].Length()
		Loop % NCols  {
			NC := A_index  ; Current Column
			NCD := A_index + ColAcum   ; Current Column in Destination
		    Aux := Vet[NV,NL,NC] 
			VRes[NL,NCD] := Aux
	    } 	
		ColAcum := ColAcum + NCols
    }	
}	
Return VRes
} 




; QuickSort2D: ordina in-place array2D[r,c] su keyCols multipli
; ByRef array2D - array bidimensionale originale
; rows, cols    - dimensioni dell’array
; keyCols       - array di priorità colonne es. [3,2,1]
QuickSort2D(ByRef array2D, rows, cols, keyCols) {
    _QuickSort(array2D, 1, rows, cols, keyCols)
}

;----------------------------
; _QuickSort: ricorsivo
; l, r = estremi (righe)
_QuickSort(ByRef array2D, l, r, cols, keyCols) {
    if (l >= r) 
        return
    pivot := _SelectPivot(array2D, l, r, keyCols)
    i := l, j := r
    while (i <= j) {
        while (_CompareRowVals(array2D, i, pivot, keyCols) < 0) 
            i++
        while (_CompareRowVals(array2D, j, pivot, keyCols) > 0) 
            j--
        if (i <= j) {
            _SwapRows(array2D, i, j, cols)
            i++, j--
        }
    }
    _QuickSort(array2D, l, j, cols, keyCols)
    _QuickSort(array2D, i, r, cols, keyCols)
}

;----------------------------
; Seleziona pivot come valore mediano della riga di mezzo
_SelectPivot(ByRef array2D, l, r, keyCols) {
    mid := Floor((l + r) / 2)
    return mid
}

;----------------------------
; Confronta riga i e pivot per keyCols
; ritorna -1,0,+1
_CompareRowVals(ByRef array2D, i, pivot, keyCols) {
    for _, col in keyCols {
        v1 := array2D[i, col]
        v2 := array2D[pivot, col]
        if (v1 < v2) 
            return -1
        if (v1 > v2) 
            return 1
    }
    return 0
}

;----------------------------
; Scambia due righe i e j, tutte le cols
_SwapRows(ByRef array2D, i, j, cols) {
    Loop % cols {
        tmp := array2D[i, A_index]
        array2D[i, A_index] := array2D[j, A_index]
        array2D[j, A_index] := tmp
    }
}


; ------------------------------------------------------
; SortPseudoMatrixAssoc(matrixAssoc, rows, cols = 5)
; ------------------------------------------------------
; matrixAssoc   := pseudo-matrice associativa: matrixAssoc[row,col]
; rows          := numero di righe (1…rows)
; cols (opt.)   := numero di colonne (default 5)
; Restituisce   := nuova pseudo-matrice associativa ordinata
; ------------------------------------------------------
;/*/
SortPseudoMatrixAssoc(ByRef matrixAssoc, rows, cols := 5)
{
    ; estrazione in lista ordinabile
    list := ""
    Loop % rows {
        r := A_Index
        key := Format("{:012}{:012}{:012}", matrixAssoc[r,1]+0, matrixAssoc[r,2]+0, matrixAssoc[r,3]+0)
        list .= key . "`t" . r . "`n"
    }
    Sort, list

    ; ricostruzione stesso formato [riga,colonna]
    newAssoc := {}
    newRow := 1
    Loop, Parse, list, `n, `r
    {
        if (A_LoopField = "")
            continue
        parts := StrSplit(A_LoopField, "`t")
        idx := parts[2]
        Loop % cols
            newAssoc[newRow, A_Index] := matrixAssoc[idx, A_Index]
        newRow++
    }
    return newAssoc



}
/*/

SortPseudoMatrixAssoc(ByRef matrixAssoc, rows, cols := 5)
{
    ; estrazione in lista ordinabile
    list := ""
    Loop % rows {
        r := A_Index
        key := Format("{:012}{:012}{:012}", matrixAssoc[r,1]+0, matrixAssoc[r,2]+0, matrixAssoc[r,3]+0)
        list .= key . "`t" . r . "`n"
    }
   ; msgbox % list
    Sort, list
   ; msgbox % list
    ; ricostruzione stesso formato [riga,colonna]
    newAssoc := {}
    newRow := 1
    
    
 ; 3) Spezza in righe usando StrSplit
    rowsSplit := StrSplit(RTrim(list, "`n"), "`n")

    ; 4) Ricostruisci la pseudo‑matrice mantenendo [riga,colonna]
    newAssoc := {}
    newRow := 1
    for _, line in rowsSplit {
        parts := StrSplit(line, "`t")
        idx := parts[2]  ; indice riga originale
        Loop % cols
            newAssoc[newRow, A_Index] := matrixAssoc[idx, A_Index]
        newRow++
    }

    return newAssoc

}



*/



/*/

SortPseudoMatrixAssoc(ByRef matrixAssoc, rows, cols = 5)
{
    ; 1) Copio ogni riga in un array “lineare”
    tempArray := []
    Loop % rows
    {
        rowIdx := A_index
        tmp := []
        Loop % cols
            tmp.Push( matrixAssoc[rowIdx, A_index] )
        tempArray.Push(tmp)
    }

    ; 2) Ordino con il metodo nativo (C++), O(N log N)
    tempArray.Sort( Func("CompareRows") )

    ; 3) Ricopio il risultato in una nuova pseudo-matrice
    newAssoc := {}
    for newRowIdx, rowArr in tempArray
        for colIdx, val in rowArr
            newAssoc[newRowIdx, colIdx] := val

    return newAssoc
}



 */

;===============================================================================
; FillSaltaTraduzioneConPrecedente – sostituisce SALTA_TRADUZIONE con trad precedente
;   arrayOrd : matrice [idx][1..5] da aggiornare
;===============================================================================
FillSaltaTraduzioneConPrecedente(arrayOrd)
{
    local nuovoArray := []
    local total      := arrayOrd.Length()
    local updateInt  := total > 1000 ? 1000 : Ceil(total / 20)
    local pct

    Loop, % total
    {
        row := arrayOrd[A_index]

        if (row[5] = "SALTA TRADUZIONE" && A_index > 1)
        {
            prev := arrayOrd[A_index - 1]
            if (row[4] = prev[4]
                && prev[5] != ""
                && prev[5] != "SALTA TRADUZIONE")
            {
                row[5] := prev[5]
            }
        }

        nuovoArray.Push(row)

        ; mostra tooltip ogni updateInt iterazioni
        if (Mod(A_index, updateInt) = 0)
        {
            pct := Round(A_index * 100 / total)
            ToolTip, % "FillSaltaTradPrev: " pct "%", 0, 0
        }
    }

    ToolTip  finito Fill Salta Traduzione Con Precedente,0,0
    return nuovoArray
}

;===============================================================================
; RemoveCsvHeader(array)
;   • Se la prima riga ha ID=”ID” e Text=”Text”, la scarta  
;   • Restituisce l’array “ripulito”
;===============================================================================
RemoveCsvHeader(ByRef arr)
{
    if (arr.Length() && arr[1][1] = "ID" && arr[1][5] = "Text")
        arr.RemoveAt(1)
    return arr
}




; … (definizione del tray menu, variabili globali, ecc.) …



preparafile:
;————————————————————————————
; FASE 1/5 – Selezione file
;————————————————————————————
Tooltip, Fase 1/5: Selezione file…, 0, 0
configFile := A_ScriptDir . "\config.ini"
IniRead, fileDaAgg, %configFile%, Percorsi, fileDaAggiornare, NOT_FOUND
if (fileDaAgg = "NOT_FOUND" || !FileExist(fileDaAgg)) {
    FileSelectFile, fileDaAgg, 3,, Seleziona il file da aggiornare (inglese en.lang)
    if (!fileDaAgg) {
        Tooltip
        return
    }
    IniWrite, %fileDaAgg%, %configFile%, Percorsi, fileDaAggiornare
}
IniRead, fileTrad, %configFile%, Percorsi, fileTraduzioni, NOT_FOUND
if (fileTrad = "NOT_FOUND" || !FileExist(fileTrad)) {
    FileSelectFile, fileTrad, 3,, Seleziona il file delle traduzioni (italiano)
    if (!fileTrad) {
        Tooltip
        return
    }
    IniWrite, %fileTrad%, %configFile%, Percorsi, fileTraduzioni
}
; Aggiunta: File francese
IniRead, fileFrench, %configFile%, Percorsi, fileFrench, NOT_FOUND
if (fileFrench = "NOT_FOUND" || !FileExist(fileFrench)) {
    FileSelectFile, fileFrench, 3,, Seleziona il file francese (fr.lang)
    if (!fileFrench) {
        Tooltip
        return
    }
    IniWrite, %fileFrench%, %configFile%, Percorsi, fileFrench
}
; Aggiunta: File spagnolo
IniRead, fileSpanish, %configFile%, Percorsi, fileSpanish, NOT_FOUND
if (fileSpanish = "NOT_FOUND" || !FileExist(fileSpanish)) {
    FileSelectFile, fileSpanish, 3,, Seleziona il file spagnolo (es.lang)
    if (!fileSpanish) {
        Tooltip
        return
    }
    IniWrite, %fileSpanish%, %configFile%, Percorsi, fileSpanish
}
Tooltip, Completata Fase 1/5: Selezione file, 0, 0
Sleep, 500
;————————————————————————————
; FASE 2/5 – Lettura e caricamento in array
;————————————————————————————
Tooltip, Fase 2/5: Lettura file…, 0, 0
dataOld := caricafileinarraymulticolonna(fileDaAgg, totalOld, 0)
Tooltip, Lettura inglese completata (%totalOld% righe), 0, 0
Sleep, 500
dataNew := caricafileinarraymulticolonna(fileTrad, totalNew, 0)
Tooltip, Lettura italiano completata (%totalNew% righe), 0, 0
Sleep, 500
dataFrench := caricafileinarraymulticolonna(fileFrench, totalFr, 0)
Tooltip, Lettura francese completata (%totalFr% righe), 0, 0
Sleep, 500
dataSpanish := caricafileinarraymulticolonna(fileSpanish, totalSp, 0)
Tooltip, Lettura spagnolo completata (%totalSp% righe), 0, 0
Sleep, 500
; Crea mappe per accesso rapido
engMap := {}
frMap := {}
spMap := {}
itMap := {}
; ---------- Inizio: funzioni utilità per marcatori ----------
markerMap := {}
markerMap["m"] := "m"
markerMap["md"] := "md"
markerMap["f"] := "f"
markerMap["fd"] := "fd"
markerMap["pm"] := "pm"
markerMap["pf"] := "pf"
markerMap["fm"] := "f"
markerMap["mf"] := "m"
markerMap["fmd"]:= "fd"
markerMap["mfd"]:= "md"
; ---------- Fine: funzioni utilità per marcatori ----------
Tooltip, Creazione mappa inglese..., 0, 0
for i, row in dataOld {
    key := row[1] . "" . row[2] . "" . row[3]
    engMap[key] := row[5]
    if (Mod(i, 20000) = 0) {
        Tooltip, Mappa inglese: %i% / %totalOld%, 0, 0
    }
}
Tooltip, Mappa inglese completata, 0, 0
Sleep, 500
Tooltip, Creazione mappa francese..., 0, 0
for i, row in dataFrench {
    key := row[1] . "" . row[2] . "" . row[3]
    frMap[key] := row[5]
    if (Mod(i, 20000) = 0) {
        Tooltip, Mappa francese: %i% / %totalFr%, 0, 0
    }
}
Tooltip, Mappa francese completata, 0, 0
Sleep, 500
Tooltip, Creazione mappa spagnola..., 0, 0
for i, row in dataSpanish {
    key := row[1] . "" . row[2] . "" . row[3]
    spMap[key] := row[5]
    if (Mod(i, 20000) = 0) {
        Tooltip, Mappa spagnola: %i% / %totalSp%, 0, 0
    }
}
Tooltip, Mappa spagnola completata, 0, 0
Sleep, 500
Tooltip, Creazione mappa italiana..., 0, 0
for i, row in dataNew {
    key := row[1] . "" . row[2] . "" . row[3]
    itMap[key] := row[5]
    if (Mod(i, 20000) = 0) {
        Tooltip, Mappa italiana: %i% / %totalNew%, 0, 0
    }
}
Tooltip, Mappa italiana completata, 0, 0
Sleep, 500
; Generazione file Lua per ESO
zoneTranslations := {}
npcTranslations := {}
zoneCount := 0
npcCount := 0
Tooltip, Estrazione località e NPC da inglese..., 0, 0
for i, row in dataOld {
    if (row[1] = 4330293 || row[1] = 10860933 || row[1] = 162658389 || row[1] = 28666901 || row[1] = 49656629 || row[1] = 121975845) {
        trimmed2 := RegExReplace(row[2], "^\s+|\s+$", "")
        trimmed3 := RegExReplace(row[3], "^\s+|\s+$", "")
        key := row[1] . "" . Format("{:d}{:d}", (trimmed2 = "" ? 0 : trimmed2), trimmed3)
        zoneTranslations[key] := { "en": row[5] }
    } else if (row[1] = 8290981) {
        trimmed2 := RegExReplace(row[2], "^\s+|\s+$", "")
        trimmed3 := RegExReplace(row[3], "^\s+|\s+$", "")
        key := row[1] . "" . Format("{:d}{:d}", (trimmed2 = "" ? 0 : trimmed2), trimmed3)
        npcTranslations[key] := { "en": row[5] }
    }
    if (Mod(i, 20000) = 0) {
        Tooltip, Estrazione inglese: %i% / %totalOld%, 0, 0
    }
}
Tooltip, Estrazione inglese completata, 0, 0
Sleep, 500
Tooltip, Aggiunta traduzioni italiane per località e NPC (con verifica marcatori FR/ES)..., 0, 0
for i, row in dataNew {
    trimmed2 := RegExReplace(row[2], "^\s+|\s+$", "")
    trimmed3 := RegExReplace(row[3], "^\s+|\s+$", "")
    key := row[1] . "" . Format("{:d}{:d}", (trimmed2 = "" ? 0 : trimmed2), trimmed3)
    itRaw := row[5]
    frRaw := frMap.HasKey(key) ? frMap[key] : ""
    spRaw := spMap.HasKey(key) ? spMap[key] : ""
    ; Normalizza eventuali marcatori già in IT (es. ^M -> ^m, ^fm -> ^f)
    itNormalized := NormalizeMarkerInString(itRaw)
    ; DecideMarker deve essere la versione conservativa: restituisce "" se FR e ES sono silenti
    chosen := DecideMarker(key, itRaw, frRaw, spRaw)
    enText := ""
    if (zoneTranslations.HasKey(key)) {
        enText := zoneTranslations[key].en
    } else if (npcTranslations.HasKey(key)) {
        enText := npcTranslations[key].en
    }
    enMarker := ExtractMarkerFromString(enText)
    hasEnMarker := (enMarker != "")
    currentItMarker := ExtractMarkerFromString(itNormalized)
    hasItMarker := (currentItMarker != "")
    itStrip := RegExReplace(itNormalized, "\^[A-Za-z]{1,4}\s*$", "")
    strippedNoMarker := Trim(itStrip)
    wordWithoutMarker := strippedNoMarker
    wordGender := GetGenderFromWord(wordWithoutMarker)
    newMarker := ""
    if (chosen != "") {
        newMarker := chosen
        if (wordGender != "") {
            newMarker := wordGender
        } else if (hasItMarker) {
            if (currentItMarker != chosen) {
                newMarker := chosen
            } else {
                newMarker := currentItMarker
            }
        } else {
            newMarker := chosen
        }
    } else if (hasItMarker) {
        newMarker := currentItMarker
        if (wordGender != "") {
            newMarker := wordGender
        }
    } else if (wordGender != "") {
        newMarker := wordGender
    }
    if (newMarker != "") {
        if (!hasEnMarker) {
            newMarkerLetters := SubStr(newMarker, 2)
            newMarker := "^i" . newMarkerLetters
        }
        ; Gestione caso vuoto: usa enText senza marker + newMarker
        enStrip := RegExReplace(enText, "\^[A-Za-z]{1,4}\s*$", "")
        if (strippedNoMarker == "") {
            itNormalized := Trim(enStrip) . newMarker
        } else {
            itNormalized := RTrim(itStrip) . newMarker
        }
        ; Log correzione se modificato
        if (itNormalized != itRaw) {
            corrRow := """" . row[1] . """,""" . row[2] . """,""" . row[3] . """,""" . row[4] . """,""" . itNormalized . """`n"
            corrContent .= corrRow
        }
    }
    if (zoneTranslations.HasKey(key)) {
        zoneTranslations[key].it := itNormalized
        zoneCount++
    } else if (npcTranslations.HasKey(key)) {
        npcTranslations[key].it := itNormalized
        npcCount++
    }
    if (Mod(i, 20000) = 0) {
        Tooltip, Aggiunta italiana: %i% / %totalNew%, 0, 0
    }
}
Tooltip, Aggiunta italiana completata (zone: %zoneCount% npc: %npcCount%), 0, 0
Sleep, 500
; Elimina doppioni per zone
uniqueZoneTranslations := {}
for key, data in zoneTranslations {
    if (data.HasKey("it") && data.HasKey("en") && data.it != data.en) {
        if (!uniqueZoneTranslations.HasKey(data.it)) {
            uniqueZoneTranslations[data.it] := data.en
        }
    }
}
zoneCount := uniqueZoneTranslations.Count()
; Genera zone_it.lua
outputZoneLua := "TraduzioneItaESO = TraduzioneItaESO or {`n"
outputZoneLua .= " ZoneTranslations = {`n"
if (zoneCount > 0) {
    current := 0
    Tooltip, Generazione zone_it.lua..., 0, 0
    for itName, enName in uniqueZoneTranslations {
        current++
        itEsc := StrReplace(itName, """", """")
        enEsc := StrReplace(enName, """", """")
        outputZoneLua .= "[ """ . itEsc . """ ] = """ . enEsc . """"
        if (current < zoneCount)
            outputZoneLua .= ","
        outputZoneLua .= "`n"
    }
    Tooltip, Generazione zone_it.lua completata, 0, 0
    Sleep, 500
} else {
    outputZoneLua .= " -- Nessuna traduzione per le località`n"
}
outputZoneLua .= " }`n}`n"
outputZoneFile := A_ScriptDir . "\zone_it.lua"
FileDelete, %outputZoneFile%
sleep 100
FileAppend, %outputZoneLua%, %outputZoneFile%, UTF-8
sleep 100
; Genera npc_it.lua
outputNPCLua := "TraduzioneItaESO = TraduzioneItaESO or {`n"
outputNPCLua .= " NPCTranslations = {`n"
if (npcCount > 0) {
    current := 0
    Tooltip, Generazione npc_it.lua..., 0, 0
    for key, data in npcTranslations {
        if (data.it && data.en && data.it != data.en) {
            current++
            itName := data.it
            enName := data.en
            itEsc := StrReplace(itName, """", """")
            enEsc := StrReplace(enName, """", """")
            outputNPCLua .= "[ """ . itEsc . """ ] = """ . enEsc . """"
            if (current < npcCount)
                outputNPCLua .= ","
            outputNPCLua .= "`n"
        }
    }
    Tooltip, Generazione npc_it.lua completata, 0, 0
    Sleep, 500
} else {
    outputNPCLua .= " -- Nessuna traduzione per gli NPC`n"
}
outputNPCLua .= " }`n}`n"
outputNPCFile := A_ScriptDir . "\npc_it.lua"
FileDelete, %outputNPCFile%
sleep 100
FileAppend, %outputNPCLua%, %outputNPCFile%, UTF-8
sleep 100
; Debug
debugLog := A_ScriptDir . "\debug_lua.txt"
FileDelete, %debugLog%
FileAppend, Contenuto di zone_it.lua:`n%outputZoneLua%`n`nContenuto di npc_it.lua:`n%outputNPCLua%, %debugLog%, UTF-8
MsgBox, 64, File Lua Generati, Generati %zoneCount% traduzioni per zone_it.lua e %npcCount% traduzioni per npc_it.lua`n`nControlla %debugLog% per il contenuto esatto., 4
Tooltip, Completata Fase 2/5: Lettura e caricamento, 0, 0
Sleep, 500
;————————————————————————————
; FASE 3/5 – Lettura opzione preparatestopergioco
;————————————————————————————
Tooltip, Fase 3/5: Lettura opzione..., 0, 0
IniRead, prepStr, %configFile%, Opzioni, preparatestopergioco
if (ErrorLevel || prepStr = "") {
    MsgBox, 4, Sostituzioni extra, (LTrim Join`n Vuoi attivare le sostituzioni extra per il gioco? (Sì = ON / No = OFF)
    IfMsgBox Yes
        prep := 1
    else
        prep := 0
    IniWrite, %prep%, %configFile%, Opzioni, preparatestopergioco
} else {
    prep := prepStr + 0
}
preparatestopergioco := prep
Tooltip, Completata Fase 3/5: Opzione letta (preparatestopergioco = %preparatestopergioco%), 0, 0
Sleep, 500
;————————————————————————————
; FASE 4/5 – Merge-join con progress tooltip
;————————————————————————————
Tooltip, Fase 4/5: Inizio merge-join..., 0, 0
output := ""
logContent := ""
corrContent := ""
contotltip := 0
outputCount := 0
iOld := 1
iNew := 1
tipInterval := 5000
varconfronto := ""
startTime := A_TickCount
mismatchCount := 0
debugLimit := 0
while (iOld <= totalOld && iNew <= totalNew) {
    contotltip++
    if (contotltip > tipInterval) {
        elapsed := (A_TickCount - startTime) / 1000
        ToolTip, Merge-join: riga %iOld% di %totalOld% (iNew: %iNew%) - Tempo: %elapsed%s - Output: %outputCount%, 0, 0
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
            if (o3 = n3) {
                var1 := n1
                var2 := n2
                var3 := n3
                var4 := dataNew[iNew][4]
                var5 := dataNew[iNew][5]
                varconfronto := dataOld[iOld][5]
                Gosub BuildRow
                outputCount++
                iOld++
                iNew++
                continue
            }
    if (o1 < n1) {
        var1 := o1
        var2 := o2
        var3 := o3
        var4 := dataOld[iOld][4]
        var5 := dataOld[iOld][5]
        varconfronto := ""
        Gosub BuildRow
        outputCount++
        iOld++
        continue
    }
    if (o1 = n1)
        if (o2 < n2) {
            var1 := o1
            var2 := o2
            var3 := o3
            var4 := dataOld[iOld][4]
            var5 := dataOld[iOld][5]
            varconfronto := ""
            Gosub BuildRow
            outputCount++
            iOld++
            continue
        }
    if (o1 = n1)
        if (o2 = n2)
            if (o3 < n3) {
                var1 := o1
                var2 := o2
                var3 := o3
                var4 := dataOld[iOld][4]
                var5 := dataOld[iOld][5]
                varconfronto := ""
                Gosub BuildRow
                outputCount++
                iOld++
                continue
            }
    if (o1 > n1) {
        iNew++
        continue
    }
    if (o1 = n1)
        if (o2 > n2) {
            iNew++
            continue
        }
    if (o1 = n1)
        if (o2 = n2)
            if (o3 > n3) {
                iNew++
                continue
            }
}
; Gestione restanti record "old"
while (iOld <= totalOld) {
    var1 := dataOld[iOld][1]
    var2 := dataOld[iOld][2]
    var3 := dataOld[iOld][3]
    var4 := dataOld[iOld][4]
    var5 := dataOld[iOld][5]
    varconfronto := ""
    Gosub BuildRow
    outputCount++
    iOld++
    if (Mod(iOld, 5000) = 0) {
        elapsed := (A_TickCount - startTime) / 1000
        ToolTip, Merge-join restanti: %iOld% / %totalOld% - Tempo: %elapsed%s - Output: %outputCount%, 0, 0
    }
}
; Scrivi i file di log e correzioni accumulati
logFile := A_ScriptDir . "\daconttrollare.txt"
corrFile := A_ScriptDir . "\verifica.txt"
toTranslateFile := A_ScriptDir . "\daritradurre.txt"
SplitPath, logFile, , logDir
FileCreateDir, %logDir%
if (logContent != "") {
    FileDelete, %logFile%
    FileAppend, %logContent%, %logFile%, UTF-8
}
if (corrContent != "") {
    FileDelete, %corrFile%
    FileAppend, %corrContent%, %corrFile%, UTF-8
}
if (toTranslateContent != "") {
    FileDelete, %toTranslateFile%
    FileAppend, %toTranslateContent%, %toTranslateFile%, UTF-8
}
Tooltip, Completata Fase 4/5: Merge-join (%outputCount% righe), 0, 0
Sleep, 500
;————————————————————————————
; FASE 5/5 – Scrittura su disco
;————————————————————————————
Tooltip, Fase 5/5: Scrittura su disco…, 0, 0
outputFile := A_ScriptDir . "\output.csv"
FileDelete, %outputFile%
FileAppend, %output%, %outputFile%, UTF-8
MsgBox, 64, Fatto, Ho generato %outputFile% con %outputCount% record controlla il file daconttrollare.txt .
Tooltip
return
; === SUBROUTINE BUILDROW CON GESTIONE VIRGOLETTE AGGIORNATA ===
; Applico le sostituzioni extra
; Aggiungi questa nuova funzione dopo markerMap
; Modifica BuildRow come segue
BuildRow:
; Applico le sostituzioni extra
expandToTranslate := false ; Se true, comporta come ora (solo dispari); se false, include anche pari con problemi non modificati in daritradurre.txt
if (Trim(var5) = "SALTA TRADUZIONE" || Trim(var5) = "NON TRADUCIBILE") {
    var5 := varconfronto
}
if (varconfronto <> "") {
    key := var1 . "" . var2 . "" . var3
    textItOrig := var5
    textFr := frMap.HasKey(key) ? frMap[key] : ""
    textSp := spMap.HasKey(key) ? spMap[key] : ""
    ; Aggiunta: Correzione marcatori estesa a tutti i record (output.csv, verifica.txt, ecc.)
    itNormalized := NormalizeMarkerInString(textItOrig)
    chosen := DecideMarker(key, textItOrig, textFr, textSp)
    enText := engMap.HasKey(key) ? engMap[key] : ""
    enMarker := ExtractMarkerFromString(enText)
    hasEnMarker := (enMarker != "")
    currentItMarker := ExtractMarkerFromString(itNormalized)
    hasItMarker := (currentItMarker != "")
    itStrip := RegExReplace(itNormalized, "\^[A-Za-z]{1,4}\s*$", "")
    strippedNoMarker := Trim(itStrip)
    wordWithoutMarker := strippedNoMarker
    wordGender := GetGenderFromWord(wordWithoutMarker)
    newMarker := ""
    if (chosen != "") {
        newMarker := chosen
        if (wordGender != "") {
            newMarker := wordGender
        } else if (hasItMarker) {
            if (currentItMarker != chosen) {
                newMarker := chosen
            } else {
                newMarker := currentItMarker
            }
        } else {
            newMarker := chosen
        }
    } else if (hasItMarker) {
        newMarker := currentItMarker
        if (wordGender != "") {
            newMarker := wordGender
        }
    } else if (wordGender != "") {
        newMarker := wordGender
    }
    if (newMarker != "") {
        if (!hasEnMarker) {
            newMarkerLetters := SubStr(newMarker, 2)
            newMarker := "^i" . newMarkerLetters
        }
        ; Gestione caso vuoto: usa enText senza marker + newMarker
        enStrip := RegExReplace(enText, "\^[A-Za-z]{1,4}\s*$", "")
        if (strippedNoMarker == "") {
            itNormalized := Trim(enStrip) . newMarker
        } else {
            itNormalized := RTrim(itStrip) . newMarker
        }
        ; Log correzione se modificato
        if (itNormalized != textItOrig) {
            corrRow := """" . var1 . """,""" . var2 . """,""" . var3 . """,""" . var4 . """,""" . itNormalized . """`n"
            corrContent .= corrRow
        }
    }
    textItOrig := itNormalized ; Applica la versione corretta con marker
    textIt := textItOrig
    textEng := engMap[key]
    textFr := frMap.HasKey(key) ? frMap[key] : ""
    textSp := spMap.HasKey(key) ? spMap[key] : ""
    ; Salva originali per debug
    textEngOrig := textEng
    textFrOrig := textFr
    textSpOrig := textSp
    ; Crea copie normalizzate solo per conteggi e check
    textItNorm := NormalizeQuotes(textItOrig)
    textEngNorm := NormalizeQuotes(textEng)
    textFrNorm := NormalizeQuotes(textFr)
    textSpNorm := NormalizeQuotes(textSp)
    ; Calcola Q totale per ogni lingua su originale (weighted)
    itTotalQuotes := CountAllQuotes(textItOrig, true)
    engTotalQuotes := CountAllQuotes(textEngOrig, false)
    frTotalQuotes := (textFrOrig != "") ? CountAllQuotes(textFrOrig, false) : -1
    spTotalQuotes := (textSpOrig != "") ? CountAllQuotes(textSpOrig, false) : -1
    ; Trova tutti i Q candidati validi SOLO per le altre lingue
    engCandidates := GetValidQCandidates(engTotalQuotes)
    frCandidates := (textFrOrig != "") ? GetValidQCandidates(frTotalQuotes) : [-1]
    spCandidates := (textSpOrig != "") ? GetValidQCandidates(spTotalQuotes) : [-1]
    ; DEBUG (solo per mismatch)
    debugMsg := "=== ANALISI Q CANDIDATI ===`n"
    debugMsg .= "Chiave: " key "`n"
    debugMsg .= "IT: " textItOrig " (Q totale=" itTotalQuotes ")`n"
    debugMsg .= "ENG Orig: " textEngOrig "`n"
    debugMsg .= "ENG Norm: " textEngNorm " (Q totale=" engTotalQuotes ", Candidati: " ArrayToString(engCandidates) ")`n"
    debugMsg .= "FR Orig: " textFrOrig "`n"
    debugMsg .= "FR Norm: " textFrNorm " (Q totale=" frTotalQuotes ", Candidati: " ArrayToString(frCandidates) ")`n"
    debugMsg .= "SP Orig: " textSpOrig "`n"
    debugMsg .= "SP Norm: " textSpNorm " (Q totale=" spTotalQuotes ", Candidati: " ArrayToString(spCandidates) ")`n"
    anyFixed := false
    ; Controlla e aggiungi se " unpaired in italiano
    numQuotes := StrLen(textItNorm) - StrLen(StrReplace(textItNorm, """"))
    if Mod(numQuotes, 2) = 1 {
        textIt .= """"
        anyFixed := true
        itTotalQuotes += 1
        debugMsg .= "Aggiunto "" per escape unpaired`n"
        debugMsg .= "IT modificata: " textIt " (Q totale=" itTotalQuotes ")`n"
    }
    ; Cerca match
    match := false
    matchedQ := ""
    if (itTotalQuotes <= engTotalQuotes && Mod(itTotalQuotes, 2) = 0) {
        match := true
        matchedQ := itTotalQuotes
        debugMsg .= "MATCH trovato con ENG: Q=" itTotalQuotes "`n"
    } else if (textFrOrig != "" && itTotalQuotes <= frTotalQuotes && Mod(itTotalQuotes, 2) = 0) {
        match := true
        matchedQ := itTotalQuotes
        debugMsg .= "MATCH trovato con FR: Q=" itTotalQuotes "`n"
    } else if (textSpOrig != "" && itTotalQuotes <= spTotalQuotes && Mod(itTotalQuotes, 2) = 0) {
        match := true
        matchedQ := itTotalQuotes
        debugMsg .= "MATCH trovato con SP: Q=" itTotalQuotes "`n"
    }
    if (!match) {
        mismatchCount++
        if (debugLimit > 0 && mismatchCount >= debugLimit) {
            goto SaveAndExit
        }
        debugMsg .= "NESSUN MATCH trovato`n"
        ; Tentativo di correzione automatica
        newIt := textIt
        newItaQ := itTotalQuotes
        ; === CASISTICA 1 ===
        hasSurroundingAny := hasSurroundingQuotes(textEngNorm) || (textFrOrig != "" && hasSurroundingQuotes(textFrNorm)) || (textSpOrig != "" && hasSurroundingQuotes(textSpNorm))
        if (itTotalQuotes = 0 && Trim(textIt) != "" && hasSurroundingAny) {
            if (!RegExMatch(textItNorm, "^\s*[""""]") && !RegExMatch(textItNorm, "[""""]\s*$")) {
                newIt := """" . textIt . """"
                newItaQ := CountAllQuotes(newIt, true)
                if (Mod(newItaQ, 2) = 0 && (newItaQ <= engTotalQuotes || (frTotalQuotes != -1 && newItaQ <= frTotalQuotes) || (spTotalQuotes != -1 && newItaQ <= spTotalQuotes))) {
                    anyFixed := true
                    textIt := newIt
                    itTotalQuotes := newItaQ
                    debugMsg .= "CASISTICA 1 APPLICATA: Aggiunte virgolette esterne`n"
                    debugMsg .= "IT modificata: " newIt " (Q totale=" newItaQ ")`n"
                } else {
                    debugMsg .= "CASISTICA 1 TENTATA ma NON APPLICATA`n"
                }
            } else {
                debugMsg .= "CASISTICA 1 TENTATA ma NON APPLICATA`n"
            }
        } else {
            debugMsg .= "CASISTICA 1 NON APPLICABILE`n"
        }
        if (anyFixed) {
            ; Recheck match dopo fix
            match := false
            if (itTotalQuotes <= engTotalQuotes && Mod(itTotalQuotes, 2) = 0) {
                match := true
                debugMsg .= "MATCH ora trovato dopo questa casistica - Stop correzioni`n"
            } else if (textFrOrig != "" && itTotalQuotes <= frTotalQuotes && Mod(itTotalQuotes, 2) = 0) {
                match := true
                debugMsg .= "MATCH ora trovato dopo questa casistica - Stop correzioni`n"
            } else if (textSpOrig != "" && itTotalQuotes <= spTotalQuotes && Mod(itTotalQuotes, 2) = 0) {
                match := true
                debugMsg .= "MATCH ora trovato dopo questa casistica - Stop correzioni`n"
            }
            if (match) {
                goto EndFixed
            }
        }
        ; === CASISTICA 6: Riduzione sequenze di virgolette a max 2 ===
        maxOtherQ := engTotalQuotes
        if (frTotalQuotes != -1 && frTotalQuotes > maxOtherQ)
            maxOtherQ := frTotalQuotes
        if (spTotalQuotes != -1 && spTotalQuotes > maxOtherQ)
            maxOtherQ := spTotalQuotes
        if (itTotalQuotes > maxOtherQ) {
            ; Riduci tutte le sequenze di 3 o più virgolette a 2
            newIt := RegExReplace(textIt, """{3,}", """""")
            newItaQ := CountAllQuotes(newIt, true)
            ; Applica solo se il risultato è coerente
            if (newIt != textIt && Mod(newItaQ, 2) = 0 && newItaQ <= maxOtherQ) {
                anyFixed := true
                textIt := newIt
                itTotalQuotes := newItaQ
                debugMsg .= "CASISTICA 6 APPLICATA: Ridotte sequenze ridondanti (>=3 a 2) globalmente`n"
                debugMsg .= "IT modificata: " newIt " (Q totale=" newItaQ ")`n"
            }
        }
        if (anyFixed) {
            ; Recheck match dopo fix
            match := false
            if (itTotalQuotes <= engTotalQuotes && Mod(itTotalQuotes, 2) = 0) {
                match := true
                debugMsg .= "MATCH ora trovato dopo questa casistica - Stop correzioni`n"
            } else if (textFrOrig != "" && itTotalQuotes <= frTotalQuotes && Mod(itTotalQuotes, 2) = 0) {
                match := true
                debugMsg .= "MATCH ora trovato dopo questa casistica - Stop correzioni`n"
            } else if (textSpOrig != "" && itTotalQuotes <= spTotalQuotes && Mod(itTotalQuotes, 2) = 0) {
                match := true
                debugMsg .= "MATCH ora trovato dopo questa casistica - Stop correzioni`n"
            }
            if (match) {
                goto EndFixed
            }
        }
        ; === CASISTICA 3 ===
        if (itTotalQuotes > 0 && !hasSurroundingAny) {
            removed := false
            if (SubStr(textIt, 1, 2) = """""" && SubStr(textIt, -1, 2) = """""") {
                newIt := SubStr(textIt, 3, StrLen(textIt) - 4)
                removed := true
            } else if (SubStr(textIt, 1, 1) = """" && SubStr(textIt, -1, 1) = """") {
                newIt := SubStr(textIt, 2, StrLen(textIt) - 2)
                removed := true
            } else if (SubStr(textIt, 1, 1) = "«" && SubStr(textIt, -1, 1) = "»") {
                newIt := SubStr(textIt, 2, StrLen(textIt) - 2)
                removed := true
            } else if (SubStr(textIt, 1, 1) = "“" && SubStr(textIt, -1, 1) = "”") {
                newIt := SubStr(textIt, 2, StrLen(textIt) - 2)
                removed := true
            }
            if (!removed) {
                ; Se non rimosso, tenta rimozione di tutte le virgolette esterne consecutive
                result := RemoveAllOuterQuotes(textIt)
                if (result.changed) {
                    newIt := result.text
                    removed := true
                }
            }
            if (removed) {
                newItaQ := CountAllQuotes(newIt, true)
                if (Mod(newItaQ, 2) = 0 && (newItaQ <= engTotalQuotes || (frTotalQuotes != -1 && newItaQ <= frTotalQuotes) || (spTotalQuotes != -1 && newItaQ <= spTotalQuotes))) {
                    anyFixed := true
                    textIt := newIt
                    itTotalQuotes := newItaQ
                    debugMsg .= "CASISTICA 3 APPLICATA: Rimosse virgolette esterne`n"
                    debugMsg .= "IT modificata: " newIt " (Q totale=" newItaQ ")`n"
                } else {
                    debugMsg .= "CASISTICA 3 TENTATA ma NON APPLICATA`n"
                }
            } else {
                debugMsg .= "CASISTICA 3 TENTATA ma NON APPLICATA`n"
            }
        } else {
            debugMsg .= "CASISTICA 3 NON APPLICABILE`n"
        }
        if (anyFixed) {
            ; Recheck match dopo fix
            match := false
            if (itTotalQuotes <= engTotalQuotes && Mod(itTotalQuotes, 2) = 0) {
                match := true
                debugMsg .= "MATCH ora trovato dopo questa casistica - Stop correzioni`n"
            } else if (textFrOrig != "" && itTotalQuotes <= frTotalQuotes && Mod(itTotalQuotes, 2) = 0) {
                match := true
                debugMsg .= "MATCH ora trovato dopo questa casistica - Stop correzioni`n"
            } else if (textSpOrig != "" && itTotalQuotes <= spTotalQuotes && Mod(itTotalQuotes, 2) = 0) {
                match := true
                debugMsg .= "MATCH ora trovato dopo questa casistica - Stop correzioni`n"
            }
            if (match) {
                goto EndFixed
            }
        }
        ; === CASISTICA 4 RIVISTA: Regolate virgolette esterne SOLO se presenti in altre lingue ===
        hasOuterInAny := hasSurroundingQuotes(textEngNorm) || (textFrOrig != "" && hasSurroundingQuotes(textFrNorm)) || (textSpOrig != "" && hasSurroundingQuotes(textSpNorm))
        if (hasOuterInAny) { ; Nuova condizione: Aggiungi outer solo se almeno una lingua le ha
            result := EnsureTwoOuterQuotes(textItNorm)
            if (result.changed) {
                newIt := result.text
                newItaQ := CountAllQuotes(newIt, true)
                if (Mod(newItaQ, 2) = 0 && newItaQ <= maxOtherQ) { ; Usa maxOtherQ calcolato prima
                    anyFixed := true
                    textIt := newIt
                    itTotalQuotes := newItaQ
                    debugMsg .= "CASISTICA 4 APPLICATA: Regolate virgolette esterne (presenti in altre lingue)`n"
                    debugMsg .= "IT modificata: " newIt " (Q totale=" newItaQ ")`n"
                } else {
                    debugMsg .= "CASISTICA 4 TENTATA ma NON APPLICATA`n"
                }
            } else {
                debugMsg .= "CASISTICA 4 NON APPLICABILE`n"
            }
        } else {
            debugMsg .= "CASISTICA 4 NON APPLICABILE: Nessuna outer nelle lingue di riferimento`n"
        }
        if (anyFixed) {
            ; Recheck match dopo fix
            match := false
            if (itTotalQuotes <= engTotalQuotes && Mod(itTotalQuotes, 2) = 0) {
                match := true
                debugMsg .= "MATCH ora trovato dopo questa casistica - Stop correzioni`n"
            } else if (textFrOrig != "" && itTotalQuotes <= frTotalQuotes && Mod(itTotalQuotes, 2) = 0) {
                match := true
                debugMsg .= "MATCH ora trovato dopo questa casistica - Stop correzioni`n"
            } else if (textSpOrig != "" && itTotalQuotes <= spTotalQuotes && Mod(itTotalQuotes, 2) = 0) {
                match := true
                debugMsg .= "MATCH ora trovato dopo questa casistica - Stop correzioni`n"
            }
            if (match) {
                goto EndFixed
            }
        }
        ; === RIAPPLICA: riduci più virgolette esterne a due (garantisce coppia esterna) ===
        hasOuterInAny := hasSurroundingQuotes(textEngNorm) || (textFrOrig != "" && hasSurroundingQuotes(textFrNorm)) || (textSpOrig != "" && hasSurroundingQuotes(textSpNorm))
        if (hasOuterInAny) { ; Nuova condizione: Solo se outer presenti in almeno una lingua
            res := EnsureTwoOuterQuotes(textIt)
            if (res.changed) {
                candidate := res.text
                candidateQ := CountAllQuotes(candidate, true)
                maxOtherQ := engTotalQuotes ; ... (calcola max come prima)
                if (Mod(candidateQ, 2) = 0 && candidateQ <= maxOtherQ) {
                    if (candidate != textIt) { ; Nuova check: Applica solo se davvero cambiato
                        anyFixed := true
                        textIt := candidate
                        itTotalQuotes := candidateQ
                        debugMsg .= "`nCASISTICA 4B APPLICATA: ridotte virgolette esterne a coppia`n"
                        debugMsg .= "IT prima: " textIt " (Q totale=" itTotalQuotes ")`n"
                        debugMsg .= "IT dopo: " candidate " (Q totale=" candidateQ ")`n"
                    } else {
                        debugMsg .= "`nCASISTICA 4B TENTATA ma NON APPLICATA: Nessun cambiamento effettivo`n"
                    }
                } else {
                    debugMsg .= "`nCASISTICA 4B TENTATA ma NON APPLICATA: Q=" candidateQ " non valido`n"
                }
            } else {
                debugMsg .= "`nCASISTICA 4B NON APPLICABILE`n"
            }
        } else {
            debugMsg .= "`nCASISTICA 4B NON APPLICABILE: Nessuna outer nelle lingue di riferimento`n"
        }
        if (anyFixed) {
            ; Recheck match dopo fix
            match := false
            if (itTotalQuotes <= engTotalQuotes && Mod(itTotalQuotes, 2) = 0) {
                match := true
                debugMsg .= "MATCH ora trovato dopo questa casistica - Stop correzioni`n"
            } else if (textFrOrig != "" && itTotalQuotes <= frTotalQuotes && Mod(itTotalQuotes, 2) = 0) {
                match := true
                debugMsg .= "MATCH ora trovato dopo questa casistica - Stop correzioni`n"
            } else if (textSpOrig != "" && itTotalQuotes <= spTotalQuotes && Mod(itTotalQuotes, 2) = 0) {
                match := true
                debugMsg .= "MATCH ora trovato dopo questa casistica - Stop correzioni`n"
            }
            if (match) {
                goto EndFixed
            }
        }
        ; === CASISTICA 4C SEMPLIFICATA (corretta): lavora sul sorgente italiano originale e non su eventuale fallback ENG ===
        ; usa textItOrig come sorgente garantita del testo italiano non sovrascritto
        srcIt := textItOrig
        ; Normalizza prima eventuali surrogate per avere comportamento consistente
        srcItNorm := NormalizeQuotes(srcIt)
        hasOuterInAny := hasSurroundingQuotes(textEngNorm) || (textFrOrig != "" && hasSurroundingQuotes(textFrNorm)) || (textSpOrig != "" && hasSurroundingQuotes(textSpNorm))
        if (hasOuterInAny) { ; Nuova condizione: Solo se outer in almeno una lingua
            res := EnsureTwoOuterQuotes(srcItNorm) ; opera su srcItNorm pulito
            if (res.changed) {
                cand := res.text
                candQ := CountAllQuotes(cand, true)
                ; calcola massimo confronto tra ENG/FR/SP
                maxOtherQ := engTotalQuotes
                if (frTotalQuotes != -1 && frTotalQuotes > maxOtherQ)
                    maxOtherQ := frTotalQuotes
                if (spTotalQuotes != -1 && spTotalQuotes > maxOtherQ)
                    maxOtherQ := spTotalQuotes
                applied := false
                ; Caso 1: versione ridotta è già valida
                if (Mod(candQ, 2) = 0 && candQ <= maxOtherQ) {
                    if (cand != srcIt) { ; Nuova: Applica solo se cambiato
                        anyFixed := true
                        textIt := cand
                        itTotalQuotes := candQ
                        applied := true
                        debugMsg .= "`nCASISTICA 4C APPLICATA (diretto su IT orig)`n"
                        debugMsg .= "IT orig: " textItOrig " (Q totale originale=" CountAllQuotes(textItOrig, true) ")`n"
                        debugMsg .= "IT dopo: " cand " (Q totale=" candQ ")`n"
                    } else {
                        debugMsg .= "`nCASISTICA 4C TENTATA ma NON APPLICATA: Nessun cambiamento effettivo`n"
                    }
                }
                ; Caso 2: se candQ = 2 e possiamo avere Q = 4, aggiungi coppia esterna
                if (!applied && candQ = 2 && maxOtherQ >= 4) {
                    cand2 := """" . cand . """"
                    cand2Q := CountAllQuotes(cand2, true)
                    if (Mod(cand2Q, 2) = 0 && cand2Q <= maxOtherQ) {
                        anyFixed := true
                        textIt := cand2
                        itTotalQuotes := cand2Q
                        applied := true
                        debugMsg .= "`nCASISTICA 4C APPLICATA: ridotte a coppia poi aggiunta coppia esterna per Q=4`n"
                        debugMsg .= "IT orig: " textItOrig " (Q totale originale=" CountAllQuotes(textItOrig, true) ")`n"
                        debugMsg .= "IT intermedia (2): " cand " (Q totale=2)`n"
                        debugMsg .= "IT dopo (4): " cand2 " (Q totale=" cand2Q ")`n"
                    }
                }
                if (!applied) {
                    debugMsg .= "`nCASISTICA 4C TENTATA ma NON APPLICATA: Q=" candQ " (maxOtherQ=" maxOtherQ ")`n"
                }
            } else {
                debugMsg .= "`nCASISTICA 4C NON APPLICABILE`n"
            }
        } else {
            debugMsg .= "`nCASISTICA 4C NON APPLICABILE: Nessuna outer nelle lingue di riferimento`n"
        }
        if (anyFixed) {
            ; Recheck match dopo fix
            match := false
            if (itTotalQuotes <= engTotalQuotes && Mod(itTotalQuotes, 2) = 0) {
                match := true
                debugMsg .= "MATCH ora trovato dopo questa casistica - Stop correzioni`n"
            } else if (textFrOrig != "" && itTotalQuotes <= frTotalQuotes && Mod(itTotalQuotes, 2) = 0) {
                match := true
                debugMsg .= "MATCH ora trovato dopo questa casistica - Stop correzioni`n"
            } else if (textSpOrig != "" && itTotalQuotes <= spTotalQuotes && Mod(itTotalQuotes, 2) = 0) {
                match := true
                debugMsg .= "MATCH ora trovato dopo questa casistica - Stop correzioni`n"
            }
            if (match) {
                goto EndFixed
            }
        }
        ; === CASISTICA 5: Normalizzazione surrogati anche dopo altre casistiche ===
        ; Usa la versione aggiornata di textIt (eventualmente modificata dalle casistiche precedenti)
        va = """
        va1 = “
        va2 = ”
        va3 = «
        va4 = »
        ; === CASISTICA 5 (semplice): sostituzione carattere-per-carattere e verifica ===
        if InStr(textIt, va1) || InStr(textIt, va2) || InStr(textIt, va3) || InStr(textIt, va4) {
            ; normalizzazione carattere-per-carattere (curly -> doppia ASCII)
            normalizedIt := StrReplace(textIt, va1, va)
            normalizedIt := StrReplace(normalizedIt, va2, va)
            normalizedIt := StrReplace(normalizedIt, va3, va)
            normalizedIt := StrReplace(normalizedIt, va4, va)
            if (normalizedIt != textIt) {
                ; ricalcola il conteggio virgolette sul testo normalizzato
                newItaQ := CountAllQuotes(normalizedIt, true)
                ; calcola massimo confronto tra ENG/FR/SP
                maxOtherQ := engTotalQuotes
                if (frTotalQuotes != -1 && frTotalQuotes > maxOtherQ)
                    maxOtherQ := frTotalQuotes
                if (spTotalQuotes != -1 && spTotalQuotes > maxOtherQ)
                    maxOtherQ := spTotalQuotes
                ; valida e applica
                if (Mod(newItaQ, 2) = 0 && newItaQ <= maxOtherQ) {
                    anyFixed := true
                    textIt := normalizedIt
                    itTotalQuotes := newItaQ
                    debugMsg .= "`nCASISTICA 5 APPLICATA: conversione carattere-per-carattere in virgolette ASCII`n"
                    debugMsg .= "IT dopo: " normalizedIt " (Q totale=" newItaQ ")`n"
                } else {
                    debugMsg .= "`nCASISTICA 5 TENTATA ma NON APPLICATA: newQ=" newItaQ " (non valido rispetto ai limiti)`n"
                }
            } else {
                debugMsg .= "`nCASISTICA 5 NON APPLICABILE`n"
            }
        } else {
            debugMsg .= "`nCASISTICA 5 NON APPLICABILE`n"
        }
        if (anyFixed) {
            ; Recheck match dopo fix
            match := false
            if (itTotalQuotes <= engTotalQuotes && Mod(itTotalQuotes, 2) = 0) {
                match := true
                debugMsg .= "MATCH ora trovato dopo questa casistica - Stop correzioni`n"
            } else if (textFrOrig != "" && itTotalQuotes <= frTotalQuotes && Mod(itTotalQuotes, 2) = 0) {
                match := true
                debugMsg .= "MATCH ora trovato dopo questa casistica - Stop correzioni`n"
            } else if (textSpOrig != "" && itTotalQuotes <= spTotalQuotes && Mod(itTotalQuotes, 2) = 0) {
                match := true
                debugMsg .= "MATCH ora trovato dopo questa casistica - Stop correzioni`n"
            }
            if (match) {
                goto EndFixed
            }
        }
EndFixed:
        hasValid := (itTotalQuotes = 0) || (Mod(itTotalQuotes, 2) = 0)
        if (!anyFixed && !hasValid) {
            debugMsg .= "NESSUN MATCH e NON VALIDO (non fixabile) - Usa inglese`n"
            textIt := textEng
            rowToTranslate := """" . var1 . """,""" . var2 . """,""" . var3 . """,""" . var4 . """,""" . textEng . """`n"
            toTranslateContent .= rowToTranslate
            origRow := """" . var1 . """,""" . var2 . """,""" . var3 . """,""" . var4 . """,""" . textItOrig . """`n"
            toTranslateContent .= origRow
        } else if (!match && hasValid) {
            debugMsg .= "NESSUN MATCH ma VALIDO SECONDO LOGICA - Usa italiano`n"
            if (!expandToTranslate && !anyFixed) {
                rowToTranslate := """" . var1 . """,""" . var2 . """,""" . var3 . """,""" . var4 . """,""" . textEng . """`n"
                toTranslateContent .= rowToTranslate
                origRow := """" . var1 . """,""" . var2 . """,""" . var3 . """,""" . var4 . """,""" . textItOrig . """`n"
                toTranslateContent .= origRow
            }
        } else {
            debugMsg .= "MATCH CONFERMATO - Usa italiano`n"
        }
        debugMsg .= "Riga italiana originale: """ . var1 . """,""" . var2 . """,""" . var3 . """,""" . var4 . """,""" . textItOrig . """`n"
        logContent .= "Mismatch virgolette per chiave " . key . ":`n" . debugMsg . "`n"
    } else {
        debugMsg .= "MATCH CONFERMATO - Usa italiano`n"
    }
    var5 := textIt
}
; === LUNGA LISTA STRINGREPLACE PER preparatestopergioco ===
if (preparatestopergioco) {
    var5chesost := var5
    var5chesost := StrReplace(var5chesost, "battlefield", "Campo di battaglia - Battleground Match")
    var5chesost := StrReplace(var5chesost, "Summerset", "Isola del Tramonto - Summerset")
    var5chesost := StrReplace(var5chesost, "Reaper's March", "Marcia del Mietitore - Reaper's March")
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
; Escaping standard CSV
;var5 := StrReplace(var5, """", """""")
v = "
v1 = ","
rowLine := v . var1 . v1 . var2 . v1 . var3 . v1 . var4 . v1 . var5 . v "`n"
output .= rowLine
if (anyFixed) {
    corrRow := v . var1 . v1 . var2 . v1 . var3 . v1 . var4 . v1 . var5 . v "`n"
    corrContent .= corrRow
}
if (debugLimit > 0 && mismatchCount >= debugLimit) {
    goto SaveAndExit
}
return
NormalizeQuotes(text) {
    text := StrReplace(text, "“", """")
    text := StrReplace(text, "”", """")
    text := StrReplace(text, "«", """")
    text := StrReplace(text, "»", """")
    ; text := StrReplace(text, "‘", "'")
    ; text := StrReplace(text, "’", "'")
    return text
}
CountAllQuotes(text, isItalian := false) {
    count := 0
    count += (StrLen(text) - StrLen(StrReplace(text, """"))) * 1
    count += (StrLen(text) - StrLen(StrReplace(text, "“"))) * 2
    count += (StrLen(text) - StrLen(StrReplace(text, "”"))) * 2
    count += (StrLen(text) - StrLen(StrReplace(text, "«"))) * 2
    count += (StrLen(text) - StrLen(StrReplace(text, "»"))) * 2
    if (!isItalian) {
        allSingle := (StrLen(text) - StrLen(StrReplace(text, "'"))) + (StrLen(text) - StrLen(StrReplace(text, "’")))
        apoRepl := RegExReplace(text, "[a-zA-Z]'[a-zA-Z]|[a-zA-Z]’[a-zA-Z]", "", apoCount)
        quoteSingleCount := allSingle - apoCount
        count += quoteSingleCount * 2
    }
    return count
}
GetValidQCandidates(totalQuotes) {
    validCandidates := []
    if (totalQuotes < 0)
        return []
    loopVar := Floor(totalQuotes / 2) * 2
    while (loopVar >= 0) {
        validCandidates.Push(loopVar)
        loopVar -= 2
    }
    return validCandidates
}
hasSurroundingQuotes(text) {
    if (text = "")
        return false
    first := SubStr(text, 1, 1)
    last := SubStr(text, StrLen(text), 1)
    return (first = """" || first = "'") && (last = """" || last = "'")
}
ArrayToString(arr) {
    result := ""
    for i, val in arr {
        if (i > 1)
            result .= ", "
        result .= val
    }
    return "[" result "]"
}
SaveAndExit:
logFile := A_ScriptDir . "\daconttrollare.txt"
corrFile := A_ScriptDir . "\verifica.txt"
toTranslateFile := A_ScriptDir . "\daritradurre.txt"
FileDelete, %logFile%
FileAppend, %logContent%, %logFile%, UTF-8
FileDelete, %corrFile%
FileAppend, %corrContent%, %corrFile%, UTF-8
FileDelete, %toTranslateFile%
FileAppend, %toTranslateContent%, %toTranslateFile%, UTF-8
outputFile := A_ScriptDir . "\output.csv"
FileDelete, %outputFile%
FileAppend, %output%, %outputFile%, UTF-8
MsgBox, 64, Debug Limit Raggiunto, Raggiunto limite debug di %debugLimit% mismatch.nFile parziali generati., 5
ExitApp
EnsureTwoOuterQuotes(text) {
    lead := 0
    while (SubStr(text, lead + 1, 1) = """") {
        lead++
    }
    len := StrLen(text)
    trail := 0
    while (SubStr(text, len - trail, 1) = """") {
        trail++
    }
    changed := (lead <> 1 || trail <> 1)
    if (changed) {
        inner := SubStr(text, lead + 1, len - lead - trail)
        newtext := """" . inner . """"
    } else {
        newtext := text
    }
    return {changed: changed, text: newtext}
}
RemoveAllOuterQuotes(text) {
    lead := 0
    while (SubStr(text, lead + 1, 1) = """") {
        lead++
    }
    len := StrLen(text)
    trail := 0
    while (SubStr(text, len - trail, 1) = """") {
        trail++
    }
    changed := (lead > 0 || trail > 0)
    if (changed) {
        inner := SubStr(text, lead + 1, len - lead - trail)
        newtext := inner
    } else {
        newtext := text
    }
    return {changed: changed, text: newtext}
}
DecideMarker(key, itRaw, frRaw, spRaw) {
    global markerMap
    frNorm := NormalizeMarkerInString(frRaw)
    spNorm := NormalizeMarkerInString(spRaw)
    frMarker := ExtractMarkerFromString(frNorm)
    spMarker := ExtractMarkerFromString(spNorm)
    frClean := frMarker ? SubStr(frMarker, 2) : ""
    spClean := spMarker ? SubStr(spMarker, 2) : ""
    if (frClean = "" && spClean = "")
        return ""
    if (frClean != "" && spClean != "" && frClean = spClean)
        return frMarker
    if (frClean != "" && spClean != "")
        return "" ; Conflitto → non correggere
    return (frClean != "" ? frMarker : spMarker)
}
GetGenderFromWord(word) {
if (Trim(word) = "") {
return ""
}
word := Trim(word)
; Estrai la prima parola principale (per nomi composti)
RegExMatch(word, "^([^\s]+)", mainWord)
mainWord := mainWord1
; Analisi terminazione (minuscolo)
mainWordLower := Format("{:L}", mainWord)
len := StrLen(mainWordLower)
lastChar := SubStr(mainWordLower, len, 1) ; Ultima lettera
lastTwo := (len >= 2) ? SubStr(mainWordLower, len-1, 2) : "" ; Ultime due lettere
; Determinazione genere e numero dalla parola
gender := ""
number := ""
; Casi speciali per override (es. errori AI comuni)
if (lastTwo = "ci" || lastTwo = "di" || lastTwo = "ti") {
gender := "f"
number := "p"
} else if (lastChar = "a") {
gender := "f"
number := "s"
} else if (lastChar = "o") {
gender := "m"
number := "s"
} else if (lastChar = "i") {
gender := "m"
number := "p"
} else if (lastChar = "e") {
gender := "m" ; Default m s per -e (es. portatore), ma override sotto se speciale
number := "s"
}
; Casi ESO specifici (aggiungi qui se noti pattern, es. per eclissi)
if (mainWordLower = "eclissi" || mainWordLower = "concentrazione" || mainWordLower = "protezione") {
gender := "f"
number := "s" ; Forza f s per questi
} else if (mainWordLower = "mine") {
gender := "f"
number := "p"
}
if (mainWordLower = "dispetto") {
gender := "m"
number := "s"
}
if (gender = "") {
return "" ; Non deducibile
}
; Calcola se inizia con vocale/H o speciale per distinguere i marcatori
firstChar := Format("{:L}", SubStr(word, 1, 1))
secondChar := (StrLen(word) >= 2) ? Format("{:L}", SubStr(word, 2, 1)) : ""
isVowel := InStr("aeiouàèéìòùáéíóúäëïöü", firstChar)
isH := (firstChar = "h")
startsWithVowelOrH := isVowel || isH
startsWithSpecial := false
if (firstChar = "s" && secondChar != "" && !InStr("aeiouàèéìòùáéíóúäëïöü", secondChar)) {
startsWithSpecial := true
} else if (firstChar = "z") {
startsWithSpecial := true
} else if (firstChar = "g" && secondChar = "n") {
startsWithSpecial := true
} else if (firstChar = "p" && (secondChar = "s" || secondChar = "n")) {
startsWithSpecial := true
} else if (firstChar = "x" || firstChar = "y") {
startsWithSpecial := true
}
; Mappa al marcatore specifico basato su genere, numero e regole iniziali
marker := ""
if (number = "s") {
if (gender = "f") {
if (startsWithVowelOrH) {
marker := "^f" ; Per l' (elisione)
} else {
marker := "^fd" ; Per la (default femminile singolare)
}
} else if (gender = "m") {
if (startsWithVowelOrH) {
marker := "^m" ; Per l' (elisione maschile)
} else if (startsWithSpecial) {
marker := "^ms" ; Per lo (speciale come s+cons, z, gn, etc.)
} else {
marker := "^md" ; Per il (default maschile singolare)
}
}
} else if (number = "p") {
if (gender = "f") {
marker := "^fp" ; Per le (femminile plurale, no variazioni)
} else if (gender = "m") {
if (startsWithVowelOrH || startsWithSpecial) {
marker := "^np" ; Per gli (plurale speciale/eliso, usando neutral come variante)
} else {
marker := "^mp" ; Per i (default maschile plurale)
}
}
}
return marker
}
; -----------------------
; NormalizeMarkerInString: trova tutti i marker ^xxxx, li normalizza (lowercase)
; e applica eventuale mappatura definita in markerMap (global).
; Restituisce la stringa modificata.
; -----------------------
NormalizeMarkerInString(str)
{
    global markerMap
    if (str = "")
        return str
    new := str
    pos := 1
    ; loop per tutte le occorrenze successive di ^<letters>
    while RegExMatch(new, "\^([A-Za-z]{1,6})\b", m, pos)
    {
        matchPos := m ; posizione dell'intero match
        matchFull := SubStr(new, matchPos) ; parte rimanente dalla match
        ; estrai l'intera occorrenza (es. ^ifd o ^md)
        if RegExMatch(matchFull, "^\^([A-Za-z]{1,6})\b", mm)
        {
            raw := mm1
            ; normalizza in lowercase e rimuovi prefisso i se c'è
            StringLower, rawLower, raw
            if (SubStr(rawLower,1,1) = "i" && StrLen(rawLower) > 1)
                rawLower := SubStr(rawLower,2)
            ; determina replacement: usa markerMap se presente
            if (IsObject(markerMap) && markerMap.HasKey(rawLower))
                replacement := "^" . markerMap[rawLower]
            else
                replacement := "^" . rawLower
            ; ricomponi la stringa
            before := SubStr(new, 1, matchPos-1)
            after := SubStr(new, matchPos + StrLen(mm0))
            new := before . replacement . after
            ; sposta pos oltre il replacement
            pos := matchPos + StrLen(replacement)
        }
        else
            break
    }
    return new
}
; -----------------------
; ExtractMarkerFromString: estrae il primo marker come stringa minuscola senza prefisso i
; restituisce es. "md" o "" se non trovato
; -----------------------
ExtractMarkerFromString(str)
{
    if (str = "") return ""
    if RegExMatch(str, "\^([A-Za-z]{1,6})\b", m)
    {
        marker := m1
        StringLower, marker, marker
        if (SubStr(marker,1,1) = "i" && StrLen(marker) > 1)
            marker := SubStr(marker,2)
        return marker
    }
    return ""
}