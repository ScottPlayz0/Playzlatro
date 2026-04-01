
SMODS.Voucher {
    key = 'whole_circus',
    pos = { x = 3, y = 0 },
    loc_txt = {
        name = 'Whole Circus',
        text = {
            [1] = '{C:dark_edition}+2{} Joker slot'
        },
        unlock = {
            [1] = 'Unlocked by default.'
        }
    },
    cost = 10,
    unlocked = true,
    discovered = true,
    no_collection = false,
    can_repeat_soul = false,
    requires = {'v_playzlatrovouchers_private_party'},
    atlas = 'CustomVouchers',
    redeem = function(self, card)
        return {
            
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.jokers.config.card_limit = G.jokers.config.card_limit + 2
                    return true
                end
            }))
            
        }
    end
}