private
setRgb: rgbValue alpha: alphaValue
	"Set the state of this translucent color. Alpha is represented internally by an integer in the range 0..255."

	rgb == nil ifFalse: [self attemptToMutateError].
	rgb _ rgbValue.
	alpha _ (255.0 * alphaValue) asInteger min: 255 max: 0.