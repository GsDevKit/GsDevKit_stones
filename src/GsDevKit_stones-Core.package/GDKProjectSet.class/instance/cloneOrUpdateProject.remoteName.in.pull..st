installation
cloneOrUpdateProject: projectDirName remoteName: remoteName in: gitRootPath pull: pull
	"Clone the project into the gitRootPath directory using the information in the load spec for project. If the project 
		has already been cloned, then checkout the revision specified in the load spec. The loadSpecs are indexed by
        projectDirName to allow for multiple copies of the project in the same directory. Normally, projectDirName
		and projectName are the same."

	| wasTracing gitTool specDict gitUrls gitProjectRef gitUrl cloned projectName title stdout |
	(wasTracing := Rowan projectTools trace isTracing)
		ifTrue: [ Rowan projectTools trace stopTracing ].
	gitTool := Rowan gitTools.
	specDict := self loadSpecs at: projectDirName.
	gitUrls := specDict at: 'gitUrls'.
	gitUrl := gitUrls at: remoteName.
	projectName := specDict at: 'projectName' ifAbsent: [ projectDirName ].
	gitProjectRef := gitRootPath asFileReference / projectDirName.
	cloned := false.
	title := 'Clone or update ' , projectName.
	projectDirName = projectName
		ifFalse: [ title := title , ' as ' , projectDirName ].
	stdout := GsFile stdout.
	stdout
		cr;
		nextPutAll: '====================';
		cr;
		nextPutAll: 'Directory ', gitProjectRef basename printString;
		cr;
		nextPutAll: 'Project ' , projectName printString;
		cr;
		nextPutAll: '====================';
		cr;
		tab;
		nextPutAll: 'Remote ' , remoteName;
		cr;
		tab;
		nextPutAll: 'In  directory ' , gitProjectRef fullName.
	gitProjectRef exists
		ifTrue: [ 
			(Rowan gitTools gitstatusIn: gitProjectRef fullName with: '--porcelain') isEmpty
				not
				ifTrue: [ 
					"the git repository has unsaved modifications, so abort the operation"
					self
						error:
							'There are unsaved changes in ' , gitProjectRef fullName printString
								, '. We cannot clone or update a repository with unsaved changes' ] ]
		ifFalse: [ 
			| originArg dirNameArg |
			"GIT CLONE"
			originArg := ''.
			remoteName ~= 'origin'
				ifTrue: [ originArg := ' --origin ' , remoteName , ' ' ].
			dirNameArg := ''.
			projectName = projectDirName
				ifFalse: [ dirNameArg := ' ' , projectDirName ].
			stdout
				cr;
				tab;
				nextPutAll: 'Cloning ' , gitUrl , ' to ' , projectDirName.
			stdout
				cr;
				nextPutAll:
						(gitTool
								gitcloneIn: gitRootPath
								with: originArg , gitUrl , dirNameArg
								logging: false).
			cloned := true ].
	(specDict at: 'revision' ifAbsent: [  ])
		ifNotNil: [ :revision | 
			stdout
				cr;
				tab;
				nextPutAll: 'Set ' , projectDirName , ' revision to ' , revision.
			cloned
				ifTrue: [ 
					"GIT SWITCH"
					stdout
						cr;
						tab;
						nextPutAll:
								'Switch (after clone) ' , remoteName , '/' , revision , ' -t -C ' , revision.
					stdout
						cr;
						nextPutAll:
								(gitTool
										performGitCommand: 'switch'
										in: gitProjectRef fullName
										with: ' ' , remoteName , '/' , revision , ' -t -C ' , revision) ]
				ifFalse: [ 
					pull
						ifTrue: [ 
							"GIT FETCH
								GIT SWITCH
								GIT PULL"
							stdout
								cr;
								tab;
								nextPutAll: 'Fetch  --all '.
							stdout
								cr;
								nextPutAll: (gitTool gitfetchIn: gitProjectRef with: ' --all').
							stdout
								cr;
								tab;
								nextPutAll:
										'Switch (after fetch) ' , remoteName , '/' , revision , ' -t -C ' , revision.
							stdout
								cr;
								nextPutAll:
										(gitTool
												performGitCommand: 'switch'
												in: gitProjectRef fullName
												with: ' ' , remoteName , '/' , revision , ' -t -C ' , revision).
							stdout
								cr;
								tab;
								nextPutAll:
										'Pull ' , projectName , ' revision ' , revision , ' from remote ' , remoteName.
							stdout
								cr;
								nextPutAll:
										(gitTool gitpullIn: gitProjectRef fullName remote: remoteName branch: revision) ] ] ].
	cloned
		ifTrue: [ 
			"GIT REMOTE ADD"
			(gitUrls keys reject: [ :each | each = remoteName ])
				do: [ :theRemote | 
					self
						gitAddRemoteIn: gitProjectRef fullName
						remote: theRemote
						gitUrl: (gitUrls at: theRemote) ].	"GIT FETCH --all"
			stdout
				cr;
				tab;
				nextPutAll: 'Fetch  --all '.
			stdout
				cr;
				nextPutAll: (gitTool gitfetchIn: gitProjectRef with: ' --all') ].
	stdout
		cr;
		nextPutAll: '------ branch';
		cr;
		nextPutAll: (Rowan gitTools gitbranchIn: gitProjectRef fullName with: '');
		cr;
		nextPutAll: '==========';
		cr;
		nextPutAll: '==========';
		cr.
	wasTracing
		ifTrue: [ Rowan projectTools trace startTracing ]