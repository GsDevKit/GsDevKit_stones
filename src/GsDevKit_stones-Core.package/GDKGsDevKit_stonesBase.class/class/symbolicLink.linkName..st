utils
symbolicLink: targetPath linkName: linkPath
	"create symbolic link to targetPath with name linkPath"

	self link: '-s' target: targetPath linkName: linkPath