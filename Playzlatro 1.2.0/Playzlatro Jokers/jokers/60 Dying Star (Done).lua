SMODS.Joker({
    key = "dying_star",
    config = { extra = { repetitions = 3 }},
    loc_txt = {
        name = "Dying Star",
        text = {
            "Raises the {C:planet}Planet Level{}",
            "of every played",
            "or discarded hand"
        },
        unlock = { "Unlocked by default." }
    },

    atlas = "playz_jokers",
    pos = { x = 4, y = 11 },
    soul_pos = { x = 4, y = 12 },
    soul_atlas = "playz_jokers",
    cost = 20,
    rarity = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    legendary = true,

    calculate = function(self, card, context)
        if context.before and context.cardarea == G.jokers then
            local target_hand = (context.scoring_name or "High Card")
            level_up_hand(card, target_hand, true, 1)
            return {
                message = localize('k_level_up_ex')
            }
        end
        if context.pre_discard then
            local text = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
            local target_hand2 = text
            level_up_hand(card, target_hand2, true, 1)
            return {
                message = localize('k_level_up_ex')
            }
        end
    end
})
