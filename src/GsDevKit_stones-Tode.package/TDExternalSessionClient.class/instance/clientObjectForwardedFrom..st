accessing
clientObjectForwardedFrom: anOopType
    ^ self clientForwarderCache at: anOopType ifAbsent: [ ^ nil ]