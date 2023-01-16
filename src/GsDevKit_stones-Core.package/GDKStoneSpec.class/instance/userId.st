accessing
userId
	^ userId ifNil: [ userId := 'SystemUser' ]