
SMODS.Enhancement {
    key = 'ceramic_card',
    pos = { x = 0, y = 0 },
    config = {
        extra = {
            xchips0 = 3,
            odds = 5
        }
    },
    loc_txt = {
        name = 'Ceramic Card',
        text = {
            [1] = '{X:blue,C:white}X3{} Chips',
            [2] = '{C:green}1 in 5{} chance to',
            [3] = 'destroy card'
        }
    },

    atlas = 'playzlatro_enhancements',
    any_suit = false,
    shatters = true,
    replace_base_card = false,
    no_rank = false,
    no_suit = false,
    always_scores = false,
    unlocked = true,
    discovered = true,
    no_collection = false,
    weight = 5,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,
    calculate = function(self, card, context)
        if context.destroy_card and context.cardarea == G.play and context.destroy_card == card and card.should_destroy then
            return { remove = true }
        end
        if context.main_scoring and context.cardarea == G.play then
            card.should_destroy = false
            return {
                x_chips = 3
                ,
                func = function()
                    if SMODS.pseudorandom_probability(card, 'group_0_e3ccf8d0', 1, card.ability.extra.odds, 'j_playzlat_ceramiccard', false) then
                        context.other_card.should_destroy = true
                        card.should_destroy = true
                        
                    end
                    return true
                end
            }
        end
    end
}