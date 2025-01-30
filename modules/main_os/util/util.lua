local util = {}

function util.tableMerge(table1, table2, result)
	for _, v in ipairs(table1) do
		table.insert(result, v)
	end
	for _, v in ipairs(table2) do
		table.insert(result, v)
	end
end

function util.getTableFromString(filepath)
    local tableFile = fs.open(filepath, "r")
    print(filepath)
    local table = loadstring("return"..tableFile:readAll())()
    tableFile:close()
    return table
end

return util
