accessing
stoneHost
	^ stoneHost ifNil: [ stoneHost := GDKConfiguration hostName ]