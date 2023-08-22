utils
link: options target: targetPath linkName: linkPath
	"create link to targetPath with name linkName"

	self
		executeCommandLine:
			'/bin/ln ' , options , ' ' , targetPath asFileReference fullName , ' '
				, linkPath asFileReference fullName