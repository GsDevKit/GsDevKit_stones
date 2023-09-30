installation
cloneOrUpdateProject: projectName remoteName: remoteName in: gitRootPath pull: pull
	"Clone the named project into the gitRootPath directory using the information in the load spec for project. If the project 
		has already been cloned, then checkout the revision specified in the load spec"

	| gitTool specDict gitUrls gitProjectRef origin cloned |
	gitTool := Rowan gitTools.
	specDict := self loadSpecs at: projectName.
	gitUrls := specDict at: 'gitUrls'.
	origin := gitUrls at: remoteName.
	gitProjectRef := gitRootPath asFileReference / projectName.
	cloned := false.
	gitProjectRef exists
		ifTrue: [ 
			(Rowan gitTools gitstatusIn: gitProjectRef fullName with: '--porcelain') isEmpty
				not
				ifTrue: [ 
					"the git repository has unsaved modifications, so abort the operation"
					self
						error:
							'There are unsaved changes in ' , gitProjectRef fullName printString
								, '. We cannot clone or update a repository with unsaved chnages' ] ]
		ifFalse: [ 
			"GIT CLONE"
			gitTool gitcloneIn: gitRootPath with: origin logging: true.
			cloned := true ].
	(specDict at: 'revision' ifAbsent: [  ])
		ifNotNil: [ :revision | 
			Transcript
				cr;
				show: '  Set ' , projectName , ' revision to ' , revision.
			cloned
				ifTrue: [ 
					"GIT CHECKOUT -B"
					gitTool
						gitcheckoutIn: gitProjectRef
						with: ' -B ' , remoteName , '/' , revision ]
				ifFalse: [ 
					"GIT CHECKOUT -b"
					[ 
					gitTool
						gitcheckoutIn: gitProjectRef
						with: ' -b ' , revision , ' ' , remoteName , '/' , revision ]
						on: Error
						do: [ :ex | 
							"assume that the branch already exists, and try again without -b option"
							Transcript
								cr;
								show: 'assume branch ' , revision , ' already exists. Tryig again'.
							gitTool gitcheckoutIn: gitProjectRef with: revision ] ].
			pull
				ifTrue: [ 
					"GIT PULL"
					Transcript
						cr;
						show:
								'  Pull ' , projectName , ' revision ' , revision , ' from remote ' , remoteName.
					gitTool
						gitpullIn: gitProjectRef fullName
						remote: remoteName
						branch: revision ] ].
	cloned
		ifTrue: [ 
			"GIT REMOTE ADD"
			(gitUrls keys reject: [ :each | each = remoteName ])
				do: [ :theRemote | 
					self
						gitAddRemoteIn: gitProjectRef fullName
						remote: theRemote
						gitUrl: (gitUrls at: theRemote) ].	"GIT FETCH --all"
			Transcript
				cr;
				show: '  Fetch  --all '.
			gitTool gitfetchIn: gitProjectRef with: ' --all' ]