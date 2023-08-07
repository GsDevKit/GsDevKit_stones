runtime
stopStone: timeoutNilOrNumber immediate: immediateBool
	^ self
		stopStone: nil
		withSuperDoitOptions: false
		timeout: timeoutNilOrNumber
		immediate: immediateBool