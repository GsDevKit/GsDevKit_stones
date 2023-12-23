accessing
currentGemStoneVersion
	^ (System gemVersionReport at: 'gsVersion') asRwGemStoneVersionNumber
