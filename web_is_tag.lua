return function (tab)
	local r
	local u={}
	if lt=="none"
		then
			r=lt
		else
			if file.exists("T_"..lt)
				then
					u = frj ("T_"..lt)
					if u.u == nil  or u.mu == nil or u.e== nil or u.n == nil	-- failsafe if read zero file
						then
							print ("[ WEB_IS_TAG ] Invalid data:" ..lt)
							u={u=0, mu=100,p="none",wu=0,p="none", e=2,n="ERROR"}
					end	
					u.tag=lt
					u.exists=1
					lt="none"
					r = sjson.encode(u)
				else
					r='{"exists":"2","tag":"'..lt..'","n":"Нов таг","p":"недефинирана","e":"1","wu":0,"u":"0","mu":"1000"}'
					lt="none"
				end
			end
	return r
end
