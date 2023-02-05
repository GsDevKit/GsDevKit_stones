accessing
stonesRegistryNamed: registryName
	^ self
		stonesRegistryNamed: registryName
		ifAbsent: [ 
			self
				error:
					'The registry (' , registryName
						, ' does not exist. Use createRegistry.solo to create the registry' ]