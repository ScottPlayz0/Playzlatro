SMODS.Consumable {
    key = "haumea",
    set = "Planet",
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Dwarf Planet', get_type_colour(self or card.config, card), nil, 1.2)
    end,
    loc_txt = {
        name = "Haumea",
        text = {
            "Apply {C:attention}1{} levels to",
            "{C:attention}3{} random hands."
        }
    },

    pos = { x = 3, y = 0 },
    cost = 3,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',

    use = function(self, card, area, copier)
        local used_card = copier or card
        update_hand_text(
            { sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 },
            { handname = '???', chips = '???', mult = '???', level = '' }
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
        update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.9, delay = 0 }, { level = '+'..tostring(3) })
        delay(1.3)
        local hand_pool = {}
        for hand_key, _ in pairs(G.GAME.hands) do
            table.insert(hand_pool, hand_key)
        end
        if #hand_pool == 0 then
            update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.0, delay = 0 },
                { handname = '', chips = '', mult = '', level = '' })
            update_hand_text({ delay = 0 }, { StatusText = false })
            return used_card
        end
        local want = math.min(3, #hand_pool)
        local chosen = {}
        for i = 1, want do
            local sel = pseudorandom_element(hand_pool, 'haumea_random_'..tostring(i))
            if sel then
                table.insert(chosen, sel)
                for j, v in ipairs(hand_pool) do
                    if v == sel then
                        table.remove(hand_pool, j)
                        break
                    end
                end
            end
            if #hand_pool == 0 then break end
        end
        for _, hand_key in ipairs(chosen) do
            level_up_hand(card, hand_key, true, 1)

            update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 },
                { handname = localize(hand_key, 'poker_hands'),
                  chips = G.GAME.hands[hand_key].chips,
                  mult  = G.GAME.hands[hand_key].mult,
                  level = G.GAME.hands[hand_key].level })
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