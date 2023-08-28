-- printing values of arrays
--[[ This is a long commit
  It can span multiple lines
  ]]

local str1 = "This is a lua string"
local str2 = "This is a multiline lua \
string that works by escaping the newline character"
-- local str3 = " But this string does not escape
-- newline character so this is not valid"
local str4 = "Hello this is a string!"
local str5 = [[
   This is a proper multiline string
   We are free to write any thing here
   No need to escape newlines :)
]]
     -- 3.0     3.1416     314.16e-2     0.31416E1     34e1
     -- 0x0.1E  0xA23p-4   0X1.921FB54442D18P+1
local float1 = 5.5
local float2 = 5.
local float3 = .5
-- local float4 = .  -- not valid

local arr={2,3,2345,264236,23452345,2456, .5, 5., -.5, 1e-1, 0xa.}
for i=1, #arr do
   print(arr[i])
end
