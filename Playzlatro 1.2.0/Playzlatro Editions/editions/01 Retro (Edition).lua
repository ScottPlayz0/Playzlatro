SMODS.Shader({ key = 'retro', path = 'retro.fs' })

SMODS.Edition {
    key = 'retro',
    shader = 'retro',
    config = {
        extra = {
            xchips0 = 1.7
        }
    },
    in_shop = true,
    extra_cost = 4,
    apply_to_float = false,
    sound = { sound = "negative", per = 1.6, vol = 0.6 },
    disable_shadow = false,
    disable_base_shader = false,
    loc_txt = {
        name = 'Retro',
        label = 'Retro',
        text = {
            "{X:blue,C:white}1.7x{} Chips"
        },
    },
    
    unlocked = true,
    discovered = true,
    no_collection = false,

    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    
    calculate = function(self, card, context)
        if context.pre_joker or (context.main_scoring and context.cardarea == G.play) then
            return {
                x_chips = 1.7
            }
        end
    end
}