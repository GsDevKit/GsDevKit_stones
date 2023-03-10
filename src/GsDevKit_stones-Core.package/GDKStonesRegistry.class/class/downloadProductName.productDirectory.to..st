product management
downloadProductName: productName productDirectory: downloadDirName to: downloadPath
	"curl  -L -O -s -S 'https://ftp.gemtalksystems.com/GemStone64/3.6.5/GemStone64Bit3.6.5-x86_64.Linux.zip'"

	| osName cwd downloadDir |
	osName := System gemVersionReport at: 'osName'.
	downloadDir := downloadPath asFileReference.
	[ 
	cwd := GsFile serverCurrentDirectory.
	self chdir: downloadPath.
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
					| volume |
					"
		VOLUME=`hdiutil attach ${dlname}.dmg | grep Volumes | awk '{print $3}'`
		cp -rf $VOLUME/${dlname} .
		hdiutil detach $VOLUME
"
					volume = '/usr/bin/hdiutil attach ' , downloadFileName.
					self halt ] ] ]
		ensure: [ self chdir: cwd ]