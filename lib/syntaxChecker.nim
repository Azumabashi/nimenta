import types

proc syntaxChecker*(contents: seq[Nimenta]): bool = 
  var idx = 0
  while idx < contents.len:
    case contents[idx].ctype
    of ContentType.command:
      case contents[idx].content
      of r"\documentclass", r"\begin", r"\end", r"\textbf":
        if contents[idx + 1].ctype == ContentType.group:
          assert syntaxChecker(contents[idx+1].inGroup)
          idx += 2
        else:
          return false
    of ContentType.commandWithoutArgs:
      idx += 1
    of ContentType.group:
      assert syntaxChecker(contents[idx].inGroup)
      idx += 1
    of ContentType.openGroup:
      # OpenGroup should not come here
      return false
    of ContentType.quote:
      idx += 1
    of ContentType.text:
      idx += 1
  return true
