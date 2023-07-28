instance creation
streamContents: blockWithArg 
	| stream |
	stream := TextStream on: self new.
	blockWithArg value: stream.
	^ stream contents