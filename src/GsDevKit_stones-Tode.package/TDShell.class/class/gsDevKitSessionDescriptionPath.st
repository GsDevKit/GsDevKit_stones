home
gsDevKitSessionDescriptionPath
	| clientDescriptionsPath "allow new client to connect to an old gsDevKitHome structure" |
			clientDescriptionsPath := 'client/descriptions/'.
			self useTodeSys
				ifTrue: [ ^ self todeClientSysLocalPath , clientDescriptionsPath ].
			^ self todeRoot , '/' , clientDescriptionsPath , '/'
