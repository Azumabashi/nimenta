type
  ContentType {.pure.} = enum
    headline,
    text,
    quote
  Nimenta = ref object
    content: string