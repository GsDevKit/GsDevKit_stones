accessing
registryNamed: registryName ifAbsent: absentBlock
	^ GDKStonesRegistry
		fromPath: (self at: registryName asSymbol ifAbsent: absentBlock)
		ifAbsent: absentBlock