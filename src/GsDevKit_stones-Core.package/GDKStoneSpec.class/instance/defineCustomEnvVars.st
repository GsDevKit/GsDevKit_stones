runtime
defineCustomEnvVars
	self stoneDirectorySpec
		ifNotNil: [ :dirSpec | 
			dirSpec customenv
				ifNotNil: [ :customenv | 
					customenv
						keysAndValuesDo: [ :varName :valueStr | 
							varName = 'PATH'
								ifFalse: [ 
									"bad idea to monky with PATH in netldi and stone"
									System gemEnvironmentVariable: varName put: valueStr ] ] ] ]