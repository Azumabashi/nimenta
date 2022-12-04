import strutils
import types
import patty

variant Token:
  CHAR(content: string)
  COMMAND(name: string)
  

proc getContent(path: string): seq[string] = 
  var file = open(path, FileMode.fmRead)
  defer:
    close(file)
  result = file.readAll().split("\n")

proc syntaxParser*(path: string): seq[Nimenta] = 
  let contents = path.getContent
  var parsed: seq[Nimenta] = @[]