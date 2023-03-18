installation
cloneProjectSet: gitRootPath
	| gitTool gitRootRef |
	gitTool := Rowan gitTools.
	gitRootRef := gitRootPath asFileReference.
	self loadSpecs
		keysAndValuesDo: [ :projectName :specDict | 
			| gitUrls |
			gitUrls := specDict at: 'gitUrls'.
			gitUrls
				at: 'origin'
				ifPresent: [ :origin | 
					(gitRootRef / projectName) exists
						ifTrue: [ self stdout nextPutAll: 'Project ' , projectName , ' is already cloned.' ]
						ifFalse: [ gitTool gitcloneIn: gitRootPath with: origin logging: true ] ] ]