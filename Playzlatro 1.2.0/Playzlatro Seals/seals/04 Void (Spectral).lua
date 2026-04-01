SMODS.Consumable {
    key = 'void',
    set = 'Spectral',
    loc_txt = {
        name = 'Void',
        text = {
            "Add a Black Seal",
            "to 1 selected",
            "card in your hand"
        }
    },

    pos = { x = 0, y = 0 },
    cost = 4,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'playzlatro_seal_consumables',

    loc_vars = function(self, info_queue, card)
        for k, v in pairs(G.P_SEALS or {}) do
            if k:find("black_seal") then
                info_queue[#info_queue + 1] = v
                break
            end
        end
        return {}
    end,

    can_use = function(self, card)
        return G.hand and G.hand.highlighted and #G.hand.highlighted == 1
    end,

    use = function(self, card, area, copier)
        local selected_card = G.hand.highlighted[1]
        local target_key = nil

        for k, v in pairs(SMODS.Seals) do
            if k:find("black_seal") then
                target_key = k
                break
            end
        end

        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.4,
            func = function()
                if target_key and SMODS.Seals[target_key] then
                    selected_card:set_seal(target_key, true)
                    selected_card:juice_up(0.3, 0.5)
                    card_eval_status_text(selected_card, "extra", nil, nil, nil, {message = "Black Seal!"})
                else
                    for k, v in pairs(SMODS.Seals) do print("Found: " .. k) end
                    card_eval_status_text(selected_card, "extra", nil, nil, nil, {message = "Not Found - Check Console"})
                end
                return true
            end
        }))
    end
}