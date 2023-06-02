runtime
defineCustomEnvVars
	self stoneDirectorySpec
		ifNotNil: [ :dirSpec | 
			dirSpec customenv
				ifNotNil: [ :customenv | 
					customenv
						keysAndValuesDo: [ :varName :valueStr | System gemEnvironmentVariable: varName put: valueStr ] ] ]