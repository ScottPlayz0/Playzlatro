SMODS.Joker{
    key = "ruby_parcel",
    config = { extra = { dollars0 = 1 } },
    loc_txt = {
        name = "Ruby Parcel",
        text = {
            "Played cards with",
            "{C:hearts}Heart{} suit earn",
            "{C:gold}$1{} when scored"
        },
    },

    atlas = "playz_jokers",
    pos = { x = 4, y = 2 },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if context.other_card:is_suit("Hearts") then
                return {
                    func = function()
                        local current_dollars = G.GAME.dollars
                        local target_dollars = G.GAME.dollars + 1
                        local dollar_value = target_dollars - current_dollars
                        ease_dollars(dollar_value)
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+"..tostring(1), colour = G.C.MONEY})
                        return true
                    end
                }
            end
        end
    end
}