SMODS.Joker{
    key = "bluecard",
    config = {
        extra = {
            chips = 0,
            gain = 20
        }
    },
    loc_txt = {
        name = "Blue Card",
        text = {
            "This Joker gains",
            "{C:chips}+#1#{} Chips when any",
            "{C:attention}Booster Pack{} is skipped",
            "{C:inactive}(Currently{} {C:chips}+#2#{} {C:inactive}Chips){}"
        },
        unlock = { "Unlocked by default." }
    },

    atlas = "playz_jokers",
    pos = { x = 2, y = 2 },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,

    loc_vars = function(self, _, card)
        if card then
            card.ability = card.ability or {}
            card.ability.extra = card.ability.extra or {}
            card.ability.extra.gain  = card.ability.extra.gain  or (self.config and self.config.extra and self.config.extra.gain)  or 20
            card.ability.extra.chips = card.ability.extra.chips or (self.config and self.config.extra and self.config.extra.chips) or 0
        end
        local gain  = (card and card.ability and card.ability.extra and card.ability.extra.gain)  or (self.config and self.config.extra and self.config.extra.gain)  or 20
        local chips = (card and card.ability and card.ability.extra and card.ability.extra.chips) or (self.config and self.config.extra and self.config.extra.chips) or 0
        return { vars = { gain, chips } }
    end,

    calculate = function(self, card, context)
        if card then
            card.ability = card.ability or {}
            card.ability.extra = card.ability.extra or {}
            card.ability.extra.gain  = card.ability.extra.gain  or (self.config and self.config.extra and self.config.extra.gain)  or 20
            card.ability.extra.chips = card.ability.extra.chips or (self.config and self.config.extra and self.config.extra.chips) or 0
        end
        if context.skipping_booster and not context.blueprint then
            local gain = (card and card.ability and card.ability.extra and card.ability.extra.gain) or (self.config and self.config.extra and self.config.extra.gain) or 20
            card.ability.extra.chips = (card.ability.extra.chips or 0) + gain
            G.E_MANAGER:add_event(Event({
                func = function()
                    card:juice_up(0.8, 0.8)
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = "+" .. tostring(gain) .. " Chips",
                        colour = G.C.BLUE
                    })
                    return true
                end
            }))
        end
        if context.joker_main and card and card.ability and card.ability.extra and card.ability.extra.chips > 0 then
            return { chips = card.ability.extra.chips }
        end
    end
}
