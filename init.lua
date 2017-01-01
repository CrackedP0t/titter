local _empty = {}

local titter = function(t, k1)
	k1 = k1 or "<top>"

	local currentNode
	local start = true

	return function()
		if start then
			local nextKey, nextValue = next(t)
			currentNode = {prevNode = nil, key = nextKey, value = nextValue, table = t}
			start = false
			return false, k1, t
		else
			if currentNode == nil then
				return nil
			else
				local retFinish, retKey, retValue = false, currentNode.key, currentNode.value

				local empty
				if type(retValue) == "table" then
					empty = not next(retValue)
				end

				if not retKey then
					currentNode = currentNode.prevNode
					return true, not (currentNode or _empty).key
				end

				currentNode.key, currentNode.value = next(currentNode.table, currentNode.key)

				local last = not currentNode.key

				if type(retValue) == "table" then
					local nextKey, nextValue = next(retValue)
					currentNode = {
						prevNode = currentNode,
						key = nextKey,
						value = nextValue,
						table = retValue
					}
				end

				return retFinish, retKey, retValue, last, empty
			end
		end
	end
end

return titter
