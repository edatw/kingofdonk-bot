;=================================================================
; Short Stack
;=================================================================
;#include <Array.au3>
#include <String.au3>
#include-once
Global $iMinBlind = Int(IniRead(@ScriptDir & "\settings.ini", "Table", "table_min_blind", 1))
Global $iMaxBlind = Int(IniRead(@ScriptDir & "\settings.ini", "Table", "table_max_blind", 2000000))
Global $iMinPlayers = Int(IniRead(@ScriptDir & "\settings.ini", "Table", "table_min_players", 6))
Global $xamount = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "call", "preflopcallamount", "Doh")
Global $xamountriver = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "call", "flopcallamount", "Doh")
Global $yamountriver = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "call", "turncallamount", "Doh")
Global $zamountriver = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "call", "rivercallamount", "Doh")
Global $ramount = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "raise", "preflopraiseamount", "Doh")
Global $framount = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "raise", "flopraiseamount", "Doh")
Global $tramount = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "raise", "turnraiseamount", "Doh")
Global $rramount = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "raise", "riverraiseamount", "Doh")
Global $iBank = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "ForceBank", "hands", "Doh")
Global $all_in_Bank = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "ForceBank", "all_ins", "Doh")
Global $raises_Bank = IniRead(@ScriptDir & "\Dead_Eye_Fred.ini", "ForceBank", "raises", "Doh")
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
Global $Banked = False ;Fixed banking on joining room
Global $bank_allin_count = 0
Global $bank_raise_count = 0
Global $inBank = 0
Global $raBank = 0
Global $xBank = 0
Global $yBank = 0
Global $zBank = 0
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
Global $xScore = 0
Global $camount = 0
Global $samount = 0 
Global $damount = 0 
Global $eamount = 0 
Global $famount = 0 
Global $amount = 0 
Global $iamount = 0 
Global $iScore = 0
Global $gScore = 0
Global $iLoop = 0
Global $tHands = 0
Global $aAllIns = 0 ;for toolbar allins
Global $bAllIns = 0 ;for toolbar allins
Global $cAllIns = False ;for toolbar allins
Global $bWins = 0 ;for toolbar wins
Global $cWon = False
Global $pWon = 0 ;% won
Global $bLose = 0 ;for toolbar loses
Global $aRaises = 0 
Global $bRaises = 0 
Global $aCall_anys = 0 
Global $bCall_anys = 0 
Global $aCall_onces = 0 
Global $bCall_onces = 0 
Global $aCall_uptos = 0 
Global $bCall_uptos = 0 
Global $aFolds = 0 
Global $bFolds = 0 
Global $samount_call = False



Func Dead_Eye_Fred()
	If $iBlind == 0 Then
		$iBlind = _Blind()
	EndIf
	$iSeat = _Seat()
	$sHand = _Cards($iSeat)
	$sStreet = _Street($sHand)
	_HandHistory($sHand)
	If $bForceBank Then ;Fixed banking on joining room
		;_Log('OK - forcebank')
		$bForceBank = False
		;$iCashChange = False
		$Banked = False
	ElseIf $sStreet == 'NOGAME' Then
		_Log('OK - nogame')
		$iStuck = $iStuck + 1
		Dead_Eye_Fred_NOGAME($iSeat, $sHand)
		;If $sStreet == 'NOGAME' Or $bForceBank Then
	ElseIf $sStreet == 'PREFLOP' Then
		_Log('OK - preflop')
		$iStuck = 0
		Dead_Eye_Fred_PREFLOP($iSeat, $sHand)
	ElseIf $sStreet == 'FLOP' Then
		_Log('OK - flop')
		$iStuck = 0
		Dead_Eye_Fred_FLOP($iSeat, $sHand)
	ElseIf $sStreet == 'TURN' Then
		_Log('OK - turn')
		$iStuck = 0
		Dead_Eye_Fred_TURN($iSeat, $sHand)
	ElseIf $sStreet == 'RIVER' Then 
		_Log('OK - river')
		$iStuck = 0
		Dead_Eye_Fred_RIVER($iSeat, $sHand)
	EndIf
EndFunc   ;==>Dead_Eye_Fred

Func Dead_Eye_Fred_NOGAME($iSeat, $sHand)
	$iSeat = _Seat()
	$sHand = _Cards($iSeat)
	$sStreet = _Street($sHand)
	$iButton = _Button()
	$iPosition = _ButtonSeat($iSeat) + 1
	$iOpponents = _OpponentCount()
	$aActionCount = _ActionCount()
	$sStreet = _Street($sHand)
	$sBank = $iBank - $xBank
	$inBank = $all_in_Bank - $yBank
	$raBank = $raises_Bank - $zBank
	$sDebug = 'Hand: ' & $sHand & @CRLF & 'Preflop Calling - All Ins: ' & $bAllIns & ' (W: ' & $bWins & ' L: ' & $bLose & ')'& @CRLF & 'Raise: ' & $bRaises & ' Any: ' & $bCall_anys & ' Once: ' & $bCall_onces & ' UpTo: ' & $bCall_uptos & ' Fold: ' & $bFolds & @CRLF & 'Total Hands Played: ' & $tHands & @CRLF & 'Room Hands: ' & $sRounds & ' Til New Room: ' & $sLobby & @CRLF & 'Til Bank - Hands: ' & $sBank & ' All ins: ' & $inBank & ' Raises: ' & $raBank & @CRLF & 'Position: ' & $iPosition & @CRLF & 'Players: ' & $iOpponents
	;$sDebug = 'Hand: ' & $sHand & @CRLF & 'Blind: ' & $iBlind & @CRLF & 'Total Hands Played: ' & $tHands & @CRLF & 'Hands Played in Room: ' & $sRounds & @CRLF & 'Til New Room: ' & $sLobby & @CRLF & 'Til Bank: ' & $sBank & @CRLF & 'Banking: ' & $iCashChange & @CRLF & 'All Ins: ' & $bAllIns & @CRLF & 'All In Wins: ' & $bWins & @CRLF & 'All In Lose: ' & $bLose 
	$samount = 0 
	$zScore = 0
	$iScore = 0
	$gScore = 0
	;_Log('OK - $iSeat = ' & $iSeat)
	_Log('OK (no game) - $sHand = ' & $sHand)
	;_Log('OK - $iBlind = ' & $iBlind)
	;_Log('OK - $iButton = ' & $iButton)
	;_Log('OK - $iPosition = ' & $iPosition)
	;_Log('OK - $iOpponents = ' & $iOpponents)
	_Log('OK (no game) - $aActionCount = ' & _ActionString($aActionCount))
	_Log('OK (no game) - $iScore = ' & $iScore)
	_Log('OK (no game) - $gScore = ' & $gScore)
	If $sStreet == 'PREFLOP' Then
		_Log('OK - preflop')
		$iStuck = 0
		Dead_Eye_Fred_PREFLOP($iSeat, $sHand)
	EndIf
	
	If $iBlind == 0 Then
		$iBlind = _Blind()
	EndIf
	
	If $sRounds = 0 And Not $Banked Then ;Fixed banking on joining room
		$iCashChange = True 
		$Banked = True
	EndIf
	
	If $aActionCount[5] Then
		$iNoGameCount = 10
		$zScore = 0
		$iScore = 0
		$gScore = 0
		$samount = 0 
		;$iNoGameCount = $iNoGameCount - 1
		$iNoGameReason = 'someone won'
		_Log('OK - waiting because someone won')
		_ToolTip('someone won', 'Waiting')
		; check number of players
		If (9 - _SeatCountEmpty()) < $iMinPlayers Then
			_Log('WARNING - not enough players')
			_ToolTip('not enough players, going to lobby', 'Bad Room')
			$sRounds = 0
			_TableStand()
			_Lobby()
			Return
		EndIf
		If $aAllIns >= 1 Then ; for tooltip allin amount
			$bAllIns = $bAllIns + 1 ;keeps all in count
			$cWon = True ;for _Tablebuyin
			$cAllIns = True
			$aAllIns = 0
		ElseIf $aRaises >= 1 Then
			$bRaises = $bRaises + 1
			$aRaises = 0
		ElseIf $aCall_anys >= 1 Then
			$bCall_anys = $bCall_anys + 1
			$aCall_anys = 0
		ElseIf $aCall_onces >= 1 Then
			$bCall_onces = $bCall_onces + 1
			$aCall_onces = 0
			$aFolds = 0
		ElseIf $aCall_uptos >= 1 Then
			$bCall_uptos = $bCall_uptos + 1
			$aCall_uptos = 0
			$aFolds = 0
		ElseIf $aFolds >= 1 Then
			$bFolds = $bFolds + 1
			$aFolds = 0 
		EndIf
		If $iWin >= 1 Then
			$sRounds = $sRounds + 1 ;hands played in room
			$xBank = $xBank + 1 ; for force bank hands
			$tHands = $tHands + 1 ; total hands played
			$iWin = 0
		EndIf
		If $bank_allin_count >= 1 Then ; for forcin bank counts
			$yBank = $yBank + 1
			$bank_allin_count = 0
			$bank_raise_count = 0
		ElseIf $bank_raise_count >= 1 Then ; for forcin bank counts
			$zBank = $zBank + 1
			$bank_raise_count = 0
		EndIf
		If $sBank <= 0 Then
			$iCashChange = True
		EndIf
		If $inBank <= 0 Then
			$iCashChange = True 
		EndIf
		If $raBank <= 0 Then
			$iCashChange = True 
		EndIf
		Sleep(100)
		;_ScreenCapture('winner')
		Return
	EndIf
	
	If $iNoGameCount <= 0 And Not $aActionCount[5] Then
		$sLobby = $iLobby - $sRounds
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
			_ToolTip('blinds too high (' & $iBlind & '), going to lobby', 'Bad Room')		
			_TableStand()
			_Lobby()
			Return
		EndIf
		; check number of players
		If (9 - _SeatCountEmpty()) < $iMinPlayers Then
			_Log('WARNING - not enough players')
			_ToolTip('not enough players, going to lobby', 'Bad Room')
			$sRounds = 0
			_TableStand()
			_Lobby()
			Return
		EndIf
		; bank if needed
		If $iCashChange And Not $aActionCount[5] Then
			_Log('OK - banking')
			_ToolTip('Needed to bank', 'Banking')
			_TableBank()
			$xBank = 0
			$yBank = 0
			$zBank = 0
			Return
		EndIf
		If $sLobby <= 0 Then ; force new room
			_ToolTip('Forcing New Room', 'Room Change')
			$sRounds = 0
			_TableStand()
			_Lobby()
			Return
		EndIf
		If $aLobby > 20 Then
			_ToolTip('No empty seat found 20 times, joining new room.','Warning')
			_TableStand()
			_Lobby()
			_PopupClose()
			$aLobby = 0
			Return
		EndIf
		_Chat()
		_ToolTip($sDebug, 'No Game')


	; decrement the wait timer
	ElseIf $iNoGameCount > 0 Then
		_Log('OK - paused ' & $iNoGameCount)
		$iNoGameCount = $iNoGameCount - 1
		If $aAllIns >= 1 Then ; for tooltip allin amount
			$bAllIns = $bAllIns + 1 ;keeps all in count
			$cWon = True ;for _Tablebuyin
			$cAllIns = True
			$aAllIns = 0
		ElseIf $aRaises >= 1 Then
			$bRaises = $bRaises + 1
			$aRaises = 0
		ElseIf $aCall_anys >= 1 Then
			$bCall_anys = $bCall_anys + 1
			$aCall_anys = 0
		ElseIf $aCall_onces >= 1 Then
			$bCall_onces = $bCall_onces + 1
			$aCall_onces = 0
			$aFolds = 0
		ElseIf $aCall_uptos >= 1 Then
			$bCall_uptos = $bCall_uptos + 1
			$aCall_uptos = 0
			$aFolds = 0
		ElseIf $aFolds >= 1 Then
			$bFolds = $bFolds + 1
			$aFolds = 0 
		EndIf
		If $iWin >= 1 Then
			$sRounds = $sRounds + 1
			$xBank = $xBank + 1
			$tHands = $tHands + 1
			$iWin = 0
		EndIf
		If $bank_allin_count >= 1 Then ; for forcin bank counts
			$yBank = $yBank + 1
			$bank_allin_count = 0
			$bank_raise_count = 0
		ElseIf $bank_raise_count >= 1 Then ; for forcin bank counts
			$zBank = $zBank + 1
			$bank_raise_count = 0
		EndIf
		$samount_call = False
		Sleep(500)
		_ToolTip($iNoGameReason & @CRLF & 'paused ' & $iNoGameCount, 'Waiting')
	EndIf
EndFunc   ;==>Dead_Eye_Fred_NOGAME

Func Dead_Eye_Fred_PREFLOP($iSeat, $sHand)
	$aLobby = 0
	$zScore = 0
	$xScore = 0
	$iScore = 0
	$gScore = 0
	$aCards = _CardNumbersArray($sHand)
	$aSuits = _CardSuitsArray($sHand)
	$iOpponents = _OpponentCount()
	$iNoGameCount = 1
	$iNoGameReason = 'Fold on Preflop'
	$iButton = _Button()
	$iPosition = _ButtonSeat($iSeat) + 1
	$aActionCount = _ActionCount()
	$iSeat = _Seat()
	$sHand = _Cards($iSeat)
	$sStreet = _Street($sHand)
	$camount = $xamount * $iBlind
	$sDebug = 'Hand: ' & $sHand & @CRLF & 'Call Amt: ' & $camount & @CRLF & 'Called Amt: ' & $samount & @CRLF & 'Banking: ' & $iCashChange & @CRLF & _ActionString($aActionCount)
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
	;_Log('OK - $iSeat = ' & $iSeat)
	_Log('OK (preflop) - $sHand = ' & $sHand)
	;_Log('OK - $iBlind = ' & $iBlind)
	;_Log('OK - $iButton = ' & $iButton)
	;_Log('OK - $iPosition = ' & $iPosition)
	;_Log('OK - $iOpponents = ' & $iOpponents)
	_Log('OK (preflop) - $aActionCount = ' & _ActionString($aActionCount))
	_Log('OK (preflop) - $iScore = ' & $iScore)
	_Log('OK (preflop) - $gScore = ' & $gScore)

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
	$eamount = 0 
	$famount = 0 

	If $sStreet == 'FLOP' Then
		_Log('OK - flop')
		$iStuck = 0
		Dead_Eye_Fred_FLOP($iSeat, $sHand)
	EndIf
	
	If $cAllIns Then
		If Not $cWon Then ; we lost
			$bLose = $bLose + 1
		Else 
			$bWins = $bWins + 1 ;we won unless _Tablebuyin ($bLose) happened
		EndIf
		$cAllIns = False
	EndIf
	
	If $samount_call Then
		$samount = $iBlind ;called amount = blind
	EndIf
			; suited
	If ($aSuits[0] == $aSuits[1]) Then
		For $i = 0 To UBound($fAll_in) - 1
			If $sholes = $fAll_in[$i] Or $sholes2 = $fAll_in[$i] Then
				_Log('OK - ' & $sholes)
				$cGoAllIn = True
				$zScore = 0
				$aAllIns = $aAllIns + 1 ; tooltip allin amount
				$bank_allin_count = $bank_allin_count + 1 ; for all in banking
			EndIf
		Next

		For $i = 0 To UBound($fRaise) - 1
			If $sholes = $fRaise[$i] Or $sholes2 = $fRaise[$i] Then
				_Log('OK - ' & $sholes)
				$cRaised = True
				$zScore = $iSuit_raise
				$aRaises = $aRaises + 1 ; tooltip raise amount
				$bank_raise_count = $bank_raise_count + 1 ; for raise banking
			EndIf
		Next

		For $i = 0 To UBound($fCall) - 1
			If $sholes = $fCall[$i] Or $sholes2 = $fCall[$i] Then ;call_any
				_Log('OK - ' & $sholes)
				$cCalled = True
				$zScore = $iSuit_any
				$aCall_anys = $aCall_anys + 1 ; tooltip call_any amount
			EndIf
		Next
		
		For $i = 0 To UBound($fCallo) - 1
			If $sholes = $fCallo[$i] Or $sholes2 = $fCallo[$i] Then ;call_once
				_Log('OK - ' & $sholes)
				$cCalledo = True
				$zScore = $iSuit_once
				$aCall_onces = $aCall_onces + 1 ; tooltip call_once amount
			EndIf
		Next
	
		For $i = 0 To UBound($fCheck) - 1
			If $sholes = $fCheck[$i] Or $sholes2 = $fCheck[$i] Then ;call_upto
				_Log('OK - ' & $sholes)
				$cChecked = True
				$zScore = $iSuit_upto
				$aCall_uptos = $aCall_uptos + 1 ; tooltip call_upto amount
			EndIf
		Next
		
	ElseIf Not ($aSuits[0] == $aSuits[1]) Then
		For $i = 0 To UBound($aAll_in) - 1
			If $sholes = $aAll_in[$i] Or $sholes2 = $aAll_in[$i] Then
				_Log('OK - ' & $sholes)
				$bGoAllIn = True
				$zScore = 0
				$aAllIns = $aAllIns + 1 ; tooltip allin amount
				$bank_allin_count = $bank_allin_count + 1 ; for all in banking
			EndIf
		Next

		For $i = 0 To UBound($aRaise) - 1
			If $sholes = $aRaise[$i] Or $sholes2 = $aRaise[$i] Then
				_Log('OK - ' & $sholes)
				$bRaised = True
				$zScore = $iHand_raise
				$aRaises = $aRaises + 1 ; tooltip raise amount
				$bank_raise_count = $bank_raise_count + 1 ; for raise banking
			EndIf
		Next

		For $i = 0 To UBound($aCall) - 1
			If $sholes = $aCall[$i] Or $sholes2 = $aCall[$i] Then ;call_any
				_Log('OK - ' & $sholes)
				$bCalled = True
				$zScore = $iHand_any
				$aCall_anys = $aCall_anys + 1 ; tooltip call_any amount
			EndIf
		Next
		
		For $i = 0 To UBound($aCallo) - 1
			If $sholes = $aCallo[$i] Or $sholes2 = $aCallo[$i] Then ;call_once
				_Log('OK - ' & $sholes)
				$bCalledo = True
				$zScore = $iHand_once
				$aCall_onces = $aCall_onces + 1 ; tooltip call_once amount
			EndIf
		Next
	
		For $i = 0 To UBound($aCheck) - 1
			If $sholes = $aCheck[$i] Or $sholes2 = $aCheck[$i] Then ;call_upto
				_Log('OK - ' & $sholes)
				$bChecked = True
				$zScore = $iHand_upto
				$aCall_uptos = $aCall_uptos + 1 ; tooltip call_upto amount
			EndIf
		Next
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
		ElseIf $bCalledo Then
			_Log('OK - Call_Once')
			_ToolTip($sDebug, 'Call_Once')
			_PlayTurnCall( 'any') ;changed
		EndIf
		
	ElseIf $bChecked Or $cChecked Then
		If $aActionCount[1] =0 And $aActionCount[0] =0 Then
			If $cChecked Then
				_Log('OK - Suited - Call_UpTo')
				_ToolTip($sDebug, 'Suited - Call_UpTo')
				_PlayTurnCall( 'any')
			ElseIf $bChecked Then
				_Log('OK - Call_UpTo')
				_ToolTip($sDebug, 'Call_UpTo')
				_PlayTurnCall( 'any')
			EndIf
		ElseIf $cChecked Then
			_Log('OK - Suited - Call_UpTo')
			_ToolTip($sDebug, 'Suited - Call_UpTo')
			_PlayFredTurnCall($camount)
		ElseIf $bChecked Then
			_Log('OK - Call_UpTo')
			_ToolTip($sDebug, 'Call_UpTo')
			_PlayFredTurnCall($camount)
		EndIf
		
	ElseIf $bGoAllIn Or $cGoAllIn Then
		If $cGoAllIn Then
			$bank_allin_count = $bank_allin_count + 1 ; for all in banking
			_Log('OK - Suited - All In')
			_ToolTip($sDebug, 'All In')
			_PlayTurnRaise($iRaise, 'any')
		ElseIf $bGoAllIn Then
			$bank_allin_count = $bank_allin_count + 1 ; for all in banking
			_Log('OK - All In')
			_ToolTip($sDebug, 'All In')
			_PlayTurnRaise($iRaise, 'any')
		EndIf
		
	ElseIf $bRaised Or $cRaised Then
		If $cRaised And $aActionCount[1] =0 And $aActionCount[0] =0 Then
			$bank_raise_count = $bank_raise_count + 1 ; for raise banking
			_Log('OK - Suited - Raise')
			_ToolTip($sDebug, 'Suited - Raise')
			_PlayTurnRaise($iRaise, 'any')
		ElseIf $bRaised And $aActionCount[1] =0 And $aActionCount[0] =0 Then
			$bank_raise_count = $bank_raise_count + 1 ; for raise banking
			_Log('OK - Raise')
			_ToolTip($sDebug, 'Raise')
			_PlayTurnRaise($iRaise, 'any')
		Else 
			$bank_raise_count = $bank_raise_count + 1 ; for raise banking
			_Log('OK - Raised - Calling Any')
			_ToolTip($sDebug, 'Raised - Calling Any')
			_PlayTurnCall( 'any')
		EndIf
		
		
	ElseIf $bCalled Or $cCalled Then
		If $cCalled Then
			_Log('OK - Suited - Call_Any')
			_ToolTip($sDebug, 'Suited - Call_Any')
			_PlayTurnCall( 'any')
		ElseIf $bCalled Then
			_Log('OK - Call_Any')
			_ToolTip($sDebug, 'Call_Any')
			_PlayTurnCall( 'any')
		EndIf
		
	Else
		$aFolds = $aFolds + 1 ; tooltip fold amount
		$zScore = 0
		_Log('OK - Check/Fold')
		_ToolTip($sDebug, 'Check/Fold')
		_PlayTurnCheck()
	EndIf
EndFunc   ;==>Dead_Eye_Fred_PREFLOP

Func Dead_Eye_Fred_FLOP($iSeat, $sHand)
	$aLobby = 0
	$camount = $xamountriver * $iBlind
	$sAction = IniReadSection(@ScriptDir & "\Dead_Eye_Fred.ini", "FlopScore")
	Local $aAction[UBound($sAction) - 1][3]
	$iNoGameReason = 'Just played a hand'
	$iOpponents = _OpponentCount()
	$iNoGameCount = 50
	$iPosition = _ButtonSeat($iSeat) + 1
	$iButton = _Button()
	$aActionCount = _ActionCount()
	$iSeat = _Seat()
	$sHand = _Cards($iSeat)
	$sStreet = _Street($sHand)
	$iScore = _SimHandMulti($sHand, $iOpponents - 1) + ($zScore)
	If $iScore > 1.0 Then 
		$iScore = 1.0
	EndIf
	$sDebug = 'Hand: ' & $sHand & @CRLF & 'Score Adjustment: ' & $zScore & @CRLF &'Score: ' & $iScore & @CRLF & 'Flop Call Amt: ' & $camount & @CRLF & 'Called Amt: ' & $damount & @CRLF & 'Banking: ' & $iCashChange & @CRLF & 'Players: ' & $iOpponents & @CRLF & _ActionString($aActionCount)
		
	;_Log('OK - $iSeat = ' & $iSeat)
	_Log('OK (flop) - $sHand = ' & $sHand)
	;_Log('OK - $iBlind = ' & $iBlind)
	;_Log('OK - $iButton = ' & $iButton)
	;_Log('OK - $iPosition = ' & $iPosition)
	;_Log('OK - $iOpponents = ' & $iOpponents)
	_Log('OK (flop) - $aActionCount = ' & _ActionString($aActionCount))
	_Log('OK (flop) - $iScore = ' & $iScore)
	_Log('OK (flop) - Score Adj = ' & $zScore)
	
	If $sStreet == 'TURN' Then
		_Log('OK - turn')
		$iStuck = 0
		Dead_Eye_Fred_TURN($iSeat, $sHand)
	EndIf

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
		$bank_allin_count = $bank_allin_count + 1 ; for all in banking
		_Log('OK - All In')
		_ToolTip($sDebug, 'All In')
		_PlayTurnRaise($iBlind * 1000, 'any')
	ElseIf $gScore = "raise" And $aActionCount[1] =0 Then
		$bank_raise_count = $bank_raise_count + 1 ; for raise banking
		_Log('OK - Raise')
		_ToolTip($sDebug, 'Raise')
		_PlayTurnRaise($iBlind * $framount, 'any')
	ElseIf $gScore = "raise" And $aActionCount[1] >0 Then
		$bank_raise_count = $bank_raise_count + 1 ; for raise banking
		_Log('OK - Raised - Calling Any')
		_ToolTip($sDebug, 'Raised - Calling Any')
		_PlayTurnCall( 'any')
	ElseIf $gScore = "call_upto" Then
		If $aActionCount[0] =0 And $aActionCount[1] =0 Then
			_Log('OK - Call_UpTo')
			_ToolTip($sDebug, 'Call_UpTo')
			_PlayTurnCall( 'any')
		Else		
			_Log('OK - Call_UpTo')
			_ToolTip($sDebug, 'Call_UpTo')
			_PlayFredTurnCall2($camount)
		EndIf
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

Func Dead_Eye_Fred_TURN($iSeat, $sHand)
	$aLobby = 0
	$xScore = ($zScore / 2)
	$camount = $yamountriver * $iBlind
	$sAction = IniReadSection(@ScriptDir & "\Dead_Eye_Fred.ini", "TurnScore")
	Local $aAction[UBound($sAction) - 1][3]
	$iNoGameReason = 'Just played a hand'
	$iOpponents = _OpponentCount()
	$iNoGameCount = 40
	$iPosition = _ButtonSeat($iSeat) + 1
	$iButton = _Button()
	$aActionCount = _ActionCount()
	$iSeat = _Seat()
	$sHand = _Cards($iSeat)
	$sStreet = _Street($sHand)
	$iScore = _SimHandMulti($sHand, $iOpponents - 1) + ($xScore)
	If $iScore > 1.0 Then 
		$iScore = 1.0
	EndIf
	$sDebug = 'Hand: ' & $sHand & @CRLF & 'Score Adjustment: ' & $xScore & @CRLF &'Score: ' & $iScore & @CRLF & 'Turn Call Amt: ' & $camount & @CRLF & 'Called Amt: ' & $eamount & @CRLF & 'Banking: ' & $iCashChange & @CRLF & 'Players: ' & $iOpponents & @CRLF & _ActionString($aActionCount)
	
	;_Log('OK - $iSeat = ' & $iSeat)
	_Log('OK (turn) - $sHand = ' & $sHand)
	;_Log('OK - $iBlind = ' & $iBlind)
	;_Log('OK - $iButton = ' & $iButton)
	;_Log('OK - $iPosition = ' & $iPosition)
	;_Log('OK - $iOpponents = ' & $iOpponents)
	_Log('OK (turn) - $aActionCount = ' & _ActionString($aActionCount))
	_Log('OK (turn) - $iScore = ' & $iScore)
	_Log('OK (turn) - Score Adj = ' & $zScore)
	
	If $sStreet == 'RIVER' Then 
		_Log('OK - river')
		$iStuck = 0
		Dead_Eye_Fred_RIVER($iSeat, $sHand)
	EndIf

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
		$bank_allin_count = $bank_allin_count + 1 ; for all in banking
		_Log('OK - All In')
		_ToolTip($sDebug, 'All In')
		_PlayTurnRaise($iBlind * 1000, 'any')
	ElseIf $gScore = "raise" And $aActionCount[1] =0 Then
		$bank_raise_count = $bank_raise_count + 1 ; for raise banking
		_Log('OK - Raise')
		_ToolTip($sDebug, 'Raise')
		_PlayTurnRaise($iBlind * $tramount, 'any')
	ElseIf $gScore = "raise" And $aActionCount[1] >0 Then
		$bank_raise_count = $bank_raise_count + 1 ; for raise banking
		_Log('OK - Raised - Calling Any')
		_ToolTip($sDebug, 'Raised - Calling Any')
		_PlayTurnCall( 'any')
	ElseIf $gScore = "call_upto" Then
		If $aActionCount[0] =0 And $aActionCount[1] =0 Then
			_Log('OK - Call_UpTo')
			_ToolTip($sDebug, 'Call_UpTo')
			_PlayTurnCall( 'any')
		Else		
			_Log('OK - Call_UpTo')
			_ToolTip($sDebug, 'Call_UpTo')
			_PlayFredTurnCall3($camount)
		EndIf
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

Func Dead_Eye_Fred_RIVER($iSeat, $sHand)
	$aLobby = 0
	$zScore = 0
	$camount = $zamountriver * $iBlind
	$sAction = IniReadSection(@ScriptDir & "\Dead_Eye_Fred.ini", "RiverScore")
	Local $aAction[UBound($sAction) - 1][3]
	$iNoGameReason = 'Just played a hand'
	$iOpponents = _OpponentCount()
	$iNoGameCount = 30
	$iPosition = _ButtonSeat($iSeat) + 1
	$iButton = _Button()
	$aActionCount = _ActionCount()
	$iSeat = _Seat()
	$sHand = _Cards($iSeat)
	$sStreet = _Street($sHand)
	$iScore = _SimHandMulti($sHand, $iOpponents - 1)
	$sDebug = 'Hand: ' & $sHand & @CRLF & 'Score Adjustment: ' & $zScore & @CRLF &'Score: ' & $iScore & @CRLF & 'River Call Amt: ' & $camount & @CRLF & 'Called Amt: ' & $famount & @CRLF & 'Banking: ' & $iCashChange & @CRLF & 'Players: ' & $iOpponents & @CRLF & _ActionString($aActionCount)
		
	;_Log('OK - $iSeat = ' & $iSeat)
	_Log('OK (river) - $sHand = ' & $sHand)
	;_Log('OK - $iBlind = ' & $iBlind)
	;_Log('OK - $iButton = ' & $iButton)
	;_Log('OK - $iPosition = ' & $iPosition)
	;_Log('OK - $iOpponents = ' & $iOpponents)
	_Log('OK (river) - $aActionCount = ' & _ActionString($aActionCount))
	_Log('OK (river) - $iScore = ' & $iScore)
	_Log('OK (river) - Score Adj = ' & $zScore)
	
	If $aActionCount[5] Then
		$zScore = 0
		$iScore = 0
		$gScore = 0
		Dead_Eye_Fred_NOGAME($iSeat, $sHand)
	EndIf

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
		$bank_allin_count = $bank_allin_count + 1 ; for all in banking
		_ToolTip($sDebug, 'All In')
		_PlayTurnRaise($iBlind * 1000, 'any')
	ElseIf $gScore = "raise" And $aActionCount[1] =0 Then
		$bank_raise_count = $bank_raise_count + 1 ; for raise banking
		_Log('OK - Raise')
		_ToolTip($sDebug, 'Raise')
		_PlayTurnRaise($iBlind * $rramount, 'any')
	ElseIf $gScore = "raise" And $aActionCount[1] >0 Then
		$bank_raise_count = $bank_raise_count + 1 ; for raise banking
		_Log('OK - Raised - Calling Any')
		_ToolTip($sDebug, 'Raised - Calling Any')
		_PlayTurnCall( 'any')
	ElseIf $gScore = "call_upto" Then
		If $aActionCount[0] =0 And $aActionCount[1] =0 Then
			_Log('OK - Call_UpTo')
			_ToolTip($sDebug, 'Call_UpTo')
			_PlayTurnCall( 'any')
		Else		
			_Log('OK - Call_UpTo')
			_ToolTip($sDebug, 'Call_UpTo')
			_PlayFredTurnCall4($camount)
		EndIf
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
