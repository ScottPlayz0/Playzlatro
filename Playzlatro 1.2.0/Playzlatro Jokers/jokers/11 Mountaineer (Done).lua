SMODS.Joker{
    key = "mountaineer",
    config = { extra = { perma_mult = 2 } },
    loc_txt = {
        name = "Mountaineer",
        text = {
            "Every played {C:attention}card{}",
            "permanently gains",
            "{C:mult}+#1#{} Mult when scored"
        },
        unlock = { "Unlocked by default." }
    },

    atlas = "playz_jokers",
    pos = { x = 0, y = 2 },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,

    loc_vars = function(self, _, card)
        local inc = (card and card.ability and card.ability.extra and card.ability.extra.perma_mult)
            or self.config.extra.perma_mult
        return { vars = { inc } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local inc = (card.ability and card.ability.extra and card.ability.extra.perma_mult)
                or self.config.extra.perma_mult
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult or 0
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult + inc
            return {
                extra = { message = localize('k_upgrade_ex'), colour = G.C.MULT },
                card = card
            }
        end
    end
}
