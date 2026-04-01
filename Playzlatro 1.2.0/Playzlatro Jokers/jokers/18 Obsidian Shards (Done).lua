SMODS.Joker{
    key = "obsidian_shards",
    config = { extra = { mult0 = 7 } },
    loc_txt = {
        name = "Obsidian Shards",
        text = {
            "Played cards with",
            "{C:spades}Spade{} suit give",
            "{C:red}+7{} Mult when scored"
        },
    },

    atlas = "playz_jokers",
    pos = { x = 2, y = 3 },
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if context.other_card:is_suit("Spades") then
                return {
                    mult = 7
                }
            end
        end
    end
}