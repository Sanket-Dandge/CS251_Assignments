-- build table
    statetab = {}
    local w1, w2 = NOWORD, NOWORD
    for w in allwords() do
      insert(prefix(w1, w2), w)
      w1 = w2; w2 = w;
    end
    insert(prefix(w1, w2), NOWORD)
    -- generate text
    w1 = NOWORD; w2 = NOWORD     -- reinitialize
    for i=1,MAXGEN do
      local list = statetab[prefix(w1, w2)]
      -- choose a random item from list
      local r = math.random(table.getn(list))
      local nextword = list[r]
      if nextword == NOWORD then return end
      io.write(nextword, " ")
      w1 = w2; w2 = nextword
    end

