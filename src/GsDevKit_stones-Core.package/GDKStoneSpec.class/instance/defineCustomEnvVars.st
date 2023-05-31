runtime
defineCustomEnvVars
	self stoneDirectorySpec customenv
		ifNotNil: [ :customenv | 
			customenv
				keysAndValuesDo: [ :varName :valueStr | System gemEnvironmentVariable: varName put: valueStr ] ]