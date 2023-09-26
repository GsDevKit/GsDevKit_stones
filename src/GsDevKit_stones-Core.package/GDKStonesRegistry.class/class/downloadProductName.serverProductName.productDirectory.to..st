product management
downloadProductName: productName serverName: serverName productDirectory: downloadDirName to: downloadPath
	"curl  -L -o GemStone64Bit3.7.0_rowanv3-Alpha1-x86_64.Linux.zip -s -S 'https://ftp.gemtalksystems.com/GemStone64/370_rowanv3-Alpha1/GemStone64Bit3.7.0-x86_64.Linux.zip'"

	| osName cwd downloadDir stdout fmt|
	stdout := GsFile stdout.
	osName := System gemVersionReport at: 'osName'.
	fmt := osName = 'Darwin'
		ifTrue: [ 'dmg' ]
		ifFalse: [ 'zip' ].
	downloadDir := downloadPath asFileReference.
	[ 
	cwd := GsFile serverCurrentDirectory.
	self chdir: downloadPath.
	stdout
		nextPutAll:
				'Downloading ' , productName, '/', downloadDirName , '.' , fmt , ' to ' , (downloadDir / serverName) fullName , ' for '
						, osName;
		lf.
	(downloadDir / serverName) exists
		ifFalse: [ 
			| downloadFileName |
			downloadFileName := serverName , '.' , fmt.
			(downloadDir / downloadFileName) exists
				ifFalse: [ 
					self
						executeCommandLine:
							'/usr/bin/curl  -L -o ', downloadFileName, ' -s -S "https://ftp.gemtalksystems.com/GemStone64/'
								, productName , '/' , downloadDirName, '.', fmt , '"' ].
			fmt = 'zip'
				ifTrue: [ 
					self executeCommandLine: '/usr/bin/unzip ' , downloadFileName, ' -d tmp'.
					self executeCommandLine: '/usr/bin/mv tmp/', downloadDirName, ' ' , serverName.
					self executeCommandLine: '/usr/bin/rm -rf tmp'.
					(downloadDir / downloadFileName) delete ]
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
		ensure: [ self chdir: cwd ].
	^ (downloadDir / serverName) fullName
