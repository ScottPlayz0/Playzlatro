SMODS.Joker({
    key = "brokenrecord",
    config = { extra = { repetitions = 3 }},
    loc_txt = {
        name = "Broken Record",
        text = {
            "{C:attention}Retrigger{} scored",
            "cards {C:attention}#1#{} additional times"
        },
        unlock = { "Unlocked by default." }
    },

    atlas = "playz_jokers",
    pos = { x = 3, y = 11 },
    soul_pos = { x = 3, y = 12 },
    soul_atlas = "playz_jokers",
    cost = 20,
    rarity = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    legendary = true,

    loc_vars = function(self, _, card)
        local reps = (card and card.ability and card.ability.extra and card.ability.extra.repetitions)
            or (self.config and self.config.extra and self.config.extra.repetitions)
            or 3
        return { vars = { reps } }
    end,

    calculate = function(self, card, context)
        if card and card.ability == nil then card.ability = {} end
        if card and card.ability.extra == nil then card.ability.extra = {} end
        local reps = (card and card.ability and card.ability.extra and card.ability.extra.repetitions)
            or (self.config and self.config.extra and self.config.extra.repetitions)
            or 3
        if context.repetition and context.cardarea == G.play then
            return {
                repetitions = reps,
                message = localize('k_again_ex')
            }
        end
    end
})
