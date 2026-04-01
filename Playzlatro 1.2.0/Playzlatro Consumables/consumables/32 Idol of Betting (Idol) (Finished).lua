SMODS.Consumable {
    key = "idol_of_betting",
    set = "idol",
    config = { 
        extra = {
            required_rounds = 3,
            completed_rounds = 0
        } 
    },
    loc_txt = {
        name = "Idol of Betting",
        text = {
            "After {C:attention}3{} rounds,",
            "use to gain",
            "{C:blue}+1{} Hands",
            "{C:inactive}(Currently #1# of 3){}"
        }
    },

        pos = { x = 1, y = 6 },
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
                card_eval_status_text(used_card, "extra", nil, nil, nil, {message = "+1 Hand", colour = G.C.BLUE})
                G.GAME.round_resets.hands = G.GAME.round_resets.hands + 1
                ease_hands_played(1)
                return true
            end
        }))
    end
}