SMODS.Voucher {
    key = 'power_player',
    config = { 
        extra = {
            hand_size0 = 1,
            play_size0 = 1
        } 
    },
    loc_txt = {
        name = 'Power Player',
        text = {
            'Permanently gain',
            '{C:attention}+1{} hand size and',
            '{C:attention}+1{} hand selection limit'
        },
        unlock = {
            'Unlocked by default.'
        }
    },

    pos = { x = 0, y = 0 },
    cost = 10,
    unlocked = true,
    discovered = true,
    no_collection = false,
    can_repeat_soul = false,
    atlas = 'CustomVouchers',

    redeem = function(self, card)
        return {
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand:change_size(1)
                    return true
                end
            })),
            extra = {
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.change_play_limit(1)
                        return true
                    end
                })),
                colour = G.C.WHITE
            }
        }
    end
}