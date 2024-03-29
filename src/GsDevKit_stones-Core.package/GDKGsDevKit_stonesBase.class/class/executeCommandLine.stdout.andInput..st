host processes
executeCommandLine: commandLine stdout: stdoutOrNil andInput: stdinStringOrNil
	| errorRedirectReference |
	errorRedirectReference := FileReference
		newTempFilePrefix: 'gsd_stones'
		suffix: '.err'.
	self verbose
		ifTrue: [ 
			GsFile
				gciLogServer:
					'executing ' , commandLine printString , ' stdout: ' , stdoutOrNil printString
						, ' stderr: ' , errorRedirectReference fullName ].
	[ 
	| hp |
	hp := GsHostProcess new
		commandLine: commandLine;
		appendToFiles: true;
		stderrPath: errorRedirectReference fullName;
		yourself.
	stdoutOrNil ifNotNil: [ hp stdoutPath: stdoutOrNil ].
	^ hp executeWithInput: stdinStringOrNil ]
		on: ChildError
		do: [ :ex | 
			self
				error:
					'The command ' , commandLine printString , ' exited with status '
						, ex status printString , '. See the file '
						, errorRedirectReference fullName printString
						,
							(stdoutOrNil
								ifNil: [ '' ]
								ifNotNil: [ ' or ' , stdoutOrNil printString , ' for additional error details.' ]) ]