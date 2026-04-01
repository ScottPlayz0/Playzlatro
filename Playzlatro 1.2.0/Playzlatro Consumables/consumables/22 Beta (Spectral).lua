SMODS.Consumable {
    key = "Beta",
    set = "Spectral",
    loc_txt = {
        name = "Beta",
        text = {
            "Apply {C:attention}Eternal{} to the",
            "{C:attention}leftmost{} Joker, then destroy",
            "the {C:attention}rightmost{} Joker",
            "{C:inactive}(Ignores Eternal){}"
        }
    },

    pos = { x = 1, y = 4 },
    cost = 4,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',

    can_use = function(self, card)
        return G.jokers and #G.jokers.cards >= 2
    end,
    use = function(self, card, area, copier)
        local used_card = copier or card
        local leftmost_joker = G.jokers.cards[1]
        local rightmost_joker = G.jokers.cards[#G.jokers.cards]
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                used_card:juice_up(0.3, 0.5)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                leftmost_joker:flip()
                play_sound('card1', 1.1)
                leftmost_joker:juice_up(0.3, 0.3)
                return true
            end
        }))
        delay(0.2)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                leftmost_joker:set_eternal(true)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                leftmost_joker:flip()
                play_sound('tarot2', 0.9)
                leftmost_joker:juice_up(0.3, 0.3)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.5,
            func = function()
                rightmost_joker.ability.eternal = nil 
                play_sound('slice1', 0.8)
                rightmost_joker:start_dissolve()
                return true
            end
        }))
    end
}