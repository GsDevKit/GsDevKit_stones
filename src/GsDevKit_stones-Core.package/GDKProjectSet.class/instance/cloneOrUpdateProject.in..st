installation
cloneOrUpdateProject: projectName in: gitRootPath
	"Clone the named project into the gitRootPath directory using the information in the load spec for project. If the project 
		has already been cloned, then checkout the revision specified in the load spec"

	self cloneOrUpdateProject: projectName in: gitRootPath pull: false