SMODS.Seal {
    key = "prismatic_seal",
    badge_colour = HEX('FF91FA'),
    loc_txt = {
        name = "Prismatic Seal",
        label = "Prismatic Seal",
        text = {
            "Create a random",
            "{C:attention}consumable{} when this card",
            "is played and scores"
        }
    },

    pos = { x = 2, y = 0 },
    atlas = "playzlatro_seals",
    unlocked = true,
    discovered = true,
    no_collection = false,

    calculate = function(self, card, context)
        if context.after and context.cardarea == G.play then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                return {
                    message = localize('k_plus_consumable'),
                    colour = G.C.PURPLE,
                    card = card,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            trigger = 'before',
                            delay = 0.0,
                            func = function()
                                local consumable_pools = {}
                                for k, v in pairs(G.P_CENTER_POOLS) do
                                    if k == 'Tarot' or k == 'Planet' or k == 'Spectral' or SMODS.ConsumableTypes[k] then
                                        table.insert(consumable_pools, k)
                                    end
                                end
                                local random_set = pseudorandom_element(consumable_pools, 'prismatic_seal_set')
                                play_sound('timpani')
                                local new_card = SMODS.add_card({ 
                                    set = random_set, 
                                    area = G.consumeables, 
                                    soulable = true 
                                })
                                card:juice_up(0.3, 0.5)
                                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer - 1
                                return true
                            end
                        }))
                    end
                }
            end
        end
    end
}