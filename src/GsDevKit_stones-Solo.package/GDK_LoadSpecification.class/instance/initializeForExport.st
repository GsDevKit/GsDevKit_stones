initialization
initializeForExport
	"preserve projectsHome on export ... projetsHome is the important piece of info"

	| myProjectsHome |
	myProjectsHome := projectsHome.
	super initializeForExport.
	projectsHome := myProjectsHome