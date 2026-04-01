--Decks
SMODS.Atlas({
    key = "modicon",
    path = "ModIcon.png",
    px = 34,
    py = 34,
    atlas_table = "ASSET_ATLAS"
})

SMODS.Atlas({
    key = "decks",
    px = 71,
    py = 95,
    path = "decks.png"
})

SMODS.Back{
    name = "Leveling Deck",
    key = "leveling_deck",
    config = { },
    config = {joker_slot = -3, add_joker_slot = 1, ante = -0},
    loc_txt = {
        name = "Leveling Deck",
        text = {
            "Start with {C:red}-3 Joker slots{}",
            "After defeating each", 
            "{C:attention}Boss Blind{},",
            "gain {C:attention}+1 Joker slots{}"
        },
    },

    pos = {x = 0, y = 0},
    unlocked = true,
    discovered = true,
    no_collection = false,
    atlas = "decks",

    calculate = function(self, back, context)
        if context.context == "eval" and G.GAME.last_blind.boss then
            G.jokers.config.card_limit =
                G.jokers.config.card_limit + self.config.add_joker_slot
        end
    end,
}

SMODS.Back{
    name = "Hoarder Deck",
    key = "hoarder_deck",
    config = { },
    loc_txt = {
        name = "Hoarder Deck",
        text = {
            "Start with {C:red}-2 Consumable slots{},",
            "and {C:red}-1 Hand Size{}.",
            "After each {C:attention}Boss Blind{}, gain",
            "{C:attention}+1 Hand Size{}, {C:attention}+1 Consumable slot{}"
        }
    },

    pos = {x = 1, y = 0},
    unlocked = true,
    discovered = true,
    no_collection = false,
    atlas = "decks",

    calculate = function(self, back, context)
        if context.context == "eval"
        and G.GAME.last_blind
        and G.GAME.last_blind.boss then
            G.E_MANAGER:add_event(Event({
                func = function()
                    if G.hand then
                        G.hand:change_size(1)
                    end
                    if G.consumeables and G.consumeables.config then
                        G.consumeables.config.card_limit =
                            (G.consumeables.config.card_limit or 0) + 1
                    end
                    return true
                end
            }))
        end
    end,
    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                if G.hand then
                    G.hand:change_size(-1)
                end
                if G.consumeables and G.consumeables.config then
                    G.consumeables.config.card_limit =
                        (G.consumeables.config.card_limit or 0) - 2
                end
                return true
            end
        }))
    end
}

SMODS.Back {
    name = "Overflow Deck",
    key = "overflow_deck",
    config = {},
    loc_txt = {
        name = "Overflow Deck",
        text = {
            "Start with {C:attention}Overstock{},",
            "gain {C:attention}+1 Booster slot{}",
            "and {C:attention}+1 Voucher slot{}"
        }
    },

    pos = {x = 2, y = 0},
    unlocked = true,
    discovered = true,
    no_collection = false,
    atlas = "decks",

    loc_vars = function(self, info_queue, card)
        if info_queue then
            info_queue[#info_queue + 1] = { key = "v_overstock_norm", set = "Voucher" }
        end
        return { vars = {} }
    end,
    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.vouchers = G.GAME.vouchers or {}
                G.GAME.used_vouchers = G.GAME.used_vouchers or {}
                for _, voucher_key in ipairs({ "v_overstock_norm" }) do
                    if G.P_CENTERS[voucher_key] then
                        G.GAME.used_vouchers[voucher_key] = true
                        G.GAME.vouchers[#G.GAME.vouchers + 1] = voucher_key
                    end
                end
                SMODS.change_booster_limit(1)
                SMODS.change_voucher_limit(1)
                return true
            end
        }))
    end
}

SMODS.Back{
    name = "Crimson Deck",
    key = "crimson_deck",
    config = { hand_size0 = 1, play_size0 = 1, discard_size0 = 1 },
    loc_txt = {
        name = "Crimson Deck",
        text = {
            "{C:dark_edition}+1{} selection limit",
            "and {C:attention}+1{} hand size",
            "every round"
        }
    },

    pos = {x = 3, y = 0},
    unlocked = true,
    discovered = true,
    no_collection = false,
    atlas = 'decks',

    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.hand:change_size(1)
                SMODS.change_play_limit(1)
                SMODS.change_discard_limit(1)
                return true
            end
        }))
    end
}

SMODS.Back{
    name = "Shattered Deck",
    key = "shattered_deck",
    loc_txt = {
        name = "Shattered Deck",
        text = {
            "{C:red}Heavily Reduced starting stats{}",
            "{C:attention}Increase{} lost stats after ",
            "defeating the {C:attention}Boss Blind{}",
            "{C:inactive}+0.5 in certain stats works like +0{}"
        }
    },

    pos = {x = 4, y = 0},
    unlocked = true,
    discovered = true,
    no_collection = false,
    atlas = "decks",

    calculate = function(self, back, context)
        if context.context == "eval" and G.GAME.last_blind and G.GAME.last_blind.boss then
            if G.jokers then G.jokers.config.card_limit = G.jokers.config.card_limit + 0.5 end
            if G.consumeables then G.consumeables.config.card_limit = G.consumeables.config.card_limit + 0.5 end
            if G.GAME.starting_params then
                G.GAME.starting_params.joker_slots = (G.GAME.starting_params.joker_slots or 2) + 0.5
                G.GAME.starting_params.consumable_slots = (G.GAME.starting_params.consumable_slots or 1) + 0.5
            end
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand:change_size(1)
                    G.GAME.round_resets.hands = (G.GAME.round_resets.hands or 0) + 0.5
                    G.GAME.round_resets.discards = (G.GAME.round_resets.discards or 0) + 0.5
                    ease_hands_played(0.5)
                    ease_discard(0.5)
                    SMODS.change_play_limit(0.5)
                    SMODS.change_discard_limit(0.5)
                    return true
                end
            }))
        end
    end,
    apply = function(self, back)
        G.GAME.starting_params.hands = (G.GAME.starting_params.hands or 4) - 1
        G.GAME.starting_params.joker_slots = (G.GAME.starting_params.joker_slots or 5) - 3
        G.GAME.starting_params.consumable_slots = (G.GAME.starting_params.consumable_slots or 2) - 1
        G.GAME.starting_params.discards = (G.GAME.starting_params.discards or 3) - 1
        G.E_MANAGER:add_event(Event({
            func = function()
                if G.hand then G.hand:change_size(-1) end
                ease_ante(-1)
                SMODS.change_play_limit(-0.5)
                SMODS.change_discard_limit(-0.5)
                return true
            end
        }))
    end
}


--Sleeves
if CardSleeves then

    SMODS.Atlas({
    key = "deck_sleeves",
    px = 73,
    py = 95,
    path = "deck_sleeves.png"
})

CardSleeves.Sleeve({
    key = "leveling_sleeve",
    name = "Leveling Sleeve",
    config = { joker_slot = -3, add_joker_slot = 1, ante = -0 },
    unlocked = true,
    loc_txt = {
        name = "Leveling Sleeve",
        text = {
            "Start with {C:red}-3 Joker slots{}",
            "After defeating each",
            "{C:attention}Boss Blind{},",
            "gain {C:attention}+1 Joker slots{}"
        },
    },

    pos = { x = 0, y = 0 },
    unlocked = true,
    discovered = true,
    no_collection = false,
    atlas = "deck_sleeves",

    calculate = function(self, sleeve, context)
        if context.context == "eval"
        and G and G.GAME and G.GAME.last_blind and G.GAME.last_blind.boss
        and G.jokers and G.jokers.config and type(G.jokers.config.card_limit) == "number" then
            G.jokers.config.card_limit = G.jokers.config.card_limit + (self.config.add_joker_slot or 0)
        end
    end,
})

CardSleeves.Sleeve({
    key = "hoarder_sleeve",
    name = "Hoarder Sleeve",
    config = { },
    unlocked = true,
    loc_txt = {
        name = "Hoarder Sleeve",
        text = {
            "Start with {C:red}-2 Consumable slots{},",
            "and {C:red}-1 Hand Size{}.",
            "After each {C:attention}Boss Blind{}, gain",
            "{C:attention}+1 Hand Size{}, {C:attention}+1 Consumable slot{}"
        }
    },

    pos = { x = 1, y = 0 },
    unlocked = true,
    discovered = true,
    no_collection = false,
    atlas = "deck_sleeves",

    calculate = function(self, back, context)
        if context.context == "eval"
        and G.GAME.last_blind
        and G.GAME.last_blind.boss then
            G.E_MANAGER:add_event(Event({
                func = function()
                    if G.hand then
                        G.hand:change_size(1)
                    end
                    if G.consumeables and G.consumeables.config then
                        G.consumeables.config.card_limit =
                            (G.consumeables.config.card_limit or 0) + 1
                    end
                    return true
                end
            }))
        end
    end,
    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                if G.hand then
                    G.hand:change_size(-1)
                end
                if G.consumeables and G.consumeables.config then
                    G.consumeables.config.card_limit =
                        (G.consumeables.config.card_limit or 0) - 2
                end
                return true
            end
        }))
    end
})

CardSleeves.Sleeve({
    key = "overflow_sleeve",
    name = "Overflow Sleeve",
    config = { },
    unlocked = true,
    loc_txt = {
        name = "Overflow Sleeve",
        text = {
            "Start with {C:attention}Overstock Plus{},",
            "gain {C:attention}+1 Booster slot{}",
            "and {C:attention}+1 Voucher slot{}"
        }
    },

    pos = {x = 2, y = 0},
    unlocked = true,
    discovered = true,
    no_collection = false,
    atlas = "deck_sleeves",

    loc_vars = function(self, info_queue, card)
        if info_queue then
            info_queue[#info_queue + 1] = { key = "v_overstock_plus", set = "Voucher" }
        end
        return { vars = {} }
    end,
    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.vouchers = G.GAME.vouchers or {}
                G.GAME.used_vouchers = G.GAME.used_vouchers or {}
                for _, voucher_key in ipairs({ "v_overstock_plus" }) do
                    if G.P_CENTERS[voucher_key] then
                        G.GAME.used_vouchers[voucher_key] = true
                        G.GAME.vouchers[#G.GAME.vouchers + 1] = voucher_key
                    end
                end
                SMODS.change_booster_limit(1)
                SMODS.change_voucher_limit(1)
                return true
            end
        }))
    end
})

CardSleeves.Sleeve({
    key = "crimson_sleeve",
    name = "Crimson Sleeve",
    config = { hand_size0 = 1, play_size0 = 1, discard_size0 = 1 },
    loc_txt = {
        name = "Crimson Sleeve",
        text = {
            "{C:dark_edition}+1{} selection limit",
            "and {C:attention}+1{} hand size",
            "every round"
        }
    },

    pos = {x = 3, y = 0},
    unlocked = true,
    discovered = true,
    no_collection = false,
    atlas = 'deck_sleeves',

    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.hand:change_size(1)
                SMODS.change_play_limit(1)
                SMODS.change_discard_limit(1)
                return true
            end
        }))
    end
})

CardSleeves.Sleeve({
    key = "shattered_sleeve",
    name = "Shattered Sleeve",
    config = { },
    unlocked = true,
    loc_txt = {
        name = "Shattered Sleeve",
        text = {
            "{C:red}Heavily Reduced starting stats{}",
            "{C:attention}Increase{} lost stats after ",
            "defeating the {C:attention}Boss Blind{}",
            "{C:inactive}+0.5 in certain stats works like +0{}"
        }
    },

    pos = {x = 4, y = 0},
    unlocked = true,
    discovered = true,
    no_collection = false,
    atlas = "deck_sleeves",

    calculate = function(self, back, context)
        if context.context == "eval" and G.GAME.last_blind and G.GAME.last_blind.boss then
            if G.jokers then G.jokers.config.card_limit = G.jokers.config.card_limit + 0.5 end
            if G.consumeables then G.consumeables.config.card_limit = G.consumeables.config.card_limit + 0.5 end
            if G.GAME.starting_params then
                G.GAME.starting_params.joker_slots = (G.GAME.starting_params.joker_slots or 2) + 0.5
                G.GAME.starting_params.consumable_slots = (G.GAME.starting_params.consumable_slots or 1) + 0.5
            end
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand:change_size(1)
                    G.GAME.round_resets.hands = (G.GAME.round_resets.hands or 0) + 0.5
                    G.GAME.round_resets.discards = (G.GAME.round_resets.discards or 0) + 0.5
                    ease_hands_played(0.5)
                    ease_discard(0.5)
                    SMODS.change_play_limit(0.5)
                    SMODS.change_discard_limit(0.5)
                    return true
                end
            }))
        end
    end,
    apply = function(self, back)
        G.GAME.starting_params.hands = (G.GAME.starting_params.hands or 4) - 1
        G.GAME.starting_params.joker_slots = (G.GAME.starting_params.joker_slots or 5) - 3
        G.GAME.starting_params.consumable_slots = (G.GAME.starting_params.consumable_slots or 2) - 1
        G.GAME.starting_params.discards = (G.GAME.starting_params.discards or 3) - 1
        G.E_MANAGER:add_event(Event({
            func = function()
                if G.hand then G.hand:change_size(-1) end
                ease_ante(-1)
                SMODS.change_play_limit(-0.5)
                SMODS.change_discard_limit(-0.5)
                return true
            end
        }))
    end
    })

end