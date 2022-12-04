type
  ContentType* {.pure.} = enum
    command,
    commandWithoutArgs,
    text,
    quote,
    group,
    openGroup
  Nimenta* = ref object of RootObj
    content*: string
    ctype*: ContentType
    inGroup*: seq[Nimenta]