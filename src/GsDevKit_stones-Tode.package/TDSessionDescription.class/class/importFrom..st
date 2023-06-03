instance creation
importFrom: filepath
  [ 
  FileStream
    readOnlyFileNamed: filepath
    do: [ :fileStream | 
      ^ ((Rowan globalNamed: 'TodeObjectSerializer') preferredSerializer fromString: fileStream contents)
        asTDSessionDescription ] ]
    on: ((Rowan globalNamed: 'Smalltalk') at: #'FileDoesNotExistException' ifAbsent: [ Error ])
    do: [ :ex | 
      self
        error:
          'The session description file ' , filepath printString , ' cannot be found.' ]
