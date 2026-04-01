SMODS.Consumable {
    key = 'Neith',
    set = 'Planet',
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Moon', get_type_colour(self or card.config, card), nil, 1.2)
    end,
    loc_txt = {
        name = 'Neith',
        text = {
            '(lvl.1) Level up',
            '{C:attention}Three of a Kind{}',
            '{C:mult}+6{} Mult or',
            '{C:chips}+60{} Chips'
        }
    },

    pos = { x = 1, y = 1 },
    cost = 3,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',

    use = function(self, card, area, copier)
        local used_card = copier or card
        local hand_key = "Three of a Kind"
        local hand = G.GAME.hands[hand_key]
        update_hand_text(
            { sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 },
            {
                handname = localize(hand_key, 'poker_hands'),
                chips = hand.chips,
                mult = hand.mult,
                level = hand.level
            }
        )
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
        local orig_level = hand.level
        local orig_chips = hand.chips
        local orig_mult = hand.mult
        level_up_hand(card, hand_key, true, 3)
        local delta_chips = hand.chips - orig_chips
        local delta_mult = hand.mult - orig_mult
        hand.level = orig_level
        hand.chips = orig_chips
        hand.mult = orig_mult
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
        local give_mult = (math.random() < 0.5)
        if give_mult then
            hand.mult = hand.mult + (delta_mult or 0)
            local show_mult = (delta_mult and tostring(delta_mult) or "0")
            update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.9, delay = 0 },
                { mult = '+'..show_mult, StatusText = true })
            delay(1.3)
            update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 },
                {
                    handname = localize(hand_key, 'poker_hands'),
                    chips = hand.chips,
                    mult = hand.mult,
                    level = hand.level
                })
        else
            hand.chips = hand.chips + (delta_chips or 0)
            local show_chips = (delta_chips and tostring(delta_chips) or "0")
            update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.9, delay = 0 },
                { chips = '+'..show_chips, StatusText = true })
            delay(1.3)
            update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 },
                {
                    handname = localize(hand_key, 'poker_hands'),
                    chips = hand.chips,
                    mult = hand.mult,
                    level = hand.level
                })
        end
        delay(1.3)
        update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.0, delay = 0 },
            { handname = '', chips = '', mult = '', level = '' })
        update_hand_text({ delay = 0 }, { StatusText = false })
        G.TAROT_INTERRUPT_PULSE = nil
    end,
    can_use = function(self, card)
        return true
    end
}