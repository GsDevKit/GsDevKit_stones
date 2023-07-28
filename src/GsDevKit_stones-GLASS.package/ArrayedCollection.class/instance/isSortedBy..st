sorting
isSortedBy: aBlock
	"Return true if the receiver is sorted by the given criterion."

	| lastElm elm |
	self isEmpty ifTrue: [^ true].
	lastElm _ self first.
	2 to: self size do: 
		[:index | 
		elm _ self at: index.
		(aBlock value: lastElm value: elm) ifFalse: [^ false].
		lastElm _ elm].
	^ true