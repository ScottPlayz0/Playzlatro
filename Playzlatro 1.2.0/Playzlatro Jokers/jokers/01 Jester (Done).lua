SMODS.Joker{
    key = "jester",
    config = { extra = { chips = 45 } },
    loc_txt = {
        name = "Jester",
        text = {
            "{C:chips}+#1#{} Chips"
        },
        unlock = { "Unlocked by default." }
    },

    atlas = "playz_jokers",
    pos = { x = 0, y = 0 },
    cost = 2,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,

    loc_vars = function(self, _, card)
        local chips = (card and card.ability and card.ability.extra and card.ability.extra.chips)
            or self.config.extra.chips
        return { vars = { chips } }
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            local chips = (card and card.ability and card.ability.extra and card.ability.extra.chips)
                or self.config.extra.chips
            return { chips = chips }
        end
    end
}