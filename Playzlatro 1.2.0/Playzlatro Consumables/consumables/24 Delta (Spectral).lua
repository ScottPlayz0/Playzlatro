SMODS.Consumable {
    key = 'delta',
    set = 'Spectral',
    loc_txt = {
        name = 'Delta',
        text = {
            "Apply random {C:dark_edition}Editions{} to",
            "up to {C:attention}3{} random cards in hand.",
            "{C:inactive}(Includes Modded Editions){}"
        }
    },

    pos = { x = 3, y = 4 },
    cost = 4,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',

    use = function(self, card, area, copier)
        local used_card = copier or card
        local affected_cards = {}
        local temp_hand = {}
        for _, playing_card in ipairs(G.hand.cards) do temp_hand[#temp_hand + 1] = playing_card end
        pseudoshuffle(temp_hand, pseudoseed('delta_shuffle'))
        for i = 1, math.min(3, #temp_hand) do 
            affected_cards[#affected_cards + 1] = temp_hand[i] 
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                used_card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #affected_cards do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    affected_cards[i]:flip()
                    play_sound('card1', 1.1)
                    affected_cards[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.2)
        for i = 1, #affected_cards do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    local edition_pool = {}
                    for _, ed in pairs(G.P_CENTER_POOLS["Edition"]) do
                        edition_pool[#edition_pool + 1] = ed.key
                    end
                    local random_edition = pseudorandom_element(edition_pool, pseudoseed('delta_edition'))
                    affected_cards[i]:set_edition(random_edition, true)
                    return true
                end
            }))
        end
        for i = 1, #affected_cards do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    affected_cards[i]:flip()
                    play_sound('tarot2', 0.9, 0.6)
                    affected_cards[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end,
    can_use = function(self, card)
        return G.hand and #G.hand.cards > 0
    end
}