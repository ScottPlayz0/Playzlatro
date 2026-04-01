SMODS.Consumable {
    key = 'Makemake',
    set = 'Planet',
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Dwarf Planet', get_type_colour(self or card.config, card), nil, 1.2)
    end,
    loc_txt = {
        name = 'Makemake',
        text = {
            "apply {C:attention}2{} levels to",
            "most played hand."
        }
    },

        pos = { x = 4, y = 0 },
    cost = 3,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',

    use = function(self, card, area, copier)
        local used_card = copier or card
        local temp_played = 0
        local temp_order = math.huge
        local target_hand = 'High Card'
        for hand, value in pairs(G.GAME.hands) do 
            if value.visible then
                if value.played > temp_played then
                    temp_played = value.played
                    temp_order = value.order
                    target_hand = hand
                elseif value.played == temp_played then
                    if value.order < temp_order then
                        temp_order = value.order
                        target_hand = hand
                    end
                end
            end
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                G.TAROT_INTERRUPT_PULSE = true
                return true
            end
        }))
        update_hand_text({ delay = 0 }, { mult = '+', StatusText = true })
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.9,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                return true
            end
        }))
        update_hand_text({ delay = 0 }, { chips = '+', StatusText = true })
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.9,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                G.TAROT_INTERRUPT_PULSE = nil
                return true
            end
        }))
        update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.9, delay = 0 }, { level = '+'..tostring(2) })
        delay(1.3)
        level_up_hand(card, target_hand, true, 2)
        update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 }, 
            { handname = localize(target_hand, 'poker_hands'), 
              chips = G.GAME.hands[target_hand].chips, 
              mult  = G.GAME.hands[target_hand].mult, 
              level = G.GAME.hands[target_hand].level })
        delay(1.3)
        return used_card
    end,
    can_use = function(self, card)
        return true
    end
}
