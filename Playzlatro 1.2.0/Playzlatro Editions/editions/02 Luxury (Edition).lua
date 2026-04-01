SMODS.Shader({ key = 'luxury', path = 'luxury.fs' })

SMODS.Edition {
    key = 'luxury',
    shader = 'luxury',
    config = {
        extra = {
            dollars0 = 4
        }
    },
    in_shop = true,
    extra_cost = 5,
    apply_to_float = false,
    sound = { sound = "gold_seal", per = 0.9, vol = 0.7 },
    disable_shadow = false,
    disable_base_shader = false,
    loc_txt = {
        name = 'Luxury',
        label = 'Luxury',
        text = {
            "Gain {C:gold}$4{}"
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
                
                func = function()
                    
                    local current_dollars = G.GAME.dollars
                    local target_dollars = G.GAME.dollars + 4
                    local dollar_value = target_dollars - current_dollars
                    ease_dollars(dollar_value)
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = "+"..tostring(4), colour = G.C.MONEY})
                    return true
                end
            }
        end
    end
}