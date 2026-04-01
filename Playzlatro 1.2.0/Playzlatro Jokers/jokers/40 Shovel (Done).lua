SMODS.Joker{
    key = "shovel",
    loc_txt = {
        name = "Shovel",
        text = {
            "When {C:attention}sold{}, destroy",
            "the {C:attention}3 left-most{} cards",
            "held in hand."
        }
    },
    atlas = "playz_jokers",
    pos = { x = 4, y = 7 },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = false,

    calculate = function(self, card, context)
        if context.selling_self and not context.blueprint then
            local to_destroy = {}
            for i = 1, 3 do
                if G.hand.cards[i] then
                    table.insert(to_destroy, G.hand.cards[i])
                end
            end
            for _, target in ipairs(to_destroy) do
                if not target.config.center.eternal then
                    target:start_dissolve()
                end
            end
            return {
                message = "Dig!",
                colour = G.C.CHIPS
            }
        end
    end
}