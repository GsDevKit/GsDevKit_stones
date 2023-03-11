product management
downloadProductName: productName productDirectory: downloadDirName to: downloadPath
	"curl  -L -O -s -S 'https://ftp.gemtalksystems.com/GemStone64/3.6.5/GemStone64Bit3.6.5-x86_64.Linux.zip'"

	| osName cwd downloadDir stdout |
	stdout := GsFile stdout.
	osName := System gemVersionReport at: 'osName'.
	downloadDir := downloadPath asFileReference.
	[ 
	cwd := GsFile serverCurrentDirectory.
	self chdir: downloadPath.
	stdout
		nextPutAll:
				'Downloading ' , downloadDirName , ' to ' , downloadDir pathString , ' for '
						, osName;
		lf.
	(downloadDir / downloadDirName) exists
		ifFalse: [ 
			| fmt downloadFileName |
			fmt := osName = 'Darwin'
				ifTrue: [ 'dmg' ]
				ifFalse: [ 'zip' ].
			downloadFileName := downloadDirName , '.' , fmt.
			(downloadDir / downloadFileName) exists
				ifFalse: [ 
					self
						executeCommandLine:
							'/usr/bin/curl  -L -O -s -S "https://ftp.gemtalksystems.com/GemStone64/'
								, productName , '/' , downloadFileName , '"' ].
			fmt = 'zip'
				ifTrue: [ self executeCommandLine: '/usr/bin/unzip ' , downloadFileName ]
				ifFalse: [ 
					| volumeList stream line volume |
					"
		VOLUME=`hdiutil attach ${dlname}.dmg | grep Volumes | awk '{print $3}'`
		cp -rf $VOLUME/${dlname} .
		hdiutil detach $VOLUME
"
					stdout
						nextPutAll: 'Current directory: ' , cwd , ' downloadPath: ' , downloadPath;
						lf.
					volumeList := self
						executeCommandLine: '/usr/bin/hdiutil attach ' , downloadFileName.
					stream := volumeList readStream.
					[ stream atEnd ]
						whileFalse: [ 
							line := stream nextLine asArrayOfSubstrings.
							(line size = 3 and: [ (line at: 3) beginsWith: '/Volumes' ])
								ifTrue: [ volume := (line at: 3) asFileReference ] ].
					volume / downloadFileName copyAllTo: downloadFileName asFileReference.
					self executeCommandLine: '/usr/bin/hdiutil detach ' , volume pathString ] ] ]
		ensure: [ self chdir: cwd ]