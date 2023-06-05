server blocks
onServer: sessionName do: aBlock
	| shell |
	shell := TDShell forSessionNamed: sessionName.
	[ shell onServerDo: aBlock ]
		ensure: [ shell windowIsClosing ]
