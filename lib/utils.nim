import types
import sequtils
import strutils

proc join*(contents: seq[Nimenta]): string = 
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