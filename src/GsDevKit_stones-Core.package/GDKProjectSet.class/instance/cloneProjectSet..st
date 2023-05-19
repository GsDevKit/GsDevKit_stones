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
						ifFalse: [ 
							gitTool gitcloneIn: gitRootPath with: origin logging: true.
							(specDict at: 'revision' ifAbsent: [  ])
								ifNotNil: [ :revision | 
									gitTool gitcheckoutIn: gitRootPath with: revision.
									Transcript
										cr;
										show: '  Set ' , projectName , ' revision to ' , revision ] ] ] ]