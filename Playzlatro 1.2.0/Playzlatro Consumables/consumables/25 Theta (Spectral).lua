SMODS.Consumable {
    key = "Theta",
    set = "Spectral",
    config = { 
        extra = {
            target_money = -25
        } 
    },
    loc_txt = {
        name = "Theta",
        text = {
            "Create a random {C:legendary}Legendary{} {C:attention}Joker{},",
            "sets money to {C:money}-$25{}"
        }
    },

    pos = { x = 4, y = 4 },
    cost = 4,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = "CustomConsumables",

    can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
    end,
    use = function(self, card, area, copier)
        local used_card = copier or card
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                SMODS.add_card({ set = 'Joker', rarity = 'Legendary' })
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    func = function()
                        G.GAME.joker_buffer = 0
                        return true
                    end
                }))
                used_card:juice_up(0.3, 0.5)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local current_dollars = G.GAME.dollars
                local target_dollars = self.config.extra.target_money
                local dollar_difference = target_dollars - current_dollars
                card_eval_status_text(used_card, 'extra', nil, nil, nil, {
                    message = "Set to -$"..math.abs(target_dollars), 
                    colour = G.C.MONEY
                })
                ease_dollars(dollar_difference, true)
                return true
            end
        }))
        delay(0.6)
    end
}