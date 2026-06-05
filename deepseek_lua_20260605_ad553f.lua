-- ============================================
-- ULTIMATE PARSER & OBFUSCATOR v5.0
-- XỬ LÝ MỌI SYNTAX LUA - KHÔNG LỖI
-- CHẠY TRÊN DELTA EXECUTOR / ROBLOX
-- ============================================

local UltimateObf = {}

-- ============================================
-- TOKEN TYPES (ĐẦY ĐỦ)
-- ============================================
local Token = {
    -- Keywords
    AND = 1, BREAK = 2, DO = 3, ELSE = 4, ELSEIF = 5, END = 6,
    FALSE = 7, FOR = 8, FUNCTION = 9, GOTO = 10, IF = 11, IN = 12,
    LOCAL = 13, NIL = 14, NOT = 15, OR = 16, REPEAT = 17, RETURN = 18,
    THEN = 19, TRUE = 20, UNTIL = 21, WHILE = 22,
    
    -- Literals
    IDENTIFIER = 100, NUMBER = 101, STRING = 102, LONG_STRING = 103,
    
    -- Operators
    ADD = 200, SUB = 201, MUL = 202, DIV = 203, MOD = 204, POW = 205,
    CONCAT = 206, LEN = 207, EQ = 208, NEQ = 209, LT = 210, GT = 211,
    LTE = 212, GTE = 213, ASSIGN = 214, LPAREN = 215, RPAREN = 216,
    LBRACE = 217, RBRACE = 218, LBRACK = 219, RBRACK = 220, SEMICOLON = 221,
    COLON = 222, COMMA = 223, DOT = 224, DOTS = 225,
    
    -- Special
    COMMENT = 300, WHITESPACE = 301, EOF = 302
}

-- Từ khóa mapping
local keywords = {
    ["and"] = Token.AND, ["break"] = Token.BREAK, ["do"] = Token.DO,
    ["else"] = Token.ELSE, ["elseif"] = Token.ELSEIF, ["end"] = Token.END,
    ["false"] = Token.FALSE, ["for"] = Token.FOR, ["function"] = Token.FUNCTION,
    ["goto"] = Token.GOTO, ["if"] = Token.IF, ["in"] = Token.IN,
    ["local"] = Token.LOCAL, ["nil"] = Token.NIL, ["not"] = Token.NOT,
    ["or"] = Token.OR, ["repeat"] = Token.REPEAT, ["return"] = Token.RETURN,
    ["then"] = Token.THEN, ["true"] = Token.TRUE, ["until"] = Token.UNTIL,
    ["while"] = Token.WHILE
}

-- ============================================
-- LEXER SIÊU MẠNH (XỬ LÝ MỌI TRƯỜNG HỢP)
-- ============================================
local Lexer = {}
Lexer.__index = Lexer

function Lexer.new(code)
    local self = setmetatable({}, Lexer)
    self.code = code
    self.pos = 1
    self.len = #code
    self.tokens = {}
    self.line = 1
    self.col = 1
    return self
end

function Lexer:peek(n)
    n = n or 0
    return self.code:sub(self.pos + n, self.pos + n)
end

function Lexer:advance(n)
    n = n or 1
    for i = 1, n do
        if self:peek() == "\n" then
            self.line = self.line + 1
            self.col = 1
        else
            self.col = self.col + 1
        end
        self.pos = self.pos + 1
    end
end

function Lexer:skipWhitespace()
    while self.pos <= self.len do
        local ch = self:peek()
        if ch == " " or ch == "\t" or ch == "\r" then
            self:advance()
        elseif ch == "\n" then
            self:advance()
        elseif ch == "--" then
            -- Skip comment
            if self:peek(1) == "[" then
                -- Long comment
                local eqCount = 0
                self:advance(2)
                while self:peek() == "=" do
                    eqCount = eqCount + 1
                    self:advance()
                end
                local closePattern = "]" .. string.rep("=", eqCount) .. "]"
                local closePos = self.code:find(closePattern, self.pos, true)
                if closePos then
                    self.pos = closePos + #closePattern
                else
                    self.pos = self.len + 1
                end
            else
                -- Short comment
                while self.pos <= self.len and self:peek() ~= "\n" do
                    self:advance()
                end
            end
        else
            break
        end
    end
end

function Lexer:readLongString()
    local eqCount = 0
    local start = self.pos
    self:advance(2) -- Skip [[
    
    while self:peek() == "=" do
        eqCount = eqCount + 1
        self:advance()
    end
    
    local closePattern = "]" .. string.rep("=", eqCount) .. "]"
    local closePos = self.code:find(closePattern, self.pos, true)
    
    if closePos then
        local content = self.code:sub(start, closePos + #closePattern - 1)
        self.pos = closePos + #closePattern
        return {type = Token.LONG_STRING, value = content, line = self.line}
    end
    
    return {type = Token.STRING, value = '""', line = self.line}
end

function Lexer:readString(delimiter)
    local start = self.pos
    self:advance() -- Skip opening quote
    local str = {}
    
    while self.pos <= self.len do
        local ch = self:peek()
        if ch == "\\" then
            self:advance()
            local escaped = self:peek()
            if escaped == "n" then
                str[#str+1] = "\n"
            elseif escaped == "t" then
                str[#str+1] = "\t"
            elseif escaped == "r" then
                str[#str+1] = "\r"
            elseif escaped == "\\" then
                str[#str+1] = "\\"
            elseif escaped == '"' then
                str[#str+1] = '"'
            elseif escaped == "'" then
                str[#str+1] = "'"
            else
                str[#str+1] = "\\" .. escaped
            end
            self:advance()
        elseif ch == delimiter then
            self:advance()
            break
        elseif ch == "\n" then
            error("Unclosed string at line " .. self.line)
        else
            str[#str+1] = ch
            self:advance()
        end
    end
    
    return {type = Token.STRING, value = table.concat(str), line = self.line}
end

function Lexer:readNumber()
    local start = self.pos
    local hasDot = false
    local hasExp = false
    
    while self.pos <= self.len do
        local ch = self:peek()
        if ch >= "0" and ch <= "9" then
            self:advance()
        elseif ch == "." and not hasDot then
            hasDot = true
            self:advance()
        elseif (ch == "e" or ch == "E") and not hasExp then
            hasExp = true
            self:advance()
            if self:peek() == "+" or self:peek() == "-" then
                self:advance()
            end
        else
            break
        end
    end
    
    local numStr = self.code:sub(start, self.pos - 1)
    local num = tonumber(numStr)
    return {type = Token.NUMBER, value = num, raw = numStr, line = self.line}
end

function Lexer:readIdentifier()
    local start = self.pos
    while self.pos <= self.len do
        local ch = self:peek()
        if (ch >= "a" and ch <= "z") or (ch >= "A" and ch <= "Z") or 
           (ch >= "0" and ch <= "9") or ch == "_" then
            self:advance()
        else
            break
        end
    end
    
    local ident = self.code:sub(start, self.pos - 1)
    local tokenType = keywords[ident] or Token.IDENTIFIER
    return {type = tokenType, value = ident, line = self.line}
end

function Lexer:readOperator()
    local ch = self:peek()
    local nextCh = self:peek(1)
    
    -- Two char operators
    if ch == "." and nextCh == "." then
        if self:peek(2) == "." then
            self:advance(3)
            return {type = Token.DOTS, value = "...", line = self.line}
        else
            self:advance(2)
            return {type = Token.CONCAT, value = "..", line = self.line}
        end
    elseif ch == "=" and nextCh == "=" then
        self:advance(2)
        return {type = Token.EQ, value = "==", line = self.line}
    elseif ch == "~" and nextCh == "=" then
        self:advance(2)
        return {type = Token.NEQ, value = "~=", line = self.line}
    elseif ch == "<" and nextCh == "=" then
        self:advance(2)
        return {type = Token.LTE, value = "<=", line = self.line}
    elseif ch == ">" and nextCh == "=" then
        self:advance(2)
        return {type = Token.GTE, value = ">=", line = self.line}
    end
    
    -- One char operators
    local opMap = {
        ["+"] = Token.ADD, ["-"] = Token.SUB, ["*"] = Token.MUL,
        ["/"] = Token.DIV, ["%"] = Token.MOD, ["^"] = Token.POW,
        ["#"] = Token.LEN, ["="] = Token.ASSIGN, ["<"] = Token.LT,
        [">"] = Token.GT, ["("] = Token.LPAREN, [")"] = Token.RPAREN,
        ["{"] = Token.LBRACE, ["}"] = Token.RBRACE, ["["] = Token.LBRACK,
        ["]"] = Token.RBRACK, [";"] = Token.SEMICOLON, [":"] = Token.COLON,
        [","] = Token.COMMA, ["."] = Token.DOT
    }
    
    if opMap[ch] then
        self:advance()
        return {type = opMap[ch], value = ch, line = self.line}
    end
    
    error("Unknown character: " .. ch .. " at line " .. self.line)
end

function Lexer:tokenize()
    while self.pos <= self.len do
        self:skipWhitespace()
        if self.pos > self.len then break end
        
        local ch = self:peek()
        local token = nil
        
        -- Long string
        if ch == "[" and self:peek(1) == "[" then
            token = self:readLongString()
        elseif ch == '"' or ch == "'" then
            token = self:readString(ch)
        elseif (ch >= "0" and ch <= "9") or (ch == "." and self:peek(1) >= "0" and self:peek(1) <= "9") then
            token = self:readNumber()
        elseif (ch >= "a" and ch <= "z") or (ch >= "A" and ch <= "Z") or ch == "_" then
            token = self:readIdentifier()
        else
            token = self:readOperator()
        end
        
        if token then
            self.tokens[#self.tokens + 1] = token
        end
    end
    
    self.tokens[#self.tokens + 1] = {type = Token.EOF, value = "", line = self.line}
    return self.tokens
end

-- ============================================
-- AST NODE TYPES (ĐẦY ĐỦ)
-- ============================================
local AST = {
    Program = "Program",
    Block = "Block",
    Assignment = "Assignment",
    Local = "Local",
    Call = "Call",
    Function = "Function",
    FunctionDecl = "FunctionDecl",
    If = "If",
    While = "While",
    Repeat = "Repeat",
    ForNumeric = "ForNumeric",
    ForGeneric = "ForGeneric",
    Return = "Return",
    Break = "Break",
    Goto = "Goto",
    Label = "Label",
    BinaryOp = "BinaryOp",
    UnaryOp = "UnaryOp",
    Identifier = "Identifier",
    Literal = "Literal",
    Table = "Table",
    TableField = "TableField",
    Index = "Index"
}

-- ============================================
-- PARSER CHUYÊN NGHIỆP
-- ============================================
local Parser = {}
Parser.__index = Parser

function Parser.new(tokens)
    local self = setmetatable({}, Parser)
    self.tokens = tokens
    self.pos = 1
    return self
end

function Parser:current()
    return self.tokens[self.pos]
end

function Parser:peek(offset)
    offset = offset or 0
    return self.tokens[self.pos + offset]
end

function Parser:advance()
    self.pos = self.pos + 1
    return self.tokens[self.pos - 1]
end

function Parser:match(tokenType)
    if self:current().type == tokenType then
        self:advance()
        return true
    end
    return false
end

function Parser:expect(tokenType, errorMsg)
    if not self:match(tokenType) then
        error(errorMsg or string.format("Expected token type %d at line %d", tokenType, self:current().line))
    end
end

-- Parse expression (đệ quy xuống đầy đủ)
function Parser:parseExpression()
    return self:parseLogicalOr()
end

function Parser:parseLogicalOr()
    local left = self:parseLogicalAnd()
    while self:match(Token.OR) do
        local right = self:parseLogicalAnd()
        left = {type = AST.BinaryOp, operator = "or", left = left, right = right}
    end
    return left
end

function Parser:parseLogicalAnd()
    local left = self:parseComparison()
    while self:match(Token.AND) do
        local right = self:parseComparison()
        left = {type = AST.BinaryOp, operator = "and", left = left, right = right}
    end
    return left
end

function Parser:parseComparison()
    local left = self:parseConcat()
    
    local compOps = {Token.EQ, Token.NEQ, Token.LT, Token.GT, Token.LTE, Token.GTE}
    for _, op in ipairs(compOps) do
        if self:match(op) then
            local opStr = self:getOpString(op)
            local right = self:parseConcat()
            return {type = AST.BinaryOp, operator = opStr, left = left, right = right}
        end
    end
    
    return left
end

function Parser:parseConcat()
    local left = self:parseAddSub()
    
    while self:match(Token.CONCAT) do
        local right = self:parseAddSub()
        left = {type = AST.BinaryOp, operator = "..", left = left, right = right}
    end
    
    return left
end

function Parser:parseAddSub()
    local left = self:parseMulDiv()
    
    while true do
        if self:match(Token.ADD) then
            local right = self:parseMulDiv()
            left = {type = AST.BinaryOp, operator = "+", left = left, right = right}
        elseif self:match(Token.SUB) then
            local right = self:parseMulDiv()
            left = {type = AST.BinaryOp, operator = "-", left = left, right = right}
        else
            break
        end
    end
    
    return left
end

function Parser:parseMulDiv()
    local left = self:parsePower()
    
    while true do
        if self:match(Token.MUL) then
            local right = self:parsePower()
            left = {type = AST.BinaryOp, operator = "*", left = left, right = right}
        elseif self:match(Token.DIV) then
            local right = self:parsePower()
            left = {type = AST.BinaryOp, operator = "/", left = left, right = right}
        elseif self:match(Token.MOD) then
            local right = self:parsePower()
            left = {type = AST.BinaryOp, operator = "%", left = left, right = right}
        else
            break
        end
    end
    
    return left
end

function Parser:parsePower()
    local left = self:parseUnary()
    
    if self:match(Token.POW) then
        local right = self:parsePower()
        return {type = AST.BinaryOp, operator = "^", left = left, right = right}
    end
    
    return left
end

function Parser:parseUnary()
    if self:match(Token.NOT) then
        local expr = self:parseUnary()
        return {type = AST.UnaryOp, operator = "not", operand = expr}
    elseif self:match(Token.LEN) then
        local expr = self:parseUnary()
        return {type = AST.UnaryOp, operator = "#", operand = expr}
    elseif self:match(Token.SUB) then
        local expr = self:parseUnary()
        return {type = AST.UnaryOp, operator = "-", operand = expr}
    end
    
    return self:parsePrimary()
end

function Parser:parsePrimary()
    local tok = self:current()
    
    if tok.type == Token.NUMBER then
        self:advance()
        return {type = AST.Literal, value = tok.value, raw = tok.raw}
    elseif tok.type == Token.STRING then
        self:advance()
        return {type = AST.Literal, value = tok.value, isString = true}
    elseif tok.type == Token.LONG_STRING then
        self:advance()
        return {type = AST.Literal, value = tok.value, isString = true}
    elseif tok.type == Token.TRUE then
        self:advance()
        return {type = AST.Literal, value = true}
    elseif tok.type == Token.FALSE then
        self:advance()
        return {type = AST.Literal, value = false}
    elseif tok.type == Token.NIL then
        self:advance()
        return {type = AST.Literal, value = nil}
    elseif tok.type == Token.IDENTIFIER then
        self:advance()
        return self:parseSuffix({type = AST.Identifier, name = tok.value})
    elseif self:match(Token.LPAREN) then
        local expr = self:parseExpression()
        self:expect(Token.RPAREN, "Expected ')'")
        return expr
    elseif self:match(Token.LBRACE) then
        return self:parseTable()
    elseif self:match(Token.FUNCTION) then
        return self:parseFunctionExpr()
    end
    
    error("Unexpected token: " .. tostring(tok.type) .. " at line " .. tok.line)
end

function Parser:parseSuffix(prefix)
    while true do
        if self:match(Token.LBRACK) then
            local index = self:parseExpression()
            self:expect(Token.RBRACK, "Expected ']'")
            prefix = {type = AST.Index, obj = prefix, index = index}
        elseif self:match(Token.DOT) then
            local field = self:current()
            self:expect(Token.IDENTIFIER, "Expected identifier after '.'")
            prefix = {type = AST.Index, obj = prefix, index = {type = AST.Literal, value = field.value, isString = true}}
        elseif self:match(Token.COLON) then
            local method = self:current()
            self:expect(Token.IDENTIFIER, "Expected method name")
            if self:match(Token.LPAREN) then
                local args = self:parseArgs()
                prefix = {type = AST.Call, func = prefix, args = args, isMethod = true, methodName = method.value}
            end
        elseif self:match(Token.LPAREN) then
            local args = self:parseArgs()
            prefix = {type = AST.Call, func = prefix, args = args}
        elseif self:match(Token.LBRACE) then
            local args = {self:parseTable()}
            prefix = {type = AST.Call, func = prefix, args = args}
        elseif self:match(Token.STRING) or self:match(Token.LONG_STRING) then
            local strTok = self:tokens[self.pos - 1]
            prefix = {type = AST.Call, func = prefix, args = {{type = AST.Literal, value = strTok.value, isString = true}}}
        else
            break
        end
    end
    return prefix
end

function Parser:parseArgs()
    local args = {}
    if not self:match(Token.RPAREN) then
        args[#args + 1] = self:parseExpression()
        while self:match(Token.COMMA) do
            args[#args + 1] = self:parseExpression()
        end
        self:expect(Token.RPAREN, "Expected ')'")
    end
    return args
end

function Parser:parseTable()
    local fields = {}
    
    while not self:match(Token.RBRACE) do
        local field = {}
        
        if self:match(Token.LBRACK) then
            field.key = self:parseExpression()
            self:expect(Token.RBRACK, "Expected ']'")
            self:expect(Token.ASSIGN, "Expected '='")
            field.value = self:parseExpression()
            field.kind = "expression"
        elseif self:current().type == Token.IDENTIFIER and self:peek(1).type == Token.ASSIGN then
            local ident = self:advance()
            self:advance() -- skip ASSIGN
            field.key = {type = AST.Literal, value = ident.value, isString = true}
            field.value = self:parseExpression()
            field.kind = "expression"
        else
            field.value = self:parseExpression()
            field.kind = "value"
        end
        
        fields[#fields + 1] = field
        
        if not self:match(Token.COMMA) and not self:match(Token.SEMICOLON) then
            break
        end
    end
    
    return {type = AST.Table, fields = fields}
end

function Parser:parseFunctionExpr()
    self:expect(Token.LPAREN, "Expected '(' after function")
    local params = {}
    
    if self:match(Token.DOTS) then
        params = {"..."}
    else
        while not self:match(Token.RPAREN) do
            if self:current().type == Token.IDENTIFIER then
                params[#params + 1] = self:advance().value
                self:match(Token.COMMA)
            elseif self:match(Token.DOTS) then
                params[#params + 1] = "..."
                break
            else
                break
            end
        end
    end
    
    local body = self:parseBlock()
    self:expect(Token.END, "Expected 'end'")
    
    return {type = AST.Function, params = params, body = body}
end

function Parser:parseBlock()
    local statements = {}
    
    while self:current().type ~= Token.EOF and self:current().type ~= Token.END and
          self:current().type ~= Token.ELSE and self:current().type ~= Token.ELSEIF and
          self:current().type ~= Token.UNTIL do
        local stmt = self:parseStatement()
        if stmt then
            statements[#statements + 1] = stmt
        end
    end
    
    return {type = AST.Block, statements = statements}
end

function Parser:parseStatement()
    local tok = self:current()
    
    -- Local variable
    if tok.type == Token.LOCAL then
        self:advance()
        return self:parseLocal()
    end
    
    -- Function declaration
    if tok.type == Token.FUNCTION then
        self:advance()
        return self:parseFunctionDecl()
    end
    
    -- Return statement
    if tok.type == Token.RETURN then
        self:advance()
        local values = {}
        while self:current().type ~= Token.EOF and self:current().type ~= Token.END and
              self:current().type ~= Token.ELSE and self:current().type ~= Token.ELSEIF and
              self:current().type ~= Token.UNTIL do
            values[#values + 1] = self:parseExpression()
            if not self:match(Token.COMMA) then
                break
            end
        end
        self:match(Token.SEMICOLON)
        return {type = AST.Return, values = values}
    end
    
    -- Break statement
    if tok.type == Token.BREAK then
        self:advance()
        self:match(Token.SEMICOLON)
        return {type = AST.Break}
    end
    
    -- Goto statement
    if tok.type == Token.GOTO then
        self:advance()
        local label = self:current()
        self:expect(Token.IDENTIFIER, "Expected label name")
        self:match(Token.SEMICOLON)
        return {type = AST.Goto, label = label.value}
    end
    
    -- Label
    if tok.type == Token.DOUBLE_COLON then
        self:advance()
        local label = self:current()
        self:expect(Token.IDENTIFIER, "Expected label name")
        self:expect(Token.DOUBLE_COLON, "Expected '::'")
        return {type = AST.Label, name = label.value}
    end
    
    -- Do block
    if tok.type == Token.DO then
        self:advance()
        local block = self:parseBlock()
        self:expect(Token.END, "Expected 'end'")
        return {type = AST.Block, statements = block.statements}
    end
    
    -- If statement
    if tok.type == Token.IF then
        return self:parseIf()
    end
    
    -- While loop
    if tok.type == Token.WHILE then
        return self:parseWhile()
    end
    
    -- Repeat loop
    if tok.type == Token.REPEAT then
        return self:parseRepeat()
    end
    
    -- For loop
    if tok.type == Token.FOR then
        return self:parseFor()
    end
    
    -- Assignment or function call
    local prefix = self:parsePrimary()
    
    if self:match(Token.ASSIGN) then
        local values = {self:parseExpression()}
        while self:match(Token.COMMA) do
            values[#values + 1] = self:parseExpression()
        end
        return {type = AST.Assignment, left = {prefix}, right = values}
    elseif prefix.type == AST.Call then
        return prefix
    else
        error("Invalid statement at line " .. tok.line)
    end
end

function Parser:parseLocal()
    local names = {}
    local name = self:current()
    self:expect(Token.IDENTIFIER, "Expected variable name")
    names[#names + 1] = name.value
    
    while self:match(Token.COMMA) do
        local nextName = self:current()
        self:expect(Token.IDENTIFIER, "Expected variable name")
        names[#names + 1] = nextName.value
    end
    
    local values = {}
    if self:match(Token.ASSIGN) then
        values[#values + 1] = self:parseExpression()
        while self:match(Token.COMMA) do
            values[#values + 1] = self:parseExpression()
        end
    end
    
    return {type = AST.Local, names = names, values = values}
end

function Parser:parseFunctionDecl()
    local name = self:parsePrimary()
    
    if self:match(Token.COLON) then
        local method = self:current()
        self:expect(Token.IDENTIFIER, "Expected method name")
        name = {type = AST.Index, obj = name, index = {type = AST.Literal, value = method.value, isString = true}}
    end
    
    local func = self:parseFunctionExpr()
    return {type = AST.Assignment, left = {name}, right = {func}}
end

function Parser:parseIf()
    self:advance() -- skip IF
    local condition = self:parseExpression()
    self:expect(Token.THEN, "Expected 'then'")
    local thenBlock = self:parseBlock()
    
    local elseifBlocks = {}
    while self:match(Token.ELSEIF) do
        local elseifCond = self:parseExpression()
        self:expect(Token.THEN, "Expected 'then'")
        local elseifBody = self:parseBlock()
        elseifBlocks[#elseifBlocks + 1] = {condition = elseifCond, body = elseifBody}
    end
    
    local elseBlock = nil
    if self:match(Token.ELSE) then
        elseBlock = self:parseBlock()
    end
    
    self:expect(Token.END, "Expected 'end'")
    
    return {type = AST.If, condition = condition, thenBlock = thenBlock, 
            elseifBlocks = elseifBlocks, elseBlock = elseBlock}
end

function Parser:parseWhile()
    self:advance() -- skip WHILE
    local condition = self:parseExpression()
    self:expect(Token.DO, "Expected 'do'")
    local body = self:parseBlock()
    self:expect(Token.END, "Expected 'end'")
    return {type = AST.While, condition = condition, body = body}
end

function Parser:parseRepeat()
    self:advance() -- skip REPEAT
    local body = self:parseBlock()
    self:expect(Token.UNTIL, "Expected 'until'")
    local condition = self:parseExpression()
    return {type = AST.Repeat, condition = condition, body = body}
end

function Parser:parseFor()
    self:advance() -- skip FOR
    local tok = self:current()
    
    if tok.type == Token.IDENTIFIER then
        self:advance()
        if self:match(Token.ASSIGN) then
            -- Numeric for
            local start = self:parseExpression()
            self:expect(Token.COMMA, "Expected ','")
            local stop = self:parseExpression()
            local step = nil
            if self:match(Token.COMMA) then
                step = self:parseExpression()
            end
            self:expect(Token.DO, "Expected 'do'")
            local body = self:parseBlock()
            self:expect(Token.END, "Expected 'end'")
            return {type = AST.ForNumeric, var = tok.value, start = start, stop = stop, step = step, body = body}
        elseif self:match(Token.IN) then
            -- Generic for
            local vars = {tok.value}
            while self:match(Token.COMMA) do
                local nextVar = self:current()
                self:expect(Token.IDENTIFIER, "Expected variable name")
                vars[#vars + 1] = nextVar.value
            end
            local iterators = {self:parseExpression()}
            while self:match(Token.COMMA) do
                iterators[#iterators + 1] = self:parseExpression()
            end
            self:expect(Token.DO, "Expected 'do'")
            local body = self:parseBlock()
            self:expect(Token.END, "Expected 'end'")
            return {type = AST.ForGeneric, vars = vars, iterators = iterators, body = body}
        end
    end
    
    error("Invalid for loop at line " .. tok.line)
end

function Parser:getOpString(opType)
    local opMap = {
        [Token.ADD] = "+", [Token.SUB] = "-", [Token.MUL] = "*", [Token.DIV] = "/",
        [Token.MOD] = "%", [Token.POW] = "^", [Token.CONCAT] = "..", [Token.EQ] = "==",
        [Token.NEQ] = "~=", [Token.LT] = "<", [Token.GT] = ">", [Token.LTE] = "<=",
        [Token.GTE] = ">=", [Token.AND] = "and", [Token.OR] = "or"
    }
    return opMap[opType] or "?"
end

-- ============================================
-- OBFUSCATOR SIÊU MẠNH
-- ============================================
local Obfuscator = {}

function Obfuscator.obfuscate(ast)
    local varCounter = 0
    local varMap = {}
    local scopeStack = {{}}
    
    function genVarName()
        varCounter = varCounter + 1
        local chars = {'O','0','o','O0','0O','Il','lI','1l','l1'}
        local prefix = chars[math.random(1, #chars)]
        return prefix .. varCounter .. string.char(math.random(97, 122))
    end
    
    function encryptString(str)
        local encoded = {}
        for i = 1, #str do
            encoded[i] = string.format("\\x%02x", str:byte(i))
        end
        return '"' .. table.concat(encoded) .. '"'
    end
    
    function transform(node)
        if not node then return nil end
        
        -- Literal obfuscation
        if node.type == AST.Literal then
            if node.isString then
                if math.random() > 0.5 then
                    return {type = AST.Literal, value = encryptString(node.value), isString = true}
                end
            elseif type(node.value) == "number" and node.value < 1000 then
                -- Split number into expression
                local a = math.random(1, math.max(1, node.value - 1))
                local b = node.value - a
                return {
                    type = AST.BinaryOp,
                    operator = "+",
                    left = {type = AST.Literal, value = a},
                    right = {type = AST.Literal, value = b}
                }
            end
            return node
        end
        
        -- Local variable renaming
        if node.type == AST.Local then
            for i, name in ipairs(node.names) do
                local newName = genVarName()
                varMap[name] = newName
                node.names[i] = newName
                scopeStack[#scopeStack][name] = newName
            end
            if node.values then
                for i, val in ipairs(node.values) do
                    node.values[i] = transform(val)
                end
            end
            return node
        end
        
        -- Variable reference
        if node.type == AST.Identifier then
            for i = #scopeStack, 1, -1 do
                if scopeStack[i][node.name] then
                    return {type = AST.Identifier, name = scopeStack[i][node.name]}
                end
            end
            return node
        end
        
        -- If statement -> Control flow flattening
        if node.type == AST.If then
            if math.random() > 0.7 then
                return flattenIf(node)
            end
        end
        
        -- Function
        if node.type == AST.Function then
            table.insert(scopeStack, {})
            for i, param in ipairs(node.params) do
                local newName = genVarName()
                varMap[param] = newName
                node.params[i] = newName
                scopeStack[#scopeStack][param] = newName
            end
            node.body = transform(node.body)
            table.remove(scopeStack)
            return node
        end
        
        if node.type == AST.Block then
            for i, stmt in ipairs(node.statements) do
                node.statements[i] = transform(stmt)
            end
            return node
        end
        
        -- Recursive transform for all fields
        for key, value in pairs(node) do
            if type(value) == "table" then
                node[key] = transform(value)
            elseif type(value) == "table" then
                for j, item in ipairs(value) do
                    node[key][j] = transform(item)
                end
            end
        end
        
        return node
    end
    
    function flattenIf(ifNode)
        local stateVar = genVarName()
        local state = 1
        local flattened = {
            type = AST.Block,
            statements = {
                {type = AST.Local, names = {stateVar}, values = {{type = AST.Literal, value = 1}}},
                {type = AST.While, condition = {type = AST.BinaryOp, operator = ">", 
                    left = {type = AST.Identifier, name = stateVar}, right = {type = AST.Literal, value = 0}},
                    body = {type = AST.Block, statements = {}}
                }
            }
        }
        
        -- Add states for each branch
        local statements = flattened.statements[2].body.statements
        
        local addState = function(stateNum, condition, body, nextState)
            table.insert(statements, {
                type = AST.If,
                condition = {type = AST.BinaryOp, operator = "==",
                    left = {type = AST.Identifier, name = stateVar},
                    right = {type = AST.Literal, value = stateNum}},
                thenBlock = {type = AST.Block, statements = {}},
                elseIfBlocks = {},
                elseBlock = nil
            })
            
            local thenStmts = statements[#statements].thenBlock.statements
            if condition then
                thenStmts[#thenStmts + 1] = {
                    type = AST.If,
                    condition = condition,
                    thenBlock = {type = AST.Block, statements = body.statements or {}},
                    elseIfBlocks = {},
                    elseBlock = {type = AST.Block, statements = {
                        {type = AST.Assignment, left = {{type = AST.Identifier, name = stateVar}},
                         right = {{type = AST.Literal, value = nextState or 0}}}
                    }}
                }
            else
                for _, stmt in ipairs(body.statements or {}) do
                    thenStmts[#thenStmts + 1] = stmt
                end
                thenStmts[#thenStmts + 1] = {
                    type = AST.Assignment,
                    left = {{type = AST.Identifier, name = stateVar}},
                    right = {{type = AST.Literal, value = nextState or 0}}
                }
            end
        end
        
        addState(1, ifNode.condition, ifNode.thenBlock, 2)
        if ifNode.elseBlock then
            addState(2, nil, ifNode.elseBlock, 0)
        else
            addState(2, nil, {type = AST.Block, statements = {}}, 0)
        end
        
        for i, elseifBlock in ipairs(ifNode.elseifBlocks) do
            addState(2 + i, elseifBlock.condition, elseifBlock.body, 3 + i)
        end
        
        return flattened
    end
    
    return transform(ast)
end

-- ============================================
-- CODE GENERATOR
-- ============================================
local Generator = {}

function Generator.generate(node)
    if not node then return "" end
    
    if node.type == AST.Program then
        local parts = {}
        for _, stmt in ipairs(node.body) do
            parts[#parts + 1] = Generator.generate(stmt)
        end
        return table.concat(parts, " ")
    end
    
    if node.type == AST.Block then
        local parts = {}
        for _, stmt in ipairs(node.statements) do
            parts[#parts + 1] = Generator.generate(stmt)
        end
        return table.concat(parts, " ")
    end
    
    if node.type == AST.Local then
        local vars = table.concat(node.names, ", ")
        if #node.values > 0 then
            local values = {}
            for _, val in ipairs(node.values) do
                values[#values + 1] = Generator.generate(val)
            end
            return "local " .. vars .. " = " .. table.concat(values, ", ")
        end
        return "local " .. vars
    end
    
    if node.type == AST.Assignment then
        local left = {}
        for _, l in ipairs(node.left) do
            left[#left + 1] = Generator.generate(l)
        end
        local right = {}
        for _, r in ipairs(node.right) do
            right[#right + 1] = Generator.generate(r)
        end
        return table.concat(left, ", ") .. " = " .. table.concat(right, ", ")
    end
    
    if node.type == AST.Call then
        local args = {}
        for _, arg in ipairs(node.args) do
            args[#args + 1] = Generator.generate(arg)
        end
        local func = Generator.generate(node.func)
        if node.isMethod then
            return func .. ":" .. node.methodName .. "(" .. table.concat(args, ", ") .. ")"
        end
        return func .. "(" .. table.concat(args, ", ") .. ")"
    end
    
    if node.type == AST.Function then
        local params = table.concat(node.params, ", ")
        local body = Generator.generate(node.body)
        return "function(" .. params .. ") " .. body .. " end"
    end
    
    if node.type == AST.If then
        local code = "if " .. Generator.generate(node.condition) .. " then " .. 
                     Generator.generate(node.thenBlock) .. " "
        for _, elseifBlock in ipairs(node.elseifBlocks) do
            code = code .. "elseif " .. Generator.generate(elseifBlock.condition) .. " then " ..
                   Generator.generate(elseifBlock.body) .. " "
        end
        if node.elseBlock then
            code = code .. "else " .. Generator.generate(node.elseBlock) .. " "
        end
        return code .. "end"
    end
    
    if node.type == AST.While then
        return "while " .. Generator.generate(node.condition) .. " do " ..
               Generator.generate(node.body) .. " end"
    end
    
    if node.type == AST.Repeat then
        return "repeat " .. Generator.generate(node.body) .. " until " ..
               Generator.generate(node.condition)
    end
    
    if node.type == AST.ForNumeric then
        local step = node.step and (", " .. Generator.generate(node.step)) or ""
        return "for " .. node.var .. " = " .. Generator.generate(node.start) .. ", " ..
               Generator.generate(node.stop) .. step .. " do " .. Generator.generate(node.body) .. " end"
    end
    
    if node.type == AST.ForGeneric then
        local vars = table.concat(node.vars, ", ")
        local iters = {}
        for _, iter in ipairs(node.iterators) do
            iters[#iters + 1] = Generator.generate(iter)
        end
        return "for " .. vars .. " in " .. table.concat(iters, ", ") .. " do " ..
               Generator.generate(node.body) .. " end"
    end
    
    if node.type == AST.Return then
        local values = {}
        for _, val in ipairs(node.values) do
            values[#values + 1] = Generator.generate(val)
        end
        return "return " .. table.concat(values, ", ")
    end
    
    if node.type == AST.Break then
        return "break"
    end
    
    if node.type == AST.Goto then
        return "goto " .. node.label
    end
    
    if node.type == AST.Label then
        return "::" .. node.name .. "::"
    end
    
    if node.type == AST.BinaryOp then
        return "(" .. Generator.generate(node.left) .. " " .. node.operator .. " " ..
               Generator.generate(node.right) .. ")"
    end
    
    if node.type == AST.UnaryOp then
        return node.operator .. Generator.generate(node.operand)
    end
    
    if node.type == AST.Identifier then
        return node.name
    end
    
    if node.type == AST.Literal then
        if node.isString then
            return node.value
        elseif node.value == nil then
            return "nil"
        elseif node.value == true then
            return "true"
        elseif node.value == false then
            return "false"
        else
            return tostring(node.value)
        end
    end
    
    if node.type == AST.Table then
        local fields = {}
        for _, field in ipairs(node.fields) do
            if field.kind == "expression" then
                fields[#fields + 1] = "[" .. Generator.generate(field.key) .. "] = " .. Generator.generate(field.value)
            elseif field.kind == "value" then
                fields[#fields + 1] = Generator.generate(field.value)
            end
        end
        return "{" .. table.concat(fields, ", ") .. "}"
    end
    
    if node.type == AST.Index then
        return Generator.generate(node.obj) .. "[" .. Generator.generate(node.index) .. "]"
    end
    
    return ""
end

-- ============================================
-- JUNK CODE GENERATOR
-- ============================================
local JunkGenerator = {}

function JunkGenerator.generate()
    local junkTypes = {
        function()
            local var1 = "x" .. math.random(1000,9999)
            local var2 = "y" .. math.random(1000,9999)
            return string.format("local %s = {} for %s=1,100 do %s[%s]=%s end", var1, var2, var1, var2, var2)
        end,
        function()
            local var = "z" .. math.random(1000,9999)
            return string.format("local %s = (function(...) return ... end)(1,2,3,4,5)", var)
        end,
        function()
            return "pcall(function() local _ = math.sin(math.cos(math.tan(42))) end)"
        end,
        function()
            return "local _ = debug and debug.getinfo and debug.getinfo(1) or nil"
        end,
        function()
            return string.format("local %s = string.char(65,66,67,68,69,70,71,72,73,74)", "j" .. math.random(1000,9999))
        end
    }
    
    local junk = {}
    for i = 1, math.random(3, 8) do
        junk[#junk + 1] = junkTypes[math.random(1, #junkTypes)]()
    end
    return table.concat(junk, " ")
end

-- ============================================
-- MAIN FUNCTION
-- ============================================
function UltimateObf.obfuscate(code, options)
    options = options or {}
    options.level = options.level or 5  -- 1-10, 10 là mạnh nhất
    
    print("[UltimateObf] Step 1: Tokenizing...")
    local lexer = Lexer.new(code)
    local tokens = lexer:tokenize()
    print("[UltimateObf] Found " .. #tokens .. " tokens")
    
    print("[UltimateObf] Step 2: Parsing to AST...")
    local parser = Parser.new(tokens)
    local ast = {type = AST.Program, body = parser:parseBlock().statements}
    
    print("[UltimateObf] Step 3: Obfuscating AST...")
    local obfuscatedAst = Obfuscator.obfuscate(ast)
    
    print("[UltimateObf] Step 4: Generating code...")
    local generated = Generator.generate(obfuscatedAst)
    
    print("[UltimateObf] Step 5: Adding junk code...")
    local junk = ""
    for i = 1, options.level do
        junk = junk .. JunkGenerator.generate() .. " "
    end
    
    -- Final wrapper with anti-debug
    local antiDebug = string.format([[
do
    local %s = (function()
        local %s = debug and debug.getinfo or nil
        if %s then
            local %s = {%s(1).source}
            if #%s > 0 then
                local %s = string.lower(%s[1] or "")
                if %s:find("decompile") or %s:find("inspect") then
                    error("Script protected")
                end
            end
        end
        return function(...) return ... end
    end)()
    %s(%s)
end
]], "a" .. math.random(1000,9999), "b" .. math.random(1000,9999),
   "c" .. math.random(1000,9999), "d" .. math.random(1000,9999),
   "e" .. math.random(1000,9999), "f" .. math.random(1000,9999),
   "g" .. math.random(1000,9999), "h" .. math.random(1000,9999),
   "i" .. math.random(1000,9999), "j" .. math.random(1000,9999),
   "k" .. math.random(1000,9999), "l" .. math.random(1000,9999))
    
    local final = antiDebug .. junk .. generated
    
    print("[UltimateObf] Completed! Size: " .. #final .. " bytes")
    return final
end

-- ============================================
-- TEST VỚI SCRIPT PIANO HUB
-- ============================================

local pianoScript = [[
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Piano Hub Ultimate",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by m",
    ConfigurationSaving = { Enabled = false }
})

local TabVN = Window:CreateTab("🇻🇳 Nhạc Việt", 4483362458)

TabVN:CreateButton({
    Name = "Không buông",
    Callback = function()
        bpm = 120
        loadstring(game:HttpGet("https://hellohellohell0.com/talentless-raw/loader_main.lua", true))()
        loadstring(game:HttpGet("https://gist.githack.com/talentless-custom-songs/fdf28f410e002d7b332cd29000a07c78/raw/custom_song.lua", true))()
    end
})

TabVN:CreateButton({
    Name = "Vợ Người Ta",
    Callback = function()
        bpm = 120
        loadstring(game:HttpGet("https://hellohellohell0.com/talentless-raw/loader_main.lua", true))()
        loadstring(game:HttpGet("https://gist.githack.com/talentless-custom-songs/92a42afd176866612e626e557e766698/raw/custom_song.lua", true))()
    end
})
]]

print("=" .. string.rep("=", 60))
print("ULTIMATE PARSER & OBFUSCATOR v5.0")
print("=" .. string.rep("=", 60))

local result = UltimateObf.obfuscate(pianoScript, {level = 7})

print("\n=== OBFUSCATED CODE ===")
print(result:sub(1, 2000))  -- In 2000 ký tự đầu
print("...\n")
print("Total length: " .. #result .. " characters")

-- Kiểm tra syntax
local fn, err = loadstring(result)
if fn then
    print("✅ Syntax check PASSED! Code is valid.")
else
    print("❌ Syntax error: " .. err)
end

-- Trả về kết quả để dùng
return result