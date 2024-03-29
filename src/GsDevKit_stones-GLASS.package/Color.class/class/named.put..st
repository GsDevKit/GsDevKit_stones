class initialization
named: newName put: aColor
	"Add a new color to the list and create an access message and a class variable for it.  The name should start with a lowercase letter.  (The class variable will start with an uppercase letter.)  (Color colorNames) returns a list of all color names.  "
	| str cap sym accessor csym |
	(aColor isKindOf: self) ifFalse: [^ self error: 'not a Color'].
	str _ newName asString.
	sym _ str asSymbol.
	cap _ str capitalized.
	csym _ cap asSymbol.
	(self class canUnderstand: sym) ifFalse: [
		"define access message"
		accessor _ str, (String with: Character cr with: Character tab), 			'^', cap.
		self class compile: accessor
			classified: 'named colors'].
	(self _classVars includesKey: csym) ifFalse: [
		self addClassVarName: cap].
	(ColorNames includes: sym) ifFalse: [
		ColorNames add: sym].
	^ self _classVars at: csym put: aColor
