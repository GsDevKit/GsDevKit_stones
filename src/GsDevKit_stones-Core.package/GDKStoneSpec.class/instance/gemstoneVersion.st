accessing
gemstoneVersion
	^ gemstoneVersionString
		ifNotNil: [ gemstoneVersionString asRwGemStoneVersionNumber ]