SMODS.Joker{
    key = "azurite_cluster",
    config = { extra = { odds = 2, xmult0 = 1.5 } },
    loc_txt = {
        name = "Azurite Cluster",
        text = {
            "{C:green}1 in 2{} chance for",
            "played cards with",
            "{C:clubs}Clubs{} suit to give",
            "{X:red,C:white}X1.5{} Mult when scored"
        },
    },

    atlas = "playz_jokers",
    pos = { x = 0, y = 3 },
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,

    loc_vars = function(self, info_queue, card)
        
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j_modprefix_azurite') 
        return {vars = {new_numerator, new_denominator}}
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if context.other_card:is_suit("Clubs") then
                if SMODS.pseudorandom_probability(card, 'group_0_98d0e565', 1, card.ability.extra.odds, 'j_modprefix_azurite', false) then
                    SMODS.calculate_effect({Xmult = 1.5}, card)
                end
            end
        end
    end
}