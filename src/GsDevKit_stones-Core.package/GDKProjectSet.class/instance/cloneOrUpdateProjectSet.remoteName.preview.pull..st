installation
cloneOrUpdateProjectSet: gitRootPath remoteName: remoteName preview: preview pull: pull
	"For each of the loadSpecs in the reciever, clone the speced project into the gitRootPath directory using the information 
	 	in the load spec for project. If the project has already been cloned, then checkout the revision specified in the 
		load spec. f preview is true display a message about whether or not a pull request is needed. If pull is true, 
		perform the pull request."

	self loadSpecs
		keysDo: [ :projectName | self cloneOrUpdateProject: projectName remoteName: remoteName in: gitRootPath  preview: preview pull: pull ]