SMODS.Consumable {
    key = "idol_of_choosing",
    set = "idol",
    config = { 
        extra = {
            required_rounds = 2,
            completed_rounds = 0
        } 
    },
    loc_txt = {
        name = "Idol of Choosing",
        text = {
            "After {C:attention}2{} rounds,",
            "use to gain",
            "{C:purple}+1{} Selection Limit",
            "{C:inactive}(Currently #1# of 2){}"
        }
    },

    pos = { x = 0, y = 6 },
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
        return (card.ability.extra.completed_rounds or 0) >= (card.ability.extra.required_rounds or 2)
    end,
    use = function(self, card, area, copier)
        local used_card = copier or card
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                card_eval_status_text(used_card, 'extra', nil, nil, nil, {message = "+" .. tostring(1) .. " Play Size", colour = G.C.BLUE})
                SMODS.change_play_limit(1)
                return true
            end
        }))
        delay(0.6)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                card_eval_status_text(used_card, 'extra', nil, nil, nil, {message = "+" .. tostring(1) .. " Discard Size", colour = G.C.RED})
                SMODS.change_discard_limit(1)
                return true
            end
        }))
        delay(0.6)
    end
}