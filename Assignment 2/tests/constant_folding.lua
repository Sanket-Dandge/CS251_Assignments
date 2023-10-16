local function checkK (func, val)
  check(func, 'LOADK', 'RETURN')
  local k = T.listk(func)
  assert(#k == 1 and k[1] == val and math.type(k[1]) == math.type(val))
  assert(func() == val)
end

checkK(function () return 3^-1 end, 1/3)

checkK(function () return (1 + 1)^(50 + 50) end, 2^100)
...
