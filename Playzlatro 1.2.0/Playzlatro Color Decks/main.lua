-- existing atlas / backs unchanged above...
SMODS.Atlas({
    key = "modicon", 
    path = "ModIcon.png", 
    px = 34,
    py = 34,
    atlas_table = "ASSET_ATLAS"
})

SMODS.Atlas({
    key = "color_decks",
    px = 71,
    py = 95,
    path = "color_decks.png"
})

SMODS.Back{
    name = "Striped Deck",
    key = "striped_deck",
    atlas = "color_decks",
    pos = {x = 0, y = 0},
    config = {suit1 = "Clubs", suit2 = "Hearts"},
    loc_txt = {
        name = "Striped Deck",
        text={
            "Start run with ",
            "{C:attention}26{} {C:clubs}Clubs{} and", 
            "{C:attention}26{} {C:hearts}Hearts{} in deck",},
    },

    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                for _, card in ipairs(G.playing_cards) do
                    if(card.base.suit == "Spades") then
                        assert(SMODS.change_base(card, self.config.suit2, nil))
                    elseif(card.base.suit == "Diamonds") then
                        assert(SMODS.change_base(card, self.config.suit1, nil))
                    end
                end
                return true
            end
        }))
    end
}

SMODS.Back{
    name = "Rippled Deck",
    key = "rippled_deck",
    atlas = "color_decks",
    pos = {x = 1, y = 0},
    config = {suit1 = "Clubs", suit2 = "Spades"},
    loc_txt = {
        name = "Rippled Deck",
        text={
            "Start run with ",
            "{C:attention}26{} {C:clubs}Clubs{} and", 
            "{C:attention}26{} {C:spades}Spades{} in deck",},
    },

    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                for _, card in ipairs(G.playing_cards) do
                    if(card.base.suit == "Hearts") then
                        assert(SMODS.change_base(card, self.config.suit2, nil))
                    elseif(card.base.suit == "Diamonds") then
                        assert(SMODS.change_base(card, self.config.suit1, nil))
                    end
                end
                return true
            end
        }))
    end
}

SMODS.Back{
    name = "Zigzag Deck",
    key = "zigzag_deck",
    atlas = "color_decks",
    pos = {x = 2, y = 0},
    config = {suit1 = "Diamonds", suit2 = "Spades"},
    loc_txt = {
        name = "Zigzag Deck",
        text={
            "Start run with ",
            "{C:attention}26{} {C:diamonds}Diamonds{} and", 
            "{C:attention}26{} {C:spades}Spades{} in deck",},
    },

    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                for _, card in ipairs(G.playing_cards) do
                    if(card.base.suit == "Hearts") then
                        assert(SMODS.change_base(card, self.config.suit2, nil))
                    elseif(card.base.suit == "Clubs") then
                        assert(SMODS.change_base(card, self.config.suit1, nil))
                    end
                end
                return true
            end
        }))
    end
}

SMODS.Back{
    name = "Sawtooth Deck",
    key = "Sawtooth_deck",
    atlas = "color_decks",
    pos = {x = 3, y = 0},
    config = {suit1 = "Diamonds", suit2 = "Hearts"},
    loc_txt = {
        name = "Sawtooth Deck",
        text={
            "Start run with ",
            "{C:attention}26{} {C:diamonds}Diamonds{} and", 
            "{C:attention}26{} {C:hearts}Hearts{} in deck",},
    },

    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                for _, card in ipairs(G.playing_cards) do
                    if(card.base.suit == "Spades") then
                        assert(SMODS.change_base(card, self.config.suit2, nil))
                    elseif(card.base.suit == "Clubs") then
                        assert(SMODS.change_base(card, self.config.suit1, nil))
                    end
                end
                return true
            end
        }))
    end
}

SMODS.Back{
    name = "Grid Deck",
    key = "grid_deck",
    atlas = "color_decks",
    pos = {x = 4, y = 0},
    config = {suit1 = "Clubs", suit2 = "Diamonds"},
    loc_txt = {
        name = "Grid Deck",
        text={
            "Start run with ",
            "{C:attention}26{} {C:clubs}Clubs{} and", 
            "{C:attention}26{} {C:diamonds}Diamonds{} in deck",},
    },

    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                for _, card in ipairs(G.playing_cards) do
                    if(card.base.suit == "Hearts") then
                        assert(SMODS.change_base(card, self.config.suit2, nil))
                    elseif(card.base.suit == "Spades") then
                        assert(SMODS.change_base(card, self.config.suit1, nil))
                    end
                end
                return true
            end
        }))
    end
}


if CardSleeves then

    SMODS.Atlas({
    key = "color_sleeves",
    px = 73,
    py = 95,
    path = "color_sleeves.png"
})

	CardSleeves.Sleeve({
		key = "striped_sleeve",
		name = "Striped Sleeve",
		atlas = "color_sleeves",
		pos = { x = 0, y = 0 },
		config = { suit1 = "Clubs", suit2 = "Hearts" },
		unlocked = true,
		loc_txt = {
			name = "Striped Sleeve",
			text = {
				"Start run with",
				"{C:attention}26{} {C:clubs}Clubs{} and",
				"{C:attention}26{} {C:hearts}Hearts{} in deck",
			},
		},
		loc_vars = function(self) return { vars = {} } end,
		trigger_effect = function(self, args) end,
		apply = function(self)
			G.E_MANAGER:add_event(Event({
				func = function()
					for _, card in ipairs(G.playing_cards) do
						if(card.base.suit == "Diamonds") then
							assert(SMODS.change_base(card, self.config.suit2, nil))
						elseif(card.base.suit == "Spades") then
							assert(SMODS.change_base(card, self.config.suit1, nil))
						end
					end
					return true
				end
			}))
		end,
		init = function(self) end,
	})

	CardSleeves.Sleeve({
		key = "rippled_sleeve",
		name = "Rippled Sleeve",
		atlas = "color_sleeves",
		pos = { x = 1, y = 0 },
		config = { suit1 = "Clubs", suit2 = "Spades" },
		unlocked = true,
		loc_txt = {
			name = "Rippled Sleeve",
			text = {
				"Start run with ",
				"{C:attention}26{} {C:clubs}Clubs{} and",
				"{C:attention}26{} {C:spades}Spades{} in deck",
			},
		},
		loc_vars = function(self) return { vars = {} } end,
		trigger_effect = function(self, args) end,
		apply = function(self)
			G.E_MANAGER:add_event(Event({
				func = function()
					for _, card in ipairs(G.playing_cards) do
						if(card.base.suit == "Hearts") then
							assert(SMODS.change_base(card, self.config.suit2, nil))
						elseif(card.base.suit == "Diamonds") then
							assert(SMODS.change_base(card, self.config.suit1, nil))
						end
					end
					return true
				end
			}))
		end,
		init = function(self) end,
	})

	CardSleeves.Sleeve({
		key = "zigzag_sleeve",
		name = "Zigzag Sleeve",
		atlas = "color_sleeves",
		pos = { x = 2, y = 0 },
		config = { suit1 = "Diamonds", suit2 = "Spades" },
		unlocked = true,
		loc_txt = {
			name = "Zigzag Sleeve",
			text = {
				"Start run with",
				"{C:attention}26{} {C:diamonds}Diamonds{} and",
				"{C:attention}26{} {C:spades}Spades{} in deck",
			},
		},
		loc_vars = function(self) return { vars = {} } end,
		trigger_effect = function(self, args) end,
		apply = function(self)
			G.E_MANAGER:add_event(Event({
				func = function()
					for _, card in ipairs(G.playing_cards) do
						if(card.base.suit == "Hearts") then
							assert(SMODS.change_base(card, self.config.suit2, nil))
						elseif(card.base.suit == "Clubs") then
							assert(SMODS.change_base(card, self.config.suit1, nil))
						end
					end
					return true
				end
			}))
		end,
		init = function(self) end,
	})

	CardSleeves.Sleeve({
		key = "sawtooth_sleeve",
		name = "Sawtooth Sleeve",
		atlas = "color_sleeves",
		pos = { x = 3, y = 0 },
		config = { suit1 = "Diamonds", suit2 = "Hearts" },
		unlocked = true,
		loc_txt = {
			name = "Sawtooth Sleeve",
			text = {
				"Start run with",
				"{C:attention}26{} {C:diamonds}Diamonds{} and",
				"{C:attention}26{} {C:hearts}Hearts{} in deck",
			},
		},
		loc_vars = function(self) return { vars = {} } end,
		trigger_effect = function(self, args) end,
		apply = function(self)
			G.E_MANAGER:add_event(Event({
				func = function()
					for _, card in ipairs(G.playing_cards) do
						if(card.base.suit == "Spades") then
							assert(SMODS.change_base(card, self.config.suit2, nil))
						elseif(card.base.suit == "Clubs") then
							assert(SMODS.change_base(card, self.config.suit1, nil))
						end
					end
					return true
				end
			}))
		end,
		init = function(self) end,
	})

	CardSleeves.Sleeve({
		key = "grid_sleeve",
		name = "Grid Sleeve",
		atlas = "color_sleeves",
		pos = { x = 4, y = 0 },
		config = { suit1 = "Clubs", suit2 = "Diamonds" },
		unlocked = true,
		loc_txt = {
			name = "Grid Sleeve",
			text = {
				"Start run with",
				"{C:attention}26{} {C:clubs}Clubs{} and",
				"{C:attention}26{} {C:diamonds}Diamonds{} in deck",
			},
		},
		loc_vars = function(self) return { vars = {} } end,
		trigger_effect = function(self, args) end,
		apply = function(self)
			G.E_MANAGER:add_event(Event({
				func = function()
					for _, card in ipairs(G.playing_cards) do
						if(card.base.suit == "Hearts") then
							assert(SMODS.change_base(card, self.config.suit2, nil))
						elseif(card.base.suit == "Spades") then
							assert(SMODS.change_base(card, self.config.suit1, nil))
						end
					end
					return true
				end
			}))
		end,
		init = function(self) end,
	})

end