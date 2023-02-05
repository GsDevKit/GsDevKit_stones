xdgb accessing
data_home
	| dir |
	dir := GDKGsDevKit_stonesBase data_home.
	dir ensureCreateDirectory.
	^ dir