installation
cloneOrUpdateProject: projectName remoteName: remoteName in: gitRootPath pull: pull
	"Clone the named project into the gitRootPath directory using the information in the load spec for project. If the project 
		has already been cloned, then checkout the revision specified in the load spec"

	| gitTool specDict gitUrls gitProjectRef gitUrl cloned |
	Transcript
		cr;
		show: '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'.
	pull
		ifTrue: [ 
			Transcript
				cr;
				show: '	Updating project: ' , projectName printString ]
		ifFalse: [ 
			Transcript
				cr;
				show: '	Cloning project: ' , projectName printString ].
	Transcript
		cr;
		show: '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'.
	gitTool := Rowan gitTools.
	specDict := self loadSpecs at: projectName.
	gitUrls := specDict at: 'gitUrls'.
	gitUrl := gitUrls at: remoteName.
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
			| originArg |
			"GIT CLONE"
			originArg := ''.
			remoteName ~= 'origin'
				ifTrue: [ originArg := ' --origin ' , remoteName , ' ' ].
			gitTool gitcloneIn: gitRootPath with: originArg , gitUrl logging: true.
			cloned := true ].
	(specDict at: 'revision' ifAbsent: [  ])
		ifNotNil: [ :revision | 
			Transcript
				cr;
				show: '  Set ' , projectName , ' revision to ' , revision.
			cloned
				ifTrue: [ 
					"GIT SWITCH"
					gitTool
						performGitCommand: 'switch'
						in: gitProjectRef fullName
						with: ' ' , remoteName , '/' , revision , ' -t -C ' , revision ]
				ifFalse: [ 
					pull
						ifTrue: [ 
							"GIT FETCH
								GIT SWITCH
									GIT PULL"
							Transcript
								cr;
								show: '  Fetch  --all '.
							gitTool gitfetchIn: gitProjectRef with: ' --all'.
							gitTool
								performGitCommand: 'switch'
								in: gitProjectRef fullName
								with: ' ' , remoteName , '/' , revision , ' -t -C ' , revision.
							Transcript
								cr;
								show:
										'  Pull ' , projectName , ' revision ' , revision , ' from remote ' , remoteName.
							gitTool
								gitpullIn: gitProjectRef fullName
								remote: remoteName
								branch: revision ] ] ].
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