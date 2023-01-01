as yet unspecified
_envName: envName defaultDir: defaultDir
  ((System gemEnvironmentVariable: 'XDG_' , envName , '_HOME')
    ifNotNil: [ :path | 
      | config_home |
      config_home := path asFileReference.
      config_home isRelativePath
        ifTrue: [ 
          "invalid specification"
          nil ]
        ifFalse: [ ^ config_home / self _applicationName ] ])
    ifNil: [ ^ defaultDir asFileReference / self _applicationName ]
