stash
promptString
  promptString
    ifNil: [ promptString := 'tode ' , self shellId asString , ' >' ].
  ^ promptString
