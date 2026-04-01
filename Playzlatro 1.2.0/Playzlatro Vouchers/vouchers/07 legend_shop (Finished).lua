SMODS.Voucher {
    key = 'legend_shop',
    pos = { x = 2, y = 1 },
    loc_txt = {
        name = 'Legend Shop',
        text = {
            [1] = '{C:legendary}Legendary{} {C:attention}Jokers{} can',
            [2] = 'appear in the {C:attention}Shop{}'
        },
    },

    cost = 10,
    unlocked = true,
    discovered = true,
    no_collection = false,
    can_repeat_soul = false,
    atlas = 'CustomVoucher',

    redeem = function(self)
        G.GAME.playz_legendary_in_shop = true
        G.GAME.playz_legendary_rate = (G.GAME.playz_legendary_rate or 0) + 0.01
    end
}