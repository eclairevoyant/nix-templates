import std/[parseopt]

proc showHelp() =
  stderr.writeLine("TBI") # TODO implement
  quit()

var
  optParser = initOptParser(shortNoVal = {'h', 'v'}, longNoVal = @["help", "verbose"])
  argCount = 0
  optDir = "."
  optVerbose: bool

for kind, key, val in optParser.getopt():
  case kind
  of cmdArgument:
    # TODO logic here with `key`
    inc argCount
  of cmdLongOption, cmdShortOption:
    case key
    of "help", "h": showHelp()
    of "verbose", "v":
      optVerbose = true
  of cmdEnd: discard # impossible
