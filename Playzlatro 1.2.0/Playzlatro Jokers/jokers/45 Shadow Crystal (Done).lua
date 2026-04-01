SMODS.Joker({
    key = "shadow_crystal",
    config = { extra = { blind_divisor = 3 }},
    loc_vars = function(self, info_queue, card)
        local divisor = (card and card.ability and card.ability.extra and card.ability.extra.blind_divisor)
            or self.config.extra.blind_divisor
        return { vars = { divisor } }
    end,

    loc_txt = {
        name = "Shadow Crystal",
        text = {
            "Divide {C:attention}blind size{} by",
            "{C:attention}#1#{} when blind is selected,",
            "sell to create a",
            "random {C:legendary}Legendary{} joker"
        },
        unlock = { "Unlocked by default." }
    },

    atlas = "playz_jokers",
    pos = { x = 4, y = 8 },
    soul_pos = { x = 1, y = 12 },
    soul_atlas = "playz_jokers",
    cost = 20,
    rarity = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    legendary = true,

    in_pool = function(self, args)
        return (
            not args 
            or args.source ~= 'sho' 
            or args.source == 'buf' or args.source == 'jud' or args.source == 'rif' or args.source == 'rta' or args.source == 'sou' or args.source == 'uta' or args.source == 'wra'
        )
        and true
    end,
    calculate = function(self, card, context)
        if context.setting_blind  then
            return {
                func = function()
                    if G.GAME.blind.in_blind then
                        local divisor = (card and card.ability and card.ability.extra and card.ability.extra.blind_divisor)
                            or self.config.extra.blind_divisor
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "/"..tostring(divisor).." Blind Size", colour = G.C.GREEN})
                        G.GAME.blind.chips = G.GAME.blind.chips / divisor
                        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                        G.HUD_blind:recalculate()
                        return true
                    end
                end
            }
        end
        if context.selling_self  then
            return {
                func = function()
                    local created_joker = false
                    if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                        created_joker = true
                        G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                local joker_card = SMODS.add_card({ set = 'Joker', rarity = 'Legendary' })
                                G.GAME.joker_buffer = 0
                                return true
                            end
                        }))
                    end
                    if created_joker then
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
                    end
                    return true
                end
            }
        end
    end
})