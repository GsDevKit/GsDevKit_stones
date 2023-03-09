utils
chmod: path fileMode: symbolicModes
	"chmod of file using symbolic representation of changes to make"

	| chmod |
	chmod := (System gemVersionReport at: 'osName') = 'Darwin'
		ifTrue: [ '/bin/chmod ' ]
		ifFalse: [ '/usr/bin/chmod ' ].
	self
		executeCommandLine:
			chmod , symbolicModes , ' ' , path asFileReference pathString