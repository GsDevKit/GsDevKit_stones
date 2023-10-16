product management
populateClientLibsIn: productsDirPath fromProductNamed: productName ifAbsent: absentBlock
	| productsDir productTreeDir clientLibDir libDir libNames readOnlyPermissions |
	productsDir := productsDirPath asFileReference.
	productTreeDir := (self products at: productName ifAbsent: absentBlock)
		asFileReference.
	clientLibDir := productsDir / 'clientlibs'.
	clientLibDir ensureCreateDirectory.
	libDir := clientLibDir / '64bit' / productName.
	libDir ensureCreateDirectory.
	libNames := #('libgcirpc' 'libgcits' 'libkrb5' 'libssl').
	readOnlyPermissions := FileSystemPermission posixPermissions: 8r444.
	(productTreeDir / 'lib') children
		do: [ :each | 
			(each extension = 'so'
				and: [ 
					(libNames detect: [ :libName | each basename beginsWith: libName ] ifNone: [  ])
						notNil ])
				ifTrue: [ 
					| target |
					target := libDir / each basename.
					target exists
						ifTrue: [ target ensureDelete ].
					each copyTo: target.
					target permissions: readOnlyPermissions ] ]