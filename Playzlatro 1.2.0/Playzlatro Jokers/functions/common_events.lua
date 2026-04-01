[manifest]
version = "1.0.0"
dump_lua = true
priority = 0

[[patches]]
[patches.pattern]
target = "functions/common_events.lua"
pattern = "local extrafunc = nil"
position = "after"
payload = '''
if eval_type == 'e_mult' then
	amt = amt
	text = '^' .. amt .. ' Mult'
	colour = G.C.MULT
	config.type = 'fade'
	config.scale = 0.7
elseif eval_type == 'e_chips' then
	amt = amt
	text = '^' .. amt
	colour = G.C.CHIPS
	config.type = 'fade'
	config.scale = 0.7
end
'''
match_indent = true
