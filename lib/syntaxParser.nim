import strutils
import types
import patty
import nimly
import algorithm

variant Token:
  CHAR(content: string)
  COMMAND(cmdName: string)
  CMDWITHOUTARGS(cmdWithoutArgsName: string)
  LGROUP
  RGROUP
  IGNORE

niml Lexer[Token]:
  r"\\\w*;":
    return CMDWITHOUTARGS(token.token)
  r"\\\w*":
    return COMMAND(token.token)
  r"\{":
    return LGROUP()
  r"}":
    return RGROUP()
  "\n":
    return IGNORE()
  r"[亜-熙ぁ-んァ-ヶ．][亜-熙ぁ-んァ-ヶ．][亜-熙ぁ-んァ-ヶ．]":
    return CHAR(token.token)
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
    of TokenKind.COMMAND, TokenKind.CMDWITHOUTARGS:
      let val = Nimenta(
        content: if tok.kind == TokenKind.Command: tok.cmdName else: tok.cmdWithoutArgsName[0..tok.cmdWithoutArgsName.len-2],
        ctype: if tok.kind == TokenKind.Command: ContentType.command else: ContentType.commandWithoutArgs,
        style: Style.default,
      )
      if openedGroup == 0:
        parsed.add(val)
      else:
        stack.add(val)
    of TokenKind.CHAR:
      let val = Nimenta(
        content: tok.content,
        ctype: ContentType.text,
        style: Style.default,
      )
      if openedGroup == 0:
        parsed.add(val)
      else:
        stack.add(val)
    of TokenKind.LGROUP:
      openedGroup += 1
      stack.add(Nimenta(
        ctype: ContentType.openGroup,
        style: Style.default,
      ))
    of TokenKind.RGROUP:
      openedGroup -= 1
      var val = Nimenta(
        ctype: ContentType.group,
        style: Style.default,
      )
      while stack[stack.len - 1].ctype != ContentType.openGroup:
        val.inGroup.add(stack.pop())
      val.inGroup.reverse()
      discard stack.pop()  # discard openGroup
      if openedGroup == 0:
        parsed.add(val)
      else:
        stack.add(val)
    of TokenKind.IGNORE:
      discard  # do nothing
  return parsed