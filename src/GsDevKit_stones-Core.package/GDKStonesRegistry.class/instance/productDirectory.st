accessing
productDirectory
	productDirectory
		ifNil: [ 
			self
				error:
					'The productDirectory for this registry has not been set. Please run registerProductDirectory.solo to set the productDirectory.' ].
	^ productDirectory