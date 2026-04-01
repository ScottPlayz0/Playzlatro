SMODS.Consumable {
    key = "idol_of_absolute",
    set = "idol",
    config = {
        extra = {
            required_rounds = 6,
            completed_rounds = 0
        }
    },
    loc_txt = {
        name = "Idol of Absolute",
        text = {
            "After {C:attention}6{} rounds,",
            "use to gain",
            "{C:dark_edition}+1{} Everything",
            "{C:inactive}(Currently #1# of 6){}"
        }
    },

    pos = { x = 4, y = 7 },
    cost = 9,
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
        return (card.ability.extra.completed_rounds or 0) >= (card.ability.extra.required_rounds or 6)
    end,
    use = function(self, card, area, copier)
        local used_card = copier or card
        G.E_MANAGER:add_event(Event({
            trigger = "after", delay = 0.4,
            func = function()
                card_eval_status_text(used_card, "extra", nil, nil, nil, {message = "+1 Hand", colour = G.C.BLUE})
                G.GAME.round_resets.hands = G.GAME.round_resets.hands + 1
                ease_hands_played(1)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = "after", delay = 0.4,
            func = function()
                card_eval_status_text(used_card, "extra", nil, nil, nil, {message = "+1 Discard", colour = G.C.RED})
                G.GAME.round_resets.discards = G.GAME.round_resets.discards + 1
                ease_discard(1)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = "after", delay = 0.4,
            func = function()
                card_eval_status_text(used_card, "extra", nil, nil, nil, {message = "+1 Hand Size", colour = G.C.BLUE})
                G.hand.config.card_limit = G.hand.config.card_limit + 1
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = "after", delay = 0.4,
            func = function()
                card_eval_status_text(used_card, "extra", nil, nil, nil, {message = "+1 Play Size", colour = G.C.BLUE})
                SMODS.change_play_limit(1)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = "after", delay = 0.4,
            func = function()
                card_eval_status_text(used_card, "extra", nil, nil, nil, {message = "+1 Discard Size", colour = G.C.RED})
                SMODS.change_discard_limit(1)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = "after", delay = 0.4,
            func = function()
                card_eval_status_text(used_card, "extra", nil, nil, nil, {message = "+1 Joker Slot", colour = G.C.DARK_EDITION})
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = "after", delay = 0.4,
            func = function()
                card_eval_status_text(used_card, "extra", nil, nil, nil, {message = "+1 Consumable Slot", colour = G.C.DARK_EDITION})
                if G.consumeables and G.consumeables.config then
                    G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
                end
                return true
            end
        }))
    end
}