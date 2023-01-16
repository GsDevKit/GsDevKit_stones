instance creation
root: aFileReferenceOrPath gemstone: gemstonePath
	"if aFileReferenceOrPath exists, it will be deleted and recreated ... empty"

	^ self
		root: aFileReferenceOrPath asFileReference
		projectsHome: self _defaultProjectsHome
		gemstone: gemstonePath
