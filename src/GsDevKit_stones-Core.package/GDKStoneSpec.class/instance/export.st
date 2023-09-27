export
export
	"since the password is stored in open text in the registry file, make 
		sure we've made the file readable by only the user"

	super export.
	self class chmod: self registryFile fullName fileMode: 'u+w,og-rw'