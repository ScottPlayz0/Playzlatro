SMODS.Joker{
    key = "raw_sulfur",
    config = { extra = { chips = 50 } },
    loc_txt = {
        name = "Raw Sulfur",
        text = {
            "Played cards with",
            "{C:diamonds}Diamond{} suit give",
            "{C:blue}+50{} Chips when scored"
        },
    },

    atlas = "playz_jokers",
    pos = { x = 1, y = 3 },
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if context.other_card:is_suit("Diamonds") then
                return {
                    chips = 50
                }
            end
        end
    end
}