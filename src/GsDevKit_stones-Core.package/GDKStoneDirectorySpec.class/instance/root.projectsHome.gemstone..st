as yet unspecified
root: aFileReference projectsHome: aProjectsHome gemstone: gemstonePath
	root := aFileReference asFileReference.
	root ensureDeleteAll.
	aFileReference ensureCreateDirectory.
	self projectsHome: aProjectsHome.
	self gemstone: gemstonePath.
	self class instVarNames
		do: [ :iv | 
			(#(#'root' #'projectHome' #'gemstone') includes: iv)
				ifFalse: [ self perform: (iv , 'Dir') asSymbol ] ].
	aFileReference / 'directorySpec.ston'
		writeStreamDo: [ :stream | self exportToStream: stream ]
