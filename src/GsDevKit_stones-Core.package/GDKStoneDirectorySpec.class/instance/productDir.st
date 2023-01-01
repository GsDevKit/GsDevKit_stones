as yet unspecified
productDir
	| dir res |
	dir := self root / self product.
	dir exists
		ifFalse: [ 
			res := System
				performOnServer:
					'ln -s ' , self gemstone asFileReference pathString , ' ' , dir pathString ].
	^ dir
