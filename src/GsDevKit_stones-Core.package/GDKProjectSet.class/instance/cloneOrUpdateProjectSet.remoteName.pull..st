installation
cloneOrUpdateProjectSet: gitRootPath remoteName: remoteName pull: pull
	self loadSpecs
		keysDo: [ :projectName | self cloneOrUpdateProject: projectName remoteName: remoteName in: gitRootPath pull: pull ]