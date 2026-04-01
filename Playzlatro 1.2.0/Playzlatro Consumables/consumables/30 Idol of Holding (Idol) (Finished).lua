SMODS.Consumable {
    key = "idol_of_holding",
    set = "idol",
    config = { 
        extra = {
            required_rounds = 4,
            completed_rounds = 0
        } 
    },
    loc_txt = {
        name = "Idol of Holding",
        text = {
            "After {C:attention}4{} rounds,",
            "use to gain",
            "{C:green}+1{} Hand Size",
            "{C:inactive}(Currently #1# of 4){}"
        }
    },

    pos = { x = 4, y = 5 },
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
        return (card.ability.extra.completed_rounds or 0) >= (card.ability.extra.required_rounds or 4)
    end,
    use = function(self, card, area, copier)
        local used_card = copier or card
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.4,
            func = function()
                card_eval_status_text(used_card, "extra", nil, nil, nil, {message = "+1 Hand Size", colour = G.C.BLUE})
                G.hand.config.card_limit = G.hand.config.card_limit + 1
                return true
            end
        }))
    end
}