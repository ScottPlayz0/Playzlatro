
SMODS.Voucher {
    key = 'private_party',
    pos = { x = 2, y = 0 },
    loc_txt = {
        name = 'Private Party',
        text = {
            [1] = '{C:dark_edition}+1{} Joker slot'
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
                    G.jokers.config.card_limit = G.jokers.config.card_limit + 1
                    return true
                end
            }))
            
        }
    end
}