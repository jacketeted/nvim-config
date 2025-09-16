---@generic T
---@param elems T[]
---@param predicate fun(value:T):boolean
---@param must_have_elem T|nil
---@return table
local function filter(elems, predicate, must_have_elem)
	local filtered_bufs = {}
	for _, value in ipairs(elems) do
		if must_have_elem ~= nil and must_have_elem == value then
			table.insert(filtered_bufs, value)
			goto continue
		end
		if predicate(value) then
			table.insert(filtered_bufs, value)
		end

		::continue::
	end
	return filtered_bufs
end

return filter
