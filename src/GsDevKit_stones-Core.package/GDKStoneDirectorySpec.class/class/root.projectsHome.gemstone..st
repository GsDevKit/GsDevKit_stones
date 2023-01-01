instance creation
root: aFileReferenceOrPath projectsHome: aProjectsHome gemstone: gemstonePath
	"if aFileReferenceOrPath exists, it will be deleted and recreated ... empty"

	^ self new
		root: aFileReferenceOrPath asFileReference
			projectsHome: aProjectsHome
			gemstone: gemstonePath;
		yourself
