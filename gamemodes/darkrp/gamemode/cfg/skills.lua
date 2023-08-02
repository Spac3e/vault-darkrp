rp.skills = {}

rp.skills.SKILL_JAIL = {
    Name = 'Судью на мыло',
    Icon = 'sup/gui/skills/ziptie.png',
    Description = 'Уменьшен срок в тюрьме',
    MaxLevel = 3,
    Hooks = {
        [0] = function()
            return rp.cfg.ArrestTime
        end,
        [1] = function()
            return rp.cfg.ArrestTime * 0.85
        end,
        [2] = function()
            return rp.cfg.ArrestTime * 0.7
        end,
        [3] = function()
            return rp.cfg.ArrestTime * 0.4
        end
    },
    Price = {
        [1] = 1000,
        [2] = 5000,
        [3] = 10000
    }
}

rp.skills.SKILL_LOCKPICK = {
    Name = 'Домушник',
    Icon = 'sup/gui/skills/lockpick.png',
    Description = 'Экстра-скорость взлома',
    MaxLevel = 3,
    Hooks = {
        [0] = function()
            return 1
        end,
        [1] = function()
            return 0.8
        end,
        [2] = function()
            return 0.75
        end,
        [3] = function()
            return 0.65
        end
    },
    Price = {
        [1] = 1000,
        [2] = 3000,
        [3] = 6000
    }
}

rp.skills.SKILL_HACK = {
    Name = 'Хакер',
    Icon = 'sup/gui/skills/keypadcracking.png',
    Description = 'Увеличенная скорость взлома кейпада',
    MaxLevel = 4,
    Hooks = {
        [0] = function()
            return 1
        end,
        [1] = function()
            return 0.5
        end,
        [2] = function()
            return 0.35
        end,
        [3] = function()
            return 0.2
        end,
    },
    Price = {
        [1] = 1000,
        [2] = 3000,
        [3] = 6000
--      [4] = 90
    }
}

/*
rp.skills.SKILL_SCAVENGE = {
    Name = 'Мусорщик',
    Icon = 'sup/gui/skills/scavenger.png',
    Description = 'Увеличевает шанс выпадения всякой хуйни',
    Hooks = {
        [0] = function()
            return 20
        end,
        [1] = function()
            return 40
        end,
        [2] = function()
            return 60
        end,
        [3] = function()
            return 80
        end,
    },
    Price = {500, 2500, 5000}
}

rp.skills.SKILL_HUNGER = {
    Name = 'Большой живот',
    Icon = 'sup/gui/skills/hunger.png',
    Description = 'В вас будет вмещатся много еды',
    Hooks = {
        [0] = function(HFM_Hunger)
            return 100
        end,
        [1] = function(HFM_Hunger)
            return 125
        end,
        [2] = function(HFM_Hunger)
            return 150
        end,
        [3] = function(HFM_Hunger)
            return 175
        end,
        [4] = function(HFM_Hunger)
            return 200
        end,
    },
    Price = {1000, 5000, 10000}
}
*/
rp.skills.SKILL_FALL = {
    Name = 'Лёгкие ноги',
    Icon = 'sup/gui/skills/fall.png',
    Description = 'Маленький урон от падения',
    Hooks = {},
    --[0] = function(damage) return damage end, --[1] = function(damage) return damage * 0.9 end, --[2] = function(damage) return damage * 0.85 end, --[3] = function(damage) return damage * 0.8 end,
    Price = {
        [1] = 500,
        [2] = 2500,
        [3] = 5000,
    }
}

rp.skills.SKILL_JUMP = {
    Name = 'Прыгун',
    Icon = 'sup/gui/skills/jump.png',
    Description = 'Увеличевает высоту прыжка',
    MaxLevel = 3,
    Hooks = {
        [0] = function()
            return 1
        end,
        [1] = function()
            return 1.1
        end,
        [2] = function()
            return 1.15
        end,
        [3] = function()
            return 1.2
        end
    },
    Price = {
        [1] = 500,
        [2] = 2500,
        [3] = 5000
    }
}

rp.skills.SKILL_RUN = {
    Name = 'Бегун',
    Icon = 'sup/gui/skills/run.png',
    Description = 'Увеличевает скорость бега',
    MaxLevel = 5,
    Hooks = {
        [0] = function(speed, max)
            return 1
        end,
        [1] = function(speed, max)
            return 1.02
        end,
        [2] = function(speed, max)
            return 1.05
        end,
        [3] = function(speed, max)
            return 1.1
        end,
    },
    Price = {
        [1] = 1000,
        [2] = 5000,
        [3] = 10000
    --  [4] = 90
    }
}