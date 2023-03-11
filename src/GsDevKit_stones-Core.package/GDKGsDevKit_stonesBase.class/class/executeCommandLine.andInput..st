host processes
executeCommandLine: commandLine andInput: stdinStringOrNil
	| stdoutRedirectPath |
	stdoutRedirectPath := FileReference
		newTempFilePrefix: 'gsd_stones'
		suffix: '.out'.
	self
		executeCommandLine: commandLine
		stdout: stdoutRedirectPath pathString
		andInput: stdinStringOrNil