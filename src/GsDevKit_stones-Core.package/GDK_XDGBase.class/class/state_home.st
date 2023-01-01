as yet unspecified
state_home
  ^ (self _envName: 'STATE' defaultDir: '$HOME/.local/state')
    ifNotNil: [ :dir | 
      dir ensureCreateDirectory.
      dir ]
