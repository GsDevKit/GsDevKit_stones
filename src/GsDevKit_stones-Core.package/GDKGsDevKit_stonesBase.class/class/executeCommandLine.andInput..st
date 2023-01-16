host processes
executeCommandLine: commandLine andInput: stdinStringOrNil
	| errorRedirectReference stdoutRedirectPath |
	errorRedirectReference := FileReference
		newTempFilePrefix: 'gsd_stones'
		suffix: '.err'.
	stdoutRedirectPath := FileReference
		newTempFilePrefix: 'gsd_stones'
		suffix: '.out'.
	GsFile
		gciLogServer:
			'executing ' , commandLine printString , ' stdout: '
				, stdoutRedirectPath pathString , ' stderr: '
				, errorRedirectReference pathString.
	[ 
	GsHostProcess new
		commandLine: commandLine;
		appendToFiles: true;
		stderrPath: errorRedirectReference pathString;
		stdoutPath: stdoutRedirectPath pathString;
		executeWithInput: stdinStringOrNil ]
		on: ChildError
		do: [ :ex | 
			self
				error:
					'The command ' , commandLine printString , ' exited with status '
						, ex status printString , '. See the file '
						, errorRedirectReference pathString printString , ' or '
						, stdoutRedirectPath pathString printString
						, ' for additional error details.' ]