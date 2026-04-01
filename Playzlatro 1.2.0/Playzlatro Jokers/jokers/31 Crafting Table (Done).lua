SMODS.Joker{
    key = "crafting_table",
    config = { extra = {} },
    loc_txt = {
        name = "Crafting Table",
        text = {
            "When {C:attention}Blind{} is Selected,",
            "Create 2 {C:attention}Random Jokers{}",
            "{C:inactive}(Can Create{} {C:legendary}Legendary{} {C:inactive}Jokers){}",
            "At end of round, create a {C:attention}Consumable{}"
        },
        unlock = { "Unlocked by default." }
    },

    atlas = "playz_jokers",
    pos = { x = 0, y = 6 },
    cost = 11,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,

    calculate = function(self, card, context)
        if context.setting_blind then
            SMODS.calculate_effect({ func = function()
                local created_count = 0
                for i = 1, 2 do
                    if #G.jokers.cards + (G.GAME.joker_buffer or 0) < G.jokers.config.card_limit then
                        G.GAME.joker_buffer = (G.GAME.joker_buffer or 0) + 1
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                SMODS.add_card({ set = 'Joker' })
                                G.GAME.joker_buffer = (G.GAME.joker_buffer or 1) - 1
                                return true
                            end
                        }))
                        created_count = created_count + 1
                    end
                end
                if created_count > 0 then
                    card_eval_status_text(
                        context.blueprint_card or card,
                        'extra', nil, nil, nil,
                        { message = localize('k_plus_joker'), colour = G.C.BLUE }
                    )
                end
                return true
            end }, card)
        end
        if context.end_of_round and context.game_over == false and context.main_eval then
            return {
                func = function()
                    local created_consumable = false
                    for i = 1, math.min(1, G.consumeables.config.card_limit - #G.consumeables.cards) do
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.4,
                            func = function()
                                play_sound('timpani')
                                local sets = {'Tarot', 'Planet', 'Spectral'}
                                local random_set = pseudorandom_element(sets, 'crafting_table_consumable')
                                SMODS.add_card({
                                    set = random_set,
                                    soulable = true
                                })
                                card:juice_up(0.3, 0.5)
                                created_consumable = true
                                return true
                            end
                        }))
                    end
                    delay(0.6)
                    if created_consumable then
                        card_eval_status_text(
                            context.blueprint_card or card,
                            'extra', nil, nil, nil,
                            { message = localize('k_plus_consumable'), colour = G.C.PURPLE }
                        )
                    end
                    return true
                end
            }
        end
    end
}
