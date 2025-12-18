installation
cloneOrUpdateProject: projectName remoteName: remoteName in: gitRootPath
	"Clone the named project into the gitRootPath directory using the information in the load spec for project. If the project 
		has already been cloned, then checkout the revision specified in the load spec. Display a message about whether 
		or not a pull request is needed"

	self cloneOrUpdateProject: projectName remoteName: remoteName in: gitRootPath preview: true pull: false