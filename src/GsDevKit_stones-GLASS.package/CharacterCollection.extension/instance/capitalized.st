*gsdevkit_stones-glass
capitalized
  "Return a copy with the first letter capitalized"
  | cap |
  self size == 0 ifTrue: [ ^ self copy ].
  cap := self copy.
  cap at: 1 put: (cap at: 1) asUppercase.
  ^ cap
