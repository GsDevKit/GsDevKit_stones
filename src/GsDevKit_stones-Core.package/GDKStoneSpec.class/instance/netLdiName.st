accessing
netLdiName
	^ netLdiName ifNil: [ netLdiName := self stoneName , '_ldi' ]