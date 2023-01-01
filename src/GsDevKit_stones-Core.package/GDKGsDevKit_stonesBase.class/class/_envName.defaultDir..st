private
_envName: envName defaultDir: defaultDir
	^ (super _envName: envName defaultDir: defaultDir) / self _applicationName