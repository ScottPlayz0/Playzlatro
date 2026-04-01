SMODS.Joker{
    key = "cursed_dice",
    config = { extra = {  } },
    loc_txt = {
        name = "Cursed Dice",
        text = {
            "Halves all {C:attention}listed{}",
            "{C:green}probabilities{}",
            "{C:inactive}(ex:{} {C:green}1 in 3{} {C:inactive}->{} {C:green}0.5 in 3{}{C:inactive}){}"
        },
    },

    atlas = "playz_jokers",
    pos = { x = 3, y = 4 },
    cost = 4,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    
    calculate = function(self, card, context)
        if context.mod_probability then
            local numerator, denominator = context.numerator, context.denominator
            numerator = numerator * 0.5 
            return {
                numerator = numerator, 
                denominator = denominator
            }
        end
    end
}