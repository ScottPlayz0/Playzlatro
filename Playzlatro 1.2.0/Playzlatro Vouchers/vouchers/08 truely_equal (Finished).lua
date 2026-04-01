SMODS.Voucher {
    key = 'true_equal',
    pos = { x = 3, y = 1 },
    loc_txt = {
        name = 'True Equal',
        text = {
            [1] = 'All {C:attention}Joker{} {C:common}R{}{C:uncommon}a{}{C:rare}r{}{C:legendary}i{}{C:common}t{}{C:uncommon}i{}{C:rare}e{}{C:legendary}s{}',
            [2] = 'appear {C:dark_edition}Equally{} as',
            [3] = 'often in the {C:attention}Shop{}'
        },
    },

    cost = 10,
    unlocked = true,
    discovered = true,
    no_collection = false,
    can_repeat_soul = false,
    requires = {'v_playzlatrovouchers_legend_shop'},
    atlas = 'CustomVoucher',

    redeem = function(self)
        G.GAME.playz_true_equal = true
    end
}