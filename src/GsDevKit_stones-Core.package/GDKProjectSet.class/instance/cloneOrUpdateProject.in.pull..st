installation
cloneOrUpdateProject: projectName in: gitRootPath pull: pull
	"Clone the named project into the gitRootPath directory using the information in the load spec for project. If the project 
		has already been cloned, then checkout the revision specified in the load spec"

	| gitTool specDict gitUrls remote gitProjectRef origin cloned |
	remote := 'origin'.	"have to somehow specify the remote to use ... maybe all the way at the top level?"
	gitTool := Rowan gitTools.
	specDict := self loadSpecs at: projectName.
	gitUrls := specDict at: 'gitUrls'.
	origin := gitUrls at: remote.
	gitProjectRef := gitRootPath asFileReference / projectName.
	cloned := false.
	gitProjectRef exists
		ifFalse: [ 
			gitTool gitcloneIn: gitRootPath with: origin logging: true.
			cloned := true ].
	(specDict at: 'revision' ifAbsent: [  ])
		ifNotNil: [ :revision | 
			gitTool gitcheckoutIn: gitProjectRef with: ' -B ', revision, ' ', remote, '/', revision.
			Transcript
				cr;
				show: '  Set ' , projectName , ' revision to ' , revision.
			pull
				ifTrue: [ gitTool gitpullIn: gitProjectRef fullName remote: remote branch: revision ] ].
	cloned
		ifTrue: [ 
			(gitUrls keys reject: [ :each | each = remote ])
				do: [ :theRemote | 
					self
						gitAddRemoteIn: gitProjectRef fullName
						remote: theRemote
						gitUrl: (gitUrls at: theRemote) ] ]