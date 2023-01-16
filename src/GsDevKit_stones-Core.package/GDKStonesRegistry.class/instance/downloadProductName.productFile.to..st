product management
downloadProductName: productName productFile: downloadFileName to: downloadPath
	"curl  -L -O -s -S 'https://ftp.gemtalksystems.com/GemStone64/3.6.5/GemStone64Bit3.6.5-x86_64.Linux.zip'"

	| cwd downloadDir |
	downloadDir := downloadPath asFileReference.
	[ 
	cwd := GsFile serverCurrentDirectory.
	GsFile _directoryPrim: 0 with: downloadPath with: nil.	"change dir"
	(downloadDir / downloadFileName) exists
		ifFalse: [ 
			(downloadDir / downloadFileName , 'zip') exists
				ifFalse: [ 
					self class
						executeCommandLine:
							'/usr/bin/curl  -L -O -s -S "https://ftp.gemtalksystems.com/GemStone64/'
								, productName , '/' , downloadFileName , '.zip' , '"'
						andInput: nil ].
			self class
				executeCommandLine: '/usr/bin/unzip ' , downloadFileName , '.zip'
				andInput: nil ] ]
		ensure: [ GsFile _directoryPrim: 0 with: cwd with: nil	"change dir" ]