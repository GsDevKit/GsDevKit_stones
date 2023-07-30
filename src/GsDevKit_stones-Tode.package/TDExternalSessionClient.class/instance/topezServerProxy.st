accessing
topezServerProxy
	^ topezServerProxy
		ifNil: [ 
			| jsonString transcriptOopType resultArray topezServerOop topezClientOopType todeServerCreationString serializeResultString |
			[ 
			todeServerCreationString := self todeServerCreationString.
			jsonString := self session executeString: todeServerCreationString ]
				on: GsErrorNotification
				do: [ :firstEx | 
					"try again with no options, in case using old version of tode ... eventually get rid of this"
					[ 
					todeServerCreationString := self todeServerCreationStringWithOptions: false.
					jsonString := self session nbExecute: todeServerCreationString ]
						on: GsErrorNotification
						do: [ :ex | 
							self
								error:
									'Unable to log into server:' , ex description , 'with: '
										, todeServerCreationString printString ] ].
"
 ^ {(topezServer asOop).
  transcriptClientForwarderOop.
  (Reflection oopOf: topezClientClientForwarder).
  (TodeObjectSerializer protocolSignatureArray).
  (self todeServerAPIVersionString)}
"
			resultArray := STON fromString: jsonString.
			topezServerOop := resultArray at: 1.
			topezClientOopType := resultArray at: 3.
			topezServerProxy := topezServerOop. "instance variable in receiver"
			(resultArray at: 2)
				ifNotNil: [ :transcriptOop | 
					transcriptOopType := transcriptOop.
					self clientForwarderCache at: transcriptOopType put: GsFile stdout ].
			self clientForwarderCache at: topezClientOopType put: self.
			resultArray size > 3
				ifTrue: [ 
					| protocolSignature objSerializer serverApiVersionString |
					protocolSignature := resultArray at: 4.
					objSerializer := STON.

					serializeResultString := self
						_serverSerializeObjectsUser: objSerializer name asString
						version: '0.9.1'
						to: topezServerOop.

					serverApiVersionString := resultArray size > 4
						ifTrue: [ resultArray at: 5 ]
						ifFalse: [ '1.0.0' ].
					self serverApiVersion: serverApiVersionString asRwSemanticVersionNumber ].
			self effectiveApiVersion >= '1.3.0' asRwSemanticVersionNumber
				ifTrue: [ 
					self
						_serverEffectiveApiVersion: self effectiveApiVersion asString
						to: topezServerOop ].
			self sessionDescription backupDirectory isEmpty not
				ifTrue: [ 
					self
						_serverBackupDirectory: self sessionDescription backupDirectory
						to: topezServerOop ].
			self sessionDescription snapshotDirectory isEmpty not
				ifTrue: [ 
					self
						_serverSnapshotDirectory: self sessionDescription snapshotDirectory
						to: topezServerOop ].
			TZGemStoneProxyBehavior new
				topez: self;
				allGlobalNames;
				yourself ]