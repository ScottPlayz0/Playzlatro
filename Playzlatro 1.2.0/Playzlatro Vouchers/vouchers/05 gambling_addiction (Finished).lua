
SMODS.Voucher {
    key = 'gambling_addiction',
    pos = { x = 0, y = 1 },
    config = { 
        extra = {
            booster_slots0 = 1
        } 
    },
    loc_txt = {
        name = 'Gambling Addiction',
        text = {
            [1] = 'Permanently gain',
            [2] = '{C:attention}+1{} booster pack',
            [3] = 'slot in shop'
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
    atlas = 'CustomVouchers',
    redeem = function(self, card)
        return {
            
            G.E_MANAGER:add_event(Event({
                func = function()
                    
                    
                    SMODS.change_booster_limit(1)
                    return true
                end
            }))
        }
    end
}