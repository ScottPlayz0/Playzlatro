SMODS.Booster {
    key = 'voucher_pack',
    atlas = "playzlatro_voucher_packs",
    pos = { x = 0, y = 0 },
    group_key = "pztro_voucher_packs",
    kind = "Voucher Pack",
    process_loc_text = function(self)
        SMODS.Booster.process_loc_text(self)
        G.localization.misc.dictionary[self.group_key] = "Voucher Pack"
        G.localization.misc.dictionary['k_' .. self.group_key] = "Voucher Pack"
    end,
    loc_txt = {
        name = "Voucher Pack",
        text = {
            "Choose {C:attention}1{} of up to",
            "{C:attention}2{} {C:voucher}Voucher{} cards",
            "to be collected"
        }
    },

    discovered = true,
    unlocked = true,
    cost = 12,
    weight = 1,
    config = { extra = 2, choose = 1 },

    loc_vars = function(self, info_queue, card)
        return { vars = { (card and card.ability.choose) or self.config.choose, (card and card.ability.extra) or self.config.extra } }
    end,
    create_card = function(self, card)
        return create_card('Voucher', G.pack_cards, nil, nil, true, true, nil, 'pztro_v')
    end,

    in_pool = function() return true end
}

SMODS.Booster {
    key = 'jumbo_voucher_pack',
    atlas = "playzlatro_voucher_packs",
    pos = { x = 1, y = 0 },
    group_key = "pztro_voucher_packs",
    kind = "Voucher Pack",
    process_loc_text = function(self)
        SMODS.Booster.process_loc_text(self)
        G.localization.misc.dictionary[self.group_key] = "Voucher Pack"
        G.localization.misc.dictionary['k_' .. self.group_key] = "Voucher Pack"
    end,
    loc_txt = {
        name = "Jumbo Voucher Pack",
        text = {
            "Choose {C:attention}1{} of up to",
            "{C:attention}3{} {C:voucher}Voucher{} cards",
            "to be collected"
        }
    },

    discovered = true,
    unlocked = true,
    cost = 14,
    weight = 1,
    config = { extra = 3, choose = 1 },

    loc_vars = function(self, info_queue, card)
        return { vars = { (card and card.ability.choose) or self.config.choose, (card and card.ability.extra) or self.config.extra } }
    end,
    create_card = function(self, card)
        return create_card('Voucher', G.pack_cards, nil, nil, true, true, nil, 'pztro_v')
    end,
    in_pool = function() return true end
}

SMODS.Booster {
    key = 'mega_voucher_pack',
    atlas = "playzlatro_voucher_packs",
    pos = { x = 2, y = 0 },
    group_key = "pztro_voucher_packs",
    kind = "Voucher Pack",
    process_loc_text = function(self)
        SMODS.Booster.process_loc_text(self)
        G.localization.misc.dictionary[self.group_key] = "Voucher Pack"
        G.localization.misc.dictionary['k_' .. self.group_key] = "Voucher Pack"
    end,
    loc_txt = {
        name = "Mega Voucher Pack",
        text = {
            "Choose {C:attention}2{} of up to",
            "{C:attention}4{} {C:voucher}Voucher{} cards",
            "to be collected"
        }
    },

    discovered = true,
    unlocked = true,
    cost = 18,
    weight = 1,
    config = { extra = 4, choose = 2 },

    loc_vars = function(self, info_queue, card)
        return { vars = { (card and card.ability.choose) or self.config.choose, (card and card.ability.extra) or self.config.extra } }
    end,
    create_card = function(self, card)
        return create_card('Voucher', G.pack_cards, nil, nil, true, true, nil, 'pztro_v')
    end,
    in_pool = function() return true end
}