utils
verbose
	^ SessionTemps current at: self _verboseFlagName ifAbsent: [ false ]