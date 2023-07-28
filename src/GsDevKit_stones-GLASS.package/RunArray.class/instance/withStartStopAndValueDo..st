accessing
withStartStopAndValueDo: aBlock
	| start stop |
	start := 1.
	runs with: values do:
		[:len : val | stop := start + len - 1.
		aBlock value: start value: stop value: val.
		start := stop + 1]