xdgb accessing
base_data_home
	"use super here, because our implementation of _envName:defaultDir: needs to be used,
	since we want the value of $XDG_DATA_HOME / $STONES_DATA_HOME, which does not include
	the application name"

	^ super data_home