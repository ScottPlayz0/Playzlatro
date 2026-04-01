SMODS.Consumable {
    key = 'upgrade',
    set = 'Spectral',
    loc_txt = {
        name = 'Upgrade',
        text = {
            "Apply random {C:dark_edition}edition{}",
            "to selected {C:attention}Joker{}"
        }
    },
    
    pos = { x = 4, y = 3 },
    cost = 4,
    unlocked = true,
    discovered = true,
    hidden = false,
    atlas = 'CustomConsumables',
    
    can_use = function(self, card)
        if #G.jokers.highlighted == 1 then
            local target = G.jokers.highlighted[1]
            if not target.edition then
                return true
            end
        end
        return false
    end,
    use = function(self, card, area, copier)
        local used_card = copier or card
        local target = G.jokers.highlighted[1]
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                used_card:juice_up(0.3, 0.5)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,
            func = function()
                target:flip()
                play_sound('card1', 1.1)
                target:juice_up(0.3, 0.3)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                local edition_pool = {}
                for k, v in pairs(G.P_CENTERS) do
                    if v.set == 'Edition' then
                        table.insert(edition_pool, k)
                    end
                end
                local selection = pseudorandom_element(edition_pool, pseudoseed('adjustment_edition'))
                local stripped_key = selection:gsub("^e_", "")
                local edition_table = {}
                edition_table[stripped_key] = true
                target:set_edition(edition_table, true)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,
            func = function()
                target:flip()
                play_sound('tarot2', 0.9, 0.6)
                target:juice_up(0.3, 0.3)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.jokers:unhighlight_all()
                return true
            end
        }))
    end
}