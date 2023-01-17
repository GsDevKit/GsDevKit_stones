accessing
stonesRegistry
	^ GDKAbstractRegistryStore
		fromPath: self parentRegistryPath
		ifAbsent: [ 
			self
				error:
					'cannot find parent registry ' , self parentRegistryName , ' at  '
						, self parentRegistryPath printString ]