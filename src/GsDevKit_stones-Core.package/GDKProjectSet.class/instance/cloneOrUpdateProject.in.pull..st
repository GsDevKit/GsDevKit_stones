installation
cloneOrUpdateProject: projectName in: gitRootPath pull: pull
	"Clone the named project into the gitRootPath directory using the information in the load spec for project. If the project 
		has already been cloned, then checkout the revision specified in the load spec. If pull is true, then perform a pull request 
		to update to  the latest branch. If pull is false, print a message indicating whether or not a pull request is needed."

	self cloneOrUpdateProject: projectName remoteName: 'origin' in: gitRootPath preview: pull not pull: pull