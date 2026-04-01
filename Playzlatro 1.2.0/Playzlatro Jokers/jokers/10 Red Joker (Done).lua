SMODS.Joker{
    key = "redjoker",
    config = {
        extra = {
            mult = 0,
            increment = 1,
        }
    },
    loc_txt = {
        name = "Red Joker",
        text = {
            "{C:mult}+#3#{} Mult for every 3",
            "remaining cards in {C:attention}deck{}",
            "{C:inactive}(Currently{} {C:mult}+#1#{} {C:inactive}Mult){}"
        },
        unlock = { "Unlocked by default." }
    },

    atlas = "playz_jokers",
    pos = { x = 4, y = 1 },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,

    loc_vars = function(self, _, card)
        local remaining = (G.deck and G.deck.cards and #G.deck.cards) or 0
        local divisor = 3
        local increment = (card and card.ability and card.ability.extra and card.ability.extra.increment)
            or self.config.extra.increment or 1
        if type(increment) ~= "number" then increment = self.config.extra.increment or 1 end
        local remaining_units = remaining / divisor
        local remaining_bonus = remaining_units * increment
        local base_mult = (card and card.ability and card.ability.extra and card.ability.extra.base_mult)
            or self.config.extra.mult or 0
        local total_mult = base_mult + remaining_bonus
        if card then
            card.ability = card.ability or {}
            card.ability.extra = card.ability.extra or {}
            card.ability.extra.base_mult = base_mult
            card.ability.extra.remaining_units = remaining_units
            card.ability.extra.remaining_bonus = remaining_bonus
            card.ability.extra.mult = total_mult
            card.ability.extra.increment = increment
        end
        return { vars = { remaining_bonus, 3, increment } }
    end,

    calculate = function(self, card, context)
        local remaining = (G.deck and G.deck.cards and #G.deck.cards) or 0
        local divisor = 3
        local increment = (card and card.ability and card.ability.extra and card.ability.extra.increment)
            or self.config.extra.increment or 1
        if type(increment) ~= "number" then increment = self.config.extra.increment or 1 end
        local remaining_units = remaining / divisor
        local remaining_bonus = remaining_units * increment
        local base_mult = (card and card.ability and card.ability.extra and card.ability.extra.base_mult)
            or self.config.extra.mult or 0
        local total_mult = base_mult + remaining_bonus
        if card then
            card.ability = card.ability or {}
            card.ability.extra = card.ability.extra or {}
            card.ability.extra.base_mult = base_mult
            card.ability.extra.remaining_units = remaining_units
            card.ability.extra.remaining_bonus = remaining_bonus
            card.ability.extra.mult = total_mult
            card.ability.extra.increment = increment
        end
        if context.joker_main then
            return { mult = total_mult }
        end
    end
}
