SMODS.Joker{
    key = "dawn",
    config = {},
    loc_txt = {
        name = "Dawn",
        text = {
            "Retrigger all played",
            "cards in {C:attention}first{}",
            "{C:attention}hand{} of round"
        },
        unlock = { "Unlocked by default." }
    },

    atlas = "playz_jokers",
    pos = { x = 2, y = 1 },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play  then
            if G.GAME.current_round.hands_played == 0 then
                return {
                    repetitions = 1,
                    message = localize('k_again_ex')
                }
            end
        end
    end
}