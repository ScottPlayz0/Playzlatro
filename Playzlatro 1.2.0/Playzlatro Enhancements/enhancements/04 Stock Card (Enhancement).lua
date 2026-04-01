SMODS.Enhancement {
    key = 'stock_card',
    pos = { x = 3, y = 0 },
    config = {
        extra = {
            x_mult = 1.0,
            gain = 0.2
        }
    },
    loc_txt = {
        name = 'Stock Card',
        text = {
            'Gains {X:red,C:white}X#1#{} Mult',
            'when discarded',
            '{C:inactive}(Currently {X:red,C:white}X#2#{} {C:inactive}Mult){}'
        }
    },

    atlas = 'playzlatro_enhancements',
    unlocked = true,
    discovered = true,
    weight = 5,

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.gain, card.ability.extra.x_mult } }
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card == card then
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.gain
            G.E_MANAGER:add_event(Event({
                func = function()
                    card:juice_up()
                    return true
                end
            }))
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.RED
            }
        end
        if context.main_scoring and context.cardarea == G.play then
            return {
                x_mult = card.ability.extra.x_mult
            }
        end
    end
}