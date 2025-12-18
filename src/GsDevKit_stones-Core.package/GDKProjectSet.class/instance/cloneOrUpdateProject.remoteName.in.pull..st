installation
cloneOrUpdateProject: projectName remoteName: remoteName in: gitRootPath pull: pull
	"Clone the named project into the gitRootPath directory using the information in the load spec for project. If the project 
		has already been cloned, then checkout the revision specified in the load spec. If pull is true, the perform a pull request 
		to update to  the latest branch. If pull is false, print a message indicating whether or not a pull request is needed."

	self
		loneOrUpdateProject: projectName
		remoteName: remoteName
		in: gitRootPath
		preview: pull not
		pull: pull