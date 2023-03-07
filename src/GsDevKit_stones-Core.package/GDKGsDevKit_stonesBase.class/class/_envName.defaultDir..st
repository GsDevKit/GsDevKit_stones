private
_envName: envName defaultDir: defaultDir
	| envVarName |
	envVarName := 'STONES_' , envName , '_HOME'.
	((System gemEnvironmentVariable: envVarName)
		ifNotNil: [ :path | 
			| dir |
			dir := path asFileReference.
			dir isRelative
				ifTrue: [ 
					"invalid specification use default"
					nil ]
				ifFalse: [ ^ dir ] ])
		ifNil: [ ^ super _envName: envName defaultDir: defaultDir ]