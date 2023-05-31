accessing
stoneNamed: stoneName ifAbsent: absentBlock
	| stonePath |
	stonePath := self stones at: stoneName ifAbsent: absentBlock.
	^ GDKAbstractRegistryStore fromPath: stonePath ifAbsent: absentBlock