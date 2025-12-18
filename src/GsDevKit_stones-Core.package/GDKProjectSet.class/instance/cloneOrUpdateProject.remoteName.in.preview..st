installation
cloneOrUpdateProject: projectName remoteName: remoteName in: gitRootPath preview: preview
	"Clone the named project into the gitRootPath directory using the information in the load spec for project. If the project 
		has already been cloned, then checkout the revision specified in the load spec. If preview is true display a message 
		about whether or not a pull request is needed"

	self
		loneOrUpdateProject: projectName
		remoteName: remoteName
		in: gitRootPath
		preview: preview
		pull: false