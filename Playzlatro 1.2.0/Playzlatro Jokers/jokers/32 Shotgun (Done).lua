SMODS.Joker{
    key = "shotgun",
    config = { extra = { odds = 8, current_odds = 8 } },
    loc_txt = {
        name = "Shotgun",
        text = {
            "When a {C:blue}hand{} is played,",
            "{C:green}#1# in #2#{} chance to increase",
            "{C:attention}blind size{} by {C:attention}50%{}, otherwise",
            "reduce blind size by {C:attention}25%{}"
        }
    },

    atlas = "playz_jokers",
    pos = { x = 1, y = 6 },
    cost = 8,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,

    loc_vars = function(self, info_queue, card)
        return { 
            vars = { 
                (G.GAME and G.GAME.probabilities.normal) or 1, 
                card.ability.extra.current_odds 
            } 
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if pseudorandom('shotgun') < (G.GAME.probabilities.normal / card.ability.extra.current_odds) then
                G.GAME.blind.chips = math.floor(G.GAME.blind.chips * 1.5)
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                card.ability.extra.current_odds = card.ability.extra.odds
                return {
                    message = "KABOOM! +50%",
                    colour = G.C.RED
                }
            else
                G.GAME.blind.chips = math.floor(G.GAME.blind.chips * 0.75)
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                card.ability.extra.current_odds = math.max(1, card.ability.extra.current_odds - 1)
                return {
                    message = "Click... -25%",
                    colour = G.C.BLUE
                }
            end
        end
    end
}