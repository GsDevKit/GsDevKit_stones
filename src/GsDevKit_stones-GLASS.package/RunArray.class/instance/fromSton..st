printing
fromSton: stonReader
  stonReader
    parseMapDo: [ :instVarName :value | self instVarNamed: instVarName put: value ]
