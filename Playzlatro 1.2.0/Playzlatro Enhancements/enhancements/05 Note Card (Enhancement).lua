SMODS.Enhancement {
    key = 'note_card',
    pos = { x = 4, y = 0 },
    config = {
        extra = {
            x_chips = 1.0,
            gain = 0.3
        }
    },
    loc_txt = {
        name = 'Note Card',
        text = {
            'Gains {X:blue,C:white}X#1#{} Chips',
            'when discarded',
            '{C:inactive}(Currently {X:blue,C:white}X#2#{} {C:inactive}Chips){}'
        }
    },

    atlas = 'playzlatro_enhancements',
    unlocked = true,
    discovered = true,
    weight = 5,

    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.gain, card.ability.extra.x_chips } }
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card == card then
            card.ability.extra.x_chips = card.ability.extra.x_chips + card.ability.extra.gain
            G.E_MANAGER:add_event(Event({
                func = function()
                    card:juice_up()
                    play_sound('chips1', 1.2, 0.4)
                    return true
                end
            }))
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS
            }
        end
        if context.main_scoring and context.cardarea == G.play then
            return {
                x_chips = card.ability.extra.x_chips
            }
        end
    end
}