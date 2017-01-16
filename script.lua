local caseId, newval = KEYS[1], KEYS[2]  
local entry = redis.call("HGETALL", caseId)
local available, used = entry[2], tonumber(entry[4])  

local function split(str) 
	local table, count = {}, 1 

	for i in string.gmatch(str, "%d+") do
	  table[count] = i
	  count = count + 1 
	end

	return table
end 

local available = split(available)

if used < 5 then 
  used = used + 1 
  redis.call("HINCRBY", caseId, "used", 1)
  
  return {available[used], used} 
end

used = 1
redis.call("HSET", caseId, "available", newval)
redis.call("HSET", caseId, "used", used)
  
available = split(newval)
  
return {available[used], used} 
