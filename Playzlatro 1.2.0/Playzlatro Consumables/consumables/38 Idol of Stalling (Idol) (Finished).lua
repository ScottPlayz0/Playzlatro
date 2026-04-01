SMODS.Consumable {
    key = "idol_of_stalling",
    set = "idol",
    config = { 
        extra = {
            required_rounds = 3,
            completed_rounds = 0
        } 
    },
    loc_txt = {
        name = "Idol of Stalling",
        text = {
            "After {C:attention}3{} rounds,",
            "use to decrease",
            "Ante by {C:attention}1{}",
               "{C:inactive}(Currently #1# of 3){}"
        }
    },

    pos = { x = 2, y = 7 },
    cost = 6,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = "CustomConsumables",

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint then
            card.ability.extra.completed_rounds = (card.ability.extra.completed_rounds or 0) + 1
        end
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { (card and card.ability and card.ability.extra and card.ability.extra.completed_rounds) or 0 } }
    end,
    can_use = function(self, card)
        return (card.ability.extra.completed_rounds or 0) >= (card.ability.extra.required_rounds or 3)
    end,
    use = function(self, card, area, copier)
        local used_card = copier or card
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.4,
            func = function()
                -- Decrease Ante and update the game state
                ease_ante(-1)
                
                card_eval_status_text(used_card, "extra", nil, nil, nil, {message = "-1 Ante", colour = G.C.FILTER})
                return true
            end
        }))
    end
}