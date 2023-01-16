accessing
stoneDirectorySpecName
	^ stoneDirectorySpecName ifNil: [ stoneDirectorySpecName := 'default' ]