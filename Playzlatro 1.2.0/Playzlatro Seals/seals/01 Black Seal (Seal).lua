SMODS.Seal {
    key = "black_seal",
    badge_colour = HEX('303030'),
    loc_txt = {
        name = "Black Seal",
        label = "Black Seal",
        text = {
            "Create 2 random {C:dark_edition}Negative{}",
            "{C:attention}Consumables{} if this card",
            "is held in hand at end of round.",
            "Removes {C:attention}Seal{} when triggered"
        }
    },

    pos = { x = 0, y = 0 },
    atlas = "playzlatro_seals",
    unlocked = true,
    discovered = true,
    no_collection = false,

    calculate = function(self, card, context)
        if not context.end_of_round or context.repetition or card.area ~= G.hand then
            card._blackseal_activated_this_end = nil
            return
        end
        if card.owner and G.local_player and card.owner ~= G.local_player then
            return
        end
        local round_id = context.round or context.round_index or context.round_number or context.event_id
        if not round_id then
            round_id = (G and G.round) or (G and G.SIM and G.SIM.round)
        end
        if round_id then
            if card._blackseal_last_round == round_id then
                return
            end
            card._blackseal_last_round = round_id
        else
            if card._blackseal_activated_this_end then
                return
            end
            card._blackseal_activated_this_end = true
        end
        return {
            message = "+1 Consumable",
            colour = G.C.SECONDARY_SET.Spectral,
            func = function()
                for i = 1, 2 do
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.4,
                        func = function()
                            local sets = {'Tarot', 'Planet', 'Spectral'}
                            local random_set = pseudorandom_element(sets, pseudoseed('black_seal_spawn'))
                            local created_consumable = create_card(random_set, G.consumeables, nil, nil, nil, nil, nil, 'blk_seal')
                            if created_consumable then
                                created_consumable:set_edition({negative = true}, true)
                                created_consumable:add_to_deck()
                                G.consumeables:emplace(created_consumable)
                                play_sound('timpani')
                                card:juice_up(0.3, 0.5)
                                card_eval_status_text(card, 'extra', nil, nil, nil, {
                                    message = "+2 Consumables",
                                    colour = G.C.SECONDARY_SET.Spectral
                                })
                            end
                            return true
                        end
                    }))
                end
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        card:set_seal(nil, true)
                        card:juice_up(0.3, 0.5)
                        return true
                    end
                }))

                return true
            end
        }
    end
}