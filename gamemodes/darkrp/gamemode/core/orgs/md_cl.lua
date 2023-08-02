local a = {}

local b = {
    __index = _G
}

setmetatable(a, b)
setfenv(1, a)

function lock(c)
    function lock_new_index(c, d, e)
        error("module has been locked -- " .. d .. " must be declared local", 2)
    end

    local f = {
        __newindex = lock_new_index
    }

    if getmetatable(c) then
        f.__index = getmetatable(c).__index
    end

    setmetatable(c, f)
end

function map(c, g)
    local h = {}

    for d, e in pairs(c) do
        h[d] = g(e, d)
    end

    return h
end

function identity(i)
    return i
end

function iff(c, j, k)
    if c then
        return j
    else
        return k
    end
end

function split(i, l)
    l = l or "\n"
    local m = {}
    local n = 1

    while true do
        local k, o = i:find(l, n)

        if not k then
            table.insert(m, i:sub(n))
            break
        end

        table.insert(m, i:sub(n, k - 1))
        n = o + 1
    end

    return m
end

function detab(i)
    local p = 4

    local function q(r)
        local s = -r:len()

        while s < 1 do
            s = s + p
        end

        return r .. string.rep(" ", s)
    end

    i = i:gsub("([^\n]-)\t", q)

    return i
end

function find_first(t, u, v)
    local w = {}

    for x, y in ipairs(u) do
        local r = {t:find(y, v)}

        if #r > 0 and (#w == 0 or r[1] < w[1]) then
            w = r
        end
    end

    return unpack(w)
end

function splice(z, A, B, C)
    if C then
        local D = B - A + 1

        while D > 0 do
            table.remove(z, A)
            D = D - 1
        end

        for E, e in ipairs(C) do
            table.insert(z, A, e)
        end

        return z
    else
        local w = {}

        for E = A, B do
            table.insert(w, z[E])
        end

        return w
    end
end

function outdent(i)
    i = "\n" .. i
    i = i:gsub("\n  ? ? ?", "\n")
    i = i:sub(2)

    return i
end

function indent(i)
    i = i:gsub("\n", "\n    ")

    return i
end

function tokenize_html(F)
    local G = {}
    local n = 1

    while true do
        local A = find_first(F, {"<!%-%-", "<[a-z/!$]", "<%?"}, n)

        if not A then
            table.insert(G, {
                type = "text",
                text = F:sub(n)
            })

            break
        end

        if A ~= n then
            table.insert(G, {
                type = "text",
                text = F:sub(n, A - 1)
            })
        end

        local x, B

        if F:match("^<!%-%-", A) then
            x, B = F:find("%-%->", A)
        elseif F:match("^<%?", A) then
            x, B = F:find("?>", A)
        else
            x, B = F:find("%b<>", A)
        end

        if not B then
            table.insert(G, {
                type = "text",
                text = F:sub(A, A)
            })

            n = A + 1
        else
            table.insert(G, {
                type = "tag",
                text = F:sub(A, B)
            })

            n = B + 1
        end
    end

    return G
end

local H = {
    inited = false,
    identifier = "",
    counter = 0,
    table = {}
}

function init_hash(i)
    H.inited = true
    H.identifier = ""
    H.counter = 0
    H.table = {}
    local t = "HASH"
    local I = 0
    local J

    while true do
        J = t .. I
        if not i:find(J, 1, true) then break end
        I = I + 1
    end

    H.identifier = J
end

function hash(t)
    assert(H.inited)

    if not H.table[t] then
        H.counter = H.counter + 1
        local J = H.identifier .. H.counter .. "X"
        H.table[t] = J
    end

    return H.table[t]
end

local K = {
    blocks = {},
    tags = {"p", "div", "h1", "h2", "h3", "h4", "h5", "h6", "blockquote", "pre", "table", "dl", "ol", "ul", "script", "noscript", "form", "fieldset", "iframe", "math", "ins", "del"}
}

function block_pattern(L)
    return "\n<" .. L .. ".-\n</" .. L .. ">[ \t]*\n"
end

function line_pattern(L)
    return "\n<" .. L .. ".-</" .. L .. ">[ \t]*\n"
end

function protect_range(i, A, B)
    local t = i:sub(A, B)
    local M = hash(t)
    K.blocks[M] = t
    i = i:sub(1, A) .. M .. i:sub(B)

    return i
end

function protect_matches(i, u)
    while true do
        local A, B = find_first(i, u)
        if not A then break end
        i = protect_range(i, A, B)
    end

    return i
end

function protect(i)
    i = protect_matches(i, map(K.tags, block_pattern))
    i = protect_matches(i, map(K.tags, line_pattern))

    i = protect_matches(i, {"\n<hr[^>]->[ \t]*\n"})

    i = protect_matches(i, {"\n<!%-%-.-%-%->[ \t]*\n"})

    return i
end

function is_protected(t)
    return K.blocks[t]
end

function unprotect(i)
    for d, e in pairs(K.blocks) do
        e = e:gsub("%%", "%%%%")
        i = i:gsub(d, e)
    end

    return i
end

function is_ruler_of(N, O)
    if not N:match("^[ %" .. O .. "]*$") then return false end
    if not N:match("%" .. O .. ".*%" .. O .. ".*%" .. O) then return false end

    return true
end

function classify(N)
    local P = {
        line = N,
        text = N
    }

    if N:match("^    ") then
        P.type = "indented"
        P.outdented = N:sub(5)

        return P
    end

    for x, Q in ipairs({'*', '-', '_', '='}) do
        if is_ruler_of(N, Q) then
            P.type = "ruler"
            P.ruler_char = Q

            return P
        end
    end

    if N == "" then
        P.type = "blank"

        return P
    end

    if N:match("^(#+)[ \t]*(.-)[ \t]*#*[ \t]*$") then
        local R, S = N:match("^(#+)[ \t]*(.-)[ \t]*#*[ \t]*$")
        P.type = "header"
        P.level = R:len()
        P.text = S

        return P
    end

    if N:match("^ ? ? ?(%d+)%.[ \t]+(.+)") then
        local T, i = N:match("^ ? ? ?(%d+)%.[ \t]+(.+)")
        P.type = "list_item"
        P.list_type = "numeric"
        P.number = 0 + T
        P.text = i

        return P
    end

    if N:match("^ ? ? ?([%*%+%-])[ \t]+(.+)") then
        local U, i = N:match("^ ? ? ?([%*%+%-])[ \t]+(.+)")
        P.type = "list_item"
        P.list_type = "bullet"
        P.bullet = U
        P.text = i

        return P
    end

    if N:match("^>[ \t]?(.*)") then
        P.type = "blockquote"
        P.text = N:match("^>[ \t]?(.*)")

        return P
    end

    if is_protected(N) then
        P.type = "raw"
        P.html = unprotect(N)

        return P
    end

    P.type = "normal"

    return P
end

function headers(z)
    local E = 1

    while E <= #z - 1 do
        if z[E].type == "normal" and z[E + 1].type == "ruler" and (z[E + 1].ruler_char == "-" or z[E + 1].ruler_char == "=") then
            local P = {
                line = z[E].line
            }

            P.text = P.line
            P.type = "header"
            P.level = iff(z[E + 1].ruler_char == "=", 1, 2)
            table.remove(z, E + 1)
            z[E] = P
        end

        E = E + 1
    end

    return z
end

function lists(z, V)
    local function W(X)
        local function Y(X)
            for E = 1, #X do
                if X[E].type == "blank" then return true end
            end

            return false
        end

        local function Z(X)
            local _ = {X[1]}

            local w = {}

            for E = 2, #X do
                if X[E].type == "list_item" then
                    table.insert(w, _)

                    _ = {X[E]}
                else
                    table.insert(_, X[E])
                end
            end

            table.insert(w, _)

            return w
        end

        local function a0(m, a1)
            while m[#m].type == "blank" do
                table.remove(m)
            end

            local a2 = m[1].text

            for E = 2, #m do
                a2 = a2 .. "\n" .. outdent(m[E].line)
            end

            if a1 then
                a2 = block_transform(a2, true)

                if not a2:find("<pre>") then
                    a2 = indent(a2)
                end

                return "    <li>" .. a2 .. "</li>"
            else
                local m = split(a2)
                m = map(m, classify)
                m = lists(m, true)
                m = blocks_to_html(m, true)
                a2 = table.concat(m, "\n")

                if not a2:find("<pre>") then
                    a2 = indent(a2)
                end

                return "    <li>" .. a2 .. "</li>"
            end
        end

        local a3 = Y(X)
        local a4 = Z(X)
        local h = ""

        for x, a5 in ipairs(a4) do
            h = h .. a0(a5, a3) .. "\n"
        end

        if X[1].list_type == "numeric" then
            return "<ol>\n" .. h .. "</ol>"
        else
            return "<ul>\n" .. h .. "</ul>"
        end
    end

    local function a6(z, V)
        local function a7(z, V)
            if z[1].type == "list_item" then return 1 end

            if V then
                for E = 1, #z do
                    if z[E].type == "list_item" then return E end
                end
            else
                for E = 1, #z - 1 do
                    if z[E].type == "blank" and z[E + 1].type == "list_item" then return E + 1 end
                end
            end

            return nil
        end

        local function a8(z, A)
            local n = #z

            for E = A, #z - 1 do
                if z[E].type == "blank" and z[E + 1].type ~= "list_item" and z[E + 1].type ~= "indented" and z[E + 1].type ~= "blank" then
                    n = E - 1
                    break
                end
            end

            while n > A and z[n].type == "blank" do
                n = n - 1
            end

            return n
        end

        local A = a7(z, V)
        if not A then return nil end

        return A, a8(z, A)
    end

    while true do
        local A, B = a6(z, V)
        if not A then break end
        local i = W(splice(z, A, B))

        local P = {
            line = i,
            type = "raw",
            html = i
        }

        z = splice(z, A, B, {P})
    end

    for x, N in ipairs(z) do
        if N.type == "list_item" then
            N.type = "normal"
        end
    end

    return z
end

function blockquotes(m)
    local function a9(m)
        local A

        for E, N in ipairs(m) do
            if N.type == "blockquote" then
                A = E
                break
            end
        end

        if not A then return nil end
        local B = #m

        for E = A + 1, #m do
            if m[E].type == "blank" or m[E].type == "blockquote" then
            elseif m[E].type == "normal" then
                if m[E - 1].type == "blank" then
                    B = E - 1
                    break
                end
            else
                B = E - 1
                break
            end
        end

        while m[B].type == "blank" do
            B = B - 1
        end

        return A, B
    end

    local function aa(m)
        local ab = m[1].text

        for E = 2, #m do
            ab = ab .. "\n" .. m[E].text
        end

        local ac = block_transform(ab)

        if not ac:find("<pre>") then
            ac = indent(ac)
        end

        return "<blockquote>\n    " .. ac .. "\n</blockquote>"
    end

    while true do
        local A, B = a9(m)
        if not A then break end
        local i = aa(splice(m, A, B))

        local P = {
            line = i,
            type = "raw",
            html = i
        }

        m = splice(m, A, B, {P})
    end

    return m
end

function codeblocks(m)
    local function ad(m)
        local A

        for E, N in ipairs(m) do
            if N.type == "indented" then
                A = E
                break
            end
        end

        if not A then return nil end
        local B = #m

        for E = A + 1, #m do
            if m[E].type ~= "indented" and m[E].type ~= "blank" then
                B = E - 1
                break
            end
        end

        while m[B].type == "blank" do
            B = B - 1
        end

        return A, B
    end

    local function ae(m)
        local ab = detab(encode_code(outdent(m[1].line)))

        for E = 2, #m do
            ab = ab .. "\n" .. detab(encode_code(outdent(m[E].line)))
        end

        return "<pre><code>" .. ab .. "\n</code></pre>"
    end

    while true do
        local A, B = ad(m)
        if not A then break end
        local i = ae(splice(m, A, B))

        local P = {
            line = i,
            type = "raw",
            html = i
        }

        m = splice(m, A, B, {P})
    end

    return m
end

function blocks_to_html(m, af)
    local h = {}
    local E = 1

    while E <= #m do
        local N = m[E]

        if N.type == "ruler" then
            table.insert(h, "<hr/>")
        elseif N.type == "raw" then
            table.insert(h, N.html)
        elseif N.type == "normal" then
            local t = N.line

            while E + 1 <= #m and m[E + 1].type == "normal" do
                E = E + 1
                t = t .. "\n" .. m[E].line
            end

            if af then
                table.insert(h, span_transform(t))
            else
                table.insert(h, "<p>" .. span_transform(t) .. "</p>")
            end
        elseif N.type == "header" then
            local t = "<h" .. N.level .. ">" .. span_transform(N.text) .. "</h" .. N.level .. ">"
            table.insert(h, t)
        else
            table.insert(h, N.line)
        end

        E = E + 1
    end

    return h
end

function block_transform(i, V)
    local m = split(i)
    m = map(m, classify)
    m = headers(m)
    m = lists(m, V)
    m = codeblocks(m)
    m = blockquotes(m)
    m = blocks_to_html(m)
    local i = table.concat(m, "\n")

    return i
end

function print_lines(m)
    for E, N in ipairs(m) do
        print(E, N.type, N.text or N.line)
    end
end

escape_chars = "'\\`*_{}[]()>#+-.!'"
escape_table = {}

function init_escape_table()
    escape_table = {}

    for E = 1, #escape_chars do
        local Q = escape_chars:sub(E, E)
        escape_table[Q] = hash(Q)
    end
end

function add_escape(i)
    if not escape_table[i] then
        escape_table[i] = hash(i)
    end

    return escape_table[i]
end

function escape_special_chars(i)
    local G = tokenize_html(i)
    local h = ""

    for x, ag in ipairs(G) do
        local c = ag.text

        if ag.type == "tag" then
            c = c:gsub("%*", escape_table["*"])
            c = c:gsub("%_", escape_table["_"])
        else
            c = encode_backslash_escapes(c)
        end

        h = h .. c
    end

    return h
end

function encode_backslash_escapes(c)
    for E = 1, escape_chars:len() do
        local Q = escape_chars:sub(E, E)
        c = c:gsub("\\%" .. Q, escape_table[Q])
    end

    return c
end

function unescape_special_chars(c)
    local ah = c

    for d, e in pairs(escape_table) do
        d = d:gsub("%%", "%%%%")
        c = c:gsub(e, d)
    end

    if c ~= ah then
        c = unescape_special_chars(c)
    end

    return c
end

function encode_code(t)
    t = t:gsub("%&", "&amp;")
    t = t:gsub("<", "&lt;")
    t = t:gsub(">", "&gt;")

    for d, e in pairs(escape_table) do
        t = t:gsub("%" .. d, e)
    end

    return t
end

function code_spans(t)
    t = t:gsub("\\\\", escape_table["\\"])
    t = t:gsub("\\`", escape_table["`"])
    local n = 1

    while true do
        local A, B = t:find("`+", n)
        if not A then return t end
        local ai = B - A + 1
        local aj, ak = t:find(string.rep("`", ai), B + 1)
        local al = t:find("\n", B + 1)

        if aj and (not al or aj < al) then
            local am = t:sub(B + 1, aj - 1)
            am = am:gsub("^[ \t]+", "")
            am = am:gsub("[ \t]+$", "")
            am = am:gsub(escape_table["\\"], escape_table["\\"] .. escape_table["\\"])
            am = am:gsub(escape_table["`"], escape_table["\\"] .. escape_table["`"])
            am = "<code>" .. encode_code(am) .. "</code>"
            am = add_escape(am)
            t = t:sub(1, A - 1) .. am .. t:sub(ak + 1)
            n = A + am:len()
        else
            n = B + 1
        end
    end

    return t
end

function encode_alt(t)
    if not t then return t end
    t = t:gsub('&', '&amp;')
    t = t:gsub('"', '&quot;')
    t = t:gsub('<', '&lt;')

    return t
end

function images(i)
    local function an(ao, J)
        ao = encode_alt(ao:match("%b[]"):sub(2, -2))
        J = J:match("%[(.*)%]"):lower()

        if J == "" then
            J = i:lower()
        end

        link_database[J] = link_database[J] or {}
        if not link_database[J].url then return nil end
        local ap = link_database[J].url or J
        ap = encode_alt(ap)
        local aq = encode_alt(link_database[J].title)

        if aq then
            aq = " title=\"" .. aq .. "\""
        else
            aq = ""
        end

        return add_escape('<img src="' .. ap .. '" alt="' .. ao .. '"' .. aq .. "/>")
    end

    local function ar(ao, as)
        ao = encode_alt(ao:match("%b[]"):sub(2, -2))
        local ap, aq = as:match("%(<?(.-)>?[ \t]*['\"](.+)['\"]")
        ap = ap or as:match("%(<?(.-)>?%)")
        ap = encode_alt(ap)
        aq = encode_alt(aq)

        if aq then
            return add_escape('<img src="' .. ap .. '" alt="' .. ao .. '" title="' .. aq .. '"/>')
        else
            return add_escape('<img src="' .. ap .. '" alt="' .. ao .. '"/>')
        end
    end

    i = i:gsub("!(%b[])[ \t]*\n?[ \t]*(%b[])", an)
    i = i:gsub("!(%b[])(%b())", ar)

    return i
end

function anchors(i)
    local function an(i, J)
        i = i:match("%b[]"):sub(2, -2)
        J = J:match("%b[]"):sub(2, -2):lower()

        if J == "" then
            J = i:lower()
        end

        link_database[J] = link_database[J] or {}
        if not link_database[J].url then return nil end
        local ap = link_database[J].url or J
        ap = encode_alt(ap)
        local aq = encode_alt(link_database[J].title)

        if aq then
            aq = " title=\"" .. aq .. "\""
        else
            aq = ""
        end

        return add_escape("<a href=\"" .. ap .. "\"" .. aq .. ">") .. i .. add_escape("</a>")
    end

    local function ar(i, as)
        i = i:match("%b[]"):sub(2, -2)
        local ap, aq = as:match("%(<?(.-)>?[ \t]*['\"](.+)['\"]")
        aq = encode_alt(aq)
        ap = ap or as:match("%(<?(.-)>?%)") or ""
        ap = encode_alt(ap)

        if aq then
            return add_escape("<a href=\"" .. ap .. "\" title=\"" .. aq .. "\">") .. i .. "</a>"
        else
            return add_escape("<a href=\"" .. ap .. "\">") .. i .. add_escape("</a>")
        end
    end

    i = i:gsub("(%b[])[ \t]*\n?[ \t]*(%b[])", an)
    i = i:gsub("(%b[])(%b())", ar)

    return i
end

function auto_links(i)
    local function as(t)
        return add_escape("<a href=\"" .. t .. "\">") .. t .. "</a>"
    end

    local function at(t)
        local au = {
            code = function(Q)
                return "&#x" .. string.format("%x", Q:byte()) .. ";"
            end,
            count = 1,
            rate = 0.45
        }

        local av = {
            code = function(Q)
                return "&#" .. Q:byte() .. ";"
            end,
            count = 0,
            rate = 0.45
        }

        local aw = {
            code = function(Q)
                return Q
            end,
            count = 0,
            rate = 0.1
        }

        local ax = {au, av, aw}

        local function ay(c, az, aA)
            local aB = c[aA]
            c[aA] = c[az]
            c[az] = aB
        end

        local h = ""

        for E = 1, t:len() do
            for x, am in ipairs(ax) do
                am.count = am.count + am.rate
            end

            if ax[1].count < ax[2].count then
                ay(ax, 1, 2)
            end

            if ax[2].count < ax[3].count then
                ay(ax, 2, 3)
            end

            if ax[1].count < ax[2].count then
                ay(ax, 1, 2)
            end

            local am = ax[1]
            local Q = t:sub(E, E)

            if Q == "@" and am == aw then
                am = ax[2]
            end

            h = h .. am.code(Q)
            am.count = am.count - 1
        end

        return h
    end

    local function aC(t)
        t = unescape_special_chars(t)
        local aD = at("mailto:" .. t)
        local i = at(t)

        return add_escape("<a href=\"" .. aD .. "\">") .. i .. "</a>"
    end

    i = i:gsub("<(https?:[^'\">%s]+)>", as)
    i = i:gsub("<(ftp:[^'\">%s]+)>", as)
    i = i:gsub("<mailto:([^'\">%s]+)>", aC)
    i = i:gsub("<([-.%w]+%@[-.%w]+)>", aC)

    return i
end

function amps_and_angles(t)
    local n = 1

    while true do
        local aE = t:find("&", n)
        if not aE then break end
        local aF = t:find(";", aE + 1)
        local B = t:find("[ \t\n&]", aE + 1)

        if not aF or B and B < aF or aF - aE > 15 then
            t = t:sub(1, aE - 1) .. "&amp;" .. t:sub(aE + 1)
            n = aE + 1
        else
            n = aE + 1
        end
    end

    t = t:gsub("<([^a-zA-Z/?$!])", "&lt;%1")
    t = t:gsub("<$", "&lt;")

    return t
end

function emphasis(i)
    for x, t in ipairs{"%*%*", "%_%_"} do
        i = i:gsub(t .. "([^%s][%*%_]?)" .. t, "<strong>%1</strong>")
        i = i:gsub(t .. "([^%s][^<>]-[^%s][%*%_]?)" .. t, "<strong>%1</strong>")
    end

    for x, t in ipairs{"%*", "%_"} do
        i = i:gsub(t .. "([^%s_])" .. t, "<em>%1</em>")
        i = i:gsub(t .. "(<strong>[^%s_]</strong>)" .. t, "<em>%1</em>")
        i = i:gsub(t .. "([^%s_][^<>_]-[^%s_])" .. t, "<em>%1</em>")
        i = i:gsub(t .. "([^<>_]-<strong>[^<>_]-</strong>[^<>_]-)" .. t, "<em>%1</em>")
    end

    return i
end

function line_breaks(i)
    return i:gsub("  +\n", " <br/>\n")
end

function span_transform(i)
    i = code_spans(i)
    i = escape_special_chars(i)
    i = images(i)
    i = amps_and_angles(i)
    i = emphasis(i)
    i = line_breaks(i)

    return i
end

function cleanup(i)
    i = i:gsub("\r\n", "\n")
    i = i:gsub("\r", "\n")
    i = detab(i)

    while true do
        local aG
        i, aG = i:gsub("\n[ \t]+\n", "\n\n")
        if aG == 0 then break end
    end

    return "\n" .. i .. "\n"
end

function strip_link_definitions(i)
    local aH = {}

    local function aI(J, ap, aq)
        J = J:match("%[(.+)%]"):lower()
        aH[J] = aH[J] or {}
        aH[J].url = ap or aH[J].url
        aH[J].title = aq or aH[J].title

        return ""
    end

    local aJ = "\n ? ? ?(%b[]):[ \t]*\n?[ \t]*<?([^%s>]+)>?[ \t]*"
    local aK = aJ .. "[ \t]+\n?[ \t]*[\"'(]([^\n]+)[\"')][ \t]*"
    local aL = aJ .. "[ \t]*\n[ \t]*[\"'(]([^\n]+)[\"')][ \t]*"
    local aM = aJ .. "[ \t]*\n?[ \t]+[\"'(]([^\n]+)[\"')][ \t]*"
    i = i:gsub(aK, aI)
    i = i:gsub(aL, aI)
    i = i:gsub(aM, aI)
    i = i:gsub(aJ, aI)

    return i, aH
end

link_database = {}

function markdown(i)
    i = i:gsub("%b<>", ""):gsub("%b< ", "")
    init_hash(i)
    init_escape_table()
    i = cleanup(i)
    i = protect(i)
    i, link_database = strip_link_definitions(i)
    i = block_transform(i)
    i = unescape_special_chars(i)

    return i
end

setfenv(1, _G)
a.lock(a)
rp.orgs = rp.orgs or {}
rp.orgs.ParseMarkdown = a.markdown