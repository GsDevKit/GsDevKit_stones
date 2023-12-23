backup/restore
copydbf: args forFilePath: filePath
  | copyDbfCommand |
  copyDbfCommand := (GsFile _expandEnvVariable: 'GEMSTONE' isClient: false)
    , '/bin/copydbf ' , args , ' ' , filePath.
  ^ Rowan gitTools performOnServer: copyDbfCommand logging: true