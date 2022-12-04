import strutils
import types
import patty
import nimly

variant Token:
  CHAR(content: string)
  COMMAND(cmdName: string)

niml Lexer[Token]:
  r"\\\w*":
    return COMMAND(token.token)
  r".":
    return CHAR(token.token)
  

proc getContent(path: string): string = 
  var file = open(path, FileMode.fmRead)
  defer:
    close(file)
  result = file.readAll()

proc syntaxParser*(path: string): seq[Nimenta] = 
  let contents = path.getContent
  var 
    parsed: seq[Nimenta] = @[]
    lexer = Lexer.newWithString(contents)
  for tok in lexer.lexIter:
    echo tok