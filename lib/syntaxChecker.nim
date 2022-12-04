import types
import sequtils
import strutils
import utils

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
