accessing
registryDir
	^ self parentRegistryName
		ifNil: [ 
			"this is for cross platform templates, like 'default'"
			self class registry_home ]
		ifNotNil: [ :parentName | self class registry_home / parentName ]