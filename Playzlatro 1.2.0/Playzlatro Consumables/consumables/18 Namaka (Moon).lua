SMODS.Consumable {
    key = 'Namaka',
    set = 'Planet',
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Moon', get_type_colour(self or card.config, card), nil, 1.2)
    end,
    config = {
        extra = {
            repetitions = 3
        }
    },
    loc_txt = {
        name = 'Namaka',
        text = {
            "Randomly apply",
            "{C:attention}4x{} {C:chips}Chips{} or {C:attention}4x{} {C:mult}Mult{}",
            "to 3 random hands"
        }
    },

    pos = { x = 2, y = 3 },
    cost = 3,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',

    use = function(self, card, area, copier)
        local used_card = copier or card
        local visible_hands = {}
        for handname, info in pairs(G.GAME.hands) do
            if info.visible then
                table.insert(visible_hands, handname)
            end
        end
        if #visible_hands == 0 then
            return used_card
        end
        local want = math.min(self.config.extra.repetitions or 3, #visible_hands)
        local chosen = {}
        for i = 1, want do
            local idx = math.random(1, #visible_hands)
            table.insert(chosen, visible_hands[idx])
            table.remove(visible_hands, idx)
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
        for i, hand_key in ipairs(chosen) do
            local hand = G.GAME.hands[hand_key]
            update_hand_text(
                { sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.1 },
                {
                    handname = localize(hand_key, 'poker_hands'),
                    chips = hand.chips,
                    mult = hand.mult,
                    level = hand.level
                }
            )
            local orig_level = hand.level
            local orig_chips = hand.chips
            local orig_mult = hand.mult
            level_up_hand(card, hand_key, true, 3)
            local delta_chips = hand.chips - orig_chips
            local delta_mult = hand.mult - orig_mult
            hand.level = orig_level
            hand.chips = orig_chips
            hand.mult = orig_mult
            local scaled_chips = (delta_chips or 0) * 4
            local scaled_mult  = (delta_mult  or 0) * 4
            local give_mult = (math.random() < 0.5)
            if give_mult then
                hand.mult = hand.mult + scaled_mult
                local show_mult = tostring(scaled_mult)
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
                hand.chips = hand.chips + scaled_chips
                local show_chips = tostring(scaled_chips)
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
        end
        update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.0, delay = 0 },
            { handname = '', chips = '', mult = '', level = '' })
        update_hand_text({ delay = 0 }, { StatusText = false })
        return used_card
    end,
    can_use = function(self, card)
        return true
    end
}