scripts
copyExtent: extentRef stonesRegistry: stonesRegistry stoneName: stoneName script: scriptOrNil withSuperDoitOptions: withSuperDoitOptions
	| stoneSpec |
	stoneSpec := stonesRegistry stoneNamed: stoneName.
	^ self
		copyExtent: extentRef
		toStoneSpec: stoneSpec
		script: scriptOrNil
		withSuperDoitOptions: withSuperDoitOptions