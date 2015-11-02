Func GetTownHallLevel(ByRef $location, ByRef $left, ByRef $top, Const $x1 = -1, Const $y1 = -1, Const $x2 = -1, Const $y2 = -1)
   ;DebugWrite("GetTownHallLevel()")

   ; Method = 0: CV_TM_SQDIFF, 1: CV_TM_SQDIFF_NORMED, 2: CV_TM_CCORR, 3: CV_TM_CCORR_NORMED
   ;          4: CV_TM_CCOEFF, 5: CV_TM_CCOEFF_NORMED

   ; Returns best TH level match, 0 if no good match
   Local $bestMatch, $bestConfidence

   ; Grab and scan frame
   GrabFrameToFile("TownHallCenterFrame.bmp", $x1, $y1, $x2, $y2)
   ScanFrameForBestBMP("TownHallCenterFrame.bmp", $TownHallBMPs, $gConfidenceTownHall, $bestMatch, $bestConfidence, $left, $top)
   If $bestMatch<>-1 Then $location = $eTownHallMiddle

   If $x1 = -1 Then
	  ; No good match, scan top of screen
	  If $bestMatch = -1 Then
		 ZoomOut(False)
		 MoveScreenDownToTop(False)
		 GrabFrameToFile("TownHallTopFrame.bmp")
		 MoveScreenUpToCenter()
		 ScanFrameForBestBMP("TownHallTopFrame.bmp", $TownHallBMPs, $gConfidenceTownHall, $bestMatch, $bestConfidence, $left, $top)
		 If $bestMatch<>-1 Then $location = $eTownHallTop

	  EndIf

	  ; No good match, scan bottom of screen
	  If $bestMatch = -1 Then
		 MoveScreenUpToBottom(False)
		 GrabFrameToFile("TownHallBotFrame.bmp")
		 MoveScreenDownToCenter()
		 ScanFrameForBestBMP("TownHallBotFrame.bmp", $TownHallBMPs, $gConfidenceTownHall, $bestMatch, $bestConfidence, $left, $top)
		 If $bestMatch<>-1 Then $location = $eTownHallBottom
	  EndIf
   EndIf

   If $bestMatch = -1 Then
	  ;DebugWrite("Unknown TH Level" & @CRLF)
	  Return -1
   Else
	  ;DebugWrite("Likely TH Level " & $bestMatch+7 & @CRLF)
	  Return $bestMatch+3
   EndIf
EndFunc
