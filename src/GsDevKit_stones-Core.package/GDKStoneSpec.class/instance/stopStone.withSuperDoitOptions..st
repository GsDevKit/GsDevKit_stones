runtime
stopStone: superDoitScriptOrNil withSuperDoitOptions: superDoitOptionsBoolean
	"if superDoitOptionsBoolean is true, then superDoitScriptOrNil is expected to respond to the following messages:
		scriptPath
		immediate
		timeout"

	^ self
		stopStone: superDoitScriptOrNil
		withSuperDoitOptions: superDoitOptionsBoolean
		timeout: nil
		immediate: false