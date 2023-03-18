installation
cloneProject: projectName in: gitRootPath
	| gitTool specDict gitUrls |
	gitTool := Rowan gitTools.
	specDict := self loadSpecs at: projectName.
	gitUrls := specDict at: 'gitUrls'.
	gitUrls
		at: 'origin'
		ifPresent: [ :origin | 
			(gitRootPath asFileReference / projectName) exists
				ifFalse: [ gitTool gitcloneIn: gitRootPath with: origin logging: true ] ]