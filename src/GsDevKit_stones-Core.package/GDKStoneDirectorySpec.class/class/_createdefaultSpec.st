private
_createdefaultSpec
	"self _createdefaultSpec"

	((Rowan projectNamed: 'GsDevKit_stones') repositoryRoot / 'templates'
		/ 'defaultDirectorySpec.ston') asFileReference
		writeStreamDo: [ :stream | stream nextPutAll: (STON toStringPretty: GDKStoneDirectorySpec new) ]
