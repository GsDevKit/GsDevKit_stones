private
_envName: envName defaultDir: defaultDir
	| envVarName |
	envVarName := 'XDG_' , envName , '_HOME'.
	((System gemEnvironmentVariable: envVarName)
		ifNotNil: [ :path | 
			| dir |
			dir := path asFileReference.
			dir isRelative
				ifTrue: [ 
					"invalid specification use default"
					nil ]
				ifFalse: [ ^ dir ] ])
		ifNil: [ 
			System gemEnvironmentVariable: envVarName put: defaultDir.
			^ defaultDir asFileReference ]