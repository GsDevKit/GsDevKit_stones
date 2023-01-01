xdgb accessing
registry_home
  | dir |
  dir := (self data_home asFileReference / self _registryName)
    asFileReference.
  dir ensureCreateDirectory.
  ^ dir