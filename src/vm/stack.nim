######################################################
# Arturo
# Programming Language + Bytecode VM compiler
# (c) 2019-2020 Yanis Zafirópulos
#
# @file: vm/stack.nim
######################################################

#=======================================
# Libraries
#=======================================

import strformat, tables

import vm/value

#=======================================
# Constants
#=======================================

const StackSize* = 100000
const AttrsSize* = 10

#=======================================
# Globals
#=======================================

var Stack*{.threadvar.}: seq[Value]
var Attrs*: OrderedTable[string,Value]
var SP*: int
var AP*: int
var CSP*: int

#=======================================
# Methods
#=======================================

## Main stack

template push*(v: Value) = 
    Stack[SP] = v
    SP += 1

template pop*(): Value = 
    SP -= 1
    Stack[SP]

template sTop*(): Value =
    Stack[SP-1]

template sTopsFrom*(start: int): ValueArray =
    Stack[start..SP-1]

template emptyStack*() =
    SP = 0

## Attributes stack

template pushAttr*(label: string, v: Value) =
    Attrs[label] = v

template emptyAttrs*() =
    Attrs = initOrderedTable[string,Value]()

proc getAttr*(attr: string): Value =
    Attrs.getOrDefault(attr, VNULL)

proc popAttr*(attr: string): Value =
    result = Attrs.getOrDefault(attr, VNULL)
    Attrs.del(attr)

proc getAttrsDict*(): Value =
    result = newDictionary(Attrs)

    emptyAttrs()

# Debugging

proc dumpStack*() =
    var i = 0
    while i < SP:
        stdout.write fmt("{i}: ")
        var item = Stack[i]

        item.dump(0, false)

        i += 1

when defined(VERBOSE):

    proc printAttrs*() =
        for k,v in pairs(Attrs):
            echo k & " => " & $(v)
