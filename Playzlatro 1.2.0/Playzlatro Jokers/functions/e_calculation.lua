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
if SMODS and SMODS.calculate_individual_effect then
	local originalCalcIndiv = SMODS.calculate_individual_effect
	function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)
		local ret = originalCalcIndiv(effect, scored_card, key, amount, from_edition)
		if ret then
			return ret
		end
		if (key == 'e_mult' or key == 'emult' or key == 'Emult_mod') and amount ~= 1 then
			if effect.card then juice_card(effect.card) end
			if SMODS.Scoring_Parameters then
				local mult = SMODS.Scoring_Parameters["mult"]
				mult:modify(mult.current ^ amount - mult.current)
			else
				mult = mod_mult(mult ^ amount)
				update_hand_text({delay = 0}, {chips = hand_chips, mult = mult})
			end
			if not effect.remove_default_message then
				if from_edition then
					card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = "^"..amount.." "..localize("k_mult"), colour =  G.C.EDITION, edition = true})
				elseif key ~= 'Emult_mod' then
					if effect.emult_message then
						card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.emult_message)
					else
						card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'e_mult', amount, percent)
					end
				end
			end
			return true
		end
		if (key == 'e_chips' or key == 'echips' or key == 'Echip_mod') and amount ~= 1 then
			if effect.card then juice_card(effect.card) end
			if SMODS.Scoring_Parameters then
				local chips = SMODS.Scoring_Parameters["chips"]
				chips:modify(chips.current ^ amount - chips.current)
			else
				hand_chips = mod_chips(hand_chips ^ amount)
				update_hand_text({delay = 0}, {chips = hand_chips, mult = mult})
			end
			if not effect.remove_default_message then
				if from_edition then
					card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = "^"..amount, colour = G.C.EDITION, edition = true})
				elseif key ~= 'Echip_mod' then
					if effect.echip_message then
						card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.echip_message)
					else
						card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'e_chips', amount, percent)
					end
				end
			end
			return true
		end
	end
	for _, v in ipairs({'e_mult', 'e_chips', 'emult', 'echips', 'Emult_mod', 'Echip_mod'}) do
		table.insert(SMODS.scoring_parameter_keys or SMODS.calculation_keys, v)
	end
end
