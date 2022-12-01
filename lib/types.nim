type
  ContentType {.pure.} = enum
    headline,
    text,
    quote
  Nimenta = ref object 
    content: string
    ctype: ContentType
  Heading = ref object of Nimenta
    level: int