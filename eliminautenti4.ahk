1   
2   
3   #SingleInstance force
4   
5   
6   CoordMode, ToolTip, Screen
7   
8   IniRead, cancellacartellatemp, impostazioni.ini, impostazioni, cancellacartellatemp
9   if (cancellacartellatemp = "ERROR")
10    {
11     MsgBox, 4,,abilitare cancellazione  cartella temp? (premi SI or NO)
12  IfMsgBox Yes
13      {
14       cancellacartellatemp := 1
15       IniWrite,1, impostazioni.ini, impostazioni, cancellacartellatemp
16      }
17      else
18      {
19       cancellacartellatemp := 0
20       IniWrite,0, impostazioni.ini, impostazioni, cancellacartellatemp
21      }  
22    
23    }
24  
25  IniRead, sceltametodocancellazione, impostazioni.ini, impostazioni, sceltametodocancellazione
26  if (sceltametodocancellazione = "ERROR")
27    {
28    inputbox,sceltametodocancellazione,sceltametodocancellazione,inserire 1 testato 2 veloce ; 3 ancora più veloce con Remove-Item
29  
30       IniWrite,%sceltametodocancellazione%, impostazioni.ini, impostazioni, sceltametodocancellazione
31    
32    }
33  
34  
35  IniRead, aggiornamentowindows, impostazioni.ini, impostazioni, aggiornamentowindows
36  if (aggiornamentowindows = "ERROR")
37    {
38     
39     MsgBox, 4,, abilitare aggiornamento windows? (premi SI or NO)
40  IfMsgBox Yes
41      {
42       aggiornamentowindows := 1
43       IniWrite,1, impostazioni.ini, impostazioni, aggiornamentowindows
44      }
45      else
46      {
47       aggiornamentowindows := 0
48       IniWrite,0, impostazioni.ini, impostazioni, aggiornamentowindows
49      }  
50    
51    }
52  
53  
54  
55  
56  IniRead, filtrodata, impostazioni.ini, impostazioni, filtrodata
57  if (filtrodata = "ERROR")
58    {
59     
60     MsgBox, 4,, abilitare filtro per data? (premi SI or NO)
61  IfMsgBox Yes
62      {
63       filtrodata := 1
64       IniWrite,1, impostazioni.ini, impostazioni, filtrodata
65      }
66      else
67      {
68       filtrodata := 0
69       IniWrite,0, impostazioni.ini, impostazioni, filtrodata
70      }  
71    
72    }
73    
74  IniRead, INTERVALLODATEUSCITA, impostazioni.ini, impostazioni, INTERVALLODATEUSCITA
75  ;MSGBOX % INTERVALLODATEUSCITA
76  if (INTERVALLODATEUSCITA = "ERROR")
77    {
78     
79     INPUTBOX,INTERVALLODATEUSCITA, INSERIRE INTERVALLO DATE PER NON ESECUZIONE PROGRAMMA, , , ,,,,,,0615|0901 
80     
81       IniWrite,%INTERVALLODATEUSCITA%, impostazioni.ini, impostazioni, INTERVALLODATEUSCITA
82     
83    
84    }
85  
86  
87  
88  IniRead, eliminazioneautomatica, impostazioni.ini, impostazioni, eliminazioneautomatica
89  if (eliminazioneautomatica = "ERROR")
90    {
91     
92     MsgBox, 4,, abilitare l'eliminazione automatica utenti? (premi SI or NO)
93  IfMsgBox Yes
94      {
95       eliminazioneautomatica := 1
96       IniWrite,1, impostazioni.ini, impostazioni, eliminazioneautomatica
97      }
98      else
99      {
100      eliminazioneautomatica := 0
101      IniWrite,0, impostazioni.ini, impostazioni, eliminazioneautomatica
102     }  
103   
104   }
105   
106 IniRead, pausa, impostazioni.ini, impostazioni, pausa
107 if (pausa = "ERROR")
108   {
109    
110   INPUTBOX,pausa, INSERIRE SECONDI PAUSA DOPO MESSAGGI, , , ,,,,,,30
111      ;INTERvallodate := 1
112      IniWrite,%PAUSA%, impostazioni.ini, impostazioni, pausa
113   
114   }  
115   
116 
117  IniRead, chiusurapcaltermine, impostazioni.ini, impostazioni, chiusurapcaltermine
118 if (chiusurapcaltermine = "ERROR")
119   {
120    
121    MsgBox, 4,, Chiudere il pc una volta concluso il lavoro? (premi SI or NO)
122 IfMsgBox Yes
123     {
124      chiusurapcaltermine := 1
125      IniWrite,1, impostazioni.ini, impostazioni, chiusurapcaltermine
126     }
127     else
128     {
129      chiusurapcaltermine := 0
130      IniWrite,0, impostazioni.ini, impostazioni, chiusurapcaltermine
131     }  
132   
133   }  
134   
135  */ 
136 
137 
138 if (cancellacartellatemp = 1)
139    gosub, cancellacartellatemp
140 
141 if (aggiornamentowindows = 1)
142    {
143 MsgBox, 1, , vuoi avviare aggiornamento di windows (Press YES or NO)
144 IfMsgBox Yes
145     RunWait, cmd /c "wuauclt /detectnow & wuauclt /updatenow", , Hide
146    }
147 
148 
149 ;MSGBOX % INTERVALLODATEUSCITA
150 StringSplit, DATAArray, INTERVALLODATEUSCITA,|
151 ;SubStr("123abc789", 4, 3) ; Returns abc
152 
153 data := A_MM A_dd
154 
155 ;MSGBOX % data " <= " DATAArray1 " or " data ">= " DATAArray2 
156 
157 if (filtrodata = 1)
158   IF (data <= DATAArray1) or (data >= DATAArray2)
159     {
160      MSGBOX,0,elimina utenti, ESCE PROGRAMMA, %pausa%
161      exitapp
162     } 
163     ;ELSE
164     ;{
165     ; MSGBOX ESEGUE PROGRAMMA
166      
167     ;} 
168     
169 
170 Menu, Tray, Add,eliminazione automatica, eliminazioneautomatica 
171 if (eliminazioneautomatica = 1)
172    Menu,tray , check,eliminazione automatica
173 else
174   Menu,tray , Uncheck,eliminazione automatica
175 
176 Menu, Tray, Add, chiusura al termine, chiusurapcaltermine
177 if (chiusurapcaltermine = 1)
178    Menu,tray , check,chiusura al termine
179 else
180   Menu,tray , Uncheck,chiusura al termine
181   
182 Menu, Tray, Add, filtro data, filtrodata
183 if (filtrodata = 1)
184    Menu,tray , check,filtro data
185 else
186   Menu,tray , Uncheck,filtro data
187 
188 
189 
190 if A_OSVersion in WIN_XP
191 {
192    MsgBox, 262160, Profile Remover, This is not compatible with XP.`n`nThis script will now exit.
193    ExitApp
194 }
195 
196 if not A_IsAdmin
197 {
198    Run *RunAs "%A_AhkPath%" "%A_ScriptFullPath%"
199    ExitApp
200 }
201 
202 OnExit("Cleanup")
203 OnExit(ObjBindMethod(MyObject, "Exiting"))
204 SetBatchLines, -1
205 
206 TempFolder = %A_Temp%\ProfileKiller
207 TempFolder =  %A_MyDocuments%\trash
208 
209 FileCreateDir %TempFolder%
210 
211 selezioneutente := 1
212 creagui:
213 Gui, Destroy
214 sleep 1
215 Gui, Margin, 10, 10
216 
217 if(selezioneutente = 1)
218 Gui, Add, ListView, List r10 w460 h380 Grid vVLV hwndHLV gColClick
219    , User Profiles|Last Modified|Size|SSID|Extra
220 else   
221 Gui, Add, ListView,  r10 w460 h380 Grid vVLV hwndHLV gColClick
222    , User Profiles|Last Modified|Size|SSID|Extra   
223    
224 Gui Add, Text, x476 y5, Select the profiles to remove and click Go.
225 Gui Add, Text, x476 y25 w220, Any rows highlighted in yellow are user folders that are invalid and are not in the registry.
226 Gui Add, Button, x476 y60 w50 gaggiornastatogui, Go
227 gosub UserList
228 
229 ; Create a new instance of LV_Colors
230 CLV := New LV_Colors(HLV)
231 
232 
233 ; Set the colors for selected rows
234 CLV.SelectionColors(0x0000FF, 0xFFFFFF)
235 If !IsObject(CLV) {
236    MsgBox, 0, ERROR, Couldn't create a new LV_Colors object!
237    ExitApp
238 }
239 
240 ;msgbox % "iooi " CLV " --- " HLV
241 
242 ; ======  Adjusting column widths  ======
243 LV_ModifyCol(1, AutoHdr)
244 LV_ModifyCol(3, 80)
245 LV_ModifyCol(4, 0)
246 LV_ModifyCol(5, 0)
247 
248 
249 Gui Show, xCenter YCenter, Profile Remover
250 
251 ; Redraw the ListView after the first Gui, Show command to show the colors, if any.
252 WinSet, Redraw, , ahk_id %HLV%
253 
254 
255 
256 
257 gosub ExtraFolders
258 gosub FolderSize
259 
260 if (eliminazioneautomatica = 1)
261 {
262 
263 ;msgbox % "myUserList " myUserList
264 ;msgbox % "ListUserName" ListUserName
265  ListUserName := myUserList
266  
267  Gui eliminautenti:Add, text,, %ListUserName%
268  Gui, eliminautenti:Show,X0 Y0 
269  
270  MsgBox, 4, , rimuovere i seguenti utenti - avvio automatico dopo %pausa% secondi, %pausa%
271 ;IfMsgBox Timeout
272 ;    MsgBox You didn't press YES or NO within the 5-second period.
273   IfMsgBox No
274    {
275     gui eliminautenti:destroy
276     return
277    }
278  gosub,engage
279 }
280 
281 
282 Loop
283 {
284     ; Controlla aggiornamenti disponibili online
285     RunWait, powershell -Command "Get-WindowsUpdate | Out-File %A_Temp%\available_updates.txt", , Hide
286     FileRead, availableUpdates, %A_Temp%\available_updates.txt
287 
288     ; Se ci sono aggiornamenti, installa
289     If (availableUpdates != "")
290     {
291         RunWait, powershell -Command "Install-WindowsUpdate -AcceptAll -AutoReboot", , Hide
292 
293         ; Controlla se gli aggiornamenti sono stati completati
294         Sleep, 60000  ; Attende 1 minuto prima di verificare
295         RunWait, powershell -Command "Get-WindowsUpdate | Out-File %A_Temp%\available_updates.txt", , Hide
296         FileRead, availableUpdates, %A_Temp%\available_updates.txt
297 
298         If (availableUpdates = "")
299             Break  ; Se tutto è aggiornato, esce dal loop
300     }
301     Else
302         Break  ; Se non ci sono aggiornamenti, esce subito
303     
304     Sleep, 60000  ; Attende 1 minuto prima di ripetere il controllo
305 }
306 
307 
308 if (aggiornamentowindows = 1)
309    {
310 
311    
312  RunWait, powershell -Command "Get-WindowsUpdate", , Hide
313 If ErrorLevel = 0
314 {
315     
316     RunWait, powershell -Command "Install-WindowsUpdate -AcceptAll -AutoReboot", , Hide
317     
318  ; Disabilita aggiornamenti automatici
319     RunWait, cmd /c "sc config wuauserv start= disabled & net stop wuauserv", , Hide   
320    
321    }
322 ; Spegne il PC
323   else
324 ; Disabilita aggiornamenti automatici
325     RunWait, cmd /c "sc config wuauserv start= disabled & net stop wuauserv", , Hide
326 }
327 
328 if (chiusurapcaltermine = 1)
329 {
330 ;msgbox % "myUserList " myUserList
331 ;msgbox % "ListUserName" ListUserName
332  
333  Shutdown, 1
334  
335 }
336 
337 Return
338 
339 GuiClose:
340 GuiEscape:
341 ExitApp
342 
343 cancellacartellatemp:
344 
345 
346 Run, "%A_ScriptDir%\PulisciTemp.exe"
347 
348 return
349 
350 
351 
352 
353 
354 UserList:
355 ; ==============  get list of logged in users to exclude from list  ==================
356 RunWait cmd.exe /c quser > %TempFolder%\quser.txt,, Hide
357 ;FileRead LoadedProfiles, %TempFolder%\quser.txt
358 FileRead LoadedProfiles, quser.txt
359 LoadedProfiles := LoadedProfiles listadaescludere
360 
361 ;msgbox % "fer " LoadedProfiles 
362 
363 ; ==============  this piece gets the list of existing profiles from registry  ==================
364 ProfileRegList = HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList
365 
366 Loop Reg, %ProfileRegList%, KR
367 {
368 	if (A_LoopRegName = "S-1-5-18" or A_LoopRegName = "S-1-5-19" or A_LoopRegName = "S-1-5-20")
369 		continue ; skip the above system accounts
370 	SIDNames = %SIDNames%%A_LoopRegName%`n ; add the SID #s of these reg entries to a list
371 }
372 
373 ; ======  parse the SID list and get the username each corresponds to  ======
374 Loop Parse, SIDNames, `n
375 {
376 	if A_LoopField = ; if empty, move on
377 		continue
378 	RegRead LocalPath, %ProfileRegList%\%A_LoopField%, ProfileImagePath
379 	LocalPath := StrReplace(LocalPath, "C:\Users\") ; remove the beginning of the path so it's just the username
380 	Needle = %LocalPath%%A_Space% ; Username plus a space
381 	
382   ;msgbox % "fer1 "   LoadedProfiles "°°°°°°°°°°°°°° " Needle
383     
384     
385 	if InStr(LoadedProfiles, Needle) ; if the Username+Space is found in the list of loaded users
386 		{
387         continue ; skip it
388 	    
389         }
390     LV_Add("",LocalPath,,, A_LoopField) ; this gives me a username and SID
391 	NewLocalPath = %NewLocalPath%%LocalPath%`n
392 
393     ;msgbox % "NewLocalPath " NewLocalPath
394     
395 }
396 myUserList = %NewLocalPath%
397 
398 ;msgbox % "myUserList " myUserList
399 
400 
401 ; ======  get last modified time for folders  ======
402 Loop Parse, myUserList, `n
403 {
404 	if A_LoopField =
405 		continue
406 	FileGetTime LastMod, C:\Users\%A_LoopField%
407 	FormatTime LastMod, %LastMod%, yyyy/M/d
408 	LV_Modify(A_Index, , , LastMod, "<calculating>")
409 }
410 return
411 
412 
413 ExtraFolders:
414 CLV.OnMessage()
415 GuiControl, Focus, %HLV%
416 GuiControl, -Redraw, %HLV%
417 CLV.Clear(1, 1)
418 
419 Loop Files, C:\Users\*, D
420 {
421 	Needle = %A_LoopFileName%%A_Space% ; Username plus a space
422 	if InStr(LoadedProfiles, Needle) ; if the Username+Space is found in the list of loaded users
423 		continue ; skip it
424 	
425 	if (A_LoopFileName = "All Users" or A_LoopFileName = "Default" or A_LoopFileName = "Default User" or A_LoopFileName = "Public" or A_LoopFileName = "Administrator")
426 		continue
427 		
428 	if !InStr(NewLocalPath, A_LoopFileName . "`n")
429 	{
430 		FileGetTime LastMod, C:\Users\%A_LoopFileName%
431 		FormatTime LastMod, %LastMod%, yyyy/M/d
432         LV_Add("", A_LoopFileName, LastMod, "<calculating>",, "1")
433 		Row := LV_GetCount()
434 		CLV.Row(Row, 0xFFFF00, 0x000000) ; make it yellow
435 	}
436 }
437 CLV.NoSort(False) ; this enables column re-sorting
438 GuiControl, +Redraw, %HLV%
439 return
440 
441 
442 
443 ; ======  calculate user folder sizes  ======
444 FolderSize:
445 Loop
446 {
447    LV_GetText(Name, A_Index)  ; Resume the search at the row after that found by the previous iteration.
448    if Name =
449       break
450    
451    ; ======  calculate the size.  No offline files, directories or system files.  The last two don't make much diff for size but speeds it up  ======
452    if A_OSVersion in WIN_7,WIN_8,WIN_8.1,WIN_VISTA
453 		RunWait cmd.exe /c dir C:\Users\%Name% /a:-D-S /S > %TempFolder%\%Name%-Size.txt,, Hide
454 	
455     else if (A_OSVersion >= "10.0.17763")
456 		; the Offline file attribute was introduced in version 1809 of Windows 10, which is preferred, as it 
457 		; lets me calculate the actual "on disk" file size.  Not just what is allocated by offline files in cloud-syncing programs.
458 		RunWait cmd.exe /c dir C:\Users\%Name% /a:-O-D-S /S > %TempFolder%\%Name%-Size.txt,, Hide
459 	
460     else ; if W10 and lower than 1809
461 		RunWait cmd.exe /c dir C:\Users\%Name% /a:-D-S /S > %TempFolder%\%Name%-Size.txt,, Hide
462    
463    FileRead theText, %TempFolder%\%Name%-Size.txt
464    
465    ; ======  get beginning of location from bottom and trim  ======
466    FileLineNum := InStr(theText, "File", , 0, 1)
467    Replacement1 := SubStr(theText, FileLineNum)
468    
469    ; ======  get end of byte #'s and trim  ======
470    0Dir := InStr(Replacement1, "0 Dir",, 0) - 1
471    Replacement1 := SubStr(Replacement1, 1, 0Dir)
472    
473    ; ======  get rid of extra stuff  ======
474    Replacement1 := StrReplace(Replacement1, "bytes", "")
475    Replacement1 := StrReplace(Replacement1, ",", "")
476    Replacement1 := StrReplace(Replacement1, "File(s) ", "")
477    Replacement1 := StrReplace(Replacement1, "`r`n", "")
478    Replacement1 := StrReplace(Replacement1, " ", "")
479    
480    ; ======  converstion from bytes to xxx.x MB or xx.xx GB  ======
481    if (Replacement1 <= 1073741824) ; if < 1GB
482    {
483       Replacement1 := Replacement1 // 1024 / 1024 ; the individual "/" is not a mistake
484       Replacement1 := Round(Replacement1, 1)
485       LV_Modify(A_Index, , , , Replacement1 . "  MB") ; modify the size field with calculated value
486    }
487    else
488    {
489       Replacement1 := Replacement1 // 1024 // 1024 / 1024
490       Replacement1 := Round(Replacement1, 2)
491       LV_Modify(A_Index, , , , Replacement1 . "  GB")
492    }
493 }
494 return
495 
496 
497 
498 
499 ; ======  this section is to re-color the "extra" user profiles if the columns are re-sorted  ======
500 ColClick:
501 CLV.OnMessage()
502 GuiControl, Focus, %HLV%
503 GuiControl, -Redraw, %HLV%
504 CLV.Clear(1, 1)
505 
506 Loop
507 {
508    LV_GetText(Name, A_Index)  ; Resume the search at the row after that found by the previous iteration.
509    if Name =
510       break
511    
512    LV_GetText(Extra, A_Index, 5)
513    if Extra = 1
514       CLV.Row(A_Index, 0xFFFF00, 0x000000)
515    else
516       CLV.Row(A_Index)
517 
518 
519    ;msgbox % "ds " clv
520 }
521 
522 ;msgbox % "ds7 " HLV
523 GuiControl, +Redraw, %HLV%
524 ;msgbox % "ds7 " HLV
525 
526 return
527 
528 
529 aggiornastatogui:
530 
531 
532 if (selezioneutente = 1)
533   {
534   selezioneutente := 0
535   ;
536 
537   RowNumber := 0
538   listadacancellare := ""
539   loop
540    {
541     RowNumber := LV_GetNext(RowNumber)
542     
543     if not RowNumber  
544         break 
545         
546     
547     LV_GetText(ListUserName, RowNumber)
548     
549    listadacancellare := listadacancellare "`n" ListUserName 
550 
551    
552    }
553  
554  ;msgbox % listadacancellare
555  RowNumber := LV_GetCount()
556  tot := RowNumber
557  ;msgbox % RowNumber
558  i:= 0
559  listadaescludere := ""
560  
561  loop %tot%
562    {
563      RowNumber := tot - i
564     
565       i := i + 1  
566           
567 	LV_GetText(ListUserName, RowNumber)
568     ;msgbox % "ds4 " ListUserName " -- " RowNumber " -- " i 
569     
570     If InStr(listadacancellare,ListUserName) 
571       {
572       }
573       else
574      listadaescludere := listadaescludere "`n" ListUserName 
575     ;msgbox % "ds5 " listadaescludere
576 	                  
577             
578        
579            
580    }
581 
582     
583    
584   
585  
586   
587   gosub, creagui
588   return
589   }
590 
591 gosub,engage
592 
593 return
594 
595 
596 
597 
598 ; ======  kill the profile  ======
599 Engage:
600 ; ========== Engage (sostitutivo completo) ==========
601 
602 RowNumber = 0  ; This causes the first loop iteration to start the search at the top of the list.
603 con := 0
604 i := 0
605 
606 ; Nuovo: lista per utenti falliti al primo giro + set per evitare duplicati
607 daRiprova := []
608 giaSegnati := {}
609 
610 FileDelete, %TEMP%\*
611 Loop, %TEMP%\*, 2
612 {
613     FileRemoveDir, %A_LoopFileFullPath%, 1
614 }
615 
616 Loop
617 {
618     RowNumber := LV_GetCount()
619     RowNumber := RowNumber - i
620     
621     if (RowNumberprecedente = RowNumber)
622     {
623         con := con + 1
624         if (con = 3)
625         {
626             con := 0
627             i := i + 1
628         }
629     }
630     
631     RowNumberprecedente := RowNumber
632     
633     if not RowNumber
634         break ; The above returned zero, so there are no more selected rows.
635 
636     LV_GetText(ListUserName, RowNumber)
637     LV_GetText(SSID, RowNumber, 4)
638 
639     Profile = C:\Users\%ListUserName%
640     Gui, 2:add, progress, xCenter yCenter w500 h20 Range0-2
641     Gui, 2:Show,, Removing User folder %Profile% RowNumber %RowNumber%
642 
643     if (sceltametodocancellazione = 2)
644     {
645         start := a_tickcount
646 
647         ; Imposta log file
648         logFile := A_ScriptDir "\log_eliminazione.txt"
649         handlePath := A_ScriptDir "\handle64.exe"
650         resultFile := A_ScriptDir "\processi_bloccanti.txt"
651         targetFolder := Profile
652 
653         ; 🔹 1️⃣ Tentativo iniziale di rimozione permessi e contenuti
654         RunWait, powershell -Command "if (Test-Path \"%targetFolder%\") { try { takeown /F \"%targetFolder%\" /R /D Y; icacls \"%targetFolder%\" /grant $env:USERNAME:F /T /C /Q; attrib -r -s -h \"%targetFolder%\" /S /D } catch { $_ | Out-File -Append -FilePath \"%logFile%\" } }", , Hide, 60000
655         RunWait, powershell -Command "if (Test-Path \"%targetFolder%\") { try { Get-ChildItem -Path \"%targetFolder%\" -Recurse -Force -File | Remove-Item -Force -ErrorAction Stop } catch { $_ | Out-File -Append -FilePath \"%logFile%\" } }", , Hide, 60000
656         RunWait, powershell -Command "if (Test-Path \"%targetFolder%\") { try { Get-ChildItem -Path \"%targetFolder%\" -Recurse -Force -Directory | Remove-Item -Force -Recurse -ErrorAction Stop } catch { $_ | Out-File -Append -FilePath \"%logFile%\" } }", , Hide, 60000
657         RunWait, cmd /c "rmdir \"%targetFolder%\" /S /Q", , Hide, 60000
658         RunWait, powershell -Command "if (Test-Path \"%targetFolder%\") { try { Remove-Item -Path \"%targetFolder%\" -Force -Recurse } catch { $_ | Out-File -Append -FilePath \"%logFile%\" } }", , Hide, 60000
659 
660         ; 🔹 2️⃣ Se ancora esiste, cerca i processi che la bloccano
661         IfExist, %targetFolder%
662         {
663             Log("Cartella non eliminata. Avvio rilevamento dei processi bloccanti...")
664             RunWait, %ComSpec% /c "%handlePath% \"%targetFolder%\" > \"%resultFile%\"", , Hide
665             Loop, Read, %resultFile%
666             {
667                 if RegExMatch(A_LoopReadLine, "i)pid: (\d+)", match)
668                 {
669                     pid := match1
670                     RunWait, powershell -Command "Stop-Process -Id %pid% -Force", , Hide
671                     Log("Terminato processo PID: " . pid)
672                 }
673             }
674             FileDelete, %resultFile%
675             ; 🔁 Riprova la cancellazione finale
676             RunWait, powershell -Command "if (Test-Path \"%targetFolder%\") { try { Remove-Item -Path \"%targetFolder%\" -Force -Recurse } catch { $_ | Out-File -Append -FilePath \"%logFile%\" } }", , Hide, 60000
677         }
678 
679         ; 🔹 3️⃣ Riavvia Explorer se assente
680         RunWait, powershell -Command "if (!(Get-Process explorer -ErrorAction SilentlyContinue)) { Start-Process explorer.exe }", , Hide
681 
682         ; 🔹 4️⃣ Robocopy + eliminazione con cartella temporanea
683         IfExist %targetFolder%
684         {
685             cartellaTmp := A_ScriptDir "\temp"
686             if not FileExist(cartellaTmp)
687                 FileCreateDir, %cartellaTmp%
688             RunWait, powershell -Command "robocopy \"%cartellaTmp%\" \"%targetFolder%\" /MIR", , Hide, 60000
689             FileRemoveDir, %cartellaTmp%, 1
690             FileRemoveDir, %targetFolder%, 1
691             Log("Eliminazione finale completata con robocopy.")
692         }
693         else
694         {
695             Log("La cartella """ . targetFolder . """ è stata eliminata correttamente.")
696         }
697 
698         GuiControl, 2:, msctls_progress321, +1
699         ris := (a_tickcount - start) / 1000
700         tooltip, tempo impiegato rimozione files utente %ListUserName% %ris% secondi ,0,0
701     }
702 
703     ; ======  use PS to remove profile from registry  ======
704     Gui, 2:Show,, Removing Profile from registry %ListUserName% riga %RowNumber%
705     start := a_tickcount
706 
707     if (sceltametodocancellazione = 2)
708     {
709         start := A_TickCount
710         tempPS1 := A_Temp "\remove_profile.ps1"
711 
712         ; 1️⃣ Crea script PS per rimozione dal registro
713         FileDelete, %tempPS1%
714         FileAppend,
715         (
716         Get-CimInstance Win32_UserProfile |
717         Where-Object { -not $_.Special -and -not $_.Loaded -and $_.LocalPath -like '*%Profile%' } |
718         Remove-CimInstance
719         ), %tempPS1%
720 
721         ; 2️⃣ Esegui rimozione profilo dal registro
722         RunWait, powershell -ExecutionPolicy Bypass -File "%tempPS1%", , Hide
723 
724         ; 3️⃣ Elimina fisicamente la cartella utente
725         FileDelete, %tempPS1%
726         FileAppend,
727         (
728         if (Test-Path "%Profile%") {
729             Remove-Item -Path "%Profile%" -Recurse -Force
730         }
731         ), %tempPS1%
732         RunWait, powershell -ExecutionPolicy Bypass -File "%tempPS1%", , Hide
733 
734         ; 4️⃣ Elimina chiave registro se ancora presente
735         RegRead, LocalPath, %ProfileRegList%\%SSID%, ProfileImagePath
736         if !ErrorLevel
737         {
738             RegDelete, %ProfileRegList%\%SSID%
739         }
740 
741         ; 5️⃣ Tooltip finale
742         ris := (A_TickCount - start) / 1000
743         ToolTip, ✅ Rimozione completata per %ListUserName% in %ris% secondi, 0, 0
744     }
745 
746     if (sceltametodocancellazione = 3)
747     {
748         psCommand := "Get-CimInstance Win32_UserProfile | Where-Object { -not $_.Special -and -not $_.Loaded -and $_.LocalPath -match 'Profile' } | ForEach-Object { Remove-Item -Path $_.LocalPath -Recurse -Force }"
749         shell := ComObjCreate("WScript.Shell")
750         shell.Exec("powershell -command """ psCommand """")
751     }
752 
753     if (sceltametodocancellazione = 3)
754     {
755         RunWait Powershell -command "& {Get-WmiObject win32_userprofile | Where-Object {!$_.Special -and !$_.Loaded -and $_.LocalPath -like '%Profile%'} | RWMI}",, Hide
756         ris := (a_tickcount - start) / 1000
757         tooltip, tempo impiegato rimozione voce registro %ListUserName% %ris% secondi ,0,0
758     }
759 
760     Gui, 2:Destroy
761     sleep 1
762 
763     IfExist %Profile%
764     {
765         Failure = 1
766         FolderMessage = files %Profile% non cancellati
767     }
768 
769     RegRead LocalPath, %ProfileRegList%\%SSID%, ProfileImagePath
770     if !ErrorLevel
771     {
772         Failure = 1
773         RegMessage = Registro %ListUserName% Profilo non rimosso
774     }
775 
776     if Failure = 1
777     {
778         ; Accoda utente per il “giro di ripasso” (una sola volta)
779         if (!giaSegnati.HasKey(SSID))
780         {
781             daRiprova.Push({Name: ListUserName, SSID: SSID})
782             giaSegnati[SSID] := true
783         }
784 
785         con := con + 1
786         if (con = 3)
787         {
788             noneliminati := noneliminati FolderMessage " ---- " RegMessage "`n"
789             con := 0
790             i := i + 1
791         }
792     }
793     else
794     {
795         LV_Delete(RowNumber)
796     }
797 }
798 
799 ; ==========================
800 ; Secondo passaggio: riprova gli utenti falliti
801 ; ==========================
802 if (daRiprova.Length() > 0)
803 {
804     ; MsgBox, 64, Info, Avvio secondo tentativo su % daRiprova.Length() " utenti non eliminati al primo giro."
805     for idx, ut in daRiprova
806     {
807         ListUserName := ut.Name
808         SSID := ut.SSID
809         Profile = C:\Users\%ListUserName%
810 
811         ; --- ripete la stessa logica di cancellazione ---
812 
813         if (sceltametodocancellazione = 2)
814         {
815             start := a_tickcount
816 
817             logFile := A_ScriptDir "\log_eliminazione.txt"
818             handlePath := A_ScriptDir "\handle64.exe"
819             resultFile := A_ScriptDir "\processi_bloccanti.txt"
820             targetFolder := Profile
821 
822             RunWait, powershell -Command "if (Test-Path \"%targetFolder%\") { try { takeown /F \"%targetFolder%\" /R /D Y; icacls \"%targetFolder%\" /grant $env:USERNAME:F /T /C /Q; attrib -r -s -h \"%targetFolder%\" /S /D } catch { $_ | Out-File -Append -FilePath \"%logFile%\" } }", , Hide, 60000
823             RunWait, powershell -Command "if (Test-Path \"%targetFolder%\") { try { Get-ChildItem -Path \"%targetFolder%\" -Recurse -Force -File | Remove-Item -Force -ErrorAction Stop } catch { $_ | Out-File -Append -FilePath \"%logFile%\" } }", , Hide, 60000
824             RunWait, powershell -Command "if (Test-Path \"%targetFolder%\") { try { Get-ChildItem -Path \"%targetFolder%\" -Recurse -Force -Directory | Remove-Item -Force -Recurse -ErrorAction Stop } catch { $_ | Out-File -Append -FilePath \"%logFile%\" } }", , Hide, 60000
825             RunWait, cmd /c "rmdir \"%targetFolder%\" /S /Q", , Hide, 60000
826             RunWait, powershell -Command "if (Test-Path \"%targetFolder%\") { try { Remove-Item -Path \"%targetFolder%\" -Force -Recurse } catch { $_ | Out-File -Append -FilePath \"%logFile%\" } }", , Hide, 60000
827 
828             IfExist, %targetFolder%
829             {
830                 RunWait, %ComSpec% /c "%handlePath% \"%targetFolder%\" > \"%resultFile%\"", , Hide
831                 Loop, Read, %resultFile%
832                 {
833                     if RegExMatch(A_LoopReadLine, "i)pid: (\d+)", match)
834                     {
835                         pid := match1
836                         RunWait, powershell -Command "Stop-Process -Id %pid% -Force", , Hide
837                     }
838                 }
839                 FileDelete, %resultFile%
840                 RunWait, powershell -Command "if (Test-Path \"%targetFolder%\") { try { Remove-Item -Path \"%targetFolder%\" -Force -Recurse } catch { $_ | Out-File -Append -FilePath \"%logFile%\" } }", , Hide, 60000
841             }
842 
843             RunWait, powershell -Command "if (!(Get-Process explorer -ErrorAction SilentlyContinue)) { Start-Process explorer.exe }", , Hide
844 
845             IfExist %targetFolder%
846             {
847                 cartellaTmp := A_ScriptDir "\temp"
848                 if not FileExist(cartellaTmp)
849                     FileCreateDir, %cartellaTmp%
850                 RunWait, powershell -Command "robocopy \"%cartellaTmp%\" \"%targetFolder%\" /MIR", , Hide, 60000
851                 FileRemoveDir, %cartellaTmp%, 1
852                 FileRemoveDir, %targetFolder%, 1
853             }
854         }
855 
856         ; Registro (metodo 2)
857         if (sceltametodocancellazione = 2)
858         {
859             tempPS1 := A_Temp "\remove_profile.ps1"
860             FileDelete, %tempPS1%
861             FileAppend,
862             (
863             Get-CimInstance Win32_UserProfile |
864             Where-Object { -not $_.Special -and -not $_.Loaded -and $_.LocalPath -like '*%Profile%' } |
865             Remove-CimInstance
866             ), %tempPS1%
867             RunWait, powershell -ExecutionPolicy Bypass -File "%tempPS1%", , Hide
868 
869             FileDelete, %tempPS1%
870             FileAppend,
871             (
872             if (Test-Path "%Profile%") {
873                 Remove-Item -Path "%Profile%" -Recurse -Force
874             }
875             ), %tempPS1%
876             RunWait, powershell -ExecutionPolicy Bypass -File "%tempPS1%", , Hide
877 
878             RegRead, LocalPath, %ProfileRegList%\%SSID%, ProfileImagePath
879             if !ErrorLevel
880             {
881                 RegDelete, %ProfileRegList%\%SSID%
882             }
883         }
884 
885         ; Metodo 3
886         if (sceltametodocancellazione = 3)
887         {
888             psCommand := "Get-CimInstance Win32_UserProfile | Where-Object { -not $_.Special -and -not $_.Loaded -and $_.LocalPath -match 'Profile' } | ForEach-Object { Remove-Item -Path $_.LocalPath -Recurse -Force }"
889             shell := ComObjCreate("WScript.Shell")
890             shell.Exec("powershell -command """ psCommand """")
891             RunWait Powershell -command "& {Get-WmiObject win32_userprofile | Where-Object {!$_.Special -and !$_.Loaded -and $_.LocalPath -like '%Profile%'} | RWMI}",, Hide
892         }
893 
894         ; Valutazione esito secondo passaggio
895         Failure := 0
896         IfExist %Profile%
897         {
898             Failure := 1
899             FolderMessage := "files " . Profile . " non cancellati"
900         }
901         RegRead LocalPath, %ProfileRegList%\%SSID%, ProfileImagePath
902         if !ErrorLevel
903         {
904             Failure := 1
905             RegMessage := "Registro " . ListUserName . " Profilo non rimosso"
906         }
907 
908         if (Failure = 1)
909         {
910             noneliminati := noneliminati FolderMessage " ---- " RegMessage "`n"
911         }
912         else
913         {
914             ; se esiste ancora in ListView, rimuovi la riga corrispondente al nome
915             idxToDel := 0
916             Loop % LV_GetCount()
917             {
918                 LV_GetText(_nm, A_Index)
919                 if (_nm = ListUserName) {
920                     idxToDel := A_Index
921                     break
922                 }
923             }
924             if (idxToDel)
925                 LV_Delete(idxToDel)
926         }
927     }
928 }
929 
930 gosub ColClick ; re-color the rows
931 
932 msgbox % "non è stato possibile eliminare i seguenti utenti:`n" noneliminati
933 return
934 
935 
936 Log(Msg) {
937     global logFile
938     FileAppend, [%A_Hour%:%A_Min%:%A_Sec%] %Msg%`n, %logFile%
939 }
940 
941 ; ======  cleanup the Temp folder  ======
942 Cleanup(ExitReason, ExitCode)
943 {
944    
945 }
946 
947 
948 class MyObject
949 {
950    Exiting()
951    {
952 		Run cmd.exe /c rmdir "%LocalAppData%\Temp\ProfileKiller" /S /Q,, Hide
953    }
954 }
955 
956 
957 
958 ; ======  do not modify below this line  ======
959 ; credit to "just me",  https://www.autohotkey.com/boards/memberlist.php?mode=viewprofile&u=148
960 ; posting: https://www.autohotkey.com/boards/viewtopic.php?f=6&t=1081
961 ; ======================================================================================================================
962 ; Namespace:      LV_Colors
963 ; Function:       Individual row and cell coloring for AHK ListView controls.
964 ; Tested with:    AHK 1.1.23.05 (A32/U32/U64)
965 ; Tested on:      Win 10 (x64)
966 ; Changelog:
967 ;     1.1.04.01/2016-05-03/just me - added change to remove the focus rectangle from focused rows
968 ;     1.1.04.00/2016-05-03/just me - added SelectionColors method
969 ;     1.1.03.00/2015-04-11/just me - bugfix for StaticMode
970 ;     1.1.02.00/2015-04-07/just me - bugfixes for StaticMode, NoSort, and NoSizing
971 ;     1.1.01.00/2015-03-31/just me - removed option OnMessage from __New(), restructured code
972 ;     1.1.00.00/2015-03-27/just me - added AlternateRows and AlternateCols, revised code.
973 ;     1.0.00.00/2015-03-23/just me - new version using new AHK 1.1.20+ features
974 ;     0.5.00.00/2014-08-13/just me - changed 'static mode' handling
975 ;     0.4.01.00/2013-12-30/just me - minor bug fix
976 ;     0.4.00.00/2013-12-30/just me - added static mode
977 ;     0.3.00.00/2013-06-15/just me - added "Critical, 100" to avoid drawing issues
978 ;     0.2.00.00/2013-01-12/just me - bugfixes and minor changes
979 ;     0.1.00.00/2012-10-27/just me - initial release
980 ; ======================================================================================================================
981 ; CLASS LV_Colors
982 ;
983 ; The class provides six public methods to set individual colors for rows and/or cells, to clear all colors, to
984 ; prevent/allow sorting and rezising of columns dynamically, and to deactivate/activate the message handler for
985 ; WM_NOTIFY messages (see below).
986 ;
987 ; The message handler for WM_NOTIFY messages will be activated for the specified ListView whenever a new instance is
988 ; created. If you want to temporarily disable coloring call MyInstance.OnMessage(False). This must be done also before
989 ; you try to destroy the instance. To enable it again, call MyInstance.OnMessage().
990 ;
991 ; To avoid the loss of Gui events and messages the message handler might need to be set 'critical'. This can be
992 ; achieved by setting the instance property 'Critical' ti the required value (e.g. MyInstance.Critical := 100).
993 ; New instances default to 'Critical, Off'. Though sometimes needed, ListViews or the whole Gui may become
994 ; unresponsive under certain circumstances if Critical is set and the ListView has a g-label.
995 ; ======================================================================================================================
996 Class LV_Colors {
997    ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
998    ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
999    ; META FUNCTIONS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1000   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1001   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1002   ; ===================================================================================================================
1003   ; __New()         Create a new LV_Colors instance for the given ListView
1004   ; Parameters:     HWND        -  ListView's HWND.
1005   ;                 Optional ------------------------------------------------------------------------------------------
1006   ;                 StaticMode  -  Static color assignment, i.e. the colors will be assigned permanently to the row
1007   ;                                contents rather than to the row number.
1008   ;                                Values:  True/False
1009   ;                                Default: False
1010   ;                 NoSort      -  Prevent sorting by click on a header item.
1011   ;                                Values:  True/False
1012   ;                                Default: True
1013   ;                 NoSizing    -  Prevent resizing of columns.
1014   ;                                Values:  True/False
1015   ;                                Default: True
1016   ; ===================================================================================================================
1017   __New(HWND, StaticMode := False, NoSort := True, NoSizing := True) {
1018      If (This.Base.Base.__Class) ; do not instantiate instances
1019         Return False
1020      If This.Attached[HWND] ; HWND is already attached
1021         Return False
1022      If !DllCall("IsWindow", "Ptr", HWND) ; invalid HWND
1023         Return False
1024      VarSetCapacity(Class, 512, 0)
1025      DllCall("GetClassName", "Ptr", HWND, "Str", Class, "Int", 256)
1026      If (Class <> "SysListView32") ; HWND doesn't belong to a ListView
1027         Return False
1028      ; ----------------------------------------------------------------------------------------------------------------
1029      ; Set LVS_EX_DOUBLEBUFFER (0x010000) style to avoid drawing issues.
1030      SendMessage, 0x1036, 0x010000, 0x010000, , % "ahk_id " . HWND ; LVM_SETEXTENDEDLISTVIEWSTYLE
1031      ; Get the default colors
1032      SendMessage, 0x1025, 0, 0, , % "ahk_id " . HWND ; LVM_GETTEXTBKCOLOR
1033      This.BkClr := ErrorLevel
1034      SendMessage, 0x1023, 0, 0, , % "ahk_id " . HWND ; LVM_GETTEXTCOLOR
1035      This.TxClr := ErrorLevel
1036      ; Get the header control
1037      SendMessage, 0x101F, 0, 0, , % "ahk_id " . HWND ; LVM_GETHEADER
1038      This.Header := ErrorLevel
1039      ; Set other properties
1040      This.HWND := HWND
1041      This.IsStatic := !!StaticMode
1042      This.AltCols := False
1043      This.AltRows := False
1044      This.NoSort(!!NoSort)
1045      This.NoSizing(!!NoSizing)
1046      This.OnMessage()
1047      This.Critical := "Off"
1048      This.Attached[HWND] := True
1049   }
1050   ; ===================================================================================================================
1051   __Delete() {
1052      This.Attached.Remove(HWND, "")
1053      This.OnMessage(False)
1054      WinSet, Redraw, , % "ahk_id " . This.HWND
1055   }
1056   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1057   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1058   ; PUBLIC METHODS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1059   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1060   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1061   ; ===================================================================================================================
1062   ; Clear()         Clears all row and cell colors.
1063   ; Parameters:     AltRows     -  Reset alternate row coloring (True / False)
1064   ;                                Default: False
1065   ;                 AltCols     -  Reset alternate column coloring (True / False)
1066   ;                                Default: False
1067   ; Return Value:   Always True.
1068   ; ===================================================================================================================
1069   Clear(AltRows := False, AltCols := False) {
1070      If (AltCols)
1071         This.AltCols := False
1072      If (AltRows)
1073         This.AltRows := False
1074      This.Remove("Rows")
1075      This.Remove("Cells")
1076      Return True
1077   }
1078   ; ===================================================================================================================
1079   ; AlternateRows() Sets background and/or text color for even row numbers.
1080   ; Parameters:     BkColor     -  Background color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
1081   ;                                Default: Empty -> default background color
1082   ;                 TxColor     -  Text color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
1083   ;                                Default: Empty -> default text color
1084   ; Return Value:   True on success, otherwise false.
1085   ; ===================================================================================================================
1086   AlternateRows(BkColor := "", TxColor := "") {
1087      If !(This.HWND)
1088         Return False
1089      This.AltRows := False
1090      If (BkColor = "") && (TxColor = "")
1091         Return True
1092      BkBGR := This.BGR(BkColor)
1093      TxBGR := This.BGR(TxColor)
1094      If (BkBGR = "") && (TxBGR = "")
1095         Return False
1096      This["ARB"] := (BkBGR <> "") ? BkBGR : This.BkClr
1097      This["ART"] := (TxBGR <> "") ? TxBGR : This.TxClr
1098      This.AltRows := True
1099      Return True
1100   }
1101   ; ===================================================================================================================
1102   ; AlternateCols() Sets background and/or text color for even column numbers.
1103   ; Parameters:     BkColor     -  Background color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
1104   ;                                Default: Empty -> default background color
1105   ;                 TxColor     -  Text color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
1106   ;                                Default: Empty -> default text color
1107   ; Return Value:   True on success, otherwise false.
1108   ; ===================================================================================================================
1109   AlternateCols(BkColor := "", TxColor := "") {
1110      If !(This.HWND)
1111         Return False
1112      This.AltCols := False
1113      If (BkColor = "") && (TxColor = "")
1114         Return True
1115      BkBGR := This.BGR(BkColor)
1116      TxBGR := This.BGR(TxColor)
1117      If (BkBGR = "") && (TxBGR = "")
1118         Return False
1119      This["ACB"] := (BkBGR <> "") ? BkBGR : This.BkClr
1120      This["ACT"] := (TxBGR <> "") ? TxBGR : This.TxClr
1121      This.AltCols := True
1122      Return True
1123   }
1124   ; ===================================================================================================================
1125   ; SelectionColors() Sets background and/or text color for selected rows.
1126   ; Parameters:     BkColor     -  Background color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
1127   ;                                Default: Empty -> default selected background color
1128   ;                 TxColor     -  Text color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
1129   ;                                Default: Empty -> default selected text color
1130   ; Return Value:   True on success, otherwise false.
1131   ; ===================================================================================================================
1132   SelectionColors(BkColor := "", TxColor := "") {
1133      If !(This.HWND)
1134         Return False
1135      This.SelColors := False
1136      If (BkColor = "") && (TxColor = "")
1137         Return True
1138      BkBGR := This.BGR(BkColor)
1139      TxBGR := This.BGR(TxColor)
1140      If (BkBGR = "") && (TxBGR = "")
1141         Return False
1142      This["SELB"] := BkBGR
1143      This["SELT"] := TxBGR
1144      This.SelColors := True
1145      Return True
1146   }
1147   ; ===================================================================================================================
1148   ; Row()           Sets background and/or text color for the specified row.
1149   ; Parameters:     Row         -  Row number
1150   ;                 Optional ------------------------------------------------------------------------------------------
1151   ;                 BkColor     -  Background color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
1152   ;                                Default: Empty -> default background color
1153   ;                 TxColor     -  Text color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
1154   ;                                Default: Empty -> default text color
1155   ; Return Value:   True on success, otherwise false.
1156   ; ===================================================================================================================
1157   Row(Row, BkColor := "", TxColor := "") {
1158      If !(This.HWND)
1159         Return False
1160      If This.IsStatic
1161         Row := This.MapIndexToID(Row)
1162      This["Rows"].Remove(Row, "")
1163      If (BkColor = "") && (TxColor = "")
1164         Return True
1165      BkBGR := This.BGR(BkColor)
1166      TxBGR := This.BGR(TxColor)
1167      If (BkBGR = "") && (TxBGR = "")
1168         Return False
1169      This["Rows", Row, "B"] := (BkBGR <> "") ? BkBGR : This.BkClr
1170      This["Rows", Row, "T"] := (TxBGR <> "") ? TxBGR : This.TxClr
1171      Return True
1172   }
1173   ; ===================================================================================================================
1174   ; Cell()          Sets background and/or text color for the specified cell.
1175   ; Parameters:     Row         -  Row number
1176   ;                 Col         -  Column number
1177   ;                 Optional ------------------------------------------------------------------------------------------
1178   ;                 BkColor     -  Background color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
1179   ;                                Default: Empty -> row's background color
1180   ;                 TxColor     -  Text color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
1181   ;                                Default: Empty -> row's text color
1182   ; Return Value:   True on success, otherwise false.
1183   ; ===================================================================================================================
1184   Cell(Row, Col, BkColor := "", TxColor := "") {
1185      If !(This.HWND)
1186         Return False
1187      If This.IsStatic
1188         Row := This.MapIndexToID(Row)
1189      This["Cells", Row].Remove(Col, "")
1190      If (BkColor = "") && (TxColor = "")
1191         Return True
1192      BkBGR := This.BGR(BkColor)
1193      TxBGR := This.BGR(TxColor)
1194      If (BkBGR = "") && (TxBGR = "")
1195         Return False
1196      If (BkBGR <> "")
1197         This["Cells", Row, Col, "B"] := BkBGR
1198      If (TxBGR <> "")
1199         This["Cells", Row, Col, "T"] := TxBGR
1200      Return True
1201   }
1202   ; ===================================================================================================================
1203   ; NoSort()        Prevents/allows sorting by click on a header item for this ListView.
1204   ; Parameters:     Apply       -  True/False
1205   ;                                Default: True
1206   ; Return Value:   True on success, otherwise false.
1207   ; ===================================================================================================================
1208   NoSort(Apply := True) {
1209      If !(This.HWND)
1210         Return False
1211      If (Apply)
1212         This.SortColumns := False
1213      Else
1214         This.SortColumns := True
1215      Return True
1216   }
1217   ; ===================================================================================================================
1218   ; NoSizing()      Prevents/allows resizing of columns for this ListView.
1219   ; Parameters:     Apply       -  True/False
1220   ;                                Default: True
1221   ; Return Value:   True on success, otherwise false.
1222   ; ===================================================================================================================
1223   NoSizing(Apply := True) {
1224      Static OSVersion := DllCall("GetVersion", "UChar")
1225      If !(This.Header)
1226         Return False
1227      If (Apply) {
1228         If (OSVersion > 5)
1229            Control, Style, +0x0800, , % "ahk_id " . This.Header ; HDS_NOSIZING = 0x0800
1230         This.ResizeColumns := False
1231      }
1232      Else {
1233         If (OSVersion > 5)
1234            Control, Style, -0x0800, , % "ahk_id " . This.Header ; HDS_NOSIZING
1235         This.ResizeColumns := True
1236      }
1237      Return True
1238   }
1239   ; ===================================================================================================================
1240   ; OnMessage()     Adds/removes a message handler for WM_NOTIFY messages for this ListView.
1241   ; Parameters:     Apply       -  True/False
1242   ;                                Default: True
1243   ; Return Value:   Always True
1244   ; ===================================================================================================================
1245   OnMessage(Apply := True) {
1246      If (Apply) && !This.HasKey("OnMessageFunc") {
1247         This.OnMessageFunc := ObjBindMethod(This, "On_WM_Notify")
1248         OnMessage(0x004E, This.OnMessageFunc) ; add the WM_NOTIFY message handler
1249      }
1250      Else If !(Apply) && This.HasKey("OnMessageFunc") {
1251         OnMessage(0x004E, This.OnMessageFunc, 0) ; remove the WM_NOTIFY message handler
1252         This.OnMessageFunc := ""
1253         This.Remove("OnMessageFunc")
1254      }
1255      WinSet, Redraw, , % "ahk_id " . This.HWND
1256      Return True
1257   }
1258   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1259   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1260   ; PRIVATE PROPERTIES  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1261   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1262   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1263   Static Attached := {}
1264   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1265   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1266   ; PRIVATE METHODS +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1267   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1268   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1269   On_WM_NOTIFY(W, L, M, H) {
1270      ; Notifications: NM_CUSTOMDRAW = -12, LVN_COLUMNCLICK = -108, HDN_BEGINTRACKA = -306, HDN_BEGINTRACKW = -326
1271      Critical, % This.Critical
1272      If ((HCTL := NumGet(L + 0, 0, "UPtr")) = This.HWND) || (HCTL = This.Header) {
1273         Code := NumGet(L + (A_PtrSize * 2), 0, "Int")
1274         If (Code = -12)
1275            Return This.NM_CUSTOMDRAW(This.HWND, L)
1276         If !This.SortColumns && (Code = -108)
1277            Return 0
1278         If !This.ResizeColumns && ((Code = -306) || (Code = -326))
1279            Return True
1280      }
1281   }
1282   ; -------------------------------------------------------------------------------------------------------------------
1283   NM_CUSTOMDRAW(H, L) {
1284      ; Return values: 0x00 (CDRF_DODEFAULT), 0x20 (CDRF_NOTIFYITEMDRAW / CDRF_NOTIFYSUBITEMDRAW)
1285      Static SizeNMHDR := A_PtrSize * 3                  ; Size of NMHDR structure
1286      Static SizeNCD := SizeNMHDR + 16 + (A_PtrSize * 5) ; Size of NMCUSTOMDRAW structure
1287      Static OffItem := SizeNMHDR + 16 + (A_PtrSize * 2) ; Offset of dwItemSpec (NMCUSTOMDRAW)
1288      Static OffItemState := OffItem + A_PtrSize         ; Offset of uItemState  (NMCUSTOMDRAW)
1289      Static OffCT :=  SizeNCD                           ; Offset of clrText (NMLVCUSTOMDRAW)
1290      Static OffCB := OffCT + 4                          ; Offset of clrTextBk (NMLVCUSTOMDRAW)
1291      Static OffSubItem := OffCB + 4                     ; Offset of iSubItem (NMLVCUSTOMDRAW)
1292      ; ----------------------------------------------------------------------------------------------------------------
1293      DrawStage := NumGet(L + SizeNMHDR, 0, "UInt")
1294      , Row := NumGet(L + OffItem, "UPtr") + 1
1295      , Col := NumGet(L + OffSubItem, "Int") + 1
1296      , Item := Row - 1
1297      If This.IsStatic
1298         Row := This.MapIndexToID(Row)
1299      ; CDDS_SUBITEMPREPAINT = 0x030001 --------------------------------------------------------------------------------
1300      If (DrawStage = 0x030001) {
1301         UseAltCol := !(Col & 1) && (This.AltCols)
1302         , ColColors := This["Cells", Row, Col]
1303         , ColB := (ColColors.B <> "") ? ColColors.B : UseAltCol ? This.ACB : This.RowB
1304         , ColT := (ColColors.T <> "") ? ColColors.T : UseAltCol ? This.ACT : This.RowT
1305         , NumPut(ColT, L + OffCT, "UInt"), NumPut(ColB, L + OffCB, "UInt")
1306         Return (!This.AltCols && !This.HasKey(Row) && (Col > This["Cells", Row].MaxIndex())) ? 0x00 : 0x20
1307      }
1308      ; CDDS_ITEMPREPAINT = 0x010001 -----------------------------------------------------------------------------------
1309      If (DrawStage = 0x010001) {
1310         ; LVM_GETITEMSTATE = 0x102C, LVIS_SELECTED = 0x0002
1311         If (This.SelColors) && DllCall("SendMessage", "Ptr", H, "UInt", 0x102C, "Ptr", Item, "Ptr", 0x0002, "UInt") {
1312            ; Remove the CDIS_SELECTED (0x0001) and CDIS_FOCUS (0x0010) states from uItemState and set the colors.
1313            NumPut(NumGet(L + OffItemState, "UInt") & ~0x0011, L + OffItemState, "UInt")
1314            If (This.SELB <> "")
1315               NumPut(This.SELB, L + OffCB, "UInt")
1316            If (This.SELT <> "")
1317               NumPut(This.SELT, L + OffCT, "UInt")
1318            Return 0x02 ; CDRF_NEWFONT
1319         }
1320         UseAltRow := (Item & 1) && (This.AltRows)
1321         , RowColors := This["Rows", Row]
1322         , This.RowB := RowColors ? RowColors.B : UseAltRow ? This.ARB : This.BkClr
1323         , This.RowT := RowColors ? RowColors.T : UseAltRow ? This.ART : This.TxClr
1324         If (This.AltCols || This["Cells"].HasKey(Row))
1325            Return 0x20
1326         NumPut(This.RowT, L + OffCT, "UInt"), NumPut(This.RowB, L + OffCB, "UInt")
1327         Return 0x00
1328      }
1329      ; CDDS_PREPAINT = 0x000001 ---------------------------------------------------------------------------------------
1330      Return (DrawStage = 0x000001) ? 0x20 : 0x00
1331   }
1332   ; -------------------------------------------------------------------------------------------------------------------
1333   MapIndexToID(Row) { ; provides the unique internal ID of the given row number
1334      SendMessage, 0x10B4, % (Row - 1), 0, , % "ahk_id " . This.HWND ; LVM_MAPINDEXTOID
1335      Return ErrorLevel
1336   }
1337   ; -------------------------------------------------------------------------------------------------------------------
1338   BGR(Color, Default := "") { ; converts colors to BGR
1339      Static Integer := "Integer" ; v2
1340      ; HTML Colors (BGR)
1341      Static HTML := {AQUA: 0x00FFFF, BLACK: 0x000000, RED: 0xFF0000, FUCHSIA: 0xFF00FF, GRAY: 0x808080, GREEN: 0x008000
1342                    , LIME: 0x00FF00, MAROON: 0x800000, NAVY: 0x000080, OLIVE: 0x808000, PURPLE: 0x800080, BLUE: 0x0000FF
1343                    , SILVER: 0xC0C0C0, TEAL: 0x008080, WHITE: 0xFFFFFF, YELLOW: 0xFFFF00}
1344      If Color Is Integer
1345         Return ((Color >> 16) & 0xFF) | (Color & 0x00FF00) | ((Color & 0xFF) << 16)
1346      Return (HTML.HasKey(Color) ? HTML[Color] : Default)
1347   }
1348}
1349
1350esc::
1351exitapp
1352
1353filtrodata:
1354   if (filtrodata = 1)
1355      {
1356      filtrodata := 0
1357      Menu,tray , Uncheck,filtro data
1358      }
1359   else   
1360       if (filtrodata = 0)
1361            {
1362            filtrodata := 1
1363            Menu,tray , check,filtro data
1364            }
1365return
1366
1367eliminazioneautomatica:
1368   if (eliminazioneautomatica = 1)
1369      {
1370      eliminazioneautomatica := 0
1371      Menu,tray , Uncheck,eliminazione automatica
1372      }
1373   else   
1374      if (eliminazioneautomatica = 0)
1375      {
1376      eliminazioneautomatica := 1
1377      Menu,tray , check,eliminazione automatica
1378      }
1379return
1380
1381
1382
1383chiusurapcaltermine:
1384   if (chiusurapcaltermine = 1)
1385      {
1386      chiusurapcaltermine := 0
1387      Menu,tray , Uncheck,chiusura al termine  
1388      }
1389   else   
1390      if (chiusurapcaltermine = 0)
1391      {
1392      chiusurapcaltermine := 1
1393      Menu,tray , check,chiusura al termine
1394      }
1395 
1396      
1397return