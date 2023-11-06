accessing
stoneNamed: stoneName ifAbsent: absentBlock
	| stonePath |
	stonePath := self stones at: stoneName ifAbsent: [ ^ absentBlock value ].
	^ GDKAbstractRegistryStore fromPath: stonePath ifAbsent: absentBlock