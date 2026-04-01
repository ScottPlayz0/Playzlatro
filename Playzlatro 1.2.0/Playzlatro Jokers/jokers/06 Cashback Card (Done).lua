SMODS.Joker{
    key = "employeediscount",
    config = {
        extra = {
            purchase_reward = 2,
            booster_reward = 2
        }
    },
    loc_txt = {
        name = "Employee Discount",
        text = {
            "Gain {C:gold}$#1#{} whenever making",
            "any purchase in the {C:attention}shop{}"
        },
        unlock = { "Unlocked by default." }
    },

    atlas = "playz_jokers",
    pos = { x = 0, y = 1 },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,

    loc_vars = function(self, _, card)
        local reward = (card and card.ability and card.ability.extra and card.ability.extra.purchase_reward)
            or self.config.extra.purchase_reward
        return { vars = { reward } }
    end,

    calculate = function(self, card, context)
        if context.buying_card then
            local reward = (card and card.ability and card.ability.extra and card.ability.extra.purchase_reward)
                or self.config.extra.purchase_reward
            return {
                func = function()
                    ease_dollars(reward)
                    card_eval_status_text(
                        context.blueprint_card or card,
                        'extra',
                        nil,
                        nil,
                        nil,
                        {message = "+" .. tostring(reward), colour = G.C.MONEY}
                    )
                    return true
                end
            }
        end
        if context.open_booster then
            local reward = (card and card.ability and card.ability.extra and card.ability.extra.booster_reward)
                or self.config.extra.booster_reward
            return {
                func = function()
                    ease_dollars(reward)
                    card_eval_status_text(
                        context.blueprint_card or card,
                        'extra',
                        nil,
                        nil,
                        nil,
                        {message = "+" .. tostring(reward), colour = G.C.MONEY}
                    )
                    return true
                end
            }
        end
    end
}
