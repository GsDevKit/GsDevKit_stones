product management
downloadProductName: productName productVersion: productVersion to: downloadPath
	"productName is the base name used for the downloaded directory containing the 
		product tree and the name of the ftp server product directory where the 
		productVersion zip file is located. If productName does not equal productVersion 
		then the zip file must be renamed after download"

	| osName cwd downloadDir stdout productTreeDirName productTreeHTTPServerDirName curlCmd |
	stdout := GsFile stdout.
	osName := System gemVersionReport at: 'osName'.
	downloadDir := downloadPath asFileReference.
	productTreeHTTPServerDirName := self downloadDirectoryNameFor: productVersion.
	productTreeDirName := productName = productVersion
		ifTrue: [ productTreeHTTPServerDirName ]
		ifFalse: [ self downloadDirectoryNameFor: productName ].
	[ 
	cwd := GsFile serverCurrentDirectory.
	self chdir: downloadDir fullName.
	stdout
		nextPutAll:
				'Downloading ' , productName , '/' , productTreeHTTPServerDirName , ' to '
						, downloadDir fullName , ' as ' , productTreeDirName , ' for ' , osName;
		lf.
	(downloadDir / productTreeDirName) exists
		ifFalse: [ 
			| fmt downloadFileName |
			fmt := osName = 'Darwin'
				ifTrue: [ 'dmg' ]
				ifFalse: [ 'zip' ].
			downloadFileName := productTreeHTTPServerDirName , '.' , fmt.
			fmt = 'zip'
				ifTrue: [ 
					(downloadDir / 'tmp') ensureCreateDirectory.
					self chdir: (downloadDir / 'tmp') fullName ]
				ifFalse: [ self chdir: downloadDir fullName ].
			curlCmd := '/usr/bin/curl  -L -O -s -S "https://ftp.gemtalksystems.com/GemStone64/'
				, productName , '/' , downloadFileName , '"'.
			self executeCommandLine: curlCmd.
			fmt = 'zip'
				ifTrue: [ 
					self executeCommandLine: '/usr/bin/unzip ' , downloadFileName.
					(downloadDir / 'tmp' / downloadFileName) delete.
					self
						executeCommandLine:
							'/bin/mv ' , productTreeHTTPServerDirName , ' '
								, (downloadDir / productTreeDirName) fullName
						stdout: nil
						andInput: nil ]
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
								'copying ' , (volume / productTreeHTTPServerDirName) fullName , ' to '
										, (downloadDir / productTreeDirName) fullName;
						lf.
					self
						executeCommandLine:
							'/bin/cp -R ' , (volume / productTreeHTTPServerDirName) fullName , ' '
								, (downloadDir / productTreeDirName) fullName
						stdout: nil
						andInput: nil ]
						ensure: [ 
							volume
								ifNotNil: [ self executeCommandLine: '/usr/bin/hdiutil detach ' , volume fullName ] ] ] ] ]
		ensure: [ self chdir: cwd ].
	^ (downloadDir / productTreeDirName) fullName