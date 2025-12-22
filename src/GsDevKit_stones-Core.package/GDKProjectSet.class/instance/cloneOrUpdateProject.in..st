installation
cloneOrUpdateProject: projectName in: gitRootPath
	"Clone the named project into the gitRootPath directory using the information in the load spec for project. If the project 
		has already been cloned, then checkout the revision specified in the load spec and display a message about whether or not a pull request is needed"

	self cloneOrUpdateProject: projectName remoteName: 'origin' in: gitRootPath preview: true pull: false