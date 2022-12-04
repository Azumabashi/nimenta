import types
import sequtils
import strutils

proc join(contents: seq[Nimenta]): string = 
  result = contents.map(
    proc(content: Nimenta): string = 
      if content.ctype == ContentType.text:
        result = content.content
      elif content.ctype == ContentType.group:
        result = join(content.inGroup)
      else:
        echo "Syntax Error: env name should be contain only merely string and should not be contain other things (i,e., groups)."
        quit(1)
  ).join("")

proc syntaxChecker*(contents: seq[Nimenta]): bool = 
  var 
    idx = 0
    envNameStack: seq[string] = @[]
  while idx < contents.len:
    case contents[idx].ctype
    of ContentType.command:
      case contents[idx].content
      of r"\documentclass":
        if idx == 0 and contents[idx + 1].ctype == ContentType.group:
          assert syntaxChecker(contents[idx+1].inGroup)
          idx += 2
        else:
          return false
      of r"\begin", r"\end":
        if idx == 0 and contents[idx + 1].ctype == ContentType.group:
          assert syntaxChecker(contents[idx+1].inGroup)
          if contents[idx].content == r"\begin":
            envNameStack.add(contents[idx+1].inGroup.join)
          else:
            let nowGroup = envNameStack.pop()
            if contents[idx+1].inGroup.join != nowGroup:
              echo "Error: Environment does not match!!!"
              return false
          idx += 2
        else:
          return false
      else:
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
