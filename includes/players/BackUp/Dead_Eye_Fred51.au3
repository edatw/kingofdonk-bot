;=================================================================
; Short Stack
;=================================================================
;#include <Array.au3>
#include <String.au3>
#include-once
Global $iMinBlind = Int(IniRead(@ScriptDir & "\settings.ini", "Table", "table_min_blind", 1))
Global $iMaxBlind = Int(IniRead(@ScriptDir & "\settings.ini", "Table", "table_max_blind", 2000000))
Global $iMinPlayers = Int(IniRead(@ScriptDir & "\settings.ini", "Table", "table_min_players", 6))
Global $xamount = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "call", "callamount", "Doh")
Global $xamountriver = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "call", "rivercallamount", "Doh")
Global $ramount = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "raise", "raiseamount", "Doh")
Global $rramount = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "raise", "riverraiseamount", "Doh")
Global $iBank = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "ForceBank", "hands", "Doh")
Global $iLobby = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "ForceNewRoom", "hands", "Doh")
Global $iSuit_raise = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Suited_score_adjust", "raise", "Doh")
Global $iSuit_any = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Suited_score_adjust", "call_any", "Doh")
Global $iSuit_upto = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Suited_score_adjust", "call_upto", "Doh")
Global $iSuit_once = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Suited_score_adjust", "call_once", "Doh")
Global $iHand_raise = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Preflop_score_adjust", "raise", "Doh")
Global $iHand_any = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Preflop_score_adjust", "call_any", "Doh")
Global $iHand_upto = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Preflop_score_adjust", "call_upto", "Doh")
Global $iHand_once = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Preflop_score_adjust", "call_once", "Doh")
Global $sRounds = 0
Global $sBank = 0
Global $xBank = 0
Global $sLobby = 0 ;force new room
Global $iWin = 0
Global $iBlind = 0
Global $bRaised = False
Global $bChecked = False
Global $bCalled = False
Global $bGoAllIn = False
Global $cRaised = False
Global $cChecked = False
Global $cCalled = False
Global $cGoAllIn = False
Global $bForceBank = False
Global $iStuck = 0
Global $iCashChange = False
Global $xCalled = False
Global $yCalled = False
Global $sReraise = False
Global $aLobby = 0
Global $zScore = 0
Global $camount = 0
Global $samount = 0 
Global $damount = 0 
Global $amount = 0 
Global $iamount = 0 
Global $iScore = 0
Global $gScore = 0
Global $iLoop = 0
Global $tHands = 0




Func Dead_Eye_Fred()
	If $iBlind == 0 Then
		$iBlind = _Blind()
	EndIf
	$iSeat = _Seat()
	$sHand = _Cards($iSeat)
	$sStreet = _Street($sHand)
	_HandHistory($sHand)

	If $sStreet == 'NOGAME' Or $bForceBank Then
		If $bForceBank Then
			_Log('OK - forcebank')
		EndIf
		_Log('OK - nogame')
		$iStuck = $iStuck + 1
		Dead_Eye_Fred_NOGAME($iSeat, $sHand)
		$bForceBank = False
	ElseIf $sStreet == 'PREFLOP' Then
		_Log('OK - preflop')
		$iStuck = 0
		Dead_Eye_Fred_PREFLOP($iSeat, $sHand)
	Else
		_Log('OK - game')
		Dead_Eye_Fred_GAME($iSeat, $sHand)
	EndIf
EndFunc   ;==>Dead_Eye_Fred

Func Dead_Eye_Fred_NOGAME($iSeat, $sHand)
	$sStreet = _Street($sHand)
	$iButton = _Button()
	$iPosition = _ButtonSeat($iSeat) + 1
	$iOpponents = _OpponentCount()
	$aActionCount = _ActionCount()
	$sBank = $iBank - $xBank
	$sDebug = 'Hand: ' & $sHand & @CRLF & 'Blind: ' & $iBlind & @CRLF & 'Total Hands Played: ' & $tHands & @CRLF & 'Hands Played in Room: ' & $sRounds & @CRLF & 'Til New Room: ' & $sLobby & @CRLF & 'Til Bank: ' & $sBank & @CRLF & 'Banking: ' & $iCashChange & @CRLF & 'Players: ' & $iOpponents & @CRLF & _ActionString($aActionCount)
	$samount = 0 
	_Log('OK - $iSeat = ' & $iSeat)
	_Log('OK - $sHand = ' & $sHand)
	_Log('OK - $iBlind = ' & $iBlind)
	_Log('OK - $iButton = ' & $iButton)
	_Log('OK - $iPosition = ' & $iPosition)
	_Log('OK - $iOpponents = ' & $iOpponents)
	_Log('OK - $aActionCount = ' & _ActionString($aActionCount))
	
	If $iWin >= 1 Then
		$sRounds = $sRounds + 1
		$xBank = $xBank + 1
		$tHands = $tHands + 1
		$iWin = 0
	EndIf
	
	If $sBank <= 0 Then
		$iCashChange = True
		$sBank = $iBank
	EndIf
	
	If $iBlind == 0 Then
		$iBlind = _Blind()
	EndIf
	; if no forced bank, check for a pause
	If Not $bForceBank And Not $iCashChange Then
		; wait after a winner is detected
		If $aActionCount[5] Then
			_Log('OK - waiting because someone won')
			_ToolTip('someone won', 'Waiting')
			Sleep(1000)
			;_ScreenCapture('winner')
			$iNoGameReason = 'someone won'
			$iNoGameCount = 5
			Return
		EndIf
	EndIf
	
	If $iNoGameCount <= 0 And Not $aActionCount[5] Then
		$sLobby = $iLobby - $sRounds
		If $sLobby <= 0 Then ; force new room
			_ToolTip('Forcing New Room', 'Room Change')
			$sRounds = 0
			_TableStand()
			_Lobby()
			Return
		EndIf
		If $aLobby > 15 Then
			_PopupClose()
			_ToolTip('No empty seat found 15 times, joining new room.','Warning')
			_TableStand()
			_Lobby()
			$aLobby = 0
			Return
		EndIf
		; check blind size
		If $iBlind == 0 Then
			_Log('WARNING - blinds could not be read')
			_ToolTip('blinds could not be read', 'Bad Room')
			_TableStand()
			_Lobby()
			Return
		EndIf

		If $iBlind < $iMinBlind Then
			_Log('WARNING - blinds too small (' & $iBlind & ')')
			_ToolTip('blinds too small (' & $iBlind & '), going to lobby', 'Bad Room')
			_TableStand()
			_Lobby()
			Return
		EndIf

		If $iBlind > $iMaxBlind Then
			_Log('WARNING - blinds too high (' & $iBlind & ')')
			_ToolTip('blinds too high, going to lobby', 'Bad Room')			
			_TableStand()
			_Lobby()
			Return
		EndIf

		; check number of players
		If (9 - _SeatCountEmpty() < $iMinPlayers) Then
			_Log('WARNING - not enough players')
			_ToolTip('not enough players, going to lobby', 'Bad Room')
			$sRounds = 0
			_TableStand()
			_Lobby()
			Return
		EndIf

		; bank if needed
		If $iCashChange And Not $aActionCount[5] And $sStreet == 'NOGAME' Then
			_Log('OK - banking')
			_ToolTip('Needed to bank', 'Banking')
			_TableBank()
			$xBank = 0
			Return
		EndIf
		_PlayTurnCheck()
		_Chat()
		_ToolTip($sDebug, 'No Game')

	; decrement the wait timer
	ElseIf $iNoGameCount > 0 Then
		_Log('OK - paused ' & $iNoGameCount)
		$iNoGameCount = $iNoGameCount - 1
		Sleep(1000)
		_ToolTip($iNoGameReason & @CRLF & 'paused ' & $iNoGameCount, 'Waiting')
	EndIf
EndFunc   ;==>Dead_Eye_Fred_NOGAME

Func Dead_Eye_Fred_PREFLOP($iSeat, $sHand)
	$aLobby = 0
	$aCards = _CardNumbersArray($sHand)
	$aSuits = _CardSuitsArray($sHand)
	$iOpponents = _OpponentCount()
	$iNoGameCount = 1
	$iNoGameReason = 'Fold on Preflop'
	$iButton = _Button()
	$iPosition = _ButtonSeat($iSeat) + 1
	$aActionCount = _ActionCount()
	$camount = $xamount * $iBlind
	$sDebug = 'Hand: ' & $sHand & @CRLF & 'Call Amt: ' & $camount & @CRLF & 'Called Amt: ' & $samount & @CRLF & 'Total Hands Played: ' & $tHands & @CRLF & 'Hands Played in Room: ' & $sRounds & @CRLF & 'Til New Room: ' & $sLobby & @CRLF & 'Til Bank: ' & $sBank & @CRLF & 'Banking: ' & $iCashChange & @CRLF & 'Players: ' & $iOpponents & @CRLF & _ActionString($aActionCount)
	$sholes = String($aCards[0] & $aCards[1])
	$sholes2 = String($aCards[1] & $aCards[0])
	$sAll_in = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Preflop_Hands", "all_in", "Doh")
	$sRaise = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Preflop_Hands", "raise", "Doh")
	$sCall = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Preflop_Hands", "call_any", "Doh")
	$sCallo = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Preflop_Hands", "call_once", "Doh")
	$sCheck = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Preflop_Hands", "call_upto", "Doh")
	$dAll_in = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Suited_Hands", "all_in", "Doh")
	$dRaise = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Suited_Hands", "raise", "Doh")
	$dCall = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Suited_Hands", "call_any", "Doh")
	$dCallo = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Suited_Hands", "call_once", "Doh")
	$dCheck = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "Suited_Hands", "call_upto", "Doh")
	$aAll_in = StringSplit($sAll_in, " ", 2)
	$aRaise = StringSplit($sRaise, " ", 2)
	$aCall = StringSplit($sCall, " ", 2)
	$aCallo = StringSplit($sCallo, " ", 2)
	$aCheck = StringSplit($sCheck, " ", 2)
	$fAll_in = StringSplit($dAll_in, " ", 2)
	$fRaise = StringSplit($dRaise, " ", 2)
	$fCall = StringSplit($dCall, " ", 2)
	$fCallo = StringSplit($dCallo, " ", 2)
	$fCheck = StringSplit($dCheck, " ", 2)
	_Log('OK - $iSeat = ' & $iSeat)
	_Log('OK - $sHand = ' & $sHand)
	_Log('OK - $iBlind = ' & $iBlind)
	_Log('OK - $iButton = ' & $iButton)
	_Log('OK - $iPosition = ' & $iPosition)
	_Log('OK - $iOpponents = ' & $iOpponents)
	_Log('OK - $aActionCount = ' & _ActionString($aActionCount))

	; reset decisions
	$bChecked = False
	$bCalled = False
	$bCalledo = False
	$bRaised = False
	$bGoAllIn = False
	$cChecked = False
	$cCalled = False
	$cCalledo = False
	$cRaised = False
	$cGoAllIn = False
	$damount = 0 
	
	
	
			; suited
	If ($aSuits[0] == $aSuits[1]) Then
		For $i = 0 To UBound($fAll_in) - 1
			If $sholes = $fAll_in[$i] Or $sholes2 = $fAll_in[$i] Then
				_Log('OK - ' & $sholes)
				$cGoAllIn = True
				$zScore = 0
			EndIf
		Next

		For $i = 0 To UBound($fRaise) - 1
			If $sholes = $fRaise[$i] Or $sholes2 = $fRaise[$i] Then
				_Log('OK - ' & $sholes)
				$cRaised = True
				$zScore = $iSuit_raise
			EndIf
		Next

		For $i = 0 To UBound($fCall) - 1
			If $sholes = $fCall[$i] Or $sholes2 = $fCall[$i] Then ;call_any
				_Log('OK - ' & $sholes)
				$cCalled = True
				$zScore = $iSuit_any
			EndIf
		Next
		
		For $i = 0 To UBound($fCallo) - 1
			If $sholes = $fCallo[$i] Or $sholes2 = $fCallo[$i] Then ;call_once
				_Log('OK - ' & $sholes)
				$cCalledo = True
				$zScore = $iSuit_once
			EndIf
		Next
	
		For $i = 0 To UBound($fCheck) - 1
			If $sholes = $fCheck[$i] Or $sholes2 = $fCheck[$i] Then ;call_upto
				_Log('OK - ' & $sholes)
				$cChecked = True
				$zScore = $iSuit_upto
			EndIf
		Next
		
	ElseIf Not ($aSuits[0] == $aSuits[1]) Then
		For $i = 0 To UBound($aAll_in) - 1
			If $sholes = $aAll_in[$i] Or $sholes2 = $aAll_in[$i] Then
				_Log('OK - ' & $sholes)
				$bGoAllIn = True
				$zScore = 0
			EndIf
		Next

		For $i = 0 To UBound($aRaise) - 1
			If $sholes = $aRaise[$i] Or $sholes2 = $aRaise[$i] Then
				_Log('OK - ' & $sholes)
				$bRaised = True
				$zScore = $iHand_raise
			EndIf
		Next

		For $i = 0 To UBound($aCall) - 1
			If $sholes = $aCall[$i] Or $sholes2 = $aCall[$i] Then ;call_any
				_Log('OK - ' & $sholes)
				$bCalled = True
				$zScore = $iHand_any
			EndIf
		Next
		
		For $i = 0 To UBound($aCallo) - 1
			If $sholes = $aCallo[$i] Or $sholes2 = $aCallo[$i] Then ;call_once
				_Log('OK - ' & $sholes)
				$bCalledo = True
				$zScore = $iHand_once
			EndIf
		Next
	
		For $i = 0 To UBound($aCheck) - 1
			If $sholes = $aCheck[$i] Or $sholes2 = $aCheck[$i] Then ;call_upto
				_Log('OK - ' & $sholes)
				$bChecked = True
				$zScore = $iHand_upto
			EndIf
		Next
	Else 
		$zScore = 0
	EndIf
	; decide how much to raise
	;
	If $aActionCount[1] Or $bGoAllIn Or $cGoAllIn Then ; someone raised or we have a sweet hand
		; lets go all in
		$iRaise = $iBlind * 100
		$iWin = $iWin + 1
	ElseIf $sReraise Then
		$iRaise = $iBlind * 100
		$sReraise = False
	Else
		$iRaise = $iBlind * $ramount
		$iWin = $iWin + 1
	EndIf

	;
	; lets do it !
	
	If $bCalledo And $aActionCount[0] =0 And $aActionCount[1] =0 Or $cCalledo And $aActionCount[0] =0 And $aActionCount[1] =0 Then
		If $cCalledo Then
			_Log('OK - Suited - Call_Once')
			_ToolTip($sDebug, 'Suited - Call_Once')
			_PlayTurnCall( 'any') ;changed
		Else
			_Log('OK - Call_Once')
			_ToolTip($sDebug, 'Call_Once')
			_PlayTurnCall( 'any') ;changed
		EndIf
		
	ElseIf $bChecked Or $cChecked Then
		If $cChecked Then
			_Log('OK - Suited - Call_UpTo')
			_ToolTip($sDebug, 'Suited - Call_UpTo')
			_PlayFredTurnCall($camount)
		Else
			_Log('OK - Call_UpTo')
			_ToolTip($sDebug, 'Call_UpTo')
			_PlayFredTurnCall($camount)
		EndIf
		
		
	ElseIf $bRaised Or $bGoAllIn Or $cRaised Or $cGoAllIn Then
		If $cRaised And Not $aActionCount[1] And Not $aActionCount[0] Then
			$iCashChange = True
			_Log('OK - Suited - Raise')
			_ToolTip($sDebug, 'Suited - Raise')
			_PlayTurnRaise($iRaise, 'any')
		ElseIf $bRaised And Not $aActionCount[1] And Not $aActionCount[0] Then
			$iCashChange = True
			_Log('OK - Raise')
			_ToolTip($sDebug, 'Raise')
			_PlayTurnRaise($iRaise, 'any')
		ElseIf $cGoAllIn Then
			$iCashChange = True
			_Log('OK - Suited - All In')
			_ToolTip($sDebug, 'All In')
			_PlayTurnRaise($iRaise, 'any')
		ElseIf $bGoAllIn Then
			$iCashChange = True
			_Log('OK - All In')
			_ToolTip($sDebug, 'All In')
			_PlayTurnRaise($iRaise, 'any')
		Else 
			$iCashChange = True
			_Log('OK - Raised - Calling Any')
			_ToolTip($sDebug, 'Raised - Calling Any')
			_PlayTurnCall( 'any')
		EndIf
		
		
	ElseIf $bCalled Or $cCalled Then
		If $cCalled Then
			_Log('OK - Suited - Call_Any')
			_ToolTip($sDebug, 'Suited - Call_Any')
			_PlayTurnCall( 'any') ;changed
		Else
			_Log('OK - Call_Any')
			_ToolTip($sDebug, 'Call_Any')
			_PlayTurnCall( 'any') ;changed
		EndIf
		
	Else
		_Log('OK - Check/Fold')
		_ToolTip($sDebug, 'Check/Fold')
		_PlayTurnCheck()
	EndIf

EndFunc   ;==>Dead_Eye_Fred_PREFLOP

Func Dead_Eye_Fred_GAME($iSeat, $sHand)
	$aLobby = 0
	$samount = 0 
	$camount = $xamountriver * $iBlind
	$sAction = IniReadSection(@ScriptDir & "\Dead_Eye_Fred.ini", "FlopScore")
	Local $aAction[UBound($sAction) - 1][3]
	$iNoGameReason = 'Just played a hand'
	$iOpponents = _OpponentCount()
	$iNoGameCount = 30
	$iPosition = _ButtonSeat($iSeat) + 1
	$iButton = _Button()
	$aActionCount = _ActionCount()
	$iScore = _SimHandMulti($sHand, $iOpponents - 1) + ($zScore)
	If $iScore > 1.0 Then 
		$iScore = 1.0
	EndIf
	$sDebug = 'Hand: ' & $sHand & @CRLF & 'Score Adjustment: ' & $zScore & @CRLF &'Score: ' & $iScore & @CRLF & 'River Call Amt: ' & $camount & @CRLF & 'Called Amt: ' & $damount & @CRLF & 'Players: ' & $iOpponents & @CRLF & _ActionString($aActionCount)

	_Log('OK - $iSeat = ' & $iSeat)
	_Log('OK - $sHand = ' & $sHand)
	_Log('OK - $iBlind = ' & $iBlind)
	_Log('OK - $iButton = ' & $iButton)
	_Log('OK - $iPosition = ' & $iPosition)
	_Log('OK - $iOpponents = ' & $iOpponents)
	_Log('OK - $aActionCount = ' & _ActionString($aActionCount))
	_Log('OK - $iScore = ' & $iScore)

	For $i = 1 To $sAction[0][0]
		$aTemp = StringSplit($sAction[$i][0], "-", 2)
		$aAction[$i - 1][0] = $aTemp[0]
		$aAction[$i - 1][1] = $aTemp[1]
		$aAction[$i - 1][2] = $sAction[$i][1]
	Next
	For $i = 0 To UBound($aAction) - 1
		If $iScore >= $aAction[$i][0] And $iScore <= $aAction[$i][1] Then
			$gScore = $aAction[$i][2]
		EndIf
	Next
	
	If $gScore = "all_in" Then
		$iCashChange = True
		_Log('OK - All In')
		_ToolTip($sDebug, 'All In')
		_PlayTurnRaise($iBlind * 1000, 'any')
	ElseIf $gScore = "raise" Then
		$iCashChange = True
		_Log('OK - Raise')
		_ToolTip($sDebug, 'Raise')
		_PlayTurnRaise($iBlind * $rramount, 'any')
	ElseIf $gScore = "call_upto" Then
		_Log('OK - Call_UpTo')
		_ToolTip($sDebug, 'Call_UpTo')
		_PlayFredTurnCall2($camount)
	ElseIf $gScore = "call" Then
		_Log('OK - Call')
		_ToolTip($sDebug, 'Call')
		_PlayTurnCall( 'any')
	Else
		_Log('OK - Check/Fold')
		_ToolTip($sDebug, 'Check/Fold')
		_PlayTurnCheck()
	EndIf
	
EndFunc  ;==>Dead_Eye_Fred_GAME
