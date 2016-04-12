-- Yelp api for corona
--By:Scott Harrison
-- Verison 1.0 April 11, 2016
local m = {}
local oAuth = require "oAuth"
local json = require("json")
local consumer_key
local access_token
local consumer_secret
local access_token_secret
function string.urlEncode( str )
   if ( str ) then
      str = string.gsub( str, "\n", "\r\n" )
      str = string.gsub( str, "([^%w ])",
         function (c) return string.format( "%%%02X", string.byte(c) ) end )
      str = string.gsub( str, " ", "+" )
   end
   return str
end
function print_r ( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end
function m.init( key1, key2, key3, key4 )
	consumer_key = key1
	consumer_secret = key2
	access_token = key3
	access_token_secret = key4
end
function m.search( myRequestTable, lis )
	local myString = ""
	local tempTable = {}
	if (myRequestTable.term) then
		tempTable[#tempTable+1] = {key="term", value =string.urlEncode(tostring(myRequestTable.term))}
	end
	if (myRequestTable.limit) then
		tempTable[#tempTable+1] = {key="limit", value =string.urlEncode( tostring(myRequestTable.limit))}
	end
	if (myRequestTable.offset) then
		tempTable[#tempTable+1] = {key="offset", value =string.urlEncode( tostring(myRequestTable.offset))}
	end
	if (myRequestTable.sort) then
		tempTable[#tempTable+1] = {key="sort", value =string.urlEncode( tostring(myRequestTable.sort))}
	end
	if (myRequestTable.category_filter) then
		tempTable[#tempTable+1] = {key="category_filter", value =string.urlEncode( tostring(myRequestTable.category_filter))}
	end
	if (myRequestTable.radius_filter) then
		tempTable[#tempTable+1] = {key= "radius_filter", value =string.urlEncode( tostring(myRequestTable.radius_filter))}
	end
	if (myRequestTable.deals_filter) then
		tempTable[#tempTable+1] = {key ="deals_filter", value =string.urlEncode( tostring(myRequestTable.deals_filter))}
	end
	if (myRequestTable.location) then
		tempTable[#tempTable+1] = {key ="location", value =string.urlEncode( tostring(myRequestTable.location))}
	end
	if (myRequestTable.cll) then
		tempTable[#tempTable+1] = {key ="cll", value =string.urlEncode( tostring(myRequestTable.cll))}
	end
	if (myRequestTable.bounds) then
		tempTable[#tempTable+1] = { key ="bounds" , value = string.urlEncode( tostring(myRequestTable.bounds))}
	end
	if (myRequestTable.ll) then
		tempTable[#tempTable+1] = {key ="ll", value =string.urlEncode( tostring(myRequestTable.ll))}
	end
	local function doSearch( status, result )
		print( result )
		local response = json.decode( result )
		lis({status =status, response = response })
	end
	oAuth.makeRequest("https://api.yelp.com/v2/search",
		tempTable, consumer_key, access_token, consumer_secret, access_token_secret,
		"GET", doSearch )
end
return m