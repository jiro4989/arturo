######################################################
# Arturo
# Programming Language + Bytecode VM compiler
# (c) 2019-2020 Yanis Zafirópulos
#
# @file: library/Numbers.nim
######################################################

#=======================================
# Libraries
#=======================================

import vm/stack, vm/value

#=======================================
# Methods
#=======================================

template BinaryNot*():untyped =
    require(opBNot)
    stack.push(newInteger(not x.i))

template BinaryAnd*():untyped = 
    require(opBAnd)
    stack.push(newInteger(x.i and y.i))

template BinaryOr*():untyped =
    require(opBOr)
    stack.push(newInteger(x.i or y.i))

template BinaryXor*():untyped =
    require(opBXor)
    stack.push(newInteger(x.i xor y.i))

template Add*():untyped =
    require(opAdd)

    if x.kind==Literal:
        if syms[x.s].kind==Integer and y.kind==Integer:
            syms[x.s].i += y.i
        else:
            if syms[x.s].kind==Floating:
                if y.kind==Floating: syms[x.s].f += y.f
                else: syms[x.s].f += (float)(y.i)
            else:
                syms[x.s] = newFloating((float)(x.i)+y.f)
    else:
        if x.kind==Integer and y.kind==Integer:
            stack.push(newInteger(x.i+y.i))
        else:
            if x.kind==Floating:
                if y.kind==Floating: stack.push(newFloating(x.f+y.f))
                else: stack.push(newFloating(x.f+(float)(y.i)))
            else:
                stack.push(newFloating((float)(x.i)+y.f))

template Sub*():untyped =
    require(opSub)

    if x.kind==Literal:
        if syms[x.s].kind==Integer and y.kind==Integer:
            syms[x.s].i -= y.i
        else:
            if syms[x.s].kind==Floating:
                if y.kind==Floating: syms[x.s].f -= y.f
                else: syms[x.s].f -= (float)(y.i)
            else:
                syms[x.s] = newFloating((float)(x.i)-y.f)
    else:
        if x.kind==Integer and y.kind==Integer:
            stack.push(newInteger(x.i-y.i))
        else:
            if x.kind==Floating:
                if y.kind==Floating: stack.push(newFloating(x.f-y.f))
                else: stack.push(newFloating(x.f-(float)(y.i)))
            else:
                stack.push(newFloating((float)(x.i)-y.f))

template Mul*():untyped =
    require(opMul)

    if x.kind==Literal:
        if syms[x.s].kind==Integer and y.kind==Integer:
            syms[x.s].i *= y.i
        else:
            if syms[x.s].kind==Floating:
                if y.kind==Floating: syms[x.s].f *= y.f
                else: syms[x.s].f *= (float)(y.i)
            else:
                syms[x.s] = newFloating((float)(x.i)*y.f)
    else:
        if x.kind==Integer and y.kind==Integer:
            stack.push(newInteger(x.i*y.i))
        else:
            if x.kind==Floating:
                if y.kind==Floating: stack.push(newFloating(x.f*y.f))
                else: stack.push(newFloating(x.f*(float)(y.i)))
            else:
                stack.push(newFloating((float)(x.i)*y.f))

template Div*():untyped =
    require(opDiv)

    if x.kind==Literal:
        if syms[x.s].kind==Integer and y.kind==Integer:
            syms[x.s].i = syms[x.s].i div y.i
        else:
            if syms[x.s].kind==Floating:
                if y.kind==Floating: syms[x.s].f /= y.f
                else: syms[x.s].f /= (float)(y.i)
            else:
                syms[x.s] = newFloating((float)(x.i)/y.f)
    else:
        if x.kind==Integer and y.kind==Integer:
            stack.push(newInteger(x.i div y.i))
        else:
            if x.kind==Floating:
                if y.kind==Floating: stack.push(newFloating(x.f/y.f))
                else: stack.push(newFloating(x.f/(float)(y.i)))
            else:
                stack.push(newFloating((float)(x.i)/y.f))

template FDiv*():untyped = 
    require(opFDiv)

    if x.kind==Literal:
        if syms[x.s].kind==Integer and y.kind==Integer:
            syms[x.s] = newFloating(syms[x.s].i / y.i)
        else:
            if syms[x.s].kind==Floating:
                if y.kind==Floating: syms[x.s].f /= y.f
                else: syms[x.s].f /= (float)(y.i)
            else:
                syms[x.s] = newFloating((float)(x.i)/y.f)
    else:
        if x.kind==Integer and y.kind==Integer:
            stack.push(newFloating(x.i / y.i))
        else:
            if x.kind==Floating:
                if y.kind==Floating: stack.push(newFloating(x.f / y.f))
                else: stack.push(newFloating(x.f/(float)(y.i)))
            else:
                stack.push(newFloating((float)(x.i)/y.f))

template Mod*():untyped = 
    require(opMod)

    if x.kind==Literal:
        syms[x.s].i = syms[x.s].i mod y.i
    else:
        stack.push(newInteger(x.i mod y.i))

template Pow*():untyped =
    require(opPow)

    if x.kind==Literal:
        if syms[x.s].kind==Integer and y.kind==Integer:
            let res = pow((float)syms[x.s].i,(float)y.i)
            syms[x.s] = newInteger((int)res)
        else:
            if syms[x.s].kind==Floating:
                if y.kind==Floating: syms[x.s] = newFloating(pow(syms[x.s].f,y.f))
                else: syms[x.s] = newFloating(pow(syms[x.s].f,(float)(y.i)))
            else:
                syms[x.s] = newFloating(pow((float)(syms[x.s].i),y.f))
    else:
        if x.kind==Integer and y.kind==Integer:
            let res = pow((float)x.i,(float)y.i)
            stack.push(newInteger((int)res))
        else:
            if x.kind==Floating:
                if y.kind==Floating: stack.push(newFloating(pow(x.f,y.f)))
                else: stack.push(newFloating(pow(x.f,(float)(y.i))))
            else:
                stack.push(newFloating(pow((float)(x.i),y.f)))

template Neg*():untyped =
    require(opNeg)

    if x.kind==Literal:
        if syms[x.s].kind==Integer: syms[x.s].i *= -1
        else: syms[x.s] = newFloating(syms[x.s].f * (-1))
    else:
        if x.kind==Integer: stack.push(newInteger(x.i * (-1)))
        else: stack.push(newFloating(x.f * (-1)))

template Shl*():untyped =
    require(opShl)
    stack.push(newInteger(x.i shl y.i))

template Shr*():untyped =
    require(opShr)
    stack.push(newInteger(x.i shr y.i))

template Inc*():untyped =
    require(opInc)

    if x.kind==Literal:
        if syms[x.s].kind == Integer: syms[x.s].i += 1
        elif syms[x.s].kind == Floating: syms[x.s].f += 1.0
    elif x.kind==Integer:
        stack.push(newInteger(x.i+1))
    elif x.kind==Floating:
        stack.push(newFloating(x.f+1.0))

template Dec*():untyped =
    require(opDec)

    if x.kind==Literal:
        if syms[x.s].kind == Integer: syms[x.s].i -= 1
        elif syms[x.s].kind == Floating: syms[x.s].f -= 1.0
    elif x.kind==Integer:
        stack.push(newInteger(x.i-1))
    elif x.kind==Floating:
        stack.push(newFloating(x.f-1.0))

template Random*():untyped =
    require(opRandom)

    stack.push(newInteger(rand(x.i..y.i)))

template Abs*():untyped = 
    require(opAbs)

    stack.push(newInteger(abs(x.i)))

template Acos*():untyped = 
    require(opAcos)

    stack.push(newFloating(arccos(x.f)))

template Acosh*():untyped = 
    require(opAcosh)

    stack.push(newFloating(arccosh(x.f)))

template Asin*():untyped = 
    require(opAsin)

    stack.push(newFloating(arcsin(x.f)))

template Asinh*():untyped = 
    require(opAsinh)

    stack.push(newFloating(arcsinh(x.f)))

template Atan*():untyped = 
    require(opAtan)

    stack.push(newFloating(arctan(x.f)))

template Atanh*():untyped = 
    require(opAtanh)

    stack.push(newFloating(arctanh(x.f)))

template Cos*():untyped = 
    require(opAcos)

    stack.push(newFloating(cos(x.f)))

template Cosh*():untyped = 
    require(opCosh)

    stack.push(newFloating(cosh(x.f)))

template Csec*():untyped = 
    require(opCsec)

    stack.push(newFloating(csc(x.f)))

template Csech*():untyped = 
    require(opCsech)

    stack.push(newFloating(csch(x.f)))

template Ctan*():untyped = 
    require(opCtan)

    stack.push(newFloating(cot(x.f)))

template Ctanh*():untyped = 
    require(opCtanh)

    stack.push(newFloating(coth(x.f)))

template Sec*():untyped = 
    require(opSec)

    stack.push(newFloating(sec(x.f)))

template Sech*():untyped = 
    require(opSech)

    stack.push(newFloating(sech(x.f)))

template Sin*():untyped = 
    require(opSin)

    stack.push(newFloating(sin(x.f)))

template Sinh*():untyped = 
    require(opSinh)

    stack.push(newFloating(sinh(x.f)))

template Tan*():untyped = 
    require(opTan)

    stack.push(newFloating(tan(x.f)))

template Tanh*():untyped = 
    require(opTanh)

    stack.push(newFloating(tanh(x.f)))

template Sqrt*():untyped =
    require(opSqrt)

    if x.kind==Integer: stack.push(newFloating(sqrt((float)x.i)))
    else: stack.push(newFloating(sqrt(x.f)))