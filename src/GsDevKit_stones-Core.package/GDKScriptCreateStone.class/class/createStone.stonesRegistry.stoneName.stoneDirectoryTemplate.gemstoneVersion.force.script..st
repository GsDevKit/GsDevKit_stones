scripts
createStone: stonesRootDir stonesRegistry: stonesRegistry stoneName: stoneName stoneDirectoryTemplate: templateName gemstoneVersion: gemstoneVersionString force: force script: scriptOrNil
	^ self new
		createStone: stonesRootDir
		stonesRegistry: stonesRegistry
		stoneName: stoneName
		stoneDirectoryTemplate: templateName
		gemstoneVersion: gemstoneVersionString
		force: force
		script: scriptOrNil