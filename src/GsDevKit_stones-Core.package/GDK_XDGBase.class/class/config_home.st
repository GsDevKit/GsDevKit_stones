as yet unspecified
config_home
  ^ (self _envName: 'CONFIG' defaultDir: '$HOME/.config')
    ifNotNil: [ :dir | 
      dir ensureCreateDirectory.
      dir ]
