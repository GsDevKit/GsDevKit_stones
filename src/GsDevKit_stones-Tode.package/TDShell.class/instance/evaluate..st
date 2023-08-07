evaluator engine
evaluate: aString
	"return an array of command results, with one result per command"

	^ self evaluate: aString batchMode: self batchMode