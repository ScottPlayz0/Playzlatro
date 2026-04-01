SMODS.Joker{
    key = "ouroboros",
    config = {
        extra = {
            Xchips = 1.2,
            Xmult  = 1.3,
            denom  = 1
        }
    },
    loc_txt = {
        name = "Ouroboros",
        text = {
            "{C:mult}×#1# Mult{}, {C:chips}×#2# Chips{}, {C:green}#5# in #6#{} chance",
            "to be {C:attention}sacrificed{} at {C:attention}end of round{},",
            "{C:inactive}({}{C:mult}+#3# Mult{}{C:inactive},{} {C:chips}+#4# Chips{} {C:inactive}and{} {C:green}+1{} {C:inactive}when sacrificed,{}",
            "{C:inactive}stats persist between shop appearances){}"
        },
        unlock = { "Unlocked by default." }
    },

    atlas = "playz_jokers",
    pos = { x = 3, y = 7 },
    cost = 3,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,

    _read_vals = function(self, card)
        local g = G.GAME or {}
        local cfg = self.config and self.config.extra or {}
        local Xchips = g.ouroboros_Xchips or (card and card.ability and card.ability.extra and card.ability.extra.Xchips) or cfg.Xchips or 1.2
        local Xmult  = g.ouroboros_Xmult  or (card and card.ability and card.ability.extra and card.ability.extra.Xmult)  or cfg.Xmult  or 1.3
        local denom  = g.ouroboros_denom  or (card and card.ability and card.ability.extra and card.ability.extra.denom)  or cfg.denom  or 1
        return Xchips, Xmult, denom
    end,

    loc_vars = function(self, _, card)
        if card then
            card.ability = card.ability or {}
            card.ability.extra = card.ability.extra or {}
        end
        local Xchips, Xmult, denom = self:_read_vals(card)
        local gainMult  = 0.3
        local gainChips = 0.2
        if SMODS and SMODS.get_probability_vars and card then
            local ok, numer, out_denom = pcall(SMODS.get_probability_vars, card, 1, denom, "j_modprefix_ouroboros")
            if ok and numer and out_denom then
                return { vars = { Xmult, Xchips, gainMult, gainChips, numer, out_denom } }
            end
        end
        return { vars = { Xmult, Xchips, gainMult, gainChips, 1, denom } }
    end,

    calculate = function(self, card, context)
        if card then
            card.ability = card.ability or {}
            card.ability.extra = card.ability.extra or {}
            local g = G.GAME or {}
            card.ability.extra.Xchips = g.ouroboros_Xchips or card.ability.extra.Xchips or (self.config and self.config.extra and self.config.extra.Xchips) or 1.2
            card.ability.extra.Xmult  = g.ouroboros_Xmult  or card.ability.extra.Xmult  or (self.config and self.config.extra and self.config.extra.Xmult)  or 1.3
            card.ability.extra.denom  = g.ouroboros_denom  or card.ability.extra.denom  or (self.config and self.config.extra and self.config.extra.denom)  or 1
        end
        if context.cardarea == G.jokers and context.joker_main and card then
            return {
                x_chips = card.ability.extra.Xchips,
                extra = {
                    Xmult = card.ability.extra.Xmult,
                    denom = card.ability.extra.denom
                }
            }
        end
        if context.end_of_round and context.main_eval and not context.game_over and card then
            local denom = card.ability and card.ability.extra and card.ability.extra.denom or (self.config.extra and self.config.extra.denom) or 1
            local numer, out_denom
            if SMODS and SMODS.get_probability_vars then
                local ok, n, d = pcall(SMODS.get_probability_vars, card, 1, denom, "j_modprefix_ouroboros")
                if ok and n and d then
                    numer, out_denom = n, d
                end
            end
            numer = numer or 1
            out_denom = out_denom or denom
            if SMODS and SMODS.pseudorandom_probability and SMODS.pseudorandom_probability(card, "group_ouroboros", numer, out_denom, "j_modprefix_ouroboros") then
                local incChips = 0.2
                local incMult  = 0.3
                local incDenom = 1
                G.GAME = G.GAME or {}
                G.GAME.ouroboros_Xchips = (G.GAME.ouroboros_Xchips or (self.config.extra and self.config.extra.Xchips) or 1.2) + incChips
                G.GAME.ouroboros_Xmult  = (G.GAME.ouroboros_Xmult  or (self.config.extra and self.config.extra.Xmult)  or 1.3) + incMult
                G.GAME.ouroboros_denom  = (G.GAME.ouroboros_denom  or (self.config.extra and self.config.extra.denom)  or 1)   + incDenom
                if card and card.ability and card.ability.extra then
                    card.ability.extra.Xchips = G.GAME.ouroboros_Xchips
                    card.ability.extra.Xmult  = G.GAME.ouroboros_Xmult
                    card.ability.extra.denom  = G.GAME.ouroboros_denom
                end
                card.getting_sliced = true
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:start_dissolve({ G.C.RED }, nil, 2.4)
                        card_eval_status_text(card, "extra", nil, nil, nil, {
                            message = string.format("Sacrificed"),
                            colour = G.C.RED
                        })
                        return true
                    end
                }))
            end
        end
    end
}