product management
downloadProductName: productName productFile: downloadFileName to: downloadPath
	"curl  -L -O -s -S 'https://ftp.gemtalksystems.com/GemStone64/3.6.5/GemStone64Bit3.6.5-x86_64.Linux.zip'"

	| cwd downloadDir |
	downloadDir := downloadPath asFileReference.
	[ 
	cwd := GsFile serverCurrentDirectory.
	self class chdir: downloadPath.
	(downloadDir / downloadFileName) exists
		ifFalse: [ 
			(downloadDir / downloadFileName , 'zip') exists
				ifFalse: [ 
					self class
						executeCommandLine:
							'/usr/bin/curl  -L -O -s -S "https://ftp.gemtalksystems.com/GemStone64/'
								, productName , '/' , downloadFileName , '.zip' , '"' ].
			self class executeCommandLine: '/usr/bin/unzip ' , downloadFileName , '.zip' ] ]
		ensure: [ self class chdir: cwd ]