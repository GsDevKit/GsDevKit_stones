accessing
configFile
	| config_home |
	config_home := self config_home.
	config_home ensureCreateDirectory.
	^ config_home / 'configuration.ston'