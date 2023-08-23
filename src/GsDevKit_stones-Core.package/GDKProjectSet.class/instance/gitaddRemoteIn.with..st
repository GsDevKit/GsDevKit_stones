git support
gitaddRemoteIn: gitRepoPath with: args
	^ Rowan gitTools performGitCommand: 'remote add' in: gitRepoPath with: args