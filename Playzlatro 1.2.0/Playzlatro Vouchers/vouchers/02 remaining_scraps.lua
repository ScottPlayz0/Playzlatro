SMODS.Voucher {
    key = 'remaining_scraps',
    config = { 
        extra = {
            discard_size0 = 1
        } 
    },
    loc_txt = {
        name = 'Remaining Scraps',
        text = {
            'Permanently gain',
            '{C:attention}+1{} consumable slot and',
            '{C:attention}+1{} discard selection limit'
        },
        unlock = {
            'Unlocked by default.'
        }
    },

    pos = { x = 1, y = 0 },
    cost = 10,
    unlocked = true,
    discovered = true,
    no_collection = false,
    can_repeat_soul = false,
    requires = {'v_playzlatrovouchers_power_player'},
    atlas = 'CustomVouchers',

    redeem = function(self, card)
        return {
            G.E_MANAGER:add_event(Event({
                func = function()
                    SMODS.change_discard_limit(1)
                    return true
                end
            })),
            extra = {
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
                        return true
                    end
                })),
                colour = G.C.BLUE
            }
        }
    end
}