######################################################
# Arturo
# Programming Language + Bytecode VM compiler
# (c) 2019-2020 Yanis Zafirópulos
#
# @file: arturo.nim
######################################################

#=======================================
# Libraries
#=======================================

import parseopt, strformat, strutils, tables, times

when defined(PROFILE):
    import nimprof

import translator/eval, translator/parse
import vm/exec, vm/value

when defined(BENCHMARK):
    import strutils
    import utils

#=======================================
# Constants
#=======================================

const 
    Version = static readFile("version").strip()
    Build = static readFile("build_number").strip()

#=======================================
# Types
#=======================================

type
    CmdAction = enum
        execFile
        evalCode
        showHelp
        showVersion

#=======================================
# Globals
#=======================================

let versionTxt = "arturo v/" & Version

let helpTxt = """

Usage:
  arturo [options] <path>

Options:
  -e --evaluate       Evaluate given code
  -c --console        Show repl / interactive console
  -h --help           Show this help screen
  -v --version        Show current version
"""
    
#=======================================
# Main entry
#=======================================

when isMainModule:

    var token = initOptParser()

    var action: CmdAction = evalCode
    var filename: string = ""
    var runConsole = static readFile("src/tools/console.art")
    var code: string = ""
    var arguments: ValueArray = @[]

    while true:
        token.next()
        case token.kind:
            of cmdArgument: 
                if code=="":
                    action = execFile
                    code = token.key
                else:
                    arguments.add(newString(token.key))
            of cmdShortOption, cmdLongOption:
                case token.key:
                    of "c","console":
                        action = evalCode
                        code = runConsole
                    of "e","evaluate":
                        action = evalCode
                        code = token.val
                    of "h","help":
                        action = showHelp
                    of "v","version":
                        action = showVersion
                    else:
                        echo "error: unrecognized option (" & token.key & ")"
            of cmdEnd: break

    case action:
        of execFile, evalCode:
            if code=="":
                code = runConsole

            when defined(BENCHMARK):
                benchmark "doParse / doEval":
                    let parsed = doParse(move code, isFile = action==execFile)
                    let evaled = parsed.doEval()
            else:
                var env: ValueDict = initOrderedTable[string,Value]()
                env["arg"] = newArray(arguments)

                env["Arturo"] = newDictionary({
                    "author"    : newString("Yanis Zafirópulos"),
                    "copyright" : newString("(c) 2019-2020"),
                    "version"   : newString(Version),
                    "build"     : newString(Build),
                    "buildDate" : newString(now().format("dd-MM-yyyy")),
                    "cpu"       : newString(hostCPU),
                    "os"        : newString(hostOS)
                }.toOrderedTable)
                let parsed = doParse(move code, isFile = action==execFile)
                let evaled = parsed.doEval()
                initVM()
                discard doExec(evaled, withSyms=addr env)

                showVMErrors()
        of showHelp:
            echo helpTxt
        of showVersion:
            echo versionTxt