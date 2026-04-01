SMODS.Consumable {
    key = "sigma",
    set = "Spectral",
    loc_txt = {
        name = 'Sigma',
        text = {
            "Make selected {C:attention}Joker{}",
            "{C:dark_edition}Negative{}, apply {C:gold}Rental{}",
            "sticker to the selected {C:attention}Joker{}"
        }
    },

    pos = { x = 0, y = 5 },
    cost = 4,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = "CustomConsumables",

    use = function(self, card, area, copier)
        local used_card = copier or card
        if #G.jokers.highlighted > 0 then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('timpani')
                    used_card:juice_up(0.3, 0.5)
                    return true
                end
            }))
            local total = #G.jokers.highlighted
            for i, joker_card in ipairs(G.jokers.highlighted) do
                local this_joker = joker_card
                local percent1 = 1.15 - (i - 0.999) / (total - 0.998) * 0.3
                local percent2 = 0.85 + (i - 0.999) / (total - 0.998) * 0.3
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        if this_joker then
                            this_joker:flip()
                            play_sound('card1', percent1)
                            this_joker:juice_up(0.3, 0.3)
                        end
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.25,
                    func = function()
                        if this_joker then
                            this_joker:set_edition("e_negative", true)
                        end
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = function()
                        if this_joker then
                            this_joker:add_sticker('rental', true)
                        end
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.45,
                    func = function()
                        if this_joker then
                            this_joker:flip()
                            play_sound('tarot2', percent2, 0.6)
                            this_joker:juice_up(0.3, 0.3)
                        end
                        return true
                    end
                }))
            end
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.7,
                func = function()
                    G.jokers:unhighlight_all()
                    return true
                end
            }))
            delay(0.5)
        end
    end,
    can_use = function(self, card)
        return (#G.jokers.highlighted > 0)
    end
}