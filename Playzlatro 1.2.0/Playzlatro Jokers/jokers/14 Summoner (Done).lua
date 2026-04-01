SMODS.Joker{
    key = "summoner",
    config = {
        extra = {
            create_count = 1
        }
    },
    loc_txt = {
        name = "Summoner",
        text = {
            "When {C:attention}Blind{} is selected",
            "create {C:attention}#1#{} {C:uncommon}Uncommon{} {C:attention}Joker{}",
            "{C:inactive}(Must have room){}"
        },
        unlock = { "Unlocked by default." }
    },

    atlas = "playz_jokers",
    pos = { x = 3, y = 2 },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,

    loc_vars = function(self, _, card)
        local cnt = (card and card.ability and card.ability.extra and card.ability.extra.create_count)
            or (self.config and self.config.extra and self.config.extra.create_count)
            or 1
        return { vars = { cnt } }
    end,

    calculate = function(self, card, context)
        if context.setting_blind  then
            return {
                func = function()
                    local created_joker = false
                    local create_count = (card and card.ability and card.ability.extra and card.ability.extra.create_count)
                        or (self.config and self.config.extra and self.config.extra.create_count)
                        or 1
                    for i = 1, create_count do
                        if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                            created_joker = true
                            G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    local joker_card = SMODS.add_card({ set = 'Joker', rarity = 'Uncommon' })
                                    G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                                    return true
                                end
                            }))
                        end
                    end
                    if created_joker then
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
                    end
                    return true
                end
            }
        end
    end
}
