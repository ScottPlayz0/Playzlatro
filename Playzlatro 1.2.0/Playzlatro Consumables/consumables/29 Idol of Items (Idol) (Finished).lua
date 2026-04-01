SMODS.Consumable {
    key = "idol_of_items",
    set = "idol",
    config = {
        extra = {
            required_rounds = 2,
            completed_rounds = 0
        }
    },
    loc_txt = {
        name = "Idol Items",
        text = {
            "After {C:attention}2{} rounds,",
            "use to gain",
            "{C:attention}+1{} Consumable Slots",
            "{C:inactive}(Currently #1# of 2){}"
        }
    },

    pos = { x = 3, y = 5 },
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
        local n = (card and card.ability and card.ability.extra and card.ability.extra.completed_rounds) or 0
        return { vars = { n } }
    end,
    use = function(self, card, area, copier)
        local used_card = copier or card
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.4,
            func = function()
                card_eval_status_text(used_card, "extra", nil, nil, nil, {message = "+1 Consumable Slot", colour = G.C.DARK_EDITION})
                if G.consumeables and G.consumeables.config then
                    G.consumeables.config.card_limit = (G.consumeables.config.card_limit or 0) + 1
                end
                return true
            end
        }))
    end,
    can_use = function(self, card)
        return (card.ability.extra.completed_rounds or 0) >= (card.ability.extra.required_rounds or 2)
    end
}