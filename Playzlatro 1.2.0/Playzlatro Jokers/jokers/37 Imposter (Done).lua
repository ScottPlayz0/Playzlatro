SMODS.Joker{
    key = "imposter",
    config = {
        extra = {
            Xchips = 1,
            gain = 0.25
        }
    },
    loc_txt = {
        name = "Imposter",
        text = {
            "When a {C:attention}round ends{},",
            "gain {X:chips,C:white}X#2#{} Chips and ",
            "{C:attention}destroy{} a random consumable",
            "{C:inactive}(Currently{} {X:chips,C:white}X#1#{} {C:inactive}Chips){}"
        },
        unlock = { "Unlocked by default." }
    },

    atlas = "playz_jokers",
    pos = { x = 1, y = 7 },
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,

    _read_vals = function(self, card)
        local cfg = self.config and self.config.extra or {}
        local extra = card and card.ability and card.ability.extra or {}
        local Xchips = extra.Xchips or cfg.Xchips or 1
        local gain = cfg.gain or 0.25
        return Xchips, gain
    end,
    loc_vars = function(self, _, card)
        local Xchips, gain = self:_read_vals(card)
        return { vars = { Xchips, gain } }
    end,
    calculate = function(self, card, context)
        if card then
            card.ability = card.ability or {}
            card.ability.extra = card.ability.extra or {}
            card.ability.extra.Xchips = card.ability.extra.Xchips or (self.config and self.config.extra and self.config.extra.Xchips) or 1
        end
        if context.cardarea == G.jokers and context.joker_main and card then
            return {
                x_chips = card.ability.extra.Xchips
            }
        end
        if context.end_of_round and context.main_eval and not context.game_over and card then
            return {
                func = function()
                    card.ability.extra.Xchips = (card.ability.extra.Xchips or 1) + 0.25
                    local consumables = (G.consumeables and G.consumeables.cards) or {}
                    local target_card = nil
                    if #consumables > 0 then
                        target_card = pseudorandom_element(consumables, pseudoseed("j_modprefix_imposter"))
                        if target_card then
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    target_card:start_dissolve()
                                    return true
                                end
                            }))
                        end
                    end
                    card_eval_status_text(card, "extra", nil, nil, nil, {
                        message = "XChips +0.25",
                        colour = G.C.BLUE
                    })
                    if target_card then
                        card_eval_status_text(card, "extra", nil, nil, nil, {
                            message = "Destroyed Consumable!",
                            colour = G.C.RED
                        })
                    end
                    return true
                end
            }
        end
    end
}