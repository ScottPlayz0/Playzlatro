SMODS.Consumable {
    key = 'candling',
    set = 'Tarot',
    config = { mod_conv = 'm_ceramic' },
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge('Tarot?', get_type_colour(self or card.config, card), nil, 1.2)
    end,
    loc_vars = function(self, info_queue, card)
        local target = G.P_CENTERS[self.config.mod_conv]
        if not target then
            for k, v in pairs(G.P_CENTERS) do
                if v.set == 'Enhanced' and k:find("ceramic") then
                    target = v
                    break
                end
            end
        end
        if target then
            info_queue[#info_queue + 1] = target
        end
    end,
    loc_txt = {
        name = 'Candling',
        text = {
            "Enhances {C:attention}1{} selected",
            "card into a",
            "{C:attention}Ceramic Card{}"
        }
    },
    
    pos = { x = 0, y = 0 },
    cost = 3,
    unlocked = true,
    discovered = true,
    hidden = false,
    atlas = 'playzlatro_enhancement_consumables',

    can_use = function(self, card)
        return G.hand and G.hand.highlighted and #G.hand.highlighted == 1
    end,
    use = function(self, card, area, copier)
        local used_tarot = copier or card
        local highlighted = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            used_tarot:juice_up(0.3, 0.5)
            return true 
        end }))
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
            highlighted:flip()
            play_sound('card1', 1)
            return true 
        end }))
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            local target_enhancement = G.P_CENTERS[self.config.mod_conv]
            if not target_enhancement then
                for k, v in pairs(G.P_CENTERS) do
                    if v.set == 'Enhanced' and k:find("ceramic") then
                        target_enhancement = v
                        break
                    end
                end
            end
            if target_enhancement then
                highlighted:set_ability(target_enhancement)
            end
            return true 
        end }))
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
            highlighted:flip()
            play_sound('tarot2', 1, 0.6)
            return true 
        end }))
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
            highlighted:juice_up(0.3, 0.5)
            return true 
        end }))
    end
}