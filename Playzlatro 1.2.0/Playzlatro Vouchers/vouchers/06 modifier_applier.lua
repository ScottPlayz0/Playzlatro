
SMODS.Voucher {
    key = 'modifier_applier',
    pos = { x = 1, y = 1 },
    config = { 
        extra = {
            voucher_slots0 = 1
        } 
    },
    loc_txt = {
        name = 'Modifier Applier',
        text = {
            [1] = 'Permanently',
            [2] = 'gain {C:attention}+1{} voucher',
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
    requires = {'v_playzlatrovouchers_gambling_addiction'},
    atlas = 'CustomVouchers',
    redeem = function(self, card)
        return {
            
            G.E_MANAGER:add_event(Event({
                func = function()
                    
                    
                    SMODS.change_voucher_limit(1)
                    return true
                end
            }))
        }
    end
}