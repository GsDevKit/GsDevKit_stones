scripts
copyExtent: extentRef toStoneSpec: stoneSpec
	^ self new
		copyExtent: extentRef
		toStoneSpec: stoneSpec
		script: nil
		withSuperDoitOptions: false