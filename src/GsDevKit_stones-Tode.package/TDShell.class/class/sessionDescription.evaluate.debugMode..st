instance creation
sessionDescription: sessionDescription evaluate: script debugMode: aBool
	"return an array of command results, with one result per command"

	| shell |
	shell := self sessionDescription: sessionDescription debugMode: aBool.
	shell batchMode: true.
	[ ^ shell evaluate: script ]
		ensure: [ shell logout ]