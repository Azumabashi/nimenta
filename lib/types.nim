type
  ContentType* {.pure.} = enum
    headline,
    text,
    quote
  Nimenta* = ref object of RootObj
    content*: string
    ctype*: ContentType