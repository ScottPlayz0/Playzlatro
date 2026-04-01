SMODS.Seal {
    key = "white_seal",
    badge_colour = HEX('BDBDBD'),
    loc_txt = {
        name = "White Seal",
        label = "White Seal",
        text = {
            "Create a {C:spectral}Spectral{} card",
            "if this card is scored in the",
            "{C:attention}first hand{} of the round"
        }
    },

    pos = { x = 1, y = 0 },
    atlas = "playzlatro_seals",
    unlocked = true,
    discovered = true,
    no_collection = false,

    calculate = function(self, card, context)
        if context.after and G.GAME.current_round.hands_played == 0 then
            local in_hand = false
            for k, v in ipairs(context.scoring_hand) do
                if v == card then in_hand = true end
            end
            if in_hand then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    return {
                        message = localize('k_plus_spectral'),
                        colour = G.C.SECONDARY_SET.Spectral,
                        card = card,
                        func = function()
                            G.E_MANAGER:add_event(Event({
                                trigger = 'before',
                                delay = 0.0,
                                func = function()
                                    play_sound('timpani')
                                    local spectral = SMODS.add_card({ set = 'Spectral', area = G.consumeables, soulable = true })
                                    card:juice_up(0.3, 0.5)
                                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer - 1
                                    return true
                                end
                            }))
                        end
                    }
                end
            end
        end
    end
}