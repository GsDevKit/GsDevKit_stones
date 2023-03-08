runtime
defineCustomEnvVars
	self stoneDirectorySpec customenv
		keysAndValuesDo: [ :varName :valueStr | System gemEnvironmentVariable: varName put: valueStr ]