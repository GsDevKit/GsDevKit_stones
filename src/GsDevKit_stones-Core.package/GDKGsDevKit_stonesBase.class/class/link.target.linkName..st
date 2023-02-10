utils
link: options target: targetPath linkName: linkPath
	"create link to targetPathString with name linkName"

	self
		executeCommandLine:
			'/usr/bin/ln ' , options , ' ' , targetPath asFileReference pathString , ' '
				, linkPath asFileReference pathString