import strutils

proc getContent(path: string): seq[string] = 
  var file = open(path, FileMode.fmRead)
  defer:
    close(file)
  result = file.readAll().split("\n")