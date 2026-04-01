SMODS.Consumable {
    key = 'modifier',
    set = 'Tarot',
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Tarot?', get_type_colour(self or card.config, card), nil, 1.2)
    end,
    loc_txt = {
        name = 'Modifier',
        text = {
            "Creates a random",
            "{C:dark_edition}Modded{} {C:attention}Joker{} card.",
            "{C:inactive}(must have room){}"
        }
    },

    pos = { x = 0, y = 0 },
    cost = 3,
    unlocked = true,
    discovered = true,
    hidden = false,
    atlas = 'CustomConsumables',

    can_use = function(self, card)
        return #G.jokers.cards < G.jokers.config.card_limit or card.area == G.jokers
    end,
    use = function(self, card, area, copier)
        local used_card = copier or card
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local candidates = {}
                for k, v in pairs(G.P_CENTERS) do
                    if v.set == 'Joker' and v.key:find("^j_.-_") then 
                        table.insert(candidates, v.key)
                    end
                end
                if #candidates > 0 then
                    local chosen_key = candidates[math.random(#candidates)]
                
                    play_sound('timpani')
                    local card = create_card('Joker', G.jokers, nil, nil, nil, nil, chosen_key, 'modifier')
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    used_card:juice_up(0.3, 0.5)
                else
                    sendDebugMessage("Modifier: No modded Jokers found in G.P_CENTERS")
                end
                return true
            end
        }))
    end
}