SMODS.Consumable {
    key = 'Alpha',
    set = 'Spectral',
    loc_txt = {
        name = 'Alpha',
        text = {
            "Apply a random {C:dark_edition}seal{} to",
            "4 random cards in hand."
        }
    },

    pos = { x = 0, y = 4 },
    cost = 4,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    
    can_use = function(self, card)
        return G.hand and #G.hand.cards > 0
    end,
    use = function(self, card, area, copier)
        local used_card = copier or card
        local seal_pool = {}
        for k, v in pairs(SMODS.Seals) do
            table.insert(seal_pool, k)
        end
        local temp_hand = {}
        for _, v in ipairs(G.hand.cards) do table.insert(temp_hand, v) end
        local targets = {}
        for i = 1, 4 do
            if #temp_hand > 0 then
                local random_index = math.floor(pseudorandom('alpha_target') * #temp_hand) + 1
                table.insert(targets, table.remove(temp_hand, random_index))
            end
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                used_card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #targets do
            local percent = 1.15 - (i - 0.999) / (#targets - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    targets[i]:flip()
                    play_sound('card1', percent)
                    targets[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.2)
        for i = 1, #targets do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    local random_seal = pseudorandom_element(seal_pool, pseudoseed('alpha_seal'))
                    targets[i]:set_seal(random_seal, nil, true)
                    return true
                end
            }))
        end
        for i = 1, #targets do
            local percent = 0.85 + (i - 0.999) / (#targets - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    targets[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    targets[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.5)
    end
}