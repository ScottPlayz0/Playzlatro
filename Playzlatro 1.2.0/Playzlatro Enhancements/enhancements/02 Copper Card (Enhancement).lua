
SMODS.Enhancement {
    key = 'copper_card',
    pos = { x = 1, y = 0 },
    config = {
        extra = {
            xchips0 = 1.75
        }
    },
    loc_txt = {
        name = 'Copper Card',
        text = {
            [1] = '{X:blue,C:white}X1.75{} Chips',
            [2] = 'while this card',
            [3] = 'stays in hand'
        }
    },

    atlas = 'playzlatro_enhancements',
    any_suit = false,
    replace_base_card = false,
    no_rank = false,
    no_suit = false,
    always_scores = false,
    unlocked = true,
    discovered = true,
    no_collection = false,
    weight = 5,

    calculate = function(self, card, context)
        if context.cardarea == G.hand and context.main_scoring then
            return {
                x_chips = 1.75
            }
        end
    end
}