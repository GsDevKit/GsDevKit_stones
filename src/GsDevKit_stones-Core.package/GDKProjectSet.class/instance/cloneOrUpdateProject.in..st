installation
cloneOrUpdateProject: projectName in: gitRootPath
	"Clone the named project into the gitRootPath directory using the information in the load spec for project. If the project 
		has already been cloned, then checkout the revision specified in the load spec"

	| gitTool specDict gitUrls |
	gitTool := Rowan gitTools.
	specDict := self loadSpecs at: projectName.
	gitUrls := specDict at: 'gitUrls'.
	gitUrls
		at: 'origin'
		ifPresent: [ :origin | 
			| gitProjectRef |
			gitProjectRef := gitRootPath asFileReference / projectName.
			gitProjectRef exists
				ifFalse: [ gitTool gitcloneIn: gitRootPath with: origin logging: true ].
			(specDict at: 'revision' ifAbsent: [  ])
				ifNotNil: [ :revision | 
					gitTool gitcheckoutIn: gitProjectRef with: revision.
					Transcript
						cr;
						show: '  Set ' , projectName , ' revision to ' , revision.
					gitTool gitpullIn: gitProjectRef fullName remote: 'xxx' branch: revision ] ]