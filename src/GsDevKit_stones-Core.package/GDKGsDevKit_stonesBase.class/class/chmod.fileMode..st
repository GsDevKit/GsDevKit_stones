utils
chmod: path fileMode: symbolicModes
	"chmod of file using symbolic representation of changes to make"

	self
		executeCommandLine:
			'/bin/chmod ' , symbolicModes , ' ' , path asFileReference pathString