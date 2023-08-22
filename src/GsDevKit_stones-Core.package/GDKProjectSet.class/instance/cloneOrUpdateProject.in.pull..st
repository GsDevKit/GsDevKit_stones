installation
cloneOrUpdateProject: projectName in: gitRootPath pull: pull
	"Clone the named project into the gitRootPath directory using the information in the load spec for project. If the project 
		has already been cloned, then checkout the revision specified in the load spec"

	| gitTool specDict gitUrls remote |
	remote := 'origin'. "have to somehow specify the remote to use ... maybe all the way at the top level?"
	gitTool := Rowan gitTools.
	specDict := self loadSpecs at: projectName.
	gitUrls := specDict at: 'gitUrls'.
	gitUrls
		at: remote
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
					pull
						ifTrue: [ gitTool gitpullIn: gitProjectRef fullName remote: remote branch: revision ] ] ]