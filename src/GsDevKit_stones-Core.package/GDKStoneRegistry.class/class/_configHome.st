as yet unspecified
_configHome
	^ (System gemEnvironmentVariable: 'System XDG_CONFIG_HOME')
		ifNil: [ 
			| defaultConfigHome |
			defaultConfigHome := '$HOME/.config'.
			System
				gemEnvironmentVariable: 'System XDG_CONFIG_HOME'
				put: defaultConfigHome.
			defaultConfigHome ]
