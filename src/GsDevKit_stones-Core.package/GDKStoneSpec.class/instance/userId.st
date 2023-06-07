accessing
userId
	^ userId
		ifNil: [ 
			stoneDirectorySpec
				ifNil: [ 'SystemUser' ]
				ifNotNil: [ userId := stoneDirectorySpec defaultUserId ] ]