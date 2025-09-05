#SingleInstance force

CoordMode, ToolTip, Screen

IniRead, cancellacartellatemp, impostazioni.ini, impostazioni, cancellacartellatemp
if (cancellacartellatemp = "ERROR")
  {
   MsgBox, 4,,abilitare cancellazione  cartella temp? (premi SI or NO)
IfMsgBox Yes
    {
     cancellacartellatemp := 1
     IniWrite,1, impostazioni.ini, impostazioni, cancellacartellatemp
    }
    else
    {
     cancellacartellatemp := 0
     IniWrite,0, impostazioni.ini, impostazioni, cancellacartellatemp
    }  
  
  }

IniRead, sceltametodocancellazione, impostazioni.ini, impostazioni, sceltametodocancellazione
if (sceltametodocancellazione = "ERROR")
  {
  inputbox,sceltametodocancellazione,sceltametodocancellazione,inserire 1 testato 2 veloce ; 3 ancora più veloce con Remove-Item

     IniWrite,%sceltametodocancellazione%, impostazioni.ini, impostazioni, sceltametodocancellazione
  
  }


IniRead, aggiornamentowindows, impostazioni.ini, impostazioni, aggiornamentowindows
if (aggiornamentowindows = "ERROR")
  {
   
   MsgBox, 4,, abilitare aggiornamento windows? (premi SI or NO)
IfMsgBox Yes
    {
     aggiornamentowindows := 1
     IniWrite,1, impostazioni.ini, impostazioni, aggiornamentowindows
    }
    else
    {
     aggiornamentowindows := 0
     IniWrite,0, impostazioni.ini, impostazioni, aggiornamentowindows
    }  
  
  }




IniRead, filtrodata, impostazioni.ini, impostazioni, filtrodata
if (filtrodata = "ERROR")
  {
   
   MsgBox, 4,, abilitare filtro per data? (premi SI or NO)
IfMsgBox Yes
    {
     filtrodata := 1
     IniWrite,1, impostazioni.ini, impostazioni, filtrodata
    }
    else
    {
     filtrodata := 0
     IniWrite,0, impostazioni.ini, impostazioni, filtrodata
    }  
  
  }
  
IniRead, INTERVALLODATEUSCITA, impostazioni.ini, impostazioni, INTERVALLODATEUSCITA
;MSGBOX % INTERVALLODATEUSCITA
if (INTERVALLODATEUSCITA = "ERROR")
  {
   
   INPUTBOX,INTERVALLODATEUSCITA, INSERIRE INTERVALLO DATE PER NON ESECUZIONE PROGRAMMA, , , ,,,,,,0615|0901 
   
     IniWrite,%INTERVALLODATEUSCITA%, impostazioni.ini, impostazioni, INTERVALLODATEUSCITA
   
  
  }



IniRead, eliminazioneautomatica, impostazioni.ini, impostazioni, eliminazioneautomatica
if (eliminazioneautomatica = "ERROR")
  {
   
   MsgBox, 4,, abilitare l'eliminazione automatica utenti? (premi SI or NO)
IfMsgBox Yes
    {
     eliminazioneautomatica := 1
     IniWrite,1, impostazioni.ini, impostazioni, eliminazioneautomatica
    }
    else
    {
     eliminazioneautomatica := 0
     IniWrite,0, impostazioni.ini, impostazioni, eliminazioneautomatica
    }  
  
  }
  
IniRead, pausa, impostazioni.ini, impostazioni, pausa
if (pausa = "ERROR")
  {
   
  INPUTBOX,pausa, INSERIRE SECONDI PAUSA DOPO MESSAGGI, , , ,,,,,,30
     ;INTERvallodate := 1
     IniWrite,%PAUSA%, impostazioni.ini, impostazioni, pausa
  
  }  
  

 IniRead, chiusurapcaltermine, impostazioni.ini, impostazioni, chiusurapcaltermine
if (chiusurapcaltermine = "ERROR")
  {
   
   MsgBox, 4,, Chiudere il pc una volta concluso il lavoro? (premi SI or NO)
IfMsgBox Yes
    {
     chiusurapcaltermine := 1
     IniWrite,1, impostazioni.ini, impostazioni, chiusurapcaltermine
    }
    else
    {
     chiusurapcaltermine := 0
     IniWrite,0, impostazioni.ini, impostazioni, chiusurapcaltermine
    }  
  
  }  
  
 */ 


if (cancellacartellatemp = 1)
   gosub, cancellacartellatemp

if (aggiornamentowindows = 1)
   {
MsgBox, 1, , vuoi avviare aggiornamento di windows (Press YES or NO)
IfMsgBox Yes
    RunWait, cmd /c "wuauclt /detectnow & wuauclt /updatenow", , Hide
   }


;MSGBOX % INTERVALLODATEUSCITA
StringSplit, DATAArray, INTERVALLODATEUSCITA,|
;SubStr("123abc789", 4, 3) ; Returns abc

data := A_MM A_dd

;MSGBOX % data " <= " DATAArray1 " or " data ">= " DATAArray2 

if (filtrodata = 1)
  IF (data <= DATAArray1) or (data >= DATAArray2)
    {
     MSGBOX,0,elimina utenti, ESCE PROGRAMMA, %pausa%
     exitapp
    } 
    ;ELSE
    ;{
    ; MSGBOX ESEGUE PROGRAMMA
     
    ;} 
    

Menu, Tray, Add,eliminazione automatica, eliminazioneautomatica 
if (eliminazioneautomatica = 1)
   Menu,tray , check,eliminazione automatica
else
  Menu,tray , Uncheck,eliminazione automatica

Menu, Tray, Add, chiusura al termine, chiusurapcaltermine
if (chiusurapcaltermine = 1)
   Menu,tray , check,chiusura al termine
else
  Menu,tray , Uncheck,chiusura al termine
  
Menu, Tray, Add, filtro data, filtrodata
if (filtrodata = 1)
   Menu,tray , check,filtro data
else
  Menu,tray , Uncheck,filtro data



if A_OSVersion in WIN_XP
{
   MsgBox, 262160, Profile Remover, This is not compatible with XP.`n`nThis script will now exit.
   ExitApp
}

if not A_IsAdmin
{
   Run *RunAs "%A_AhkPath%" "%A_ScriptFullPath%"
   ExitApp
}

OnExit("Cleanup")
OnExit(ObjBindMethod(MyObject, "Exiting"))
SetBatchLines, -1

TempFolder = %A_Temp%\ProfileKiller
TempFolder =  %A_MyDocuments%\trash

FileCreateDir %TempFolder%

selezioneutente := 1
creagui:
Gui, Destroy
sleep 1
Gui, Margin, 10, 10

if(selezioneutente = 1)
Gui, Add, ListView, List r10 w460 h380 Grid vVLV hwndHLV gColClick
   , User Profiles|Last Modified|Size|SSID|Extra
else   
Gui, Add, ListView,  r10 w460 h380 Grid vVLV hwndHLV gColClick
   , User Profiles|Last Modified|Size|SSID|Extra   
   
Gui Add, Text, x476 y5, Select the profiles to remove and click Go.
Gui Add, Text, x476 y25 w220, Any rows highlighted in yellow are user folders that are invalid and are not in the registry.
Gui Add, Button, x476 y60 w50 gaggiornastatogui, Go
gosub UserList

; Create a new instance of LV_Colors
CLV := New LV_Colors(HLV)


; Set the colors for selected rows
CLV.SelectionColors(0x0000FF, 0xFFFFFF)
If !IsObject(CLV) {
   MsgBox, 0, ERROR, Couldn't create a new LV_Colors object!
   ExitApp
}

;msgbox % "iooi " CLV " --- " HLV

; ======  Adjusting column widths  ======
LV_ModifyCol(1, AutoHdr)
LV_ModifyCol(3, 80)
LV_ModifyCol(4, 0)
LV_ModifyCol(5, 0)


Gui Show, xCenter YCenter, Profile Remover

; Redraw the ListView after the first Gui, Show command to show the colors, if any.
WinSet, Redraw, , ahk_id %HLV%




gosub ExtraFolders
gosub FolderSize

if (eliminazioneautomatica = 1)
{

;msgbox % "myUserList " myUserList
;msgbox % "ListUserName" ListUserName
 ListUserName := myUserList
 
 Gui eliminautenti:Add, text,, %ListUserName%
 Gui, eliminautenti:Show,X0 Y0 
 
 MsgBox, 4, , rimuovere i seguenti utenti - avvio automatico dopo %pausa% secondi, %pausa%
;IfMsgBox Timeout
;    MsgBox You didn't press YES or NO within the 5-second period.
  IfMsgBox No
   {
    gui eliminautenti:destroy
    return
   }
 gosub,engage
}


Loop
{
    ; Controlla aggiornamenti disponibili online
    RunWait, powershell -Command "Get-WindowsUpdate | Out-File %A_Temp%\available_updates.txt", , Hide
    FileRead, availableUpdates, %A_Temp%\available_updates.txt

    ; Se ci sono aggiornamenti, installa
    If (availableUpdates != "")
    {
        RunWait, powershell -Command "Install-WindowsUpdate -AcceptAll -AutoReboot", , Hide

        ; Controlla se gli aggiornamenti sono stati completati
        Sleep, 60000  ; Attende 1 minuto prima di verificare
        RunWait, powershell -Command "Get-WindowsUpdate | Out-File %A_Temp%\available_updates.txt", , Hide
        FileRead, availableUpdates, %A_Temp%\available_updates.txt

        If (availableUpdates = "")
            Break  ; Se tutto è aggiornato, esce dal loop
    }
    Else
        Break  ; Se non ci sono aggiornamenti, esce subito
    
    Sleep, 60000  ; Attende 1 minuto prima di ripetere il controllo
}


if (aggiornamentowindows = 1)
   {

   
 RunWait, powershell -Command "Get-WindowsUpdate", , Hide
If ErrorLevel = 0
{
    
    RunWait, powershell -Command "Install-WindowsUpdate -AcceptAll -AutoReboot", , Hide
    
 ; Disabilita aggiornamenti automatici
    RunWait, cmd /c "sc config wuauserv start= disabled & net stop wuauserv", , Hide   
   
   }
; Spegne il PC
  else
; Disabilita aggiornamenti automatici
    RunWait, cmd /c "sc config wuauserv start= disabled & net stop wuauserv", , Hide
}




Return

GuiClose:
GuiEscape:
ExitApp

cancellacartellatemp:


Run, "%A_ScriptDir%\PulisciTemp.exe"

return





UserList:
; ==============  get list of logged in users to exclude from list  ==================
RunWait cmd.exe /c quser > %TempFolder%\quser.txt,, Hide
;FileRead LoadedProfiles, %TempFolder%\quser.txt
FileRead LoadedProfiles, quser.txt
LoadedProfiles := LoadedProfiles listadaescludere

;msgbox % "fer " LoadedProfiles 

; ==============  this piece gets the list of existing profiles from registry  ==================
ProfileRegList = HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList

Loop Reg, %ProfileRegList%, KR
{
	if (A_LoopRegName = "S-1-5-18" or A_LoopRegName = "S-1-5-19" or A_LoopRegName = "S-1-5-20")
		continue ; skip the above system accounts
	SIDNames = %SIDNames%%A_LoopRegName%`n ; add the SID #s of these reg entries to a list
}

; ======  parse the SID list and get the username each corresponds to  ======
Loop Parse, SIDNames, `n
{
	if A_LoopField = ; if empty, move on
		continue
	RegRead LocalPath, %ProfileRegList%\%A_LoopField%, ProfileImagePath
	LocalPath := StrReplace(LocalPath, "C:\Users\") ; remove the beginning of the path so it's just the username
	Needle = %LocalPath%%A_Space% ; Username plus a space
	
  ;msgbox % "fer1 "   LoadedProfiles "°°°°°°°°°°°°°° " Needle
    
    
	if InStr(LoadedProfiles, Needle) ; if the Username+Space is found in the list of loaded users
		{
        continue ; skip it
	    
        }
    LV_Add("",LocalPath,,, A_LoopField) ; this gives me a username and SID
	NewLocalPath = %NewLocalPath%%LocalPath%`n

    ;msgbox % "NewLocalPath " NewLocalPath
    
}
myUserList = %NewLocalPath%

;msgbox % "myUserList " myUserList


; ======  get last modified time for folders  ======
Loop Parse, myUserList, `n
{
	if A_LoopField =
		continue
	FileGetTime LastMod, C:\Users\%A_LoopField%
	FormatTime LastMod, %LastMod%, yyyy/M/d
	LV_Modify(A_Index, , , LastMod, "<calculating>")
}
return


ExtraFolders:
CLV.OnMessage()
GuiControl, Focus, %HLV%
GuiControl, -Redraw, %HLV%
CLV.Clear(1, 1)

Loop Files, C:\Users\*, D
{
	Needle = %A_LoopFileName%%A_Space% ; Username plus a space
	if InStr(LoadedProfiles, Needle) ; if the Username+Space is found in the list of loaded users
		continue ; skip it
	
	if (A_LoopFileName = "All Users" or A_LoopFileName = "Default" or A_LoopFileName = "Default User" or A_LoopFileName = "Public" or A_LoopFileName = "Administrator")
		continue
		
	if !InStr(NewLocalPath, A_LoopFileName . "`n")
	{
		FileGetTime LastMod, C:\Users\%A_LoopFileName%
		FormatTime LastMod, %LastMod%, yyyy/M/d
        LV_Add("", A_LoopFileName, LastMod, "<calculating>",, "1")
		Row := LV_GetCount()
		CLV.Row(Row, 0xFFFF00, 0x000000) ; make it yellow
	}
}
CLV.NoSort(False) ; this enables column re-sorting
GuiControl, +Redraw, %HLV%
return



; ======  calculate user folder sizes  ======
FolderSize:
Loop
{
   LV_GetText(Name, A_Index)  ; Resume the search at the row after that found by the previous iteration.
   if Name =
      break
   
   ; ======  calculate the size.  No offline files, directories or system files.  The last two don't make much diff for size but speeds it up  ======
   if A_OSVersion in WIN_7,WIN_8,WIN_8.1,WIN_VISTA
		RunWait cmd.exe /c dir C:\Users\%Name% /a:-D-S /S > %TempFolder%\%Name%-Size.txt,, Hide
	
    else if (A_OSVersion >= "10.0.17763")
		; the Offline file attribute was introduced in version 1809 of Windows 10, which is preferred, as it 
		; lets me calculate the actual "on disk" file size.  Not just what is allocated by offline files in cloud-syncing programs.
		RunWait cmd.exe /c dir C:\Users\%Name% /a:-O-D-S /S > %TempFolder%\%Name%-Size.txt,, Hide
	
    else ; if W10 and lower than 1809
		RunWait cmd.exe /c dir C:\Users\%Name% /a:-D-S /S > %TempFolder%\%Name%-Size.txt,, Hide
   
   FileRead theText, %TempFolder%\%Name%-Size.txt
   
   ; ======  get beginning of location from bottom and trim  ======
   FileLineNum := InStr(theText, "File", , 0, 1)
   Replacement1 := SubStr(theText, FileLineNum)
   
   ; ======  get end of byte #'s and trim  ======
   0Dir := InStr(Replacement1, "0 Dir",, 0) - 1
   Replacement1 := SubStr(Replacement1, 1, 0Dir)
   
   ; ======  get rid of extra stuff  ======
   Replacement1 := StrReplace(Replacement1, "bytes", "")
   Replacement1 := StrReplace(Replacement1, ",", "")
   Replacement1 := StrReplace(Replacement1, "File(s) ", "")
   Replacement1 := StrReplace(Replacement1, "`r`n", "")
   Replacement1 := StrReplace(Replacement1, " ", "")
   
   ; ======  converstion from bytes to xxx.x MB or xx.xx GB  ======
   if (Replacement1 <= 1073741824) ; if < 1GB
   {
      Replacement1 := Replacement1 // 1024 / 1024 ; the individual "/" is not a mistake
      Replacement1 := Round(Replacement1, 1)
      LV_Modify(A_Index, , , , Replacement1 . "  MB") ; modify the size field with calculated value
   }
   else
   {
      Replacement1 := Replacement1 // 1024 // 1024 / 1024
      Replacement1 := Round(Replacement1, 2)
      LV_Modify(A_Index, , , , Replacement1 . "  GB")
   }
}
return




; ======  this section is to re-color the "extra" user profiles if the columns are re-sorted  ======
ColClick:
CLV.OnMessage()
GuiControl, Focus, %HLV%
GuiControl, -Redraw, %HLV%
CLV.Clear(1, 1)

Loop
{
   LV_GetText(Name, A_Index)  ; Resume the search at the row after that found by the previous iteration.
   if Name =
      break
   
   LV_GetText(Extra, A_Index, 5)
   if Extra = 1
      CLV.Row(A_Index, 0xFFFF00, 0x000000)
   else
      CLV.Row(A_Index)


   ;msgbox % "ds " clv
}

;msgbox % "ds7 " HLV
GuiControl, +Redraw, %HLV%
;msgbox % "ds7 " HLV

return


aggiornastatogui:


if (selezioneutente = 1)
  {
  selezioneutente := 0
  ;

  RowNumber := 0
  listadacancellare := ""
  loop
   {
    RowNumber := LV_GetNext(RowNumber)
    
    if not RowNumber  
        break 
        
    
    LV_GetText(ListUserName, RowNumber)
    
   listadacancellare := listadacancellare "`n" ListUserName 

   
   }
 
 ;msgbox % listadacancellare
 RowNumber := LV_GetCount()
 tot := RowNumber
 ;msgbox % RowNumber
 i:= 0
 listadaescludere := ""
 
 loop %tot%
   {
     RowNumber := tot - i
    
      i := i + 1  
          
	LV_GetText(ListUserName, RowNumber)
    ;msgbox % "ds4 " ListUserName " -- " RowNumber " -- " i 
    
    If InStr(listadacancellare,ListUserName) 
      {
      }
      else
     listadaescludere := listadaescludere "`n" ListUserName 
    ;msgbox % "ds5 " listadaescludere
	                  
            
       
           
   }

    
   
  
 
  
  gosub, creagui
  return
  }

gosub,engage

return




; ======  kill the profile  ======
Engage:
; ========== Engage (sostitutivo completo) ==========

RowNumber = 0  ; This causes the first loop iteration to start the search at the top of the list.
con := 0
i := 0





; Nuovo: lista per utenti falliti al primo giro + set per evitare duplicati
daRiprova := []
giaSegnati := {}

FileDelete, %TEMP%\*
Loop, %TEMP%\*, 2
{
    FileRemoveDir, %A_LoopFileFullPath%, 1
}


MaxPassate   := 3
Passata      := 1
nonEliminati := ""




Loop
{
    RowNumber := LV_GetCount()
    RowNumber := RowNumber - i
    
    if (RowNumberprecedente = RowNumber)
    {
        con := con + 1
        if (con = 3)
        {
            con := 0
            i := i + 1
        }
    }
    
    RowNumberprecedente := RowNumber
    
    if not RowNumber
        break ; The above returned zero, so there are no more selected rows.

    LV_GetText(ListUserName, RowNumber)
    LV_GetText(SSID, RowNumber, 4)

    Profile = C:\Users\%ListUserName%
    Gui, 2:add, progress, xCenter yCenter w500 h20 Range0-2
    Gui, 2:Show,, Removing User folder %Profile% RowNumber %RowNumber%

start := A_TickCount
tooltip, ora rimuove con delprof2.exe utente %SSID%,0,0
Run, delprof2.exe /u /id:%SSID%, , Hide, delPid

; Ciclo di timeout (es. 30 secondi)

timeoutMs := 180000

Loop {
    ; Se è terminato, esci
    Process, Exist, %delPid%
    if !ErrorLevel
        break

    ; Timeout superato?
if (A_TickCount - start > timeoutMs) {
    Log("Warning: DelProf2 non ha finito entro " . (timeoutMs/1000) . " s, lo termino e procedo con cleanup manuale")
    Process, Close, %delPid%  ; forza chiusura
    break
}

    Sleep, 500
}
tooltip, uscito DelProf2,0,0


    if (sceltametodocancellazione = 2)
    {
        
         tooltip, esecuzione primo giro rimozione files,0,0
        ;start := a_tickcount

        ; Imposta log file
        logFile := A_ScriptDir "\log_eliminazione.txt"
        handlePath := A_ScriptDir "\handle64.exe"
        resultFile := A_ScriptDir "\processi_bloccanti.txt"
        
        targetFolder := Profile
        
        
    ;msgbox % "vedi364 "   targetFolder  


; dentro il loop, per ciascun Profile:
if (CleanupSingleProfile(Profile
        , handlePath
        , resultFile
        , logFile))
{
    Log("Profilo " . ListUserName . " rimosso con CleanupSingleProfile")
    GuiControl, 2:, msctls_progress321, +1
    Continue ; passa al prossimo
}
        
        
        
        
        
        

        ; 🔹 1️⃣ Tentativo iniziale di rimozione permessi e contenuti

        
  start := A_TickCount
            Run, powershell -Command "if (Test-Path \"%targetFolder%\") { try { takeown /F \"%targetFolder%\" /R /D Y; icacls \"%targetFolder%\" /grant $env:USERNAME:F /T /C /Q; attrib -r -s -h \"%targetFolder%\" /S /D } catch { $_ | Out-File -Append -FilePath \"%logFile%\" } }", , Hide,psPid
timeoutMs := 180000
Loop {
    Process, Exist, %psPid%
    if !ErrorLevel
        break
    if (A_TickCount - start > timeoutMs) {
        Log("Timeout: comando PowerShell bloccato, lo termino")
        Process, Close, %psPid%
        break
    }
    Sleep, 500
} 
 
 
  start := A_TickCount
                   Run, powershell -Command "if (Test-Path \"%targetFolder%\") { try { Get-ChildItem -Path \"%targetFolder%\" -Recurse -Force -File | Remove-Item -Force -ErrorAction Stop } catch { $_ | Out-File -Append -FilePath \"%logFile%\" } }", , Hide    ,psPid
timeoutMs := 180000
Loop {
    Process, Exist, %psPid%
    if !ErrorLevel
        break
    if (A_TickCount - start > timeoutMs) {
        Log("Timeout: comando PowerShell bloccato, lo termino")
        Process, Close, %psPid%
        break
    }
    Sleep, 500
}  
 
        

        
  start := A_TickCount
                   RunWait, cmd /c "rmdir \"%targetFolder%\" /S /Q", , Hide, psPid
timeoutMs := 180000
Loop {
    Process, Exist, %psPid%
    if !ErrorLevel
        break
    if (A_TickCount - start > timeoutMs) {
        Log("Timeout: comando PowerShell bloccato, lo termino")
        Process, Close, %psPid%
        break
    }
    Sleep, 500
} 
        
        
        
        
        
  
   start := A_TickCount
                           Run, powershell -Command "if (Test-Path \"%targetFolder%\") { try { Remove-Item -Path \"%targetFolder%\" -Force -Recurse } catch { $_ | Out-File -Append -FilePath \"%logFile%\" } }", , Hide,  psPid
timeoutMs := 180000
Loop {
    Process, Exist, %psPid%
    if !ErrorLevel
        break
    if (A_TickCount - start > timeoutMs) {
        Log("Timeout: comando PowerShell bloccato, lo termino")
        Process, Close, %psPid%
        break
    }
    Sleep, 500
} 
      
  
  
        


        ; 🔹 2️⃣ Se ancora esiste, cerca i processi che la bloccano
   start := A_TickCount
    Run, "%handlePath%" "%targetFolder%" > "%resultFile%", , Hide, handlePid

    timeoutMs := 180000  ; 30 secondi

    Loop {
        Process, Exist, %handlePid%
        if !ErrorLevel
            break

        if (A_TickCount - start > timeoutMs) {
            Log("Timeout: handle64.exe non ha finito entro " . (timeoutMs/1000) . " s, lo termino")
            Process, Close, %handlePid%
            break
        }
        Sleep, 500
    }

    ; Ora leggi il file di output e chiudi eventuali processi bloccanti
    if FileExist(resultFile) {
        Loop, Read, %resultFile%
        {
            if RegExMatch(A_LoopReadLine, "i)pid: (\d+)", match) {
                pid := match1
                RunWait, powershell -Command "Stop-Process -Id %pid% -Force", , Hide
                Log("Terminato processo PID: " . pid)
            }
        }
        FileDelete, %resultFile%
    } 
            
            
            FileDelete, %resultFile%
            ; 🔁 Riprova la cancellazione finale
           
            
        }




   start := A_TickCount
                             Run, powershell -Command "if (Test-Path \"%targetFolder%\") { try { Remove-Item -Path \"%targetFolder%\" -Force -Recurse } catch { $_ | Out-File -Append -FilePath \"%logFile%\" } }", , Hide, psPid
timeoutMs := 180000
Loop {
    Process, Exist, %psPid%
    if !ErrorLevel
        break
    if (A_TickCount - start > timeoutMs) {
        Log("Timeout: comando PowerShell bloccato, lo termino")
        Process, Close, %psPid%
        break
    }
    Sleep, 500
} 













        ; 🔹 3️⃣ Riavvia Explorer se assente

   start := A_TickCount
                            RunWait, powershell -Command "if (!(Get-Process explorer -ErrorAction SilentlyContinue)) { Start-Process explorer.exe }", , Hide, psPid
timeoutMs := 180000
Loop {
    Process, Exist, %psPid%
    if !ErrorLevel
        break
    if (A_TickCount - start > timeoutMs) {
        Log("Timeout: comando PowerShell bloccato, lo termino")
        Process, Close, %psPid%
        break
    }
    Sleep, 500
} 


        ; 🔹 4️⃣ Robocopy + eliminazione con cartella temporanea
        IfExist %targetFolder%
        {
            cartellaTmp := A_ScriptDir "\temp"
            if not FileExist(cartellaTmp)
                FileCreateDir, %cartellaTmp%
           
            
            
            
      start := A_TickCount
Run, powershell -Command "robocopy \"%cartellaTmp%\" \"%targetFolder%\" /MIR", , Hide,psPid
timeoutMs := 180000
Loop {
    Process, Exist, %psPid%
    if !ErrorLevel
        break
    if (A_TickCount - start > timeoutMs) {
        Log("Timeout: comando PowerShell bloccato, lo termino")
        Process, Close, %psPid%
        break
    }
    Sleep, 500
}          
            
            
            FileRemoveDir, %cartellaTmp%, 1
            FileRemoveDir, %targetFolder%, 1
            Log("Eliminazione finale completata con robocopy.")
        }
        else
        {
            Log("La cartella """ . targetFolder . """ è stata eliminata correttamente.")
        }

        GuiControl, 2:, msctls_progress321, +1
        ris := (a_tickcount - start) / 1000
        tooltip, tempo impiegato rimozione files utente %ListUserName% %ris% secondi ,0,0
    }

    ; ======  use PS to remove profile from registry  ======
    Gui, 2:Show,, Removing Profile from registry %ListUserName% riga %RowNumber%
    start := a_tickcount

    if (sceltametodocancellazione = 2)
    {
    
    
   tooltip, esecuzione primo giro rimoszione dal registro,0,0
    
    
    
  ;  handle64
    
    
    
        start := A_TickCount
        tempPS1 := A_Temp "\remove_profile.ps1"

        ; 1️⃣ Crea script PS per rimozione dal registro
        FileDelete, %tempPS1%
        FileAppend,
        (
        Get-CimInstance Win32_UserProfile |
        Where-Object { -not $_.Special -and -not $_.Loaded -and $_.LocalPath -like '*%Profile%' } |
        Remove-CimInstance
        ), %tempPS1%

        ; 2️⃣ Esegui rimozione profilo dal registro
        

      start := A_TickCount
Run, powershell -ExecutionPolicy Bypass -File "%tempPS1%", , Hide,psPid
timeoutMs := 180000
Loop {
    Process, Exist, %psPid%
    if !ErrorLevel
        break
    if (A_TickCount - start > timeoutMs) {
        Log("Timeout: comando PowerShell bloccato, lo termino")
        Process, Close, %psPid%
        break
    }
    Sleep, 500
}  



        ; 3️⃣ Elimina fisicamente la cartella utente
        FileDelete, %tempPS1%
        FileAppend,
        (
        if (Test-Path "%Profile%") {
            Remove-Item -Path "%Profile%" -Recurse -Force
        }
        ), %tempPS1%
        
        
        
        start := A_TickCount
Run, powershell -ExecutionPolicy Bypass -File "%tempPS1%", , Hide,psPid
timeoutMs := 180000
Loop {
    Process, Exist, %psPid%
    if !ErrorLevel
        break
    if (A_TickCount - start > timeoutMs) {
        Log("Timeout: comando PowerShell bloccato, lo termino")
        Process, Close, %psPid%
        break
    }
    Sleep, 500
}        
        




        ; 4️⃣ Elimina chiave registro se ancora presente
        RegRead, LocalPath, %ProfileRegList%\%SSID%, ProfileImagePath
        if !ErrorLevel
        {
            RegDelete, %ProfileRegList%\%SSID%
        }

        ; 5️⃣ Tooltip finale
        ris := (A_TickCount - start) / 1000
        ToolTip, ✅ Rimozione completata per %ListUserName% in %ris% secondi, 0, 0
    }

    if (sceltametodocancellazione = 3)
    {
        psCommand := "Get-CimInstance Win32_UserProfile | Where-Object { -not $_.Special -and -not $_.Loaded -and $_.LocalPath -match 'Profile' } | ForEach-Object { Remove-Item -Path $_.LocalPath -Recurse -Force }"
        shell := ComObjCreate("WScript.Shell")
        shell.Exec("powershell -command """ psCommand """")
    }

    if (sceltametodocancellazione = 3)
       if (sceltametodocancellazione = 3)
    {
      
        
        
        
        
         start := A_TickCount
  Run Powershell -command "& {Get-WmiObject win32_userprofile | Where-Object {!$_.Special -and !$_.Loaded -and $_.LocalPath -like '%Profile%'} | RWMI}",, Hide,psPid
timeoutMs := 180000
Loop {
    Process, Exist, %psPid%
    if !ErrorLevel
        break
    if (A_TickCount - start > timeoutMs) {
        Log("Timeout: comando PowerShell bloccato, lo termino")
        Process, Close, %psPid%
        break
    }
    Sleep, 500
}         
        
        
        
        
        
        
        
        
        ris := (a_tickcount - start) / 1000
        tooltip, tempo impiegato rimozione voce registro %ListUserName% %ris% secondi ,0,0
    }

    Gui, 2:Destroy
    sleep 1

    IfExist %Profile%
    {
        Failure = 1
        FolderMessage = files %Profile% non cancellati
    }

    RegRead LocalPath, %ProfileRegList%\%SSID%, ProfileImagePath
    if !ErrorLevel
    {
        Failure = 1
        RegMessage = Registro %ListUserName% Profilo non rimosso
    }

    if Failure = 1
    {
        ; Accoda utente per il “giro di ripasso” (una sola volta)
        if (!giaSegnati.HasKey(SSID))
        {
            daRiprova.Push({Name: ListUserName, SSID: SSID})
            giaSegnati[SSID] := true
        }

        con := con + 1
        if (con = 3)
        {
            noneliminati := noneliminati FolderMessage " ---- " RegMessage "`n"
            con := 0
            i := i + 1
        }
    }
    else
    {
        LV_Delete(RowNumber)
    }
   if (sceltametodocancellazione = 3)
    {
      
        
        
        
        
         start := A_TickCount
  Run Powershell -command "& {Get-WmiObject win32_userprofile | Where-Object {!$_.Special -and !$_.Loaded -and $_.LocalPath -like '%Profile%'} | RWMI}",, Hide,psPid
timeoutMs := 180000
Loop {
    Process, Exist, %psPid%
    if !ErrorLevel
        break
    if (A_TickCount - start > timeoutMs) {
        Log("Timeout: comando PowerShell bloccato, lo termino")
        Process, Close, %psPid%
        break
    }
    Sleep, 500
}         
        
        
        
        
        
        
        
        
        ris := (a_tickcount - start) / 1000
        tooltip, tempo impiegato rimozione voce registro %ListUserName% %ris% secondi ,0,0
    }

    Gui, 2:Destroy
    sleep 1

    IfExist %Profile%
    {
        Failure = 1
        FolderMessage = files %Profile% non cancellati
    }

    RegRead LocalPath, %ProfileRegList%\%SSID%, ProfileImagePath
    if !ErrorLevel
    {
        Failure = 1
        RegMessage = Registro %ListUserName% Profilo non rimosso
    }

    if Failure = 1
    {
        ; Accoda utente per il “giro di ripasso” (una sola volta)
        if (!giaSegnati.HasKey(SSID))
        {
            daRiprova.Push({Name: ListUserName, SSID: SSID})
            giaSegnati[SSID] := true
        }

        con := con + 1
        if (con = 3)
        {
            noneliminati := noneliminati FolderMessage " ---- " RegMessage "`n"
            con := 0
            i := i + 1
        }
    }
    else
    {
        LV_Delete(RowNumber)
    }
   if (sceltametodocancellazione = 3)
    {
    }  
        
        ris := (a_tickcount - start) / 1000
        tooltip, tempo impiegato rimozione voce registro %ListUserName% %ris% secondi ,0,0
    }

    Gui, 2:Destroy
    sleep 1

    IfExist %Profile%
    {
        Failure = 1
        FolderMessage = files %Profile% non cancellati
    }

    RegRead LocalPath, %ProfileRegList%\%SSID%, ProfileImagePath
    if !ErrorLevel
    {
        Failure = 1
        RegMessage = Registro %ListUserName% Profilo non rimosso
    }

    if Failure = 1
    {
        ; Accoda utente per il “giro di ripasso” (una sola volta)
        if (!giaSegnati.HasKey(SSID))
        {
            daRiprova.Push({Name: ListUserName, SSID: SSID})
            giaSegnati[SSID] := true
        }

        con := con + 1
        if (con = 3)
        {
            noneliminati := noneliminati FolderMessage " ---- " RegMessage "`n"
            con := 0
            i := i + 1
        }
    }
    else
    {
        LV_Delete(RowNumber)
    }
   if (sceltametodocancellazione = 3)
    {
      
        
        
        
        
         start := A_TickCount
  Run Powershell -command "& {Get-WmiObject win32_userprofile | Where-Object {!$_.Special -and !$_.Loaded -and $_.LocalPath -like '%Profile%'} | RWMI}",, Hide,psPid
timeoutMs := 180000
Loop {
    Process, Exist, %psPid%
    if !ErrorLevel
        break
    if (A_TickCount - start > timeoutMs) {
        Log("Timeout: comando PowerShell bloccato, lo termino")
        Process, Close, %psPid%
        break
    }
    Sleep, 500
}         
        
        
        
        
        
        
        
        
        ris := (a_tickcount - start) / 1000
        tooltip, tempo impiegato rimozione voce registro %ListUserName% %ris% secondi ,0,0
    }

    Gui, 2:Destroy
    sleep 1

    IfExist %Profile%
    {
        Failure = 1
        FolderMessage = files %Profile% non cancellati
    }

    RegRead LocalPath, %ProfileRegList%\%SSID%, ProfileImagePath
    if !ErrorLevel
    {
        Failure = 1
        RegMessage = Registro %ListUserName% Profilo non rimosso
    }

    if Failure = 1
    {
        ; Accoda utente per il “giro di ripasso” (una sola volta)
        if (!giaSegnati.HasKey(SSID))
        {
            daRiprova.Push({Name: ListUserName, SSID: SSID})
            giaSegnati[SSID] := true
        }

        con := con + 1
        if (con = 3)
        {
            noneliminati := noneliminati FolderMessage " ---- " RegMessage "`n"
            con := 0
            i := i + 1
        }
    }
    else
    {
        LV_Delete(RowNumber)
    }
{
      
        
        
        
        
         start := A_TickCount
  Run Powershell -command "& {Get-WmiObject win32_userprofile | Where-Object {!$_.Special -and !$_.Loaded -and $_.LocalPath -like '%Profile%'} | RWMI}",, Hide,psPid
timeoutMs := 180000
Loop {
    Process, Exist, %psPid%
    if !ErrorLevel
        break
    if (A_TickCount - start > timeoutMs) {
        Log("Timeout: comando PowerShell bloccato, lo termino")
        Process, Close, %psPid%
        break
    }
    Sleep, 500
}         
        
        
        
        
        
        
        
        
        ris := (a_tickcount - start) / 1000
        tooltip, tempo impiegato rimozione voce registro %ListUserName% %ris% secondi ,0,0
    }

    Gui, 2:Destroy
    sleep 1

    IfExist %Profile%
    {
        Failure = 1
        FolderMessage = files %Profile% non cancellati
    }

    RegRead LocalPath, %ProfileRegList%\%SSID%, ProfileImagePath
    if !ErrorLevel
    {
        Failure = 1
        RegMessage = Registro %ListUserName% Profilo non rimosso
    }

    if Failure = 1
    {
        ; Accoda utente per il “giro di ripasso” (una sola volta)
        if (!giaSegnati.HasKey(SSID))
        {
            daRiprova.Push({Name: ListUserName, SSID: SSID})
            giaSegnati[SSID] := true
        }

        con := con + 1
        if (con = 3)
        {
            noneliminati := noneliminati FolderMessage " ---- " RegMessage "`n"
            con := 0
            i := i + 1
        }
    }
    else
    {
        LV_Delete(RowNumber)
    }


; ==========================
; Secondo passaggio: riprova gli utenti falliti
; ==========================
tooltip, esecuzione secondo giro,0,0
if (daRiprova.Length() > 0)
{
    ; MsgBox, 64, Info, Avvio secondo tentativo su % daRiprova.Length() " utenti non eliminati al primo giro."
    

    
    
    for idx, ut in daRiprova
    {
        ListUserName := ut.Name
        SSID := ut.SSID
        Profile = C:\Users\%ListUserName%

        ; --- ripete la stessa logica di cancellazione ---

        if (sceltametodocancellazione = 2)
        {
            start := a_tickcount
            
             tooltip, esecuzione secondo giro rimozione files,0,0

            logFile := A_ScriptDir "\log_eliminazione.txt"
            handlePath := A_ScriptDir "\handle64.exe"
            resultFile := A_ScriptDir "\processi_bloccanti.txt"
            targetFolder := Profile

  
 start := A_TickCount
            Run, powershell -Command "if (Test-Path \"%targetFolder%\") { try { takeown /F \"%targetFolder%\" /R /D Y; icacls \"%targetFolder%\" /grant $env:USERNAME:F /T /C /Q; attrib -r -s -h \"%targetFolder%\" /S /D } catch { $_ | Out-File -Append -FilePath \"%logFile%\" } }", , Hide,psPid
timeoutMs := 300000
Loop {
    Process, Exist, %psPid%
    if !ErrorLevel
        break
    if (A_TickCount - start > timeoutMs) {
        Log("Timeout: comando PowerShell bloccato, lo termino")
        Process, Close, %psPid%
        break
    }
    Sleep, 500
} 
  
  
   
  
  start := A_TickCount
              Run, powershell -Command "if (Test-Path \"%targetFolder%\") { try { Get-ChildItem -Path \"%targetFolder%\" -Recurse -Force -File | Remove-Item -Force -ErrorAction Stop } catch { $_ | Out-File -Append -FilePath \"%logFile%\" } }", , Hide, psPid
timeoutMs := 300000
Loop {
    Process, Exist, %psPid%
    if !ErrorLevel
        break
    if (A_TickCount - start > timeoutMs) {
        Log("Timeout: comando PowerShell bloccato, lo termino")
        Process, Close, %psPid%
        break
    }
    Sleep, 500
}  
  
   
            
   start := A_TickCount
            Run, powershell -Command "if (Test-Path \"%targetFolder%\") { try { Get-ChildItem -Path \"%targetFolder%\" -Recurse -Force -Directory | Remove-Item -Force -Recurse -ErrorAction Stop } catch { $_ | Out-File -Append -FilePath \"%logFile%\" } }", , Hide, psPid
            timeoutMs := 300000
Loop {
    Process, Exist, %psPid%
    if !ErrorLevel
        break
    if (A_TickCount - start > timeoutMs) {
        Log("Timeout: comando PowerShell bloccato, lo termino")
        Process, Close, %psPid%
        break
    }
    Sleep, 500
}  
  
 
            
   start := A_TickCount
           RunWait, cmd /c "rmdir \"%targetFolder%\" /S /Q", , Hide, psPid
            timeoutMs := 300000
Loop {
    Process, Exist, %psPid%
    if !ErrorLevel
        break
    if (A_TickCount - start > timeoutMs) {
        Log("Timeout: comando PowerShell bloccato, lo termino")
        Process, Close, %psPid%
        break
    }
    Sleep, 500
}  

   start := A_TickCount
            Run, powershell -Command "if (Test-Path \"%targetFolder%\") { try { Remove-Item -Path \"%targetFolder%\" -Force -Recurse } catch { $_ | Out-File -Append -FilePath \"%logFile%\" } }", , Hide, psPid
            timeoutMs := 300000
Loop {
    Process, Exist, %psPid%
    if !ErrorLevel
        break
    if (A_TickCount - start > timeoutMs) {
        Log("Timeout: comando PowerShell bloccato, lo termino")
        Process, Close, %psPid%
        break
    }
    Sleep, 500
}  
    


            IfExist, %targetFolder%
            {
                
   start := A_TickCount
    Run, "%handlePath%" "%targetFolder%" > "%resultFile%", , Hide, handlePid

    timeoutMs := 300000  ; 30 secondi

    Loop {
        Process, Exist, %handlePid%
        if !ErrorLevel
            break

        if (A_TickCount - start > timeoutMs) {
            Log("Timeout: handle64.exe non ha finito entro " . (timeoutMs/1000) . " s, lo termino")
            Process, Close, %handlePid%
            break
        }
        Sleep, 500
    }


    ; Ora leggi il file di output e chiudi eventuali processi bloccanti
if FileExist(resultFile) {
    Loop, Read, %resultFile%
    {
        line := Trim(A_LoopReadLine)
        if (line = "")
            continue

        if RegExMatch(line, "i)pid:\s*(\d+)", match) {
            pid := match1
            if (pid != "") {
                ; Prova a terminare il processo, senza bloccare lo script
                try {
                    ; Timeout di 3 secondi per sicurezza
                    RunWait, % "powershell -Command ""Stop-Process -Id " pid " -Force""", , Hide, psPID
                    Log("Terminato processo PID: " . pid)
                } catch e {
                    Log("Errore terminando PID " . pid . ": " . e.Message)
                }
            }
        }
    }
    ; Prova a cancellare il file, ma senza bloccare se fallisce
    try FileDelete, %resultFile%
    catch e {
        Log("Impossibile cancellare " . resultFile . ": " . e.Message)
    }
            
                
                
                
                
; Funzione di attesa condizionata
; Funzione di attesa condizionata compatibile con AHK 1.1
; conditionFuncName = nome della funzione da chiamare (stringa)
; timeout = tempo massimo in millisecondi
; step = intervallo di controllo in millisecondi
; Funzione di attesa condizionata compatibile con AHK 1.1
; conditionFuncName = nome della funzione da chiamare (stringa)
; timeout = tempo massimo in millisecondi
; step = intervallo di controllo in millisecondi
WaitUntil(conditionFuncName, timeout := 5000, step := 200) {
    cond := Func(conditionFuncName) ; crea un riferimento alla funzione
    start := A_TickCount
    while (!cond.Call() && (A_TickCount - start < timeout)) {
        Sleep, %step%
    }
    return cond.Call()
}

; ============================
; Esempio di funzione condizione
CartellaSparita() {
    return !FileExist("C:\Percorso\Cartella")
}

; ============================
; Esempio di utilizzo
if WaitUntil("CartellaSparita", 180000, 500) ; aspetta max 3 minuti
    MsgBox, La cartella è stata rimossa
else
    MsgBox, Timeout: la cartella esiste ancora

; --- Rimozione cartella target ---
try {
    if FileExist(targetFolder) {
        RunWait, % "powershell -Command ""try { Remove-Item -Path '" targetFolder "' -Force -Recurse -ErrorAction Stop } catch { $_ | Out-File -Append -FilePath '" logFile "' }""", , Hide
        ; Aspetta finché la cartella non sparisce o scade il timeout
        if !WaitUntil(() => !FileExist(targetFolder), 5000)
            Log("Attenzione: la cartella " . targetFolder . " esiste ancora dopo la rimozione")
        else
            Log("Cartella rimossa: " . targetFolder)
    }
} catch e {
    Log("Errore rimozione cartella " . targetFolder . ": " . e.Message)
}

; --- Avvio Explorer se non in esecuzione ---
try {
    RunWait, % "powershell -Command ""if (!(Get-Process explorer -ErrorAction SilentlyContinue)) { Start-Process explorer.exe }""", , Hide
} catch e {
    Log("Errore avvio Explorer: " . e.Message)
}

; --- Se la cartella esiste ancora, reset con robocopy ---
if FileExist(targetFolder) {
    cartellaTmp := A_ScriptDir "\temp"
    try {
        if !FileExist(cartellaTmp)
            FileCreateDir, %cartellaTmp%
    } catch e {
        Log("Errore creazione cartella temporanea: " . e.Message)
    }

    try {
        RunWait, % "powershell -Command ""robocopy '" cartellaTmp "' '" targetFolder "' /MIR""", , Hide
        ; Aspetta finché robocopy ha finito e la cartella è vuota
        WaitUntil(() => FileExist(targetFolder), 300000)
    } catch e {
        Log("Errore robocopy: " . e.Message)
    }

    try {
        FileRemoveDir, %cartellaTmp%, 1
        WaitUntil(() => !FileExist(cartellaTmp), 300000)
    } catch e {
        Log("Errore rimozione cartella temporanea: " . e.Message)
    }

    try {
        FileRemoveDir, %targetFolder%, 1
        WaitUntil(() => !FileExist(targetFolder), 300000)
    } catch e {
        Log("Errore rimozione cartella target: " . e.Message)
    }
        
        
        
        
        
        }

        ; Registro (metodo 2)
        if (sceltametodocancellazione = 2)
        {
        
        
        
            tooltip, esecuzione secondo giro rimozione chaivi registro,0,0
            
  ; Funzione per eseguire uno script PowerShell con timeout
RunPSWithTimeout(psFile, timeoutMs := 300000) { ; default 5 minuti
    start := A_TickCount
    RunWait, powershell -ExecutionPolicy Bypass -File "%psFile%", , Hide, psPid
    Loop {
        Process, Exist, %psPid%
        if !ErrorLevel
            break
        if (A_TickCount - start > timeoutMs) {
            Log("Timeout: comando PowerShell bloccato, lo termino")
            Process, Close, %psPid%
            break
        }
        Sleep, 500
    }
}

; --- Primo blocco ---
tempPS1 := A_Temp "\remove_profile.ps1"
FileDelete, %tempPS1%
FileAppend,
(
Get-CimInstance Win32_UserProfile |
Where-Object { -not $_.Special -and -not $_.Loaded -and $_.LocalPath -like '*%Profile%' } |
Remove-CimInstance
), %tempPS1%
RunPSWithTimeout(tempPS1)  ; 5 minuti di tempo

FileDelete, %tempPS1%
FileAppend,
(
if (Test-Path "%Profile%") {
    Remove-Item -Path "%Profile%" -Recurse -Force
}
), %tempPS1%
RunPSWithTimeout(tempPS1)  ; 5 minuti di tempo

RegRead, LocalPath, %ProfileRegList%\%SSID%, ProfileImagePath
if !ErrorLevel
{
    RegDelete, %ProfileRegList%\%SSID%
}

; --- Secondo blocco (ripetuto) ---
FileDelete, %tempPS1%
FileAppend,
(
Get-CimInstance Win32_UserProfile |
Where-Object { -not $_.Special -and -not $_.Loaded -and $_.LocalPath -like '*%Profile%' } |
Remove-CimInstance
), %tempPS1%
RunPSWithTimeout(tempPS1)

FileDelete, %tempPS1%
FileAppend,
(
if (Test-Path "%Profile%") {
    Remove-Item -Path "%Profile%" -Recurse -Force
}
), %tempPS1%
RunPSWithTimeout(tempPS1)

RegRead, LocalPath, %ProfileRegList%\%SSID%, ProfileImagePath
if !ErrorLevel
{
    RegDelete, %ProfileRegList%\%SSID%
}
        
        
        }

        ; Metodo 3
        if (sceltametodocancellazione = 3)
        { 
        }
}

gosub ColClick ; re-color the rows

if (Trim(noneliminati) != "") {
    MsgBox, 48, Utenti non cancellati, Non è stato possibile eliminare i seguenti utenti:`n%noneliminati%
}

; --- chiusura
If (chiusurapcaltermine = 1)
{
    ; MsgBox 4 = Sì/No, l’ultimo parametro (Timeout) è in secondi
    MsgBox, 4, Conferma spegnimento, Confermi lo spegnimento del PC? (Autoprossegue tra 5s), 5
    
    ; Se premi No entro 5s, esci senza spegnere
    IfMsgBox No
        Return
    
    ; Se premi Sì o non rispondi entro 5s, procedi
    Shutdown, 1
}



return


Log(Msg) {
    global logFile
    FileAppend, [%A_Hour%:%A_Min%:%A_Sec%] %Msg%`n, %logFile%
}

; ======  cleanup the Temp folder  ======
Cleanup(ExitReason, ExitCode)
{
   
}


class MyObject
{
   Exiting()
   {
		Run cmd.exe /c rmdir "%LocalAppData%\Temp\ProfileKiller" /S /Q,, Hide
   }
}



; ======  do not modify below this line  ======
; credit to "just me",  https://www.autohotkey.com/boards/memberlist.php?mode=viewprofile&u=148
; posting: https://www.autohotkey.com/boards/viewtopic.php?f=6&t=1081
; ======================================================================================================================
; Namespace:      LV_Colors
; Function:       Individual row and cell coloring for AHK ListView controls.
; Tested with:    AHK 1.1.23.05 (A32/U32/U64)
; Tested on:      Win 10 (x64)
; Changelog:
;     1.1.04.01/2016-05-03/just me - added change to remove the focus rectangle from focused rows
;     1.1.04.00/2016-05-03/just me - added SelectionColors method
;     1.1.03.00/2015-04-11/just me - bugfix for StaticMode
;     1.1.02.00/2015-04-07/just me - bugfixes for StaticMode, NoSort, and NoSizing
;     1.1.01.00/2015-03-31/just me - removed option OnMessage from __New(), restructured code
;     1.1.00.00/2015-03-27/just me - added AlternateRows and AlternateCols, revised code.
;     1.0.00.00/2015-03-23/just me - new version using new AHK 1.1.20+ features
;     0.5.00.00/2014-08-13/just me - changed 'static mode' handling
;     0.4.01.00/2013-12-30/just me - minor bug fix
;     0.4.00.00/2013-12-30/just me - added static mode
;     0.3.00.00/2013-06-15/just me - added "Critical, 100" to avoid drawing issues
;     0.2.00.00/2013-01-12/just me - bugfixes and minor changes
;     0.1.00.00/2012-10-27/just me - initial release
; ======================================================================================================================
; CLASS LV_Colors
;
; The class provides six public methods to set individual colors for rows and/or cells, to clear all colors, to
; prevent/allow sorting and rezising of columns dynamically, and to deactivate/activate the message handler for
; WM_NOTIFY messages (see below).
;
; The message handler for WM_NOTIFY messages will be activated for the specified ListView whenever a new instance is
; created. If you want to temporarily disable coloring call MyInstance.OnMessage(False). This must be done also before
; you try to destroy the instance. To enable it again, call MyInstance.OnMessage().
;
; To avoid the loss of Gui events and messages the message handler might need to be set 'critical'. This can be
; achieved by setting the instance property 'Critical' ti the required value (e.g. MyInstance.Critical := 100).
; New instances default to 'Critical, Off'. Though sometimes needed, ListViews or the whole Gui may become
; unresponsive under certain circumstances if Critical is set and the ListView has a g-label.
; ======================================================================================================================
Class LV_Colors {
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; META FUNCTIONS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; ===================================================================================================================
   ; __New()         Create a new LV_Colors instance for the given ListView
   ; Parameters:     HWND        -  ListView's HWND.
   ;                 Optional ------------------------------------------------------------------------------------------
   ;                 StaticMode  -  Static color assignment, i.e. the colors will be assigned permanently to the row
   ;                                contents rather than to the row number.
   ;                                Values:  True/False
   ;                                Default: False
   ;                 NoSort      -  Prevent sorting by click on a header item.
   ;                                Values:  True/False
   ;                                Default: True
   ;                 NoSizing    -  Prevent resizing of columns.
   ;                                Values:  True/False
   ;                                Default: True
   ; ===================================================================================================================
   __New(HWND, StaticMode := False, NoSort := True, NoSizing := True) {
      If (This.Base.Base.__Class) ; do not instantiate instances
         Return False
      If This.Attached[HWND] ; HWND is already attached
         Return False
      If !DllCall("IsWindow", "Ptr", HWND) ; invalid HWND
         Return False
      VarSetCapacity(Class, 512, 0)
      DllCall("GetClassName", "Ptr", HWND, "Str", Class, "Int", 256)
      If (Class <> "SysListView32") ; HWND doesn't belong to a ListView
         Return False
      ; ----------------------------------------------------------------------------------------------------------------
      ; Set LVS_EX_DOUBLEBUFFER (0x010000) style to avoid drawing issues.
      SendMessage, 0x1036, 0x010000, 0x010000, , % "ahk_id " . HWND ; LVM_SETEXTENDEDLISTVIEWSTYLE
      ; Get the default colors
      SendMessage, 0x1025, 0, 0, , % "ahk_id " . HWND ; LVM_GETTEXTBKCOLOR
      This.BkClr := ErrorLevel
      SendMessage, 0x1023, 0, 0, , % "ahk_id " . HWND ; LVM_GETTEXTCOLOR
      This.TxClr := ErrorLevel
      ; Get the header control
      SendMessage, 0x101F, 0, 0, , % "ahk_id " . HWND ; LVM_GETHEADER
      This.Header := ErrorLevel
      ; Set other properties
      This.HWND := HWND
      This.IsStatic := !!StaticMode
      This.AltCols := False
      This.AltRows := False
      This.NoSort(!!NoSort)
      This.NoSizing(!!NoSizing)
      This.OnMessage()
      This.Critical := "Off"
      This.Attached[HWND] := True
   }
   ; ===================================================================================================================
   __Delete() {
      This.Attached.Remove(HWND, "")
      This.OnMessage(False)
      WinSet, Redraw, , % "ahk_id " . This.HWND
   }
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; PUBLIC METHODS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; ===================================================================================================================
   ; Clear()         Clears all row and cell colors.
   ; Parameters:     AltRows     -  Reset alternate row coloring (True / False)
   ;                                Default: False
   ;                 AltCols     -  Reset alternate column coloring (True / False)
   ;                                Default: False
   ; Return Value:   Always True.
   ; ===================================================================================================================
   Clear(AltRows := False, AltCols := False) {
      If (AltCols)
         This.AltCols := False
      If (AltRows)
         This.AltRows := False
      This.Remove("Rows")
      This.Remove("Cells")
      Return True
   }
   ; ===================================================================================================================
   ; AlternateRows() Sets background and/or text color for even row numbers.
   ; Parameters:     BkColor     -  Background color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> default background color
   ;                 TxColor     -  Text color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> default text color
   ; Return Value:   True on success, otherwise false.
   ; ===================================================================================================================
   AlternateRows(BkColor := "", TxColor := "") {
      If !(This.HWND)
         Return False
      This.AltRows := False
      If (BkColor = "") && (TxColor = "")
         Return True
      BkBGR := This.BGR(BkColor)
      TxBGR := This.BGR(TxColor)
      If (BkBGR = "") && (TxBGR = "")
         Return False
      This["ARB"] := (BkBGR <> "") ? BkBGR : This.BkClr
      This["ART"] := (TxBGR <> "") ? TxBGR : This.TxClr
      This.AltRows := True
      Return True
   }
   ; ===================================================================================================================
   ; AlternateCols() Sets background and/or text color for even column numbers.
   ; Parameters:     BkColor     -  Background color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> default background color
   ;                 TxColor     -  Text color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> default text color
   ; Return Value:   True on success, otherwise false.
   ; ===================================================================================================================
   AlternateCols(BkColor := "", TxColor := "") {
      If !(This.HWND)
         Return False
      This.AltCols := False
      If (BkColor = "") && (TxColor = "")
         Return True
      BkBGR := This.BGR(BkColor)
      TxBGR := This.BGR(TxColor)
      If (BkBGR = "") && (TxBGR = "")
         Return False
      This["ACB"] := (BkBGR <> "") ? BkBGR : This.BkClr
      This["ACT"] := (TxBGR <> "") ? TxBGR : This.TxClr
      This.AltCols := True
      Return True
   }
   ; ===================================================================================================================
   ; SelectionColors() Sets background and/or text color for selected rows.
   ; Parameters:     BkColor     -  Background color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> default selected background color
   ;                 TxColor     -  Text color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> default selected text color
   ; Return Value:   True on success, otherwise false.
   ; ===================================================================================================================
   SelectionColors(BkColor := "", TxColor := "") {
      If !(This.HWND)
         Return False
      This.SelColors := False
      If (BkColor = "") && (TxColor = "")
         Return True
      BkBGR := This.BGR(BkColor)
      TxBGR := This.BGR(TxColor)
      If (BkBGR = "") && (TxBGR = "")
         Return False
      This["SELB"] := BkBGR
      This["SELT"] := TxBGR
      This.SelColors := True
      Return True
   }
   ; ===================================================================================================================
   ; Row()           Sets background and/or text color for the specified row.
   ; Parameters:     Row         -  Row number
   ;                 Optional ------------------------------------------------------------------------------------------
   ;                 BkColor     -  Background color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> default background color
   ;                 TxColor     -  Text color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> default text color
   ; Return Value:   True on success, otherwise false.
   ; ===================================================================================================================
   Row(Row, BkColor := "", TxColor := "") {
      If !(This.HWND)
         Return False
      If This.IsStatic
         Row := This.MapIndexToID(Row)
      This["Rows"].Remove(Row, "")
      If (BkColor = "") && (TxColor = "")
         Return True
      BkBGR := This.BGR(BkColor)
      TxBGR := This.BGR(TxColor)
      If (BkBGR = "") && (TxBGR = "")
         Return False
      This["Rows", Row, "B"] := (BkBGR <> "") ? BkBGR : This.BkClr
      This["Rows", Row, "T"] := (TxBGR <> "") ? TxBGR : This.TxClr
      Return True
   }
   ; ===================================================================================================================
   ; Cell()          Sets background and/or text color for the specified cell.
   ; Parameters:     Row         -  Row number
   ;                 Col         -  Column number
   ;                 Optional ------------------------------------------------------------------------------------------
   ;                 BkColor     -  Background color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> row's background color
   ;                 TxColor     -  Text color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> row's text color
   ; Return Value:   True on success, otherwise false.
   ; ===================================================================================================================
   Cell(Row, Col, BkColor := "", TxColor := "") {
      If !(This.HWND)
         Return False
      If This.IsStatic
         Row := This.MapIndexToID(Row)
      This["Cells", Row].Remove(Col, "")
      If (BkColor = "") && (TxColor = "")
         Return True
      BkBGR := This.BGR(BkColor)
      TxBGR := This.BGR(TxColor)
      If (BkBGR = "") && (TxBGR = "")
         Return False
      If (BkBGR <> "")
         This["Cells", Row, Col, "B"] := BkBGR
      If (TxBGR <> "")
         This["Cells", Row, Col, "T"] := TxBGR
      Return True
   }
   ; ===================================================================================================================
   ; NoSort()        Prevents/allows sorting by click on a header item for this ListView.
   ; Parameters:     Apply       -  True/False
   ;                                Default: True
   ; Return Value:   True on success, otherwise false.
   ; ===================================================================================================================
   NoSort(Apply := True) {
      If !(This.HWND)
         Return False
      If (Apply)
         This.SortColumns := False
      Else
         This.SortColumns := True
      Return True
   }
   ; ===================================================================================================================
   ; NoSizing()      Prevents/allows resizing of columns for this ListView.
   ; Parameters:     Apply       -  True/False
   ;                                Default: True
   ; Return Value:   True on success, otherwise false.
   ; ===================================================================================================================
   NoSizing(Apply := True) {
      Static OSVersion := DllCall("GetVersion", "UChar")
      If !(This.Header)
         Return False
      If (Apply) {
         If (OSVersion > 5)
            Control, Style, +0x0800, , % "ahk_id " . This.Header ; HDS_NOSIZING = 0x0800
         This.ResizeColumns := False
      }
      Else {
         If (OSVersion > 5)
            Control, Style, -0x0800, , % "ahk_id " . This.Header ; HDS_NOSIZING
         This.ResizeColumns := True
      }
      Return True
   }
   ; ===================================================================================================================
   ; OnMessage()     Adds/removes a message handler for WM_NOTIFY messages for this ListView.
   ; Parameters:     Apply       -  True/False
   ;                                Default: True
   ; Return Value:   Always True
   ; ===================================================================================================================
   OnMessage(Apply := True) {
      If (Apply) && !This.HasKey("OnMessageFunc") {
         This.OnMessageFunc := ObjBindMethod(This, "On_WM_Notify")
         OnMessage(0x004E, This.OnMessageFunc) ; add the WM_NOTIFY message handler
      }
      Else If !(Apply) && This.HasKey("OnMessageFunc") {
         OnMessage(0x004E, This.OnMessageFunc, 0) ; remove the WM_NOTIFY message handler
         This.OnMessageFunc := ""
         This.Remove("OnMessageFunc")
      }
      WinSet, Redraw, , % "ahk_id " . This.HWND
      Return True
   }
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; PRIVATE PROPERTIES  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   Static Attached := {}
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; PRIVATE METHODS +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   On_WM_NOTIFY(W, L, M, H) {
      ; Notifications: NM_CUSTOMDRAW = -12, LVN_COLUMNCLICK = -108, HDN_BEGINTRACKA = -306, HDN_BEGINTRACKW = -326
      Critical, % This.Critical
      If ((HCTL := NumGet(L + 0, 0, "UPtr")) = This.HWND) || (HCTL = This.Header) {
         Code := NumGet(L + (A_PtrSize * 2), 0, "Int")
         If (Code = -12)
            Return This.NM_CUSTOMDRAW(This.HWND, L)
         If !This.SortColumns && (Code = -108)
            Return 0
         If !This.ResizeColumns && ((Code = -306) || (Code = -326))
            Return True
      }
   }
   ; -------------------------------------------------------------------------------------------------------------------
   NM_CUSTOMDRAW(H, L) {
      ; Return values: 0x00 (CDRF_DODEFAULT), 0x20 (CDRF_NOTIFYITEMDRAW / CDRF_NOTIFYSUBITEMDRAW)
      Static SizeNMHDR := A_PtrSize * 3                  ; Size of NMHDR structure
      Static SizeNCD := SizeNMHDR + 16 + (A_PtrSize * 5) ; Size of NMCUSTOMDRAW structure
      Static OffItem := SizeNMHDR + 16 + (A_PtrSize * 2) ; Offset of dwItemSpec (NMCUSTOMDRAW)
      Static OffItemState := OffItem + A_PtrSize         ; Offset of uItemState  (NMCUSTOMDRAW)
      Static OffCT :=  SizeNCD                           ; Offset of clrText (NMLVCUSTOMDRAW)
      Static OffCB := OffCT + 4                          ; Offset of clrTextBk (NMLVCUSTOMDRAW)
      Static OffSubItem := OffCB + 4                     ; Offset of iSubItem (NMLVCUSTOMDRAW)
      ; ----------------------------------------------------------------------------------------------------------------
      DrawStage := NumGet(L + SizeNMHDR, 0, "UInt")
      , Row := NumGet(L + OffItem, "UPtr") + 1
      , Col := NumGet(L + OffSubItem, "Int") + 1
      , Item := Row - 1
      If This.IsStatic
         Row := This.MapIndexToID(Row)
      ; CDDS_SUBITEMPREPAINT = 0x030001 --------------------------------------------------------------------------------
      If (DrawStage = 0x030001) {
         UseAltCol := !(Col & 1) && (This.AltCols)
         , ColColors := This["Cells", Row, Col]
         , ColB := (ColColors.B <> "") ? ColColors.B : UseAltCol ? This.ACB : This.RowB
         , ColT := (ColColors.T <> "") ? ColColors.T : UseAltCol ? This.ACT : This.RowT
         , NumPut(ColT, L + OffCT, "UInt"), NumPut(ColB, L + OffCB, "UInt")
         Return (!This.AltCols && !This.HasKey(Row) && (Col > This["Cells", Row].MaxIndex())) ? 0x00 : 0x20
      }
      ; CDDS_ITEMPREPAINT = 0x010001 -----------------------------------------------------------------------------------
      If (DrawStage = 0x010001) {
         ; LVM_GETITEMSTATE = 0x102C, LVIS_SELECTED = 0x0002
         If (This.SelColors) && DllCall("SendMessage", "Ptr", H, "UInt", 0x102C, "Ptr", Item, "Ptr", 0x0002, "UInt") {
            ; Remove the CDIS_SELECTED (0x0001) and CDIS_FOCUS (0x0010) states from uItemState and set the colors.
            NumPut(NumGet(L + OffItemState, "UInt") & ~0x0011, L + OffItemState, "UInt")
            If (This.SELB <> "")
               NumPut(This.SELB, L + OffCB, "UInt")
            If (This.SELT <> "")
               NumPut(This.SELT, L + OffCT, "UInt")
            Return 0x02 ; CDRF_NEWFONT
         }
         UseAltRow := (Item & 1) && (This.AltRows)
         , RowColors := This["Rows", Row]
         , This.RowB := RowColors ? RowColors.B : UseAltRow ? This.ARB : This.BkClr
         , This.RowT := RowColors ? RowColors.T : UseAltRow ? This.ART : This.TxClr
         If (This.AltCols || This["Cells"].HasKey(Row))
            Return 0x20
         NumPut(This.RowT, L + OffCT, "UInt"), NumPut(This.RowB, L + OffCB, "UInt")
         Return 0x00
      }
      ; CDDS_PREPAINT = 0x000001 ---------------------------------------------------------------------------------------
      Return (DrawStage = 0x000001) ? 0x20 : 0x00
   }
   ; -------------------------------------------------------------------------------------------------------------------
   MapIndexToID(Row) { ; provides the unique internal ID of the given row number
      SendMessage, 0x10B4, % (Row - 1), 0, , % "ahk_id " . This.HWND ; LVM_MAPINDEXTOID
      Return ErrorLevel
   }
   ; -------------------------------------------------------------------------------------------------------------------
   BGR(Color, Default := "") { ; converts colors to BGR
      Static Integer := "Integer" ; v2
      ; HTML Colors (BGR)
      Static HTML := {AQUA: 0x00FFFF, BLACK: 0x000000, RED: 0xFF0000, FUCHSIA: 0xFF00FF, GRAY: 0x808080, GREEN: 0x008000
                    , LIME: 0x00FF00, MAROON: 0x800000, NAVY: 0x000080, OLIVE: 0x808000, PURPLE: 0x800080, BLUE: 0x0000FF
                    , SILVER: 0xC0C0C0, TEAL: 0x008080, WHITE: 0xFFFFFF, YELLOW: 0xFFFF00}
      If Color Is Integer
         Return ((Color >> 16) & 0xFF) | (Color & 0x00FF00) | ((Color & 0xFF) << 16)
      Return (HTML.HasKey(Color) ? HTML[Color] : Default)
   }
}

esc::
exitapp

filtrodata:
   if (filtrodata = 1)
      {
      filtrodata := 0
      Menu,tray , Uncheck,filtro data
      }
   else   
       if (filtrodata = 0)
            {
            filtrodata := 1
            Menu,tray , check,filtro data
            }
return

eliminazioneautomatica:
   if (eliminazioneautomatica = 1)
      {
      eliminazioneautomatica := 0
      Menu,tray , Uncheck,eliminazione automatica
      }
   else   
      if (eliminazioneautomatica = 0)
      {
      eliminazioneautomatica := 1
      Menu,tray , check,eliminazione automatica
      }
return



chiusurapcaltermine:
   if (chiusurapcaltermine = 1)
      {
      chiusurapcaltermine := 0
      Menu,tray , Uncheck,chiusura al termine  
      }
   else   
      if (chiusurapcaltermine = 0)
      {
      chiusurapcaltermine := 1
      Menu,tray , check,chiusura al termine
      }
 
      
return




; --------------------------------------------------
; CleanupSingleProfile chiama i tre metodi di rimozione:
; 1) UnlockAndKill per liberare handle bloccanti
; 2) DeleteDirSH   per cancellare con SHFileOperationW
; 3) RemoveWithFileRemoveDir per FileRemoveDir
; --------------------------------------------------
; --- Funzione generica per eseguire un comando con timeout ---
; --- Esegue un comando con retry e timeout totale ---
RunWithRetry(cmd, maxTentativi := 3, timeoutMs := 180000, pausaMs := 1000) {
    start := A_TickCount
    tentativo := 0
    successo := false

    while (tentativo < maxTentativi && (A_TickCount - start < timeoutMs) && !successo) {
        tentativo++
        Log("Tentativo " . tentativo . " -> " . cmd)
        Run, %cmd%, , Hide, pid

        ; Attesa processo con controllo timeout totale
        Loop {
            Process, Exist, %pid%
            if !ErrorLevel
                break
            if (A_TickCount - start > timeoutMs) {
                Log("Timeout totale raggiunto, termino processo: " . cmd)
                Process, Close, %pid%
                break
            }
            Sleep, 500
        }

        ; Se il comando non è un'operazione su file/cartella, qui potresti aggiungere un controllo personalizzato
        ; Per ora consideriamo che se il processo è terminato, il tentativo è "riuscito"
        successo := true

        if (!successo && (A_TickCount - start < timeoutMs)) {
            Sleep, %pausaMs%
        }
    }
    return successo
}

; --- Attesa condizionata fino a max timeout ---
WaitUntilGone(path, timeoutMs := 180000) {
    start := A_TickCount
    while (DirExist(path) && (A_TickCount - start < timeoutMs)) {
        Sleep, 500
    }
    return !DirExist(path)
}

; --- Funzione principale ---
CleanupSingleProfile(ProfileFullPath, handlePath, resultFile, logFile) {
    UnlockAndKill(ProfileFullPath, handlePath, resultFile, logFile)

    if DeleteDirSH(ProfileFullPath)
        return true

    if RemoveWithFileRemoveDir(ProfileFullPath)
        return true

    return false
}

; --- 1) Sblocca handle e termina processi ---
UnlockAndKill(ProfileFullPath, handlePath, resultFile, logFile) {
    cmd := ComSpec . " /c """ . handlePath . " """ . ProfileFullPath . """ > """ . resultFile . """"
    RunWithRetry(cmd, 3, 180000, 2000) ; max 3 tentativi in 3 minuti

    Loop, Read, %resultFile%
    {
        if RegExMatch(A_LoopReadLine, "i)pid: (\d+)", m) {
            pid := m1
            try {
                Process, Exist, %pid%
                if ErrorLevel
                    Process, Close, %pid%
            } catch e {
                FileAppend, [%A_Now%] Errore killing PID %pid%: %e%`n, %logFile%
            }
        }
    }
    FileDelete, %resultFile%
}

; --- 2) Cancellazione con SHFileOperation ---
DeleteDirSH(DirPath) {
    tentativi := 0
    start := A_TickCount
    while (tentativi < 3 && (A_TickCount - start < 180000) && DirExist(DirPath)) {
        tentativi++
        Log("Tentativo DeleteDirSH #" . tentativi)
        VarSetCapacity(shfo, 72, 0)
        NumPut(72, shfo, 0, "UInt")
        NumPut(0x00000010|0x00000100, shfo, 12, "UInt")
        buf := DirPath . Chr(0) . Chr(0)
        NumPut(&buf, shfo, 16, "Ptr")
        DllCall("shell32\SHFileOperationW", "Ptr", &shfo)
        if WaitUntilGone(DirPath, 5000) ; attende max 5s tra un tentativo e l'altro
            return true
        Sleep, 1000
    }
    return !DirExist(DirPath)
}

; --- 3) Cancellazione con FileRemoveDir ---
RemoveWithFileRemoveDir(DirPath) {
    tentativi := 0
    start := A_TickCount
    while (tentativi < 3 && (A_TickCount - start < 180000) && DirExist(DirPath)) {
        tentativi++
        Log("Tentativo RemoveWithFileRemoveDir #" . tentativi)
        FileRemoveDir, %DirPath%, 1
        if WaitUntilGone(DirPath, 5000)
            return true
        Sleep, 1000
    }
    return !DirExist(DirPath)
}

; --- Utility per verificare se una cartella esiste ---
DirExist(path) {
    attr := FileExist(path)
    return (attr != "" && InStr(attr, "D"))
}


