SMODS.Booster {
    key = 'random_pack',
    atlas = "playlatro_boosters",
    pos = { x = 0, y = 0 },
    group_key = "pztro_random_packs",
    kind = "Random Pack",
    process_loc_text = function(self)
        SMODS.Booster.process_loc_text(self)
        G.localization.misc.dictionary[self.group_key] = "Random Pack"
        G.localization.misc.dictionary['k_' .. self.group_key] = "Random Pack"
    end,
    loc_txt = {
        name = "Random Pack",
        text = {
            "Choose {C:attention}1{} of up to",
            "{C:attention}4{} {C:attention}Random{} cards to",
            "be used or obtained"
        }
    },

    discovered = true,
    unlocked = true,
    draw_hand = true,
    cost = 5,
    config = { extra = 4, choose = 1 },

    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return { vars = { cfg.choose, cfg.extra } }
    end,
    create_card = function(self, card, i)
        local sets = {"Joker", "Tarot", "Planet", "Voucher", "Spectral"}
        local chosen_set = pseudorandom_element(sets, pseudoseed('pztro_random'))
        return { set = chosen_set, area = G.pack_cards, soulable = true }
    end,
    particles = function(self) end,
}

SMODS.Booster {
    key = 'random_pack2',
    atlas = "playlatro_boosters",
    pos = { x = 1, y = 0 },
    group_key = "pztro_random_packs",
    kind = "Random Pack",
    process_loc_text = function(self)
        SMODS.Booster.process_loc_text(self)
        G.localization.misc.dictionary[self.group_key] = "Random Pack"
        G.localization.misc.dictionary['k_' .. self.group_key] = "Random Pack"
    end,
    loc_txt = {
        name = "Random Pack",
        text = {
            "Choose {C:attention}1{} of up to",
            "{C:attention}4{} {C:attention}Random{} cards to",
            "be used or obtained"
        }
    },

    discovered = true,
    unlocked = true,
    draw_hand = true,
    cost = 5,
    config = { extra = 4, choose = 1 },

    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return { vars = { cfg.choose, cfg.extra } }
    end,
    create_card = function(self, card, i)
        local sets = {"Joker", "Tarot", "Planet", "Voucher", "Spectral"}
        local chosen_set = pseudorandom_element(sets, pseudoseed('pztro_random'))
        return { set = chosen_set, area = G.pack_cards, soulable = true }
    end,
    particles = function(self) end,
}

SMODS.Booster {
    key = 'jumbo_random_pack',
    atlas = "playlatro_boosters",
    pos = { x = 2, y = 0 },
    group_key = "pztro_random_packs",
    kind = "Random Pack",
    process_loc_text = function(self)
        SMODS.Booster.process_loc_text(self)
        G.localization.misc.dictionary[self.group_key] = "Random Pack"
        G.localization.misc.dictionary['k_' .. self.group_key] = "Random Pack"
    end,
    loc_txt = {
        name = "Jumbo Random Pack",
        text = {
            "Choose {C:attention}1{} of up to",
            "{C:attention}5{} {C:attention}Random{} cards to",
            "be used or obtained"
        }
    },

    discovered = true,
    unlocked = true,
    draw_hand = true,
    cost = 7,
    config = { extra = 5, choose = 1 },

    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return { vars = { cfg.choose, cfg.extra } }
    end,
    create_card = function(self, card, i)
        local sets = {"Joker", "Tarot", "Planet", "Voucher", "Spectral"}
        local chosen_set = pseudorandom_element(sets, pseudoseed('pztro_random'))
        return { set = chosen_set, area = G.pack_cards, soulable = true }
    end,
    particles = function(self) end,
}

SMODS.Booster {
    key = 'jumbo_random_pack2',
    atlas = "playlatro_boosters",
    pos = { x = 3, y = 0 },
    group_key = "pztro_random_packs",
    kind = "Random Pack",
    process_loc_text = function(self)
        SMODS.Booster.process_loc_text(self)
        G.localization.misc.dictionary[self.group_key] = "Random Pack"
        G.localization.misc.dictionary['k_' .. self.group_key] = "Random Pack"
    end,
    loc_txt = {
        name = "Jumbo Random Pack",
        text = {
            "Choose {C:attention}1{} of up to",
            "{C:attention}5{} {C:attention}Random{} cards to",
            "be used or obtained"
        }
    },

    discovered = true,
    unlocked = true,
    draw_hand = true,
    cost = 7,
    config = { extra = 5, choose = 1 },

    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return { vars = { cfg.choose, cfg.extra } }
    end,
    create_card = function(self, card, i)
        local sets = {"Joker", "Tarot", "Planet", "Voucher", "Spectral"}
        local chosen_set = pseudorandom_element(sets, pseudoseed('pztro_random'))
        return { set = chosen_set, area = G.pack_cards, soulable = true }
    end,
    particles = function(self) end,
}

SMODS.Booster {
    key = 'mega_random_pack',
    atlas = "playlatro_boosters",
    pos = { x = 4, y = 0 },
    group_key = "pztro_random_packs",
    kind = "Random Pack",
    process_loc_text = function(self)
        SMODS.Booster.process_loc_text(self)
        G.localization.misc.dictionary[self.group_key] = "Random Pack"
        G.localization.misc.dictionary['k_' .. self.group_key] = "Random Pack"
    end,
    loc_txt = {
        name = "Mega Random Pack",
        text = {
            "Choose {C:attention}2{} of up to",
            "{C:attention}6{} {C:attention}Random{} cards to",
            "be used or obtained"
        }
    },

    discovered = true,
    unlocked = true,
    draw_hand = true,
    cost = 9,
    config = { extra = 6, choose = 2 },

    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return { vars = { cfg.choose, cfg.extra } }
    end,
    create_card = function(self, card, i)
        local sets = {"Joker", "Tarot", "Planet", "Voucher", "Spectral"}
        local chosen_set = pseudorandom_element(sets, pseudoseed('pztro_random'))
        return { set = chosen_set, area = G.pack_cards, soulable = true }
    end,
    particles = function(self) end,
}