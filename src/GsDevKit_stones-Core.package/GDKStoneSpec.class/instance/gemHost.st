accessing
gemHost
	^ gemHost ifNil: [ gemHost := GDKConfiguration hostName ]