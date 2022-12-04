type
  ContentType* {.pure.} = enum
    command,
    commandWithoutArgs,
    text,
    quote,
    group,
    openGroup
  Style* {.pure.} = enum
    default
    bold
  Nimenta* = ref object of RootObj
    content*: string
    ctype*: ContentType
    inGroup*: seq[Nimenta]
    style*: Style