accessing
configFile
	| config_home |
	config_home := self data_home.
	config_home ensureCreateDirectory.
	^ config_home / 'registry.ston'