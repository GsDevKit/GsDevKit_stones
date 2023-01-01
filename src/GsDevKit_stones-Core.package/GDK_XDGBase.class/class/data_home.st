as yet unspecified
data_home
  ^ (self _envName: 'DATA' defaultDir: '$HOME/.local/share')
    ifNotNil: [ :dir | 
      dir ensureCreateDirectory.
      dir ]
