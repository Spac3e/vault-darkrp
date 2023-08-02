
RewardsModule = RewardsModule or {}
RewardsModule.Reward = RewardsModule.Reward or {}

--$Сколько будет давать кредитов за выполнение задания
RewardsModule.Reward.SteamGroup = 250
RewardsModule.Reward.SteamName = 5
RewardsModule.SteamNameTag = "VAULT"

term.Add("AlreadyInSteamGroup", "Вы уже вступили в группу Steam и получили бонус!")
term.Add("AlreadySteamTag", "Вы уже установили тэг '"..RewardsModule.SteamNameTag.."' в свой ник и получили бонус!")

