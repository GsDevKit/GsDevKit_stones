export
exportCustomEnvTo: customEnvRef
	customEnvRef
		writeStreamDo: [ :fileStream | 
			self customenv
				keysAndValuesDo: [ :key :value | 
					fileStream
						nextPutAll: 'export ' , key , '=' , value;
						lf ] ]