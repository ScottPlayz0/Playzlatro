SMODS.Joker{
    key = "voraciousjoker",
    config = { extra = { chips = 30 } },
    loc_txt = {
        name = "Voracious Joker",
        text = {
            "Played cards with",
            "{C:clubs}Club{} suit give",
            "{C:chips}+#1#{} Chips when scored"
        },
        unlock = { "Unlocked by default." }
    },

    atlas = "playz_jokers",
    pos = { x = 4, y = 0 },
    cost = 5,
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
        if context.individual and context.cardarea == G.play then
            if context.other_card and context.other_card:is_suit("Clubs") then
                local chips = (context.other_card and context.other_card.ability and context.other_card.ability.extra and context.other_card.ability.extra.chips)
                    or (card and card.ability and card.ability.extra and card.ability.extra.chips)
                    or self.config.extra.chips
                return { chips = chips }
            end
        end
    end
}