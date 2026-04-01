SMODS.Joker{
    key = "sacrificialknife",
    config = {
        extra = {
            chips = 0,
            multiplier = 8
        }
    },
    loc_txt = {
        name = "Sacrificial Knife",
        text = {
            "When {C:attention}Blind{} is selected,",
            "destroy Joker to the left",
            "and permanently add {C:attention}#1#x{}",
            "its sell value to {C:chips}Chips{}",
            "{C:inactive}(Currently{} {C:chips}+#2#{} {C:inactive}Chips{})"
        },
        unlock = { "Unlocked by default." }
    },

    atlas = "playz_jokers",
    pos = { x = 1, y = 1 },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,

    loc_vars = function(self, _, card)
        if card then
            card.ability = card.ability or {}
            card.ability.extra = card.ability.extra or {}
        end
        local mult = (card and card.ability and card.ability.extra and card.ability.extra.multiplier)
            or self.config.extra.multiplier
        local chips = (card and card.ability and card.ability.extra and card.ability.extra.chips)
            or self.config.extra.chips
        return { vars = { mult, chips } }
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    my_pos = i
                    break
                end
            end
            if not my_pos or my_pos <= 1 then return end
            local target = G.jokers.cards[my_pos - 1]
            if target.getting_sliced or SMODS.is_eternal(target) then return end
            target.getting_sliced = true
            local multiplier = (card and card.ability and card.ability.extra and card.ability.extra.multiplier)
                or self.config.extra.multiplier
            local gained = (target.sell_cost or 0) * multiplier
            card.ability = card.ability or {}
            card.ability.extra = card.ability.extra or {}
            card.ability.extra.chips = (card.ability.extra.chips or self.config.extra.chips) + gained

            G.E_MANAGER:add_event(Event({
                func = function()
                    card:juice_up(0.8, 0.8)
                    target:start_dissolve({G.C.RED}, nil, 1.6)
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = "+" .. gained .. " Chips",
                        colour = G.C.BLUE
                    })
                    return true
                end
            }))
        end
        if context.joker_main then
            local chips = (card and card.ability and card.ability.extra and card.ability.extra.chips)
                or self.config.extra.chips
            if chips and chips > 0 then
                return { chips = chips }
            end
        end
    end
}
