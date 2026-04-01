SMODS.Consumable {
    key = 'creator',
    set = 'Tarot',
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Tarot?', get_type_colour(self or card.config, card), nil, 1.2)
    end,
    config = { 
        extra = {
            odds = 5   
        } 
    },
    loc_txt = {
        name = "Creator",
        text = {
            "{C:green}1 in #1#{} chance to create",
            "a {C:legendary}Legendary{} Joker",
            "{C:inactive}(Must have room){}"
        }
    },

    pos = { x = 1, y = 0 },
    cost = 3,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',

    loc_vars = function(self, info_queue, card)
        return { vars = { (card and card.ability.extra.odds) or self.config.extra.odds } }
    end,
    can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
    end,
    use = function(self, card, area, copier)
        local used_card = copier or card
        if SMODS.pseudorandom_probability(used_card, 'creator_roll', 1, self.config.extra.odds, 'j_consumab_creator') then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('timpani')
                    if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                        G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                        SMODS.add_card({ set = 'Joker', rarity = 'Legendary' })
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            func = function()
                                G.GAME.joker_buffer = 0
                                return true
                            end
                        }))
                    end
                    used_card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        else
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('tarot2', 0.5) 
                    used_card:juice_up(0.3, 0.1)
                    card_eval_status_text(used_card, 'extra', nil, nil, nil, {message = "Nope!", colour = G.C.RED})
                    return true
                end
            }))
        end
        delay(0.6)
    end
}