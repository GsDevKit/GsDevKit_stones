transformations
* aNumber
	"Answer this color with its RGB multiplied by the given number. "
	"(Color brown * 2) display"

	^ Color basicNew
		setPrivateRed: (self privateRed * aNumber) asInteger
		green: (self privateGreen * aNumber) asInteger
		blue: (self privateBlue * aNumber) asInteger