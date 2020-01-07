local text = 'test1 , lol = "was auch \\"--[[ immer" mehr = "lol"\ntesting = \'more test\'\n--"test"\n "lol ]]" \n'

local s = {}
local d = {}

local emptySpace = function(t)
    return t:sub(1, 1) .. t:sub(t:len())
end

text = text:gsub('\\"', "d" .. "@"):gsub("\\'", "s" .. "@")
print(text)
text =
    text:gsub(
    '"[^\n\r]-"',
    function(t)
        table.insert(d, t)
        return ("d%s@"):format(#d)
    end
):gsub(
    "'[^\n\r]-'",
    function(t)
        table.insert(s, t)
        return ("s%s@"):format(#s)
    end
)
text = text:gsub("%-%-[^\n]+%[%[", "--")
text = text:gsub("%-%-%[%[.*%]%]+", "")
text = text:gsub("%-%-.-\n+", "\n")
text = text:gsub("\n%s+", "\n")
print(text)
text = text:gsub("[%a%d_]%s[^%a%d_]", emptySpace):gsub("[^%d%a_]%s+[%a%d_]", emptySpace)
print(text)
text =
    text:gsub(
    "s[1-9]+@",
    function(t)
        local i = tonumber(t:sub(2, t:len() - 1))
        return s[i]
    end
)
text =
    text:gsub(
    "d[1-9]+@",
    function(t)
        local i = tonumber(t:sub(2, t:len() - 1))
        return d[i]
    end
)
print(text)
text = text:gsub("d" .. "@", '\\"')
text = text:gsub("s" .. "@", "\\'")

print(text)
