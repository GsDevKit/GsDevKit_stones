product management
populateClientLibsIn: productsDirPath fromProductNamed: productName ifAbsent: absentBlock
	| productsDir productTreeDir clientLibDir libDir libNames readOnlyPermissions libExtensions |
	productsDir := productsDirPath asFileReference.
	productTreeDir := (self products at: productName ifAbsent: absentBlock)
		asFileReference.
	clientLibDir := productsDir / 'clientlibs'.
	clientLibDir ensureCreateDirectory.
	libDir := clientLibDir / productName / '64bit'.
	libDir ensureCreateDirectory.
	libNames := #('libgcirpc' 'libgcits' 'libkrb5' 'libssl').
	libExtensions := #('so' 'dylib').
	readOnlyPermissions := FileSystemPermission posixPermissions: 8r444.
	(productTreeDir / 'lib') children
		do: [ :each | 
			(libExtensions detect: [ :libExt | libExt = each extension] ifNone: [ nil ])
			ifNotNil: [ :libExtension |  
					libNames
						do: [ :libName | 
							(each basename beginsWith: libName)
								ifTrue: [ 
									| target |
									target := libDir / each basename.
									target exists
										ifTrue: [ target ensureDelete ].
									each copyTo: target.
									target permissions: readOnlyPermissions.
									libName = 'libgcits'
										ifTrue: [ 
											| link |
											"if an alpha or beta is downloaded the product name will look 
												something like 370_rowanv3-Alpha1 and JfP will be looking 
												for a lilbgcits using that product name ... create a symbol link"
											link := libDir / (libName , '-' , productName , '-64.', libExtension).
											link basename ~= target basename
												ifTrue: [ 
													| cwd |
													link exists
														ifTrue: [ link ensureDelete ].
													[ 
													cwd := GsFile serverCurrentDirectory.
													self class chdir: link parent fullName.
													true
														ifTrue: [ 
															self class
																executeCommandLine:
																	'/bin/ln -s ' , target basename , ' ' , link basename ]
														ifFalse: [ self class symbolicLink: target basename linkName: link basename ] ]
														ensure: [ self class chdir: cwd ] ] ] ] ] ] ]