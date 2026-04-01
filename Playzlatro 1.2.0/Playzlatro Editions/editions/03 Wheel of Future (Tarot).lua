SMODS.Consumable {
    key = 'wheel_of_future',
    set = 'Tarot',
    config = { extra = 4 },
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Tarot?', get_type_colour(self or card.config, card), nil, 1.2)
    end,
    loc_txt = {
        name = 'Wheel of Future',
        text = {
            "{C:green}#1# in #2#{} chance to add",
            "{C:dark_edition}Negative{}, {C:dark_edition}Retro{}, or",
            "{C:dark_edition}Luxury{} edition",
            "to a random {C:attention}Joker{}"
        }
    },

    pos = { x = 0, y = 0 },
    cost = 3,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'playzlatro_edition_consumables',

    loc_vars = function(self, info_queue, card)
        if G.P_CENTERS.e_negative then
            info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
        end
        local retro_key, luxury_key
        for k, v in pairs(G.P_CENTERS) do
            if v.set == 'Edition' then
                if k:find("retro") then retro_key = k end
                if k:find("luxury") then luxury_key = k end
            end
        end
        if retro_key and G.P_CENTERS[retro_key] then
            local c = G.P_CENTERS[retro_key]
            info_queue[#info_queue + 1] = {
                set = 'Edition',
                key = retro_key,
                config = c.config,
                loc_txt = c.loc_txt
            }
        end
        if luxury_key and G.P_CENTERS[luxury_key] then
            local c = G.P_CENTERS[luxury_key]
            info_queue[#info_queue + 1] = {
                set = 'Edition',
                key = luxury_key,
                config = c.config,
                loc_txt = c.loc_txt
            }
        end
        return { vars = { '' .. (G.GAME and G.GAME.probabilities.normal or 1), self.config.extra } }
    end,
    can_use = function(self, card)
        for i = 1, #G.jokers.cards do
            if not G.jokers.cards[i].edition then
                return true
            end
        end
        return false
    end,
    use = function(self, card, area, copier)
        local used_tarot = copier or card
        local eligible_jokers = {}

        for _, v in pairs(G.jokers.cards) do
            if not v.edition then
                table.insert(eligible_jokers, v)
            end
        end
        if #eligible_jokers > 0 then
            if pseudorandom('wheel_of_future') < G.GAME.probabilities.normal / card.ability.extra then
                local chosen_joker = pseudorandom_element(eligible_jokers, pseudoseed('wheel_of_future_joker'))
                G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.4, func = function()
                    used_tarot:juice_up(0.3, 0.5)
                    play_sound('tarot1')
                    local retro_key = nil
                    local luxury_key = nil
                    for k, v in pairs(G.P_CENTERS) do
                        if v.set == 'Edition' then
                            if k:find("retro") then retro_key = k end
                            if k:find("luxury") then luxury_key = k end
                        end
                    end
                    local choices = { "e_negative" }
                    if retro_key then table.insert(choices, retro_key) end
                    if luxury_key then table.insert(choices, luxury_key) end
                    local selection = pseudorandom_element(choices, pseudoseed('wheel_of_future_edition'))
                    local stripped_key = selection:gsub("^e_", "")
                    local edition_table = {}
                    edition_table[stripped_key] = true
                    chosen_joker:set_edition(edition_table, true)
                    attention_text({
                        text = "Success!",
                        scale = 1.3,
                        hold = 1.4,
                        major = chosen_joker,
                        backdrop_colour = G.C.DARK_EDITION,
                        align = 'cm',
                        offset = { x = 0, y = -0.7 }
                    })
                    return true
                end }))
            else
                G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.4, func = function()
                    used_tarot:juice_up(0.3, 0.5)
                    play_sound('tarot1')
                    attention_text({
                        text = localize('k_nope_ex'),
                        scale = 1.3,
                        hold = 1.4,
                        major = used_tarot,
                        backdrop_colour = G.C.SECONDARY_SET.Tarot,
                        align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and 'tm' or 'cm',
                        offset = {
                            x = 0,
                            y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and -0.2 or 0
                        },
                        silent = true
                    })
                    play_sound('tarot2', 1, 0.4)
                    return true
                end }))
            end
        end
    end
}