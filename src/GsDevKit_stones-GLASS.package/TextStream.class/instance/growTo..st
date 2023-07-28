accessing
growTo: anInteger
   " anInteger is the required minimal new size of the collection "
  | oldSize newSize |
  oldSize := itsCollection size.
     newSize := anInteger + (oldSize // 4 max: 20).
  itsCollection size: newSize