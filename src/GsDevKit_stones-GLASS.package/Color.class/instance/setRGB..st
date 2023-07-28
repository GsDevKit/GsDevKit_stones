private
setRGB: rgb0
	rgb == nil ifFalse: [self attemptToMutateError].
	rgb _ rgb0