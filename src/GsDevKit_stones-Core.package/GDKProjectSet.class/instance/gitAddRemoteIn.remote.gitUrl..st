git support
gitAddRemoteIn: gitRepoPath remote: remote gitUrl: gitUrl
	^ self gitaddRemoteIn: gitRepoPath with: ' ' , remote , ' ' , gitUrl