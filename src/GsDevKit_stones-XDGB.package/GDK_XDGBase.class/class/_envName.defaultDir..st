private
_envName: envName defaultDir: defaultDir
	((System gemEnvironmentVariable: 'XDG_' , envName , '_HOME')
		ifNotNil: [ :path | 
			| dir |
			dir := path asFileReference.
			dir isRelativePath
				ifTrue: [ 
					"invalid specification use default"
					nil ]
				ifFalse: [ ^ dir ] ]) ifNil: [ ^ defaultDir asFileReference ]