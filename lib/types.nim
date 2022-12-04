type
  ContentType* {.pure.} = enum
    command,
    text,
    quote,
    group,
    openGroup
  Nimenta* = ref object of RootObj
    content*: string
    ctype*: ContentType