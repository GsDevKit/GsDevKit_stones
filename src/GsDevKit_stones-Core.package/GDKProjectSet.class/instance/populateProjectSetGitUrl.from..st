creation
populateProjectSetGitUrl: type from: specDictionary
	"
	The specDictionary has keys and values that look like the following STON dictionary. Each key is a project name
	whose value is another dictionary with a specification for the git url to be used to clone the project repository. 
	{
		'metacello-work' : {
			'revision' : 'master',
			'gitUrls' : {
				'origin' : [
				'github.com',
				'dalehenrich'
				],
				'gs' : [
				'git.gemtalksystems.com',
				''
				]
			}
		}
	}
	"

	specDictionary
		keysAndValuesDo: [ :projectName :projectDict | 
			| specDict |
			specDict := Dictionary new
				at: 'revision' put: (projectDict at: 'revision');
				yourself.
			(projectDict at: 'gitUrls')
				keysAndValuesDo: [ :origin :specArray | 
					| gitUrl |
					gitUrl := self
						constructGitUrl: type
						forProject: projectName
						spec: specArray.
					(specDict at: 'gitUrls' ifAbsentPut: [ Dictionary new ])
						at: origin
						put: gitUrl ].
			self loadSpecs at: projectName put: specDict ]