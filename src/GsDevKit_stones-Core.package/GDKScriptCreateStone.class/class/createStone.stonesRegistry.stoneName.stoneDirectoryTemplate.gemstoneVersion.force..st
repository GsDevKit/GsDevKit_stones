scripts
createStone: stonesRootDir stonesRegistry: stonesRegistry stoneName: stoneName stoneDirectoryTemplate: templateName gemstoneVersion: gemstoneVersionString force: force
	^ self
		createStone: stonesRootDir
		stonesRegistry: stonesRegistry
		stoneName: stoneName
		stoneDirectoryTemplate: templateName
		gemstoneVersion: gemstoneVersionString
		force: force
		script: nil