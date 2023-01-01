as yet unspecified
registry_home
  | dir |
  dir := (self data_home asFileReference / 'registry')
    asFileReference.
  dir ensureCreateDirectory.
  ^ dir
