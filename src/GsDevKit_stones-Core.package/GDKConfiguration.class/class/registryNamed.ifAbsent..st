accessing
registryNamed: registryName ifAbsent: absentBlock
	^ self instance at: registryName asSymbol ifAbsent: absentBlock