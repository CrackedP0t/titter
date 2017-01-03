local _empty = {}

local titter = function(t, k1, filter)
	k1 = k1 or "<top>"

	local found = {}

	local currentNode
	local start = true
	return function()
		if start then
			local nextKey, nextValue = next(t)
			currentNode = {prevNode = nil, key = nextKey, value = nextValue, table = t}
			start = false
			return {
				finish = false,
				key = k1,
				value = t,
				last = true,
				empty = not next(t)
			}
		else
			if currentNode == nil then
				return nil
			else
				local retFinish, retKey, retValue, retFound = false, currentNode.key, currentNode.value, found[currentNode.value]

				local empty
				if type(retValue) == "table" then
					empty = not next(retValue)
				end

				if not retKey then
					local oldTable = currentNode.table
					currentNode = currentNode.prevNode
					return {
						finish = true,
						last = not (currentNode or _empty).key,
						empty = not next(oldTable)
					}
				end

				currentNode.key, currentNode.value = next(currentNode.table, currentNode.key)

				local last = not currentNode.key

				local filtered
				if type(retValue) == "table" then
					if filter then
						filtered = filter(retValue)
					end

					if not filtered and not found[retValue] then
						found[retValue] = true
						local nextKey, nextValue = next(retValue)
						currentNode = {
							prevNode = currentNode,
							key = nextKey,
							value = nextValue,
							table = retValue
						}
					end
				end

				return {
					finish = retFinish,
					key = retKey,
					value = retValue,
					last = last,
					empty = empty,
					found = not not retFound,
					filtered = filtered
				}
			end
		end
	end
end

return titter
