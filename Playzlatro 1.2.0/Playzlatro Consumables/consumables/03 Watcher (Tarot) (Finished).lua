SMODS.Consumable {
    key = 'watcher',
    set = 'Tarot',
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Tarot?', get_type_colour(self or card.config, card), nil, 1.2)
    end,
    loc_txt = {
        name = 'Watcher',
        text = {
            [1] = 'Apply a random seal to',
            [2] = '{C:attention}1{} selected playing card'
        }
    },

    pos = { x = 2, y = 0 },
    cost = 3,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',

    use = function(self, card, area, copier)
        if #G.hand.highlighted ~= 1 then
            return false
        end
        local target = G.hand.highlighted[1]
        if target == card or target == copier or target == self then
            return false
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,
            func = function()
                target:flip()
                play_sound('card1', 1.0)
                target:juice_up(0.3, 0.3)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.35,
            func = function()
                local seal_pool = {'Gold','Red','Blue','Purple'}
                local random_seal = pseudorandom_element(seal_pool, 'random_seal')
                target:set_seal(random_seal, nil, true)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.55,
            func = function()
                target:flip()
                play_sound('tarot2', 1.0, 0.6)
                target:juice_up(0.3, 0.3)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.75,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        return true
    end,

    can_use = function(self, card)
        if #G.hand.highlighted ~= 1 then
            return false
        end
        local tgt = G.hand.highlighted[1]
        if tgt == card or tgt == self then
            return false
        end
        return true
    end
}