stone management
destroyStoneNamed: stoneName

	| stoneSpec |
	stoneSpec := self stoneNamed: stoneName.
	stoneSpec destroyStoneStructure