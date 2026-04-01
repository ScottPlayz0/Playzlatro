SMODS.Joker{
    key = "greenneedle",
    loc_txt = {
        name = "Green Needle",
        text = {
            "Copies the ability",
            "of rightmost {C:attention}Joker{}"
        },
        unlock = {"Unlocked by default."}
    },

    atlas = "playz_jokers",
    pos = { x = 1, y = 5 },
    cost = 10,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,

    loc_vars = function(self, info_queue, card)
        local jokers = G and G.jokers and G.jokers.cards
        if not jokers then
            -- Safe early exit when no game jokers exist (collection / preview)
            return {}
        end

        local target_joker
        for i = #jokers, 1, -1 do
            local j = jokers[i]
            if j ~= card then
                target_joker = j
                break
            end
        end

        if card.area == G.jokers and target_joker and target_joker.config and target_joker.config.center and target_joker.config.center.blueprint_compat then
            card.ability.blueprint_compat = ' '..localize('k_compatible')..' '
            card.ability.bubble_colour = mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8)
        else
            card.ability.blueprint_compat = ' '..localize('k_incompatible')..' '
            card.ability.bubble_colour = mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8)
        end

        return { main_end = (card.area and card.area == G.jokers) and {
            { n = G.UIT.C, config = { align = "bm", minh = 0.4 }, nodes = {
                { n = G.UIT.C, config = { ref_table = card, align = "m", colour = card.ability.bubble_colour, r = 0.05, padding = 0.06 }, nodes = {
                    { n = G.UIT.T, config = { ref_table = card.ability, ref_value = 'blueprint_compat', colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.8 } },
                } }
            } }
        } }
    end,

    calculate = function(self, card, context)
        local jokers = G and G.jokers and G.jokers.cards
        if not jokers then return end

        local target_joker
        for i = #jokers, 1, -1 do
            local j = jokers[i]
            if j ~= card then
                target_joker = j
                break
            end
        end
        if not target_joker then return end
        return SMODS.blueprint_effect(card, target_joker, context)
    end
}
