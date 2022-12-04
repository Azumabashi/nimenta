import strutils
import types
import patty
import nimly
import algorithm

variant Token:
  CHAR(content: string)
  COMMAND(cmdName: string)
  LGROUP
  RGROUP
  IGNORE

niml Lexer[Token]:
  r"\\\w*":
    return COMMAND(token.token)
  r"\{":
    return LGROUP()
  r"}":
    return RGROUP()
  r"\\n":
    return IGNORE()
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
    stack: seq[Nimenta] = @[]
    openedGroup = 0
  for tok in lexer.lexIter:
    case tok.kind
    of TokenKind.COMMAND:
      let val = Nimenta(
        content: tok.cmdName,
        ctype: ContentType.command,
      )
      if openedGroup == 0:
        parsed.add(val)
      else:
        stack.add(val)
    of TokenKind.CHAR:
      let val = Nimenta(
        content: tok.content,
        ctype: ContentType.text,
      )
      if openedGroup == 0:
        parsed.add(val)
      else:
        stack.add(val)
    of TokenKind.LGROUP:
      openedGroup += 1
      stack.add(Nimenta(
        ctype: ContentType.openGroup
      ))
    of TokenKind.RGROUP:
      openedGroup -= 1
      var val = Nimenta(
        ctype: ContentType.group
      )
      while stack[stack.len - 1].ctype != ContentType.openGroup:
        val.inGroup.add(stack.pop())
      val.inGroup.reverse()
      discard stack.pop()  # discard openGroup
      parsed.add(val)
    of TokenKind.IGNORE:
      discard  # do nothing
  return parsed