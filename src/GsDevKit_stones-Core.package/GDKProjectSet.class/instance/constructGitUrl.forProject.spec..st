creation
constructGitUrl: type forProject: projectName spec: organizationArray
	"
		'https://github.com/dalehenrich/filetree.git' 
		'git@github.com:dalehenrich/filetree.git'
		'git@git.gemtalksystems.com:filetree.git'
	"

	| site organization |
	site := organizationArray at: 1.
	organization := organizationArray size = 2
		ifTrue: [ (organizationArray at: 2) , '/' ]
		ifFalse: [ 
			organizationArray size = 1
				ifFalse: [ 
					self
						error:
							'organization array (' , organizationArray printString
								, ' must be of size one or two' ].
			'/' ].
	type = 'https'
		ifTrue: [ ^ 'https://' , site , '/' , organization , projectName , '.git' ]
		ifFalse: [ 
			type = 'ssh'
				ifTrue: [ ^ 'git@' , site , ':' , organization , projectName , '.git' ]
				ifFalse: [ self error: 'type must be either ''https'' or ''ssh''.' ] ]