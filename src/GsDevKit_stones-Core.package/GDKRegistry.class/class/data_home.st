as yet unspecified
data_home
  | dir |
  dir := GDK_XDGBase data_home / 'registry'.
  dir ensureCreateDirectory.
  ^ dir
