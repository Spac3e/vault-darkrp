rp.hats.ModelGroups = {}

for a = 1, 9 do
    rp.hats.ModelGroups['models/player/group01/male_0' .. a .. '.mdl'] = 'MALE_CITIZEN'
    rp.hats.ModelGroups['models/player/group03/male_0' .. a .. '.mdl'] = 'MALE_CITIZEN'
    rp.hats.ModelGroups['models/player/group03m/male_0' .. a .. '.mdl'] = 'MALE_CITIZEN'
end

for a = 1, 4 do
    rp.hats.ModelGroups['models/player/hostage/hostage_0' .. a .. '.mdl'] = 'MALE_CITIZEN'
end

for a = 1, 9 do
    rp.hats.ModelGroups['models/player/group01/female_0' .. a .. '.mdl'] = 'FEMALE_CITIZEN'
    rp.hats.ModelGroups['models/player/group03/female_0' .. a .. '.mdl'] = 'FEMALE_CITIZEN'
    rp.hats.ModelGroups['models/player/group03m/female_0' .. a .. '.mdl'] = 'FEMALE_CITIZEN'
end

rp.hats.Categories = {
    ['Куплено'] = 1,
    ['Новогодние'] = 2,
    ['Грелки для головы'] = 3,
    ['Шляпы дальнобойщика'] = 4,
    ['Странности'] = 5,
    ['бейсболки'] = 6,
    ['Плащи'] = 7,
    ['Шарфы'] = 8,
    ['FNAF'] = 9,
    ['Brawl Stars'] = 10,
    ['Небольшой изгиб'] = 11,
    ['Я вижу вашу точку зрения!'] = 12,
    ['Airpods MAX'] = 13,
    ['Хипстерская фаза'] = 14,
    ['Пивные шляпы'] = 15,
    ['Уродливые решения'] = 16,
    ['Обертывания'] = 17,
    ['Череп и кости'] = 18,
    ['Маски'] = 19,
    ['$ Наряд богатых людей $'] = 20,
    ['Горячая линия'] = 21,
    ['Шляпы, которые вы не можете себе позволить'] = 22,
    ['Грелки для лица'] = 23,
    ['Halloween'] = 24,
    ['Кулдык-кулдык'] = 25,
    ['Не так одиноко'] = 26
}

APPAREL_HATS, APPAREL_MASKS, APPAREL_GLASSES, APPAREL_SCARVES, APPAREL_PETS = 1, 2, 3, 4, 5

local b = {
    [APPAREL_MASKS] = true,
    [APPAREL_GLASSES] = true
}

rp.hats.Add{
    name = 'Медведь',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/bear.mdl',
    skin = 0,
    offpos = Vector(0, 0, 2),
    offang = Angle(2, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Китти Кэт',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/cat.mdl',
    skin = 0,
    offpos = Vector(0, 0, 2),
    offang = Angle(2, 0, 0),
    scale = 1.0,
    infooffset = 10,
    offsets = {
        ['MALE_CITIZEN'] = {
            offpos = Vector(0.20000000298023, -0.30000001192093, 2.7000000476837),
            offang = Angle(2, 0, 0),
            scale = 1.0395387149918
        },
        ['models/player/leet.mdl'] = {
            offpos = Vector(0, 0, 3.6243822574615),
            offang = Angle(2, 0, 0),
            scale = 1.0593080724876
        },
        ['models/player/arctic.mdl'] = {
            offpos = Vector(0.32948929071426, 0, 2.9654035568237),
            offang = Angle(2, 0, 0),
            scale = 1.0296540362438
        },
        ['models/player/lulsec.mdl'] = {
            offpos = Vector(0.98846787214279, -0.32948929071426, 2.6359143257141),
            offang = Angle(2, 0, 0),
            scale = 0.94728171334432
        },
        ['models/player/phoenix.mdl'] = {
            offpos = Vector(0, 0, 3.6243822574615),
            offang = Angle(2, 0, 0),
            scale = 1.0889621087315
        },
        ['models/code_gs/player/cage.mdl'] = {
            offpos = Vector(0.32948929071426, 0, 5.6013178825378),
            offang = Angle(2, 0, 0),
            scale = 1.0494233937397
        },
        ['models/player/riot.mdl'] = {
            offpos = Vector(0.98846787214279, 0, 3.2948930263519),
            offang = Angle(2, 0, 0)
        },
        ['models/player/gasmask.mdl'] = {
            offpos = Vector(0.69999998807907, -0.30000001192093, 3.7000000476837),
            offang = Angle(2, 0, 0)
        },
        ['models/sirgibs/ragdolls/detective_magnusson_player.mdl'] = {
            offpos = Vector(-0.69999998807907, -0.10000000149012, 1.3179571628571),
            offang = Angle(2, 0, 0),
            scale = 0.95
        },
        ['models/player/gman_high.mdl'] = {
            offpos = Vector(0, 0, 2.5999999046326),
            offang = Angle(2, 0, 0)
        },
        ['models/player/barney.mdl'] = {
            offpos = Vector(-0.46000000834465, -0.30000001192093, 2.2000000476837),
            offang = Angle(2, 0, 0),
            scale = 1.035
        },
        ['models/player/kleiner.mdl'] = {
            offpos = Vector(-0.33000001311302, 0, 2),
            offang = Angle(2, 0, 0)
        },
        ['models/hawks_odsts/models/hawks_odsts/hawks_odst.mdl'] = {
            offpos = Vector(0.66000002622604, 0, 3),
            offang = Angle(2, -6, 0)
        },
        ['models/player/halo/unsc/spartanmark6/master_chief_mkv_mp.mdl'] = {
            offpos = Vector(0.40000000596046, -0.10000000149012, 2),
            offang = Angle(2, 0, 0),
            scale = 0.8
        },
        ['models/player/monk.mdl'] = {
            offpos = Vector(-0.25, -0.25, 1.8064515590668),
            offang = Angle(2, 0, 0),
            scale = 1.03
        },
        ['models/player/skeleton.mdl'] = {
            offpos = Vector(-0.20000000298023, 0, 2),
            offang = Angle(2, 0, 0)
        }
    }
}

rp.hats.Add{
    name = 'Подлый лис',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/fox.mdl',
    skin = 0,
    offpos = Vector(0, 0, 2),
    offang = Angle(2, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Колобок',
    category = '$ Наряд богатых людей $',
    slots = b,
    type = APPAREL_MASKS,
    price = 10000000,
    model = 'models/sal/gingerbread.mdl',
    skin = 0,
    offpos = Vector(0.5, 0, 2),
    offang = Angle(0, 6, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Америка, черт возьми!',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/hawk_1.mdl',
    skin = 0,
    offpos = Vector(1, 0, 0),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Америка, черт возьми!',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/hawk_2.mdl',
    skin = 0,
    offpos = Vector(1, 0, 0),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Мистер Сова',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/owl.mdl',
    skin = 0,
    offpos = Vector(0, 0, 0),
    offang = Angle(2, 3, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Свинья',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/pig.mdl',
    skin = 0,
    offpos = Vector(0, 0, 1),
    offang = Angle(4, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Кровавая свинья',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/pig.mdl',
    skin = 1,
    offpos = Vector(0, 0, 1),
    offang = Angle(4, 0, 0),
    scale = 1.1,
    infooffset = 10,
    offsets = {
        ['models/player/leet.mdl'] = {
            offpos = Vector(0, 0, 2.5806450843811),
            offang = Angle(4, 0, 0),
            scale = 1.1
        },
    }
}

rp.hats.Add{
    name = 'Злой волк',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/wolf.mdl',
    skin = 0,
    offpos = Vector(0, 0, 1),
    offang = Angle(4, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Он был №1!',
    category = 'Пивные шляпы',
    price = 500000,
    model = 'models/sal/acc/fix/beerhat.mdl',
    skin = 0,
    offpos = Vector(0, -0.3, 3.5),
    offang = Angle(2, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Он был №2!',
    category = 'Пивные шляпы',
    price = 500000,
    model = 'models/sal/acc/fix/beerhat.mdl',
    skin = 1,
    offpos = Vector(0, -0.3, 3.5),
    offang = Angle(2, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Он был №3!',
    category = 'Пивные шляпы',
    price = 500000,
    model = 'models/sal/acc/fix/beerhat.mdl',
    skin = 2,
    offpos = Vector(0, -0.3, 3.5),
    offang = Angle(2, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Он был №4!',
    category = 'Пивные шляпы',
    price = 500000,
    model = 'models/sal/acc/fix/beerhat.mdl',
    skin = 3,
    offpos = Vector(0, -0.3, 3.5),
    offang = Angle(2, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Он был №5!',
    category = 'Пивные шляпы',
    price = 500000,
    model = 'models/sal/acc/fix/beerhat.mdl',
    skin = 4,
    offpos = Vector(0, -0.3, 3.5),
    offang = Angle(2, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Он был №6!',
    category = 'Пивные шляпы',
    price = 500000,
    model = 'models/sal/acc/fix/beerhat.mdl',
    skin = 5,
    offpos = Vector(0, -0.3, 3.5),
    offang = Angle(2, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска синия',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 0,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска "Медведь" №1',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 1,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска "Медведь" №2',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 2,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска "Медведь" №3',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 3,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска "Медведь" №4',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 4,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска "Король"',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 5,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска "Зомби"',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 6,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска "Зомби" №2',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 7,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска "Череп" №1',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 8,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска "Череп" №2',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 9,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска "Череп" №3',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 10,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска "Тень"',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 11,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10,
    offsets = {
        ['models/player/arctic.mdl'] = {
            offpos = Vector(1, 0, 2.0133090019226),
            offang = Angle(5, 15, 0)
        }
    }
}

rp.hats.Add{
    name = 'Хоккейная маска "Кожа"',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 12,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска "Кожа" №2',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 13,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Хоккейная маска "Сиэтл Кракен"',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_2.mdl',
    skin = 14,
    offpos = Vector(1.0, 0, 0.5),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

local c = {
    ['FEMALE_CITIZEN'] = {
        offpos = Vector(0.9, 0, -1.35),
        offang = Angle(5, 15, 0),
        scale = 0.975
    },
    ['MALE_CITIZEN'] = {
        offpos = Vector(1.3, 0, 0),
        offang = Angle(5, 15, 0),
        scale = 0.935
    },
    ['models/code_gs/player/cage.mdl'] = {
        offpos = Vector(1.5, 0, 2.9654035568237),
        offang = Angle(5, 15, 0),
        scale = 1.0230642504119
    },
    ['models/player/leet.mdl'] = {
        offpos = Vector(1.2999999523163, 0, 1.2999999523163),
        offang = Angle(5, 15, 0),
        scale = 1.05
    },
    ['models/player/arctic.mdl'] = {
        offpos = Vector(1, 0, 1.2999999523163),
        offang = Angle(5, 15, 0)
    },
    ['models/player/guerilla.mdl'] = {
        offpos = Vector(0.64999997615814, 0, 1.2999999523163),
        offang = Angle(5, 15, 0)
    },
    ['models/player/phoenix.mdl'] = {
        offpos = Vector(1, 0, 1.2999999523163),
        offang = Angle(5, 15, 0)
    },
    ['models/player/charple.mdl'] = {
        offpos = Vector(-0.33000001311302, 0, -0.33000001311302),
        offang = Angle(5, 15, 0),
        scale = 0.785
    },
    ['models/arachnit&hucheer/sa2/miya_player.mdl'] = {
        offpos = Vector(0.64999997615814, 0, 1.6499999761581),
        offang = Angle(5, 15, 0),
        scale = 0.92421746293245
    },
    ['models/player/halo/unsc/spartanmark6/master_chief_mkv_mp.mdl'] = {
        offpos = Vector(1.647446513176, 0, -1.647446513176),
        offang = Angle(5, 15, 0),
        scale = 1.05
    },
    ['models/hawks_odsts/models/hawks_odsts/hawks_odst.mdl'] = {
        offpos = Vector(2.2999999523163, 0, 0),
        offang = Angle(5, 15, 0)
    },
    ['models/player/riot.mdl'] = {
        offpos = Vector(2, 0, 1.2999999523163),
        offang = Angle(5, 15, 0)
    },
    ['models/sirgibs/ragdolls/detective_magnusson_player.mdl'] = {
        offpos = Vector(-0.65897858142853, 0, -0.65897858142853),
        offang = Angle(5, 15, 0)
    },
    ['models/player/skeleton.mdl'] = {
        offpos = Vector(0, 0, 1),
        offang = Angle(5, 4.75, 0),
        scale = 0.96
    },
    ['models/player/breen.mdl'] = {
        offpos = Vector(0.30000001192093, 0, -0.30000001192093),
        offang = Angle(5, 9, 0),
        scale = 0.96
    },
    ['models/player/barney.mdl'] = {
        offpos = Vector(0.325, 0, -0.325),
        offang = Angle(5, 10.675, 0),
        scale = 1.035
    },
    ['models/player/police.mdl'] = {
        offpos = Vector(2.6359143257141, 0, -2.3064250946045),
        offang = Angle(5, 26.095552444458, 0)
    },
    ['models/player/combine_soldier.mdl'] = {
        offpos = Vector(1, 0, -1.2999999523163),
        offang = Angle(5, 32, 0),
        scale = 1.075
    },
    ['models/player/riot.mdl'] = {
        offpos = Vector(1, 0, 1),
        offang = Angle(5, 15, 0)
    },
    ['models/player/combine_super_soldier.mdl'] = {
        offpos = Vector(1.2999999523163, 0, 0),
        offang = Angle(5, 31.5, 0),
        scale = 1.05
    },
    ['models/player/gasmask.mdl'] = {
        offpos = Vector(3.4000000953674, 0, -1.9769357442856),
        offang = Angle(5, 33.805603027344, 0)
    },
    ['models/player/swat.mdl'] = {
        offpos = Vector(3.625, 0, 0.32499998807907),
        offang = Angle(5, 22.5, 0),
        scale = 1.05
    },
    ['models/player/combine_soldier_prisonguard.mdl'] = {
        offpos = Vector(1.3179571628571, 0, -1.3179571628571),
        offang = Angle(5, 31.5, 0),
        scale = 1.05
    },
    ['models/player/urban.mdl'] = {
        offpos = Vector(1.6499999761581, 0, 0.64999997615814),
        offang = Angle(5, 15, 0)
    },
    ['models/sirgibs/ragdolls/detective_magnusson_player.mdl'] = {
        offpos = Vector(0, 0, -0.64999997615814),
        offang = Angle(5, 15, 0),
        scale = 0.93
    },
    ['models/player/gman_high.mdl'] = {
        offpos = Vector(1.2999999523163, 0, 0.64999997615814),
        offang = Angle(5, 15, 0),
        scale = 0.95
    },
    ['models/player/monk.mdl'] = {
        offpos = Vector(0, 0, 1),
        offang = Angle(5, 7, 0),
        scale = 0.975
    },
    ['models/player/eli.mdl'] = {
        offpos = Vector(0.66000002622604, 0, -0.32499998807907),
        offang = Angle(5, 15, 0),
        scale = 0.975
    },
    ['models/player/mossman.mdl'] = {
        offpos = Vector(0.32499998807907, 0, -0.32499998807907),
        offang = Angle(5, 11.25, 0),
        scale = 0.95
    },
    ['models/player/alyx.mdl'] = {
        offpos = Vector(-0.32499998807907, 0, -0.64999997615814),
        offang = Angle(5, 15, 0)
    },
    ['models/player/magnusson.mdl'] = {
        offpos = Vector(0.32948929071426, 0, -0.65897858142853),
        offang = Angle(5, 15, 0),
        scale = 0.975
    },
    ['models/player/p2_chell.mdl'] = {
        offpos = Vector(0.64999997615814, 0, -0.33000001311302),
        offang = Angle(5, 15, 0),
        scale = 0.95
    },
    ['models/code_gs/player/robber.mdl'] = {
        offpos = Vector(1, 0, 0.65897858142853),
        offang = Angle(5, 15, 0),
        scale = 0.945
    },
    ['models/player/corpse1.mdl'] = {
        offpos = Vector(1, 0, 0.32499998807907),
        offang = Angle(5, 13.5, 0),
        scale = 0.945
    },
    ['models/player/soldier_stripped.mdl'] = {
        offpos = Vector(0, 0, -1),
        offang = Angle(5, 15, 0),
        scale = 0.885
    },
    ['models/player/kleiner.mdl'] = {
        offpos = Vector(0.32499998807907, 0, -0.32499998807907),
        offang = Angle(5, 15, 0),
        scale = 0.975
    },
    ['models/sup/player/custom/happybirthday/merc1.mdl'] = {
        offpos = Vector(-0.32499998807907, 0, 0),
        offang = Angle(5, 7, 0)
    },
    ['models/sup/player/custom/destruction/r6s_kapkan.mdl'] = {
        offpos = Vector(-0.32499998807907, 0, 0),
        offang = Angle(5, 11, 0),
        scale = 0.95
    },
    ['models/sup/player/custom/bones/bones2.mdl'] = {
        offang = Angle(5, 15, 0),
        scale = 0.975
    },
    ['models/auditor/com/honoka/honoka.mdl'] = {
        offpos = Vector(1, 0, -0.64999997615814),
        offang = Angle(5, 15, 0),
        scale = 0.925
    }
}

rp.hats.Add{
    name = 'DOOM',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_4.mdl',
    skin = 0,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(5, 15, 0),
    offsets = c,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Материнская плата DOOM',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_4.mdl',
    skin = 1,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(5, 15, 0),
    offsets = c,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Лава DOOM',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_4.mdl',
    skin = 2,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(5, 15, 0),
    offsets = c,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Фиолетовая лава DOOM',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_4.mdl',
    skin = 3,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(5, 15, 0),
    offsets = c,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Тёмный DOOM',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_4.mdl',
    skin = 4,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(5, 15, 0),
    offsets = c,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Коллекционная Цель DOOM',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_4.mdl',
    skin = 5,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(5, 15, 0),
    offsets = c,
    scale = 1.0,
    infooffset = 10,
    unvisible = true
}

rp.hats.Add{
    name = 'Расцарапанный DOOM',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_4.mdl',
    skin = 6,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(5, 15, 0),
    offsets = c,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Электрический DOOM',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_4.mdl',
    skin = 7,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(5, 15, 0),
    offsets = c,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Деревянный DOOM',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/acc/fix/mask_4.mdl',
    skin = 8,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(5, 15, 0),
    offsets = c,
    scale = 1.0,
    infooffset = 10
}

local d = {
    ['MALE_CITIZEN'] = {
        offpos = Vector(0, 0, -25),
        offang = Angle(5, 15, 0)
    },
    ['FEMALE_CITIZEN'] = {
        offpos = Vector(0, 0, -27),
        offang = Angle(5, 15, 0)
    },
    ['models/player/skeleton.mdl'] = {
        offpos = Vector(0, 0, -25.5),
        offang = Angle(5, 15, 0)
    },
    ['models/player/breen.mdl'] = {
        offpos = Vector(-0.25, 0, -26.5),
        offang = Angle(5, 15, 0)
    },
    ['models/player/barney.mdl'] = {
        offpos = Vector(0.20000000298023, 0, -29.5),
        offang = Angle(5, 15, 0),
        scale = 1.185
    },
    ['models/player/combine_soldier.mdl'] = {
        offpos = Vector(0.5, 0, -35.914333343506),
        offang = Angle(5, 15, 0),
        scale = 1.5
    },
    ['models/player/riot.mdl'] = {
        offpos = Vector(1.25, 0, -33),
        offang = Angle(5, 15, 0),
        scale = 1.4
    },
    ['models/player/combine_soldier_prisonguard.mdl'] = {
        offpos = Vector(0.69999998807907, 0, -35.5),
        offang = Angle(5, 15, 0),
        scale = 1.5
    },
    ['models/sirgibs/ragdolls/detective_magnusson_player.mdl'] = {
        offpos = Vector(1, 0, -28),
        offang = Angle(5, 15, 0),
        scale = 1.1
    },
    ['models/player/gman_high.mdl'] = {
        offpos = Vector(0.60000002384186, 0, -25),
        offang = Angle(5, 15, 0)
    },
    ['models/player/monk.mdl'] = {
        offpos = Vector(0.40000000596046, 0, -29.5),
        offang = Angle(5, 15, 0),
        scale = 1.2
    },
    ['models/player/leet.mdl'] = {
        offpos = Vector(0.64999997615814, 0, -31),
        offang = Angle(5, 15, 0),
        scale = 1.3
    },
    ['models/player/eli.mdl'] = {
        offpos = Vector(0.80000001192093, 0, -30.313014984131),
        offang = Angle(5, 15, 0),
        scale = 1.2
    },
    ['models/player/mossman.mdl'] = {
        offpos = Vector(1, 0, -27),
        offang = Angle(5, 15, 0)
    },
    ['models/player/police.mdl'] = {
        offpos = Vector(0.20000000298023, 0, -29.5),
        offang = Angle(5, 15, 0),
        scale = 1.185
    },
    ['models/player/gasmask.mdl'] = {
        offpos = Vector(1.25, 0, -33),
        offang = Angle(5, 15, 0),
        scale = 1.4
    },
    ['models/player/swat.mdl'] = {
        offpos = Vector(1.25, 0, -33),
        offang = Angle(5, 15, 0),
        scale = 1.4
    },
    ['models/player/urban.mdl'] = {
        offpos = Vector(1.25, 0, -33),
        offang = Angle(5, 15, 0),
        scale = 1.4
    },
    ['models/player/combine_super_soldier.mdl'] = {
        offpos = Vector(0.69999998807907, 0, -35.5),
        offang = Angle(5, 15, 0),
        scale = 1.5
    },
    ['models/player/alyx.mdl'] = {
        offpos = Vector(1.2999999523163, 0, -26.5),
        offang = Angle(5, 15, 0)
    },
    ['models/player/magnusson.mdl'] = {
        offpos = Vector(1, 0, -30),
        offang = Angle(5, 15, 0),
        scale = 1.15
    },
    ['models/player/lulsec.mdl'] = {
        offpos = Vector(0.69999998807907, 0, -25.700164794922),
        offang = Angle(5, 17, 0),
        scale = 1.05
    },
    ['models/player/p2_chell.mdl'] = {
        offpos = Vector(0, 0, -26.5),
        offang = Angle(5, 18, 0)
    },
    ['models/code_gs/player/cage.mdl'] = {
        offpos = Vector(1.9769357442856, 0, -37.799999237061),
        offang = Angle(5, 10, 0),
        scale = 1.7
    },
    ['models/player/guerilla.mdl'] = {
        offpos = Vector(0.64999997615814, 0, -31),
        offang = Angle(5, 19, 0),
        scale = 1.325
    },
    ['models/code_gs/player/robber.mdl'] = {
        offpos = Vector(1.2999999523163, 0, -27),
        offang = Angle(5, 7.5, 0),
        scale = 1.1
    },
    ['models/player/odessa.mdl'] = {
        offpos = Vector(0, 0, -27.5),
        offang = Angle(5, 15, 0),
        scale = 1.1
    },
    ['models/player/phoenix.mdl'] = {
        offpos = Vector(0.32948929071426, 0, -30),
        offang = Angle(5, 19, 0),
        scale = 1.25
    },
    ['models/player/corpse1.mdl'] = {
        offpos = Vector(0, 0, -25),
        offang = Angle(5, 15, 0)
    },
    ['models/player/charple.mdl'] = {
        offpos = Vector(-0.5, 0, -26),
        offang = Angle(5, 10, 0),
        scale = 0.95
    },
    ['models/player/arctic.mdl'] = {
        offpos = Vector(0, 0, -28.5),
        offang = Angle(5, 16, 0),
        scale = 1.25
    },
    ['models/player/soldier_stripped.mdl'] = {
        offpos = Vector(0, 0, -27),
        offang = Angle(5, 15, 0)
    },
    ['models/player/kleiner.mdl'] = {
        offpos = Vector(0, 0, -28.75),
        offang = Angle(5, 15, 0),
        scale = 1.1
    },
    ['models/sup/player/custom/happybirthday/merc1.mdl'] = {
        offpos = Vector(0.5, 0, -30),
        offang = Angle(5, 15, 0),
        scale = 1.2
    },
    ['models/sup/player/custom/destruction/r6s_kapkan.mdl'] = {
        offpos = Vector(-0.98846787214279, 0, -36.5),
        offang = Angle(5, 15, 0),
        scale = 1.5
    },
    ['models/sup/player/custom/bones/bones2.mdl'] = {
        offpos = Vector(1.2999999523163, 0, -28.25),
        offang = Angle(5, 18.978582382202, 0),
        scale = 1.085
    },
    ['models/auditor/com/honoka/honoka.mdl'] = {
        offpos = Vector(-0.32948929071426, 0, -27.5),
        offang = Angle(5, 22, 0),
        scale = 1.05
    },
    ['models/arachnit&hucheer/sa2/miya_player.mdl'] = {
        offpos = Vector(0.98846787214279, 0, -27.01812171936),
        offang = Angle(5, 22.5, 0),
        scale = 1.075
    },
    ['models/player/halo/unsc/spartanmark6/master_chief_mkv_mp.mdl'] = {
        offpos = Vector(1, 0, -33),
        offang = Angle(5, 22, 0),
        scale = 1.3
    },
    ['models/hawks_odsts/models/hawks_odsts/hawks_odst.mdl'] = {
        offpos = Vector(1, 0, -31.5),
        offang = Angle(5, 19, 0),
        scale = 1.3
    }
}

rp.hats.Add{
    name = 'Шарф Белый',
    category = 'Шарфы',
    type = APPAREL_SCARVES,
    price = 1000000,
    model = 'models/sal/acc/fix/scarf01.mdl',
    skin = 0,
    offpos = Vector(1.0, 0, -25),
    offang = Angle(5, 15, 0),
    offsets = d,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Шарф Серый',
    category = 'Шарфы',
    type = APPAREL_SCARVES,
    price = 1000000,
    model = 'models/sal/acc/fix/scarf01.mdl',
    skin = 1,
    offpos = Vector(1.0, 0, -25),
    offang = Angle(5, 15, 0),
    offsets = d,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Шарф Черный',
    category = 'Шарфы',
    type = APPAREL_SCARVES,
    price = 1000000,
    model = 'models/sal/acc/fix/scarf01.mdl',
    skin = 2,
    offpos = Vector(1.0, 0, -25),
    offang = Angle(5, 15, 0),
    offsets = d,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Шарф темно-синий',
    category = 'Шарфы',
    type = APPAREL_SCARVES,
    price = 1000000,
    model = 'models/sal/acc/fix/scarf01.mdl',
    skin = 3,
    offpos = Vector(1.0, 0, -25),
    offang = Angle(5, 15, 0),
    offsets = d,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Шарф Красный',
    category = 'Шарфы',
    type = APPAREL_SCARVES,
    price = 1000000,
    model = 'models/sal/acc/fix/scarf01.mdl',
    skin = 4,
    offpos = Vector(1.0, 0, -25),
    offang = Angle(5, 15, 0),
    offsets = d,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Шарф Зеленый',
    category = 'Шарфы',
    type = APPAREL_SCARVES,
    price = 1000000,
    model = 'models/sal/acc/fix/scarf01.mdl',
    skin = 5,
    offpos = Vector(1.0, 0, -25),
    offang = Angle(5, 15, 0),
    offsets = d,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Шарф Розовый',
    category = 'Шарфы',
    type = APPAREL_SCARVES,
    price = 1000000,
    model = 'models/sal/acc/fix/scarf01.mdl',
    skin = 6,
    offpos = Vector(1.0, 0, -25),
    offang = Angle(5, 15, 0),
    offsets = d,
    scale = 1.0,
    infooffset = 10
}

local f = {
    ['FEMALE_CITIZEN'] = {
        offpos = Vector(0, 0, 9.4786729812622),
        offang = Angle(0, 0, 180),
    },
    ['models/player/kerry/police_02_female.mdl'] = {
        offpos = Vector(0, 0, 9.8578195571899),
        offang = Angle(0, 0, 180),
    },
    ['models/code_gs/player/cage.mdl'] = {
        offpos = Vector(-1.2903225421906, 0, 16.516128540039),
        offang = Angle(0, 0, 180),
    },
    ['models/sup/player/custom/cosmonaut/cosmonaut.mdl'] = {
        offpos = Vector(-2.5806450843811, 0, 12),
        offang = Angle(0, 0, 180),
    },
    ['models/player/combine_soldier.mdl'] = {
        offpos = Vector(-2.322580575943, 0, 12),
        offang = Angle(0, 0, 180),
    },
    ['models/player/combine_super_soldier.mdl'] = {
        offpos = Vector(-3.0967741012573, 0, 12),
        offang = Angle(0, 0, 180),
    },
}


-- rp.hats.Add{
--     name = 'Плащ',
--     category = 'Плащи',
--     type = APPAREL_SCARVES,
--     price = 2000000,
--     model = 'models/pac/jiggle/clothing/base_cape_1.mdl',
--     skin = 0,
--     offpos = Vector(0, -0.5, 10),
--     offang = Angle(0, 0, 180),
--     offsets = f,
--     bone = "ValveBiped.Bip01_Spine2",
--     scale = 1.0,
--     infooffset = 10
-- }

-- rp.hats.Add{
--     name = 'Плащ №2',
--     category = 'Плащи',
--     type = APPAREL_SCARVES,
--     price = 2000000,
--     model = 'models/pac/jiggle/clothing/base_cape_2.mdl',
--     skin = 0,
--     offpos = Vector(0, -0.5, 10),
--     offang = Angle(0, 0, 180),
--     offsets = f,
--     bone = "ValveBiped.Bip01_Spine2",
--     scale = 1.0,
--     cancustom = true,
--     infooffset = 10
-- }

rp.hats.Add{
    name = 'Пакет Up-n-Atom',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 1,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет улыбок',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 1,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет слез',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 2,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет немого',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 3,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет ловкости',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 4,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет зубов',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 5,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет невинных',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 6,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Мешок бургер шот',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 7,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет цели',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 8,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет дьявола',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 9,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет полицейского',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 10,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет криков',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 11,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет гнева',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 12,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет Зигзага',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 13,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет черепа',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 14,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет собаки',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 15,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет призрака',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 16,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет пришельца',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 17,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Мешок "HELP ME"',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 18,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет лабиринт',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 19,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет иди нахуй',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 20,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет сэр',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 21,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет с наклейками',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 22,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет красоты',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 23,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет любви',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 24,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Пакет черного цвета',
    category = 'Уродливые решения',
    type = APPAREL_MASKS,
    price = 250000,
    model = 'models/sal/halloween/bag.mdl',
    skin = 25,
    offpos = Vector(1, 0, 1.5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Чумной доктор',
    category = 'Я вижу вашу точку зрения!',
    type = APPAREL_GLASSES,
    price = 1500000,
    model = 'models/sal/halloween/doctor.mdl',
    skin = 0,
    offpos = Vector(-0.5, -0.3, 1.25),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10,
    offsets = {
        ['models/auditor/com/honoka/honoka.mdl'] = {
            offpos = Vector(-2.9654035568237, -0.32948929071426, 0.80000001192093),
            scale = 1.0461285008237
        }
    }
}

rp.hats.Add{
    name = 'Чумной доктор 2',
    category = 'Я вижу вашу точку зрения!',
    type = APPAREL_GLASSES,
    price = 1500000,
    model = 'models/sal/halloween/doctor.mdl',
    skin = 1,
    offpos = Vector(-0.5, -0.3, 1.25),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Чумной доктор 3',
    category = 'Я вижу вашу точку зрения!',
    type = APPAREL_GLASSES,
    price = 1500000,
    model = 'models/sal/halloween/doctor.mdl',
    skin = 2,
    offpos = Vector(-0.5, -0.3, 1.25),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Обертка места преступления',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/headwrap1.mdl',
    skin = 0,
    offpos = Vector(1, 0, 1),
    offang = Angle(5, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Обертка осторожности',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/headwrap1.mdl',
    skin = 1,
    offpos = Vector(1, 0, 1),
    offang = Angle(5, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Обертка осторожности 2',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/headwrap1.mdl',
    skin = 2,
    offpos = Vector(1, 0, 1),
    offang = Angle(5, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Обертка красных стрел',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/headwrap1.mdl',
    skin = 3,
    offpos = Vector(1, 0, 1),
    offang = Angle(5, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Обертка серого',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/headwrap2.mdl',
    skin = 0,
    offpos = Vector(1, 0, 1),
    offang = Angle(5, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Обертка черного',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/headwrap2.mdl',
    skin = 1,
    offpos = Vector(1, 0, 1),
    offang = Angle(5, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Обертка светло-серого цвета',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/headwrap2.mdl',
    skin = 2,
    offpos = Vector(1, 0, 1),
    offang = Angle(5, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Обертка радуги',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/headwrap2.mdl',
    skin = 3,
    offpos = Vector(1, 0, 1),
    offang = Angle(5, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Обезьяна',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/halloween/monkey.mdl',
    skin = 0,
    offpos = Vector(0.7, 0, 1.3),
    offang = Angle(3.5, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Обезьяна черная',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/halloween/monkey.mdl',
    skin = 1,
    offpos = Vector(0.7, 0, 1.3),
    offang = Angle(3.5, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Зомби Обезьяна',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/halloween/monkey.mdl',
    skin = 2,
    offpos = Vector(0.7, 0, 1.3),
    offang = Angle(3.5, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Старая Обезьяна',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/halloween/monkey.mdl',
    skin = 3,
    offpos = Vector(0.7, 0, 1.3),
    offang = Angle(3.5, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Ниндзя чёрный',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/ninja.mdl',
    skin = 0,
    offpos = Vector(0, -0.5, 2),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Ниндзя белый',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/ninja.mdl',
    skin = 1,
    offpos = Vector(0, -0.5, 2),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Ниндзя бежевый',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/ninja.mdl',
    skin = 2,
    offpos = Vector(0, -0.5, 2),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Ниндзя темно-коричневый',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/ninja.mdl',
    skin = 3,
    offpos = Vector(0, -0.5, 2),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Ниндзя серый',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/ninja.mdl',
    skin = 4,
    offpos = Vector(0, -0.5, 2),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Ниндзя камуфляж',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/ninja.mdl',
    skin = 5,
    offpos = Vector(0, -0.5, 2),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Ниндзя бело-красный',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/ninja.mdl',
    skin = 6,
    offpos = Vector(0, -0.5, 2),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Ниндзя черно-белая',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/ninja.mdl',
    skin = 7,
    offpos = Vector(0, -0.5, 2),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Ниндзя бело-черный',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/ninja.mdl',
    skin = 8,
    offpos = Vector(0, -0.5, 2),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Ниндзя розовый камуфляж',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/ninja.mdl',
    skin = 9,
    offpos = Vector(0, -0.5, 2),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Ниндзя чёрно-золотой',
    category = 'Обертывания',
    type = APPAREL_MASKS,
    price = 275000,
    model = 'models/sal/halloween/ninja.mdl',
    skin = 10,
    offpos = Vector(0, -0.5, 2),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Череп серый',
    category = 'Череп и кости',
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/halloween/skull.mdl',
    skin = 0,
    offpos = Vector(0, -0.3, 2.6),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Череп коричневый',
    category = 'Череп и кости',
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/halloween/skull.mdl',
    skin = 1,
    offpos = Vector(0, -0.3, 2.6),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Череп светло-коричневый',
    category = 'Череп и кости',
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/halloween/skull.mdl',
    skin = 2,
    offpos = Vector(0, -0.3, 2.6),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Череп чёрный',
    category = 'Череп и кости',
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/sal/halloween/skull.mdl',
    skin = 3,
    offpos = Vector(0, -0.3, 2.6),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Франкенштейн',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/halloween/zombie.mdl',
    skin = 0,
    offpos = Vector(0.5, -0.3, 2.0),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add{
    name = 'Франкенштейн серый',
    category = 'Горячая линия',
    type = APPAREL_MASKS,
    price = 2000000,
    model = 'models/sal/halloween/zombie.mdl',
    skin = 1,
    offpos = Vector(0.5, -0.3, 2.0),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp.hats.Add {
	name = 'Интеллигентный пингвин',
	category = '$ Наряд богатых людей $',
	type = APPAREL_MASKS,
	price = 99999999,
	model = 'models/sal/penguin.mdl',
	skin = 0,
	offpos = Vector(1, -0.5, 1),
	offang = Angle(2, 15, 0),
	scale = 1.05,
	infooffset = 10,
    offsets = {
        ['models/code_gs/player/cage.mdl'] = {
            offpos = Vector(2.0645160675049, -0.5, 4.3870968818665),
            offang = Angle(2, 15, 0),
            scale = 1.05
        },
        ['models/player/leet.mdl'] = {
            offpos = Vector(1.5483870506287, -0.5, 2.8387095928192),
            offang = Angle(2, 15, 0),
            scale = 1.05
        },
    }
}

rp.hats.Add {
    name = 'Бандана',
    category = 'Небольшой изгиб',
    type = APPAREL_MASKS,
    slots = {
        [APPAREL_MASKS] = true
    },
    price = 1500000,
    model = 'models/modified/bandana.mdl',
    skin = 0,
    offpos = Vector(0.5, -0.3, -0.5),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10,
    offsets = {
        ['FEMALE_CITIZEN'] = {
            offpos = Vector(-0.32948929071426, -0.30000001192093, -1.3179571628571),
            scale = 1.0658978583196
        },
        ['MALE_CITIZEN'] = {
            offpos = Vector(0, -0.30000001192093, -0.32948929071426),
            scale = 1.0691927512356
        },
        ['models/player/skeleton.mdl'] = {
            offpos = Vector(0, -0.30000001192093, -0.5),
            scale = 1.0494233937397
        },
        ['models/player/breen.mdl'] = {
            offpos = Vector(-0.60000002384186, 0, -0.98846787214279),
            scale = 1.0593080724876
        },
        ['models/player/barney.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, -0.98846787214279),
            scale = 1.161449752883
        },
        ['models/player/police.mdl'] = {
            offpos = Vector(1.3179571628571, -0.30000001192093, -2.3064250946045),
            scale = 1.3228995057661
        },
        ['models/player/combine_soldier.mdl'] = {
            offpos = Vector(0.32948929071426, 0, -0.5),
            scale = 1.2438220757825
        },
        ['models/player/riot.mdl'] = {
            offpos = Vector(0.32948929071426, -0.32948929071426, 0.32948929071426),
            scale = 1.0757825370675
        },
        ['models/player/combine_super_soldier.mdl'] = {
            offpos = Vector(0.5, -0.32948929071426, -0.98846787214279),
            scale = 1.2042833607908
        },
        ['models/player/gasmask.mdl'] = {
            offpos = Vector(2.6359143257141, -0.65897858142853, -0.5),
            scale = 1.161449752883
        },
        ['models/player/swat.mdl'] = {
            offpos = Vector(0.5, 0, 0),
            scale = 1.1285008237232
        },
        ['models/player/combine_soldier_prisonguard.mdl'] = {
            offpos = Vector(0.98846787214279, -0.30000001192093, 0),
            scale = 1.1252059308072
        },
        ['models/player/urban.mdl'] = {
            offpos = Vector(0.43999999761581, -0.20000000298023, -0.65897858142853),
            offang = Angle(0, 11, 0),
            scale = 1.1054365733114
        },
        ['models/sirgibs/ragdolls/detective_magnusson_player.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, -1.9769357442856),
            offang = Angle(0, 8.3031301498413, 0),
            scale = 1.0757825370675
        },
        ['models/player/gman_high.mdl'] = {
            offpos = Vector(0, 0, 0.32948929071426),
            scale = 1.0527182866557
        },
        ['models/player/monk.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, 0),
            scale = 1.1252059308072
        },
        ['models/player/leet.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, 0.98846787214279),
            scale = 1.171334431631
        },
        ['models/player/eli.mdl'] = {
            offpos = Vector(-0.89999997615814, 0, -0.5),
            scale = 1.1
        },
        ['models/player/mossman.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, -1.3179571628571),
            scale = 1.1
        },
        ['models/player/alyx.mdl'] = {
            offpos = Vector(-0.98846787214279, 0, -1.647446513176),
            scale = 1.1
        },
        ['models/player/magnusson.mdl'] = {
            offpos = Vector(-0.98846787214279, 0, -1.3179571628571),
            scale = 1.1
        },
        ['models/player/lulsec.mdl'] = {
            offpos = Vector(0.32948929071426, -0.30000001192093, 0.32948929071426),
            scale = 1.0527182866557
        },
        ['models/player/p2_chell.mdl'] = {
            offpos = Vector(-0.65897858142853, -0.30000001192093, -0.98846787214279),
            scale = 1.0263591433278
        },
        ['models/code_gs/player/cage.mdl'] = {
            offpos = Vector(-0.32948929071426, -0.30000001192093, 2.6359143257141),
            scale = 1.1845140032949
        },
        ['models/player/guerilla.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, 0.32948929071426),
            scale = 1.2075782537068
        },
        ['models/code_gs/player/robber.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, 0),
            scale = 1.1
        },
        ['models/player/odessa.mdl'] = {
            offpos = Vector(-0.32948929071426, 0, -0.65897858142853),
            scale = 1.1120263591433
        },
        ['models/player/phoenix.mdl'] = {
            offpos = Vector(-0.65897858142853, -0.30000001192093, 0.65897858142853),
            scale = 1.1976935749588
        },
        ['models/player/corpse1.mdl'] = {
            offpos = Vector(-0.65897858142853, 0, 0),
            scale = 1.0296540362438
        },
        ['models/player/charple.mdl'] = {
            offpos = Vector(-1.3179571628571, 0, -1.3179571628571),
            scale = 0.88797364085667
        },
        ['models/player/arctic.mdl'] = {
            offpos = Vector(-0.65897858142853, -0.30000001192093, 0.65897858142853),
            scale = 1.1976935749588
        },
        ['models/player/kleiner.mdl'] = {
            offpos = Vector(-0.98846787214279, 0, -0.5),
            scale = 1.1219110378913
        },
        ['models/sup/player/custom/happybirthday/merc1.mdl'] = {
            offpos = Vector(-1.3179571628571, 0, -1.3179571628571),
            scale = 1.0296540362438
        },
        ['models/sup/player/custom/destruction/r6s_kapkan.mdl'] = {
            offpos = Vector(-2.3064250946045, 0, -0.65897858142853),
            scale = 1.0593080724876
        },
        ['models/sup/player/custom/bones/bones2.mdl'] = {
            offpos = Vector(-1.647446513176, -0.30000001192093, -0.65897858142853),
            scale = 1.1
        },
        ['models/auditor/com/honoka/honoka.mdl'] = {
            offpos = Vector(-1.647446513176, 0, -1.647446513176),
            scale = 1.1
        },
        ['models/arachnit&hucheer/sa2/miya_player.mdl'] = {
            offpos = Vector(-0.98846787214279, 0, 0.98846787214279),
            scale = 1.0164744645799
        },
        ['models/player/halo/unsc/spartanmark6/master_chief_mkv_mp.mdl'] = {
            offpos = Vector(0.5, 0, -1.647446513176),
            scale = 1.2306425041186
        }
    }
}

rp.hats.Add {
    name = 'Хипстерские очки',
    category = 'Я вижу вашу точку зрения!',
    type = APPAREL_GLASSES,
    price = 500000,
    model = 'models/modified/glasses01.mdl',
    skin = 0,
    offpos = Vector(0, -0.35, 3.5),
    offang = Angle(2, 0, 0),
    scale = 1.0,
    infooffset = 10,
    variants = {'Хипстерские очки №2', 'Хипстерские очки №3', 'Хипстерские очки №4', 'Хипстерские очки №5', 'Хипстерские очки №6'}
}

rp.hats.Add {
    name = 'Хипстерские очки №7',
    category = 'Я вижу вашу точку зрения!',
    type = APPAREL_GLASSES,
    price = 500000,
    model = 'models/modified/glasses02.mdl',
    skin = 0,
    offpos = Vector(0, -0.35, 3.5),
    offang = Angle(2, 0, 0),
    scale = 1.0,
    infooffset = 10,
    variants = {'Хипстерские очки №8', 'Хипстерские очки №9', 'Хипстерские очки №10', 'Хипстерские очки №11'}
}

rp.hats.Add {
    name = 'Шляпа серая',
    category = 'Хипстерская фаза',
    price = 500000,
    model = 'models/modified/hat01_fix.mdl',
    skin = 0,
    offpos = Vector(0.5, -0.25, 4.5),
    offang = Angle(2, 8, 0),
    scale = 1.0,
    infooffset = 10,
    variants = {'Шляпа чёрная', 'Шляпа белая', 'Шляпа бежевая', 'Шляпа красная', 'Шляпа чёрно-красная', 'Шляпа коричневая', 'Шляпа синия'}
}

rp.hats.Add {
    name = 'Обвисшая шапка в красную полоску',
    category = 'Хипстерская фаза',
    price = 500000,
    model = 'models/modified/hat03.mdl',
    skin = 0,
    offpos = Vector(0.5, -0.25, 4.5),
    offang = Angle(2, 8, 0),
    scale = 1.0,
    infooffset = 10,
    variants = {'Обвисшая шапка фиолетовая', 'Обвисшая шапка красная', 'Обвисшая шапка белая', 'Обвисшая шапка в черную полоску'},
    offsets = {
        ['models/player/leet.mdl'] = {
            offpos = Vector(0.79025757312775, -0.22757270932198, 7.1106290817261),
            offang = Angle(-3.3020832538605, 9.7240114212036, 0),
            scale = 1.1144421830497
        }
    }
}

rp.hats.Add {
    name = 'Шапка чёрная',
    category = 'Хипстерская фаза',
    price = 500000,
    model = 'models/modified/hat04.mdl',
    skin = 0,
    offpos = Vector(0, -0.5, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add {
    name = 'Шапка серая',
    category = 'Хипстерская фаза',
    price = 500000,
    model = 'models/modified/hat04.mdl',
    skin = 1,
    offpos = Vector(0, -0.5, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add {
    name = 'Шапка полосатая',
    category = 'Хипстерская фаза',
    price = 500000,
    model = 'models/modified/hat04.mdl',
    skin = 2,
    offpos = Vector(0, -0.5, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add {
    name = 'Шапка растомана',
    category = 'Хипстерская фаза',
    price = 500000,
    model = 'models/modified/hat04.mdl',
    skin = 3,
    offpos = Vector(0, -0.5, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Шапка синия',
    category = 'Хипстерская фаза',
    price = 500000,
    model = 'models/modified/hat04.mdl',
    skin = 4,
    offpos = Vector(0, -0.5, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Бейсболка Розовая',
    category = 'бейсболки',
    price = 250000,
    model = 'models/modified/hat05.mdl',
    skin = 1,
    offpos = Vector(1.5, -0.3, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Кепарик!',
    category = 'бейсболки',
    price = 7499999,
    model = 'models/modified/hat06.mdl',
    skin = 0,
    offpos = Vector(1.5, 0, 4.5),
    offang = Angle(5, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Бейсболка черно-зеленая',
    category = 'бейсболки',
    price = 250000,
    model = 'models/modified/hat07.mdl',
    skin = 0,
    offpos = Vector(1.5, -0.3, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Бейсболка черно-зеленая 2',
    category = 'бейсболки',
    price = 250000,
    model = 'models/modified/hat07.mdl',
    skin = 1,
    offpos = Vector(1.5, -0.3, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Бейсболка серая и черная',
    category = 'бейсболки',
    price = 250000,
    model = 'models/modified/hat07.mdl',
    skin = 2,
    offpos = Vector(1.5, -0.3, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Бейсболка белая и черная',
    category = 'бейсболки',
    price = 250000,
    model = 'models/modified/hat07.mdl',
    skin = 3,
    offpos = Vector(1.5, -0.3, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Бейсболка зелено-белая',
    category = 'бейсболки',
    price = 250000,
    model = 'models/modified/hat07.mdl',
    skin = 4,
    offpos = Vector(1.5, -0.3, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Бейсболка темно-зеленая с белым',
    category = 'бейсболки',
    price = 250000,
    model = 'models/modified/hat07.mdl',
    skin = 5,
    offpos = Vector(1.5, -0.3, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Бейсболка бордово-белая',
    category = 'бейсболки',
    price = 250000,
    model = 'models/modified/hat07.mdl',
    skin = 6,
    offpos = Vector(1.5, -0.3, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Бейсболка сине-зеленая',
    category = 'бейсболки',
    price = 250000,
    model = 'models/modified/hat07.mdl',
    skin = 7,
    offpos = Vector(1.5, -0.3, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Бейсболка коричнево-белая',
    category = 'бейсболки',
    price = 250000,
    model = 'models/modified/hat07.mdl',
    skin = 8,
    offpos = Vector(1.5, -0.3, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Бейсболка коричнево-белая 2',
    category = 'бейсболки',
    price = 250000,
    model = 'models/modified/hat07.mdl',
    skin = 9,
    offpos = Vector(1.5, -0.3, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Бейсболка коричнево-красная',
    category = 'бейсболки',
    price = 250000,
    model = 'models/modified/hat07.mdl',
    skin = 1000000,
    offpos = Vector(1.5, -0.3, 4.5),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

local e = {
    ['FEMALE_CITIZEN'] = {
        offpos = Vector(1, -0.30000001192093, 2.3064250946045),
        offang = Angle(2, 12, 0)
    },
    ['models/sup/player/custom/happybirthday/merc1.mdl'] = {
        offpos = Vector(-0.32948929071426, 0, 5.6013178825378),
        offang = Angle(2, 10.082372665405, 0),
        scale = 1.0560131795717
    },
    ['models/auditor/com/honoka/honoka.mdl'] = {
        offpos = Vector(-0.32948929071426, 0.070000000298023, 3.2948930263519),
        offang = Angle(2, 12, 0),
        scale = 1.1
    },
    ['models/player/leet.mdl'] = {
        offpos = Vector(0.20000000298023, 0.059999998658895, 7),
        offang = Angle(2, 0, 0),
        scale = 1.03
    },
    ['models/player/monk.mdl'] = {
        offpos = Vector(1, -0, 4.5),
        offang = Angle(2, 12, 0)
    },
    ['models/hawks_odsts/models/hawks_odsts/hawks_odst.mdl'] = {
        offpos = Vector(2, -0.25, 4),
        offang = Angle(2, 8.8950004577637, 0),
        scale = 0.97
    },
    ['models/player/halo/unsc/spartanmark6/master_chief_mkv_mp.mdl'] = {
        offpos = Vector(0.10000000149012, -0.20000000298023, 2.5806450843811),
        offang = Angle(2, 16.722579956055, 0),
        scale = 1.1
    },
    ['models/player/combine_soldier.mdl'] = {
        offpos = Vector(-1.2000000476837, -0.10000000149012, 4.9032258987427),
        offang = Angle(2, 10, 0),
        scale = 1.1
    },
    ['models/player/combine_super_soldier.mdl'] = {
        offpos = Vector(-1.5483870506287, 0, 5.6774191856384),
        offang = Angle(2, 1.3935483694077, 0),
        scale = 1.1
    },
    ['models/player/swat.mdl'] = {
        offpos = Vector(0, 0, 6.9677419662476),
        offang = Angle(2, 0, 0),
        scale = 1.1
    },
    ['models/player/combine_soldier_prisonguard.mdl'] = {
        offpos = Vector(-1.0322580337524, -0.10000000149012, 4.5),
        offang = Angle(2, 12, 0),
        scale = 1.05
    },
    ['models/player/alyx.mdl'] = {
        offpos = Vector(-0.69999998807907, 0.20000000298023, 4.5),
        offang = Angle(2, 9, 0)
    },
    ['models/code_gs/player/cage.mdl'] = {
        offpos = Vector(1, -0.30000001192093, 8),
        offang = Angle(2, 12, 0),
    },
}

rp.hats.Add{
    name = 'Кепка дальнобойщика оранжевая',
    category = 'Шляпы дальнобойщика',
    price = 250000,
    model = 'models/modified/hat08.mdl',
    skin = 0,
    offpos = Vector(1.0, -0.3, 4.5),
    offang = Angle(2, 12, 0),
    offsets = e,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Кепка дальнобойщика сине-белая',
    category = 'Шляпы дальнобойщика',
    price = 250000,
    model = 'models/modified/hat08.mdl',
    skin = 1,
    offpos = Vector(1.0, -0.3, 4.5),
    offang = Angle(2, 12, 0),
    offsets = e,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Кепка дальнобойщика коричнево-белая',
    category = 'Шляпы дальнобойщика',
    price = 250000,
    model = 'models/modified/hat08.mdl',
    skin = 2,
    offpos = Vector(1.0, -0.3, 4.5),
    offang = Angle(2, 12, 0),
    offsets = e,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Кепка дальнобойщика коричнево-белая 2',
    category = 'Шляпы дальнобойщика',
    price = 250000,
    model = 'models/modified/hat08.mdl',
    skin = 3,
    offpos = Vector(1.0, -0.3, 4.5),
    offang = Angle(2, 12, 0),
    offsets = e,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Кепка дальнобойщика красно-белая',
    category = 'Шляпы дальнобойщика',
    price = 250000,
    model = 'models/modified/hat08.mdl',
    skin = 4,
    offpos = Vector(1.0, -0.3, 4.5),
    offang = Angle(2, 12, 0),
    offsets = e,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Кепка дальнобойщика зелено-белая',
    category = 'Шляпы дальнобойщика',
    price = 250000,
    model = 'models/modified/hat08.mdl',
    skin = 5,
    offpos = Vector(1.0, -0.3, 4.5),
    offang = Angle(2, 12, 0),
    offsets = e,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Кепка дальнобойщика черно-Мульти',
    category = 'Шляпы дальнобойщика',
    price = 250000,
    model = 'models/modified/hat08.mdl',
    skin = 6,
    offpos = Vector(1.0, -0.3, 4.5),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Кепка дальнобойщика черно-белая',
    category = 'Шляпы дальнобойщика',
    price = 250000,
    model = 'models/modified/hat08.mdl',
    skin = 7,
    offpos = Vector(1.0, -0.3, 4.5),
    offang = Angle(2, 12, 0),
    offsets = e,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Кепка дальнобойщика черно-белая 2',
    category = 'Шляпы дальнобойщика',
    price = 250000,
    model = 'models/modified/hat08.mdl',
    skin = 8,
    offpos = Vector(1.0, -0.3, 4.5),
    offang = Angle(2, 12, 0),
    offsets = e,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Кепка дальнобойщика коричнево-белая',
    category = 'Шляпы дальнобойщика',
    price = 250000,
    model = 'models/modified/hat08.mdl',
    skin = 9,
    offpos = Vector(1.0, -0.3, 4.5),
    offang = Angle(2, 12, 0),
    offsets = e,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Кепка дальнобойщика фиолетовая-Мульти',
    category = 'Шляпы дальнобойщика',
    price = 250000,
    model = 'models/modified/hat08.mdl',
    skin = 10,
    offpos = Vector(1.0, -0.3, 4.5),
    offang = Angle(2, 12, 0),
    offsets = e,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Кепка дальнобойщика коричнево-белая 2',
    category = 'Шляпы дальнобойщика',
    price = 250000,
    model = 'models/modified/hat08.mdl',
    skin = 11,
    offpos = Vector(1.0, -0.3, 4.5),
    offang = Angle(2, 12, 0),
    offsets = e,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Наушники красные',
    category = 'Airpods MAX',
    price = 500000,
    model = 'models/modified/headphones.mdl',
    skin = 0,
    offpos = Vector(1.0, 0, 2.2),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Наушники фиолетовые',
    category = 'Airpods MAX',
    price = 500000,
    model = 'models/modified/headphones.mdl',
    skin = 1,
    offpos = Vector(1.0, 0, 2.2),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Наушники зеленые',
    category = 'Airpods MAX',
    price = 500000,
    model = 'models/modified/headphones.mdl',
    skin = 2,
    offpos = Vector(1.0, 0, 2.2),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Наушники желтые',
    category = 'Airpods MAX',
    price = 500000,
    model = 'models/modified/headphones.mdl',
    skin = 3,
    offpos = Vector(1.0, 0, 2.2),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Маска убийц',
    category = 'Маски',
    slots = b,
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/modified/mask5.mdl',
    skin = 0,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(2, 12, 0),
    offsets = c,
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Маска теней',
    category = 'Череп и кости',
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/modified/mask6.mdl',
    skin = 0,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Маска света',
    category = 'Череп и кости',
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/modified/mask6.mdl',
    skin = 1,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Маска костей',
    category = 'Череп и кости',
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/modified/mask6.mdl',
    skin = 2,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp.hats.Add{
    name = 'Маска природы',
    category = 'Череп и кости',
    type = APPAREL_MASKS,
    price = 750000,
    model = 'models/modified/mask6.mdl',
    skin = 3,
    offpos = Vector(1.0, 0, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

--[[rp.hats.Add{

    name = 'Неизвестный обезьянавт',

    category = 'Halloween',

    type = APPAREL_PETS,

    price = 70000000,

    model = 'models/player/items/all_class/hwn_ghost_pj.mdl',

    skin = 1,

    offpos = Vector(0, 8, 0),

    offang = Angle(0, -18.116128921509, 0),

    scale = 1.0,

    infooffset = 10

}



rp.hats.Add{

    name = 'Бу Воздушный шар',

    category = 'Halloween',

    type = APPAREL_PETS,

    price = 70000000,

    model = 'models/player/items/all_class/hwn_pet_balloon.mdl',

    skin = 1,

    offpos = Vector(-5.9354839324951, 15.483870506287, 0),

    scale = 1.0,

    infooffset = 10

}]]
--


--[[rp.hats.Add{

    name = 'Космический хомяк',

    category = 'Не так одиноко',

    type = APPAREL_PETS,

    price = 70000000,

    model = 'models/workshop/player/items/pyro/invasion_space_hamster_hammy/invasion_space_hamster_hammy.mdl',

    skin = 0,

    offpos = Vector(20.387096405029, 21.161291122437, -34.580646514893),

    scale = 1,

    infooffset = 10

}



rp.hats.Add{

    name = 'Гуано',

    category = 'Не так одиноко',

    type = APPAREL_PETS,

    price = 70000000,

    model = 'models/workshop/player/items/all_class/hw2013_the_fire_bat_v2/hw2013_the_fire_bat_v2_heavy.mdl',

    skin = 0,

    offpos = Vector(20.387096405029, 32.25806427002, -72.25806427002),

    scale = 1,

    infooffset = 10

}



rp.hats.Add{

    name = 'Иван Несъедобный',

    category = 'Не так одиноко',

    type = APPAREL_PETS,

    price = 70000000,

    model = 'models/workshop/player/items/heavy/hw2013_ivan_the_inedible/hw2013_ivan_the_inedible.mdl',

    skin = 0,

    offpos = Vector(4.1290321350098, 19.87096786499, 39.225807189941),

    offang = Angle(0, -72, 0),

    scale = 1,

    infooffset = 10

}



rp.hats.Add{

    name = 'Воздушный шар',

    category = 'Не так одиноко',

    type = APPAREL_PETS,

    price = 70000000,

    model = 'models/player/items/all_class/pet_balloonicorn.mdl',

    skin = 0,

    offpos = Vector(9.0322580337524, -22.193548202515, 35.612903594971),

    offang = Angle(0, -18.116128921509, 0.46451613306999),

    scale = 1,

    infooffset = 10

}



rp.hats.Add{

    name = 'Бандит де Бонкарс',

    category = 'Не так одиноко',

    type = APPAREL_PETS,

    price = 70000000,

    model = 'models/workshop/player/items/spy/spycrab/spycrab.mdl',

    skin = 1,

    offpos = Vector(17.806451797485, 16.25806427002, -75.096771240234),

    offang = Angle(0, 0, -67.819351196289),

    scale = 1,

    infooffset = 10

}



rp.hats.Add{

    name = 'Цитата',

    category = 'Не так одиноко',

    type = APPAREL_PETS,

    price = 70000000,

    model = 'models/workshop/player/items/all_class/hw2013_the_caws_of_death/hw2013_the_caws_of_death_heavy.mdl',

    skin = 0,

    offpos = Vector(20.387096405029, 32.25806427002, -72.25806427002),

    scale = 1,

    infooffset = 10

}



rp.hats.Add{

    name = 'Настоящий пингвин',

    category = 'Не так одиноко',

    type = APPAREL_PETS,

    price = 250000000,

    model = 'models/workshop/player/items/all_class/dec19_pebbles_the_penguin/dec19_pebbles_the_penguin_heavy.mdl',

    skin = 0,

    offpos = Vector(4.3870968818665, -0.51612901687622, -78.967742919922),

    scale = 1,

    infooffset = 10

}]]
--
if CLIENT then
    local function f(g, h, i, j)
        if j < 900 then
            j = j * (1 - j / 900)
        else
            j = j * (1 - j / 4096)
        end

        j = math.Clamp(j, 5, 1000)
        local k = Angle(25, 220, 0)
        local l = h + k:Forward() * j * -15
        local m = {}
        m.fov = 4 + j * 0.04
        m.origin = l + i
        m.znear = 1
        m.zfar = l:Distance(h) + j * 2
        m.angles = k

        return m
    end

    local function n(o, p, q, r)
        p.z = 15

        return f(o, p, q, r * 0.125)
    end

    local function s(o, p, q, r)
        p.z = 0

        return f(o, p, q, r * 0.125)
    end

    SpawniconGenFunctions['models/workshop/player/items/heavy/hw2013_heavy_robin/hw2013_heavy_robin.mdl'] = n
    SpawniconGenFunctions['models/workshop/player/items/medic/hw2013_medicmedes/hw2013_medicmedes.mdl'] = n
    SpawniconGenFunctions['models/workshop/player/items/demo/inquisitor/inquisitor.mdl'] = s
    SpawniconGenFunctions['models/workshop/player/items/all_class/dec15_a_well_wrapped_hat/dec15_a_well_wrapped_hat_scout.mdl'] = n
    SpawniconGenFunctions['models/workshop/player/items/all_class/ai_spacehelmet/ai_spacehelmet_scout.mdl'] = n
    SpawniconGenFunctions['models/workshop/player/items/pyro/hwn2015_face_of_mercy/hwn2015_face_of_mercy.mdl'] = n
    SpawniconGenFunctions['models/player/items/all_class/xcom_flattop_scout.mdl'] = s
    SpawniconGenFunctions['models/player/items/spy/fez.mdl'] = s
    SpawniconGenFunctions['models/workshop/player/items/spy/short2014_deadhead/short2014_deadhead.mdl'] = n
    SpawniconGenFunctions['models/workshop/player/items/sniper/thief_sniper_hood/thief_sniper_hood.mdl'] = n
    SpawniconGenFunctions['models/workshop/player/items/pyro/fall2013_popeyes/fall2013_popeyes.mdl'] = s
    SpawniconGenFunctions['models/player/items/pyro/fireman_helmet.mdl'] = s
    SpawniconGenFunctions['models/player/items/all_class/xms_furcap_scout.mdl'] = s
    SpawniconGenFunctions['models/workshop/player/items/all_class/short2014_tip_of_the_hats/short2014_tip_of_the_hats_scout.mdl'] = s
    SpawniconGenFunctions['models/workshop/player/items/all_class/sbox2014_law/sbox2014_law_scout.mdl'] = s
    SpawniconGenFunctions['models/player/items/pyro/pyro_hat.mdl'] = s

    SpawniconGenFunctions['models/workshop/player/items/heavy/jul13_bear_necessitys/jul13_bear_necessitys.mdl'] = function(o, p, q, r)
        p.z = 40
        p.y = -12

        return f(o, p, q, r * 0.25)
    end

    SpawniconGenFunctions['models/modified/hat08.mdl'] = function(o, p, q, r)
        p.z = -35

        return f(o, p, q, r * 0.15)
    end

    SpawniconGenFunctions['models/sal/acc/fix/scarf01.mdl'] = function(o, p, q, r)
        p.z = -19

        return f(o, p, q, r * 0.25)
    end

    SpawniconGenFunctions['models/modified/bandana.mdl'] = function(o, p, q, r)
        p.z = -31

        return f(o, p, q, r * 0.15)
    end

    SpawniconGenFunctions['models/sal/acc/fix/mask_4.mdl'] = function(o, p, q, r)
        p.z = -34

        return f(o, p, q, r * 0.16)
    end

    SpawniconGenFunctions['models/sal/acc/fix/mask_2.mdl'] = SpawniconGenFunctions['models/sal/acc/fix/mask_4.mdl']
    SpawniconGenFunctions['models/modified/mask5.mdl'] = SpawniconGenFunctions['models/sal/acc/fix/mask_4.mdl']
    SpawniconGenFunctions['models/modified/mask6.mdl'] = SpawniconGenFunctions['models/sal/acc/fix/mask_4.mdl']
    SpawniconGenFunctions['models/sal/pig.mdl'] = SpawniconGenFunctions['models/sal/acc/fix/mask_4.mdl']
    SpawniconGenFunctions['models/sal/acc/fix/beerhat.mdl'] = SpawniconGenFunctions['models/sal/acc/fix/mask_4.mdl']
    SpawniconGenFunctions['models/modified/hat03.mdl'] = SpawniconGenFunctions['models/sal/acc/fix/mask_4.mdl']
    SpawniconGenFunctions['models/sal/gingerbread.mdl'] = SpawniconGenFunctions['models/sal/acc/fix/mask_4.mdl']
    SpawniconGenFunctions['models/sal/hat01_fix.mdl'] = SpawniconGenFunctions['models/sal/acc/fix/mask_4.mdl']
    SpawniconGenFunctions['models/sal/penguin.mdl'] = SpawniconGenFunctions['models/sal/acc/fix/mask_4.mdl']

    --SpawniconGenFunctions['models/team vr/characters/fnaf1/accuracy/chicahead.mdl'] = SpawniconGenFunctions['models/sal/acc/fix/mask_4.mdl']
    SpawniconGenFunctions['models/sal/hawk_1.mdl'] = function(o, p, q, r)
        p.z = -13

        return f(o, p, q, r * 0.36)
    end

    SpawniconGenFunctions['models/sal/hawk_2.mdl'] = SpawniconGenFunctions['models/sal/hawk_1.mdl']
    SpawniconGenFunctions['models/sal/owl.mdl'] = SpawniconGenFunctions['models/sal/hawk_1.mdl']
    SpawniconGenFunctions['models/sal/wolf.mdl'] = SpawniconGenFunctions['models/sal/hawk_1.mdl']
    SpawniconGenFunctions['models/sal/fox.mdl'] = SpawniconGenFunctions['models/sal/hawk_1.mdl']
    SpawniconGenFunctions['models/sal/cat.mdl'] = SpawniconGenFunctions['models/sal/hawk_1.mdl']
    SpawniconGenFunctions['models/sal/bear.mdl'] = SpawniconGenFunctions['models/sal/hawk_1.mdl']

    SpawniconGenFunctions['models/modified/glasses01.mdl'] = function(o, p, q, r)
        p.x = 1
        p.z = -37

        return f(o, p, q, r * 0.11)
    end
end