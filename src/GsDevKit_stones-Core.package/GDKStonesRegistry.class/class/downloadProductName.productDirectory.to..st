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
				'Downloading ' , downloadDirName , ' to ' , downloadDir fullName , ' for '
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
						lf;
						nextPutAll: 'attaching: ' , downloadFileName;
						lf.
					volumeList := self
						executeCommandLine: '/usr/bin/hdiutil attach ' , downloadFileName
						stdout: nil
						andInput: nil.
					stdout
						nextPutAll: 'volumeList --- ';
						lf;
						nextPutAll: volumeList;
						lf;
						nextPutAll: '---';
						lf.
					stream := volumeList readStream.
					[ stream atEnd ]
						whileFalse: [ 
							| start |
							line := stream nextLine.
							(start := line indexOfSubCollection: '/Volumes' startingAt: 1) > 0
								ifTrue: [ 
									stdout
										nextPutAll: 'matching line: ' , line;
										lf.
									volume := (line copyFrom: start to: line size) asFileReference.
									stdout nextPutAll: 'volume: ' , volume fullName ]
								ifFalse: [ 
									stdout
										nextPutAll: 'skipped line: ' , line;
										lf ] ].
					stdout
						nextPutAll: 'volume: ' , volume fullName;
						lf.
					[ 
					stdout
						nextPutAll:
								'copying ' , (volume / downloadDirName) fullName , ' to '
										, (downloadDir / downloadDirName) fullName;
						lf.
					self
						executeCommandLine:
							'/bin/cp -R ' , (volume / downloadDirName) fullName , ' '
								, (downloadDir / downloadDirName) fullName
						stdout: nil
						andInput: nil ]
						ensure: [ 
							volume
								ifNotNil: [ self executeCommandLine: '/usr/bin/hdiutil detach ' , volume fullName ] ] ] ] ]
		ensure: [ self chdir: cwd ]