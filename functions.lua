lt="none"		--	last read tag, gonna be used in web interface						
rdr=1						--	value which RC522 is readed currently
rg=3				-- reset GPIO will be configured as input_pullup after system GPIO initialization to make idiotproof setup

function frj (filetemp)
	if file.open(filetemp, "r")
		then
			local s
			local ok, json = pcall(sjson.decode,file.read('\n'))
			s = ok and json or {}
			file.close()
			return s
		else
			return false
	end
end

function fwoj(f,s)	-- file_write_override_json
 local ok, json = pcall(sjson.encode, s)
  if ok then
   if file.open(f, "w") then
    file.write(json)
    file.close()
   end
   print(json)
   return "true"
 else
  return "false"
 end
end


gpio.mode(rg,gpio.INPUT,gpio.PULLUP)
if file.open("setting.json", "r") and gpio.read(rg)==1
	then
		local ok, json = pcall(sjson.decode,file.read('\n'))
		s = ok and json or {}
		file.close()
	else
		print ("Load defaults")		-- Attention, to preserve memory, GPIO pins not gonna be available for configuration thru web interface
									-- and are hardcoded into settings.html, if you edit here, need to edit there as well.
		s={		
		md=1,				-- mode, 1 normal, 2 regenerate taglist.html, 3 regenerate usagelist.html, 4 remove all tags, 5 normal mode but keep s.token
		ss1=0,				-- RC522 SDA(SS) pin	(avalable GPIO are: 0,8,1,2,9,10 last two are uart pins)
		ss2=8,				--  ( > 12 means not used reader 2 disabled)		
		bg=2,				--	(>12=disabled)buzzer gpio
		dg=1,				-- door gpio (GPIO suitable for door/buzzer are: 1,2,9)
		dov=gpio.HIGH,		--	door open value
		dcv=gpio.LOW,		--	door close value
		ob=3,				--	open button GPIO ( >12 disabled
		odt=5,				--	open door time (in seconds)
		cnt=1, 				--	tag usage count (1 enabled, other disabled)
		wopn=1,				--	open door by entering tag password via wifi (1 enabled, other disabled)
--		wifi_id = "RC8",
		wifi_id = "r-control.eu",
		wifi_pass = "88888888",
		wifi_mode = "ST",
		wifi_phy = wifi.PHYMODE_N,
		nm="RC-RFID",		-- system name
		mqtt_port = "",
		mqtt_pass = "",
		mqtt_server = "",
		mqtt = "OFF",
		mqtt_login = "",
		mqtt_time = "",
		auth="ON",
		auth_login="admin",
		auth_pass="0000"
		}
end
gpio.mode(s.dg,gpio.OUTPUT)
gpio.write(s.dg,s.dcv)

if s.md == 1			-- only in normal mode regenerate token, otherwise keep old one to preserve user logged in
	then
		s.token=node.random(10001,99999)
end
-- end system defaults

if s.ob <13 and s.ob >0		-- set button open routine
	then
		gpio.mode(s.ob,gpio.INT,gpio.PULLUP)
		gpio.trig(s.ob,"down", function (level)
			dofile("obtn4.lc")
		end)

end

if s.bg >12
	then
		function buzz(a)
		end
	else
		gpio.mode(s.bg,gpio.OUTPUT)
		gpio.write(s.bg,gpio.LOW)
		function buzz(a)
			gpio.write(s.bg,a)
		end
end


