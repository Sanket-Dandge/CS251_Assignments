local mem = {basiccases} -- for memoization
local function allcases (n)
    if mem[n] then return mem[n] end
    local res = {}
    for i = 1, n - 1 do
        for _, v1 in ipairs(allcases(i)) do
            for _, v2 in ipairs(allcases(n - i)) do
                for _, op in ipairs(binops) do
                    res[#res + 1] = {
                    "(" .. v1[1] .. op[1] .. v2[1] .. ")",
                    op[2](v1[2], v2[2])
                    }
                end
            end
        end
    end
    mem[n] = res -- memoize
    return res
end
