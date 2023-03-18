installation
cloneProjectSet: gitRootPath
	| gitTool |
	gitTool := Rowan gitTools.
	self loadSpecs
		keysAndValuesDo: [ :projectName :specDict | 
			| gitUrls |
			gitUrls := specDict at: 'gitUrls'.
			gitUrls
				at: 'origin'
				ifPresent: [ :origin | gitTool gitcloneIn: gitRootPath with: origin logging: true ] ]