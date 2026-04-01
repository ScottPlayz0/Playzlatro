SMODS.Joker{
    key = "slotmachine",
    config = {
        extra = {
            Xmult_amt = 1.7,
            payout = 1.7
        }
    },
    loc_txt = {
        name = "Slot Machine",
        text = {
            "Every scored 7 gives",
            "{X:red,C:white}×#1#{} Mult and {C:gold}$#2#{}"
        },
        unlock = { "Unlocked by default." }
    },

    atlas = "playz_jokers",
    pos = { x = 3, y = 3 },
    cost = 14,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,

    loc_vars = function(self, _, card)
        local xmult = (card and card.ability and card.ability.extra and card.ability.extra.Xmult_amt)
            or (self.config and self.config.extra and self.config.extra.Xmult_amt)
            or 1.7
        local payout = (card and card.ability and card.ability.extra and card.ability.extra.payout)
            or (self.config and self.config.extra and self.config.extra.payout)
            or 7
        return { vars = { xmult, payout } }
    end,

    calculate = function(self, card, context)
        if card then
            card.ability = card.ability or {}
            card.ability.extra = card.ability.extra or {}
            card.ability.extra.Xmult_amt = card.ability.extra.Xmult_amt
                or (self.config.extra and self.config.extra.Xmult_amt)
                or 1.7
            card.ability.extra.payout = card.ability.extra.payout
                or (self.config.extra and self.config.extra.payout)
                or 7
        end
        if context.individual and context.cardarea == G.play then
            if context.other_card and context.other_card.get_id and context.other_card:get_id() == 7 then
                local xmult = card.ability.extra.Xmult_amt
                local payout = card.ability.extra.payout
                return {
                    Xmult = xmult,
                    extra = {
                        func = function()
                            ease_dollars(payout)
                            card_eval_status_text(
                                context.blueprint_card or card,
                                'extra',
                                nil,
                                nil,
                                nil,
                                { message = "+" .. tostring(payout), colour = G.C.MONEY }
                            )
                            return true
                        end,
                        colour = G.C.MONEY
                    }
                }
            end
        end
    end
}
