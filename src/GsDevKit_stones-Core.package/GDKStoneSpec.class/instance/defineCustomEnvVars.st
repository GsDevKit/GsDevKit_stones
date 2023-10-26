runtime
defineCustomEnvVars
	self stoneDirectorySpec
		ifNotNil: [ :dirSpec | 
			dirSpec customenv
				ifNotNil: [ :customenv |
					| customenvRef block | 
					customenvRef := root asFileReference / 'customenv'.
					block := [ :varName :valueStr | 
						GsFile stdout nextPutAll: 'defineCustomEnvVars [1] ', varName printString , ' = ', valueStr printString; lf.
						System gemEnvironmentVariable: varName put: valueStr ].
					customenvRef exists
						ifTrue: [
							| stream |
							"customenv file has precedence"
							stream := PositionableStreamPortable on: customenvRef contents.
								[ stream atEnd ] whileFalse: [
										| line index keyAndValue |
								 	line := stream nextLine trimBoth.
									(line beginsWith: '#')
										ifFalse: [
											"looking for 'export xxx=yyy'"
											index := line indexOfSubCollection: 'export' startingAt: 1.
											GsFile stdout nextPutAll: 'defineCustomEnvVars [2] ', line printString; lf.
											(index > 0)
												ifTrue: [ 
													" export at beginning of line"
													line := line copyFrom: index + 'export ' size to: line size.
													keyAndValue := line subStringsDelimitedBy: $=.
													block value: (keyAndValue at: 1) value: (keyAndValue at: 2) ] ] ] ] 
						ifFalse: [ customenv keysAndValuesDo: block ] ]]