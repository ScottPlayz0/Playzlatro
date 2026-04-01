SMODS.Consumable {
    key = 'artistic',
    set = 'Tarot',
    config = { mod_conv = 'stock' },
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Tarot?', get_type_colour(self or card.config, card), nil, 1.2)
    end,
    loc_vars = function(self, info_queue, card)
        local target = nil
        for k, v in pairs(G.P_CENTERS) do
            if v.set == 'Enhanced' and k:find(self.config.mod_conv) then target = v; break end
        end
        if target then info_queue[#info_queue + 1] = target end
    end,
    loc_txt = {
        name = 'Artistic',
        text = { "Enhances up to {C:attention}2{}", "selected cards to", "{C:attention}Stock Cards{}" }
    },

    pos = { x = 3, y = 0 },
    cost = 3,
    unlocked = true,
    discovered = true,
    hidden = false,
    atlas = 'playzlatro_enhancement_consumables',

    can_use = function(self, card) return G.hand and G.hand.highlighted and #G.hand.highlighted > 0 and #G.hand.highlighted < 3 end,
    use = function(self, card, area, copier)
        local used_tarot = copier or card
        local targets = {}
        for i=1, #G.hand.highlighted do targets[i] = G.hand.highlighted[i] end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1'); used_tarot:juice_up(0.3, 0.5); return true 
        end }))
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
            for i=1, #targets do targets[i]:flip() end
            play_sound('card1', 1); return true 
        end }))
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            local target_enhancement = nil
            for k, v in pairs(G.P_CENTERS) do
                if v.set == 'Enhanced' and k:find(self.config.mod_conv) then target_enhancement = v; break end
            end
            if target_enhancement then
                for i=1, #targets do targets[i]:set_ability(target_enhancement) end
            end
            return true 
        end }))
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
            for i=1, #targets do targets[i]:flip() end
            play_sound('tarot2', 1, 0.6); return true 
        end }))
    end
}