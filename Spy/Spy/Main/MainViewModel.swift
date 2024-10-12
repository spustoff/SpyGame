//
//  MainViewModel.swift
//  Spy
//
//  Created by Вячеслав on 11/10/23.
//

import SwiftUI
import CoreData

final class MainViewModel: ObservableObject {
    
    @Published var isPaywall: Bool = false
    @Published var isPaywallBanner: Bool = true
    
    @AppStorage("is_rules") var is_rules: Bool = false
    @AppStorage("is_vibration") var is_vibration: Bool = false
    @AppStorage("is_paidSubscription") var is_paidSubscription: Bool = false
    
    @Published var gameTypes: GameTypes = .rules
    @Published var currentStep: StepTypes = .main
    
    @Published var selectedSet: [SetModel] = []
    @Published var setSelectedFor: SetTypesSelected = .main
    
    @Published var selectedNameForFavorite: Int = 0
    @Published var selectedPlayerForPicker: PlayersModel? = nil
    
    @Published var playersCount: Int = 3 {
        didSet {
            if playersCount < 3 {
                playersCount = 3
            } else if playersCount > 10 {
                playersCount = 10
            }
        }
    }
    @Published var spiesCount: Int = 1 {
        didSet {
            if spiesCount < 1 {
                spiesCount = 1
            } else if spiesCount > playersCount - 1 {
                spiesCount = playersCount - 1
            }
        }
    }
    @Published var timerCount: Int = 5 {
        didSet {
            if timerCount < 1 {
                timerCount = 1
            } else if timerCount > 10 {
                timerCount = 10
            }
        }
    }
    
    @Published var isRoles: Bool = true
    @Published var roundsCount: Int = 1 {
        didSet {
            if roundsCount < 1 {
                roundsCount = 1
            } else if roundsCount > 10 {
                roundsCount = 10
            }
        }
    }
    
    @Published var isHints: Bool = false
    @Published var isRandomSet: Bool = false
    
    @Published var playerNames: [PlayersModel] = []
    
    @Published var setsModel = MainSetsViewModel()
    @Published var dataManager = DataManager()
    @Published var KCManager = KeychainDataStore()
    
    @Published var isGame: Bool = false
    @Published var isShowHint: Bool = false
    @Published var isLastCard: Bool = false
    
    @Published var toPickerFromScreen: StepTypes = .names
    
    // MARK: -- GAMEView
    @Published var currentCard: Int = 1
    @Published var gameLocation: Location? = nil
    @Published var isShowCard: Bool = false
    
    // MARK: -- TIMERView
    @Published var selectedAsker: PlayersModel?
    @Published var isActiveTimer = false
    @Published var hint: String = ""
    
    @Published var timeRemaining: Int
    
    var totalTime: Int {
        
        timerCount * 60
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // MARK: -- VOTINGView
    @Published var isVoting: Bool = false
    @Published var currentVotingStep: VotingSteps = .main
    
    @Published var votes: [Int: Int] = [:]
    @Published var currentPlayerIndex = 0
    
    @Published var selectedByPlayer: Int = 0
    @Published var selectedForPlayer: Int = 0
    @Published var PlayerWithMostVotes: PlayersModel? = nil
    
    @Published var findedSpiesInGame: [PlayersModel] = []
    
    @Published var retriedVoting: Int = 0
    
    // MARK: -- LOCATION ANSWER
    @Published var shuffledLocations: [Location] = []
    @Published var selectedLocationByPlayer: Location? = nil
    
    @Published var isHistory: Bool = false
    
    @Published var isSpyWon: Bool = false
    
    @Published var gameFinishedHistoryModel: HistoryModel? = nil
    
    @Published var isReviewView: Bool = false
    @AppStorage("isReviewedAlready") var isReviewedAlready: Bool = false
    
    init() {
        
        self.timeRemaining = 0
        self.timeRemaining = totalTime
        
        playerNames = Array(repeating: PlayersModel(id: 0, playerName: "", playerPhoto: "avatar_name", playerRole: ""), count: playersCount)
    }
    
    func gameFinished() {
        
        gameTypes = .rules
        currentStep = .main
        selectedSet = []
        selectedNameForFavorite = 0
        
        playerNames = Array(repeating: PlayersModel(id: 0, playerName: "", playerPhoto: "avatar_name", playerRole: ""), count: playersCount)
        
        isGame = false
        isShowHint = false
        isLastCard = false
        
        currentCard = 1
        gameLocation = nil
        isShowCard = false
        isRandomSet = false
        
        selectedAsker = nil
        isActiveTimer = false
        hint.removeAll()
        
        isVoting = false
        currentVotingStep = .main
        
        votes.removeAll()
        currentPlayerIndex = 0
        
        selectedByPlayer = 0
        selectedForPlayer = 0
        
        retriedVoting = 0
        PlayerWithMostVotes = nil
        
        findedSpiesInGame.removeAll()
        shuffledLocations.removeAll()
        
        selectedLocationByPlayer = nil
    }
    
    func saveHistoryGame() {
        
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let history = NSEntityDescription.insertNewObject(forEntityName: "HistoryModel", into: context) as! HistoryModel

        history.isHints = isHints
        history.isSpyWon = isSpyWon
        history.playersCount = Int16(playersCount)
        
        let totalRolesCount = selectedSet.reduce(0) { sum, setModel in
            
            sum + (setModel.roles?.count ?? 0)
        }
        
        history.roles = Int16(totalRolesCount)
        
        history.rounds = 1
        history.spyCount = Int16(spiesCount)
        history.gameID = Int64.random(in: 1...259439)
        history.time = "\(timerCount):00"
        history.gameDate = Date()
        
        let coreDataPlayers = playerNames.map { playerModel -> PlayersCoreModel in
            
            let coreDataPlayer = NSEntityDescription.insertNewObject(forEntityName: "PlayersCoreModel", into: context) as! PlayersCoreModel

            coreDataPlayer.playerName = playerModel.playerName
            coreDataPlayer.playerRole = playerModel.playerRole
            coreDataPlayer.playerPhoto = playerModel.playerPhoto
            coreDataPlayer.playerID = Int64(playerModel.id)
            
            return coreDataPlayer
        }

        history.playersModel = NSSet(array: coreDataPlayers)
        
        let coreDataSets = selectedSet.map { convertModelToCoreData(model: $0, context: context) }
        history.setModel = NSSet(array: coreDataSets)

        CoreDataStack.shared.saveContext()
        
        self.gameFinishedHistoryModel = history
        
        self.isGame = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            self.gameFinished()
            self.isHistory = true
        }
    }
    
    func getRandomSets(sets: [SetModel]) {
        
        guard !sets.isEmpty else { return }

        selectedSet = Array(sets.shuffled().prefix(5))
    }
    
    func convertModelToCoreData(model: SetModel, context: NSManagedObjectContext) -> HistorySet {
        
        let coreSetModel = HistorySet(context: context)

        let encoder = JSONEncoder()

        // Кодирование массивов строк в Data и их присваивание
        if let rolesData = try? encoder.encode(model.roles) {
            coreSetModel.roles = NSData(data: rolesData) // Преобразование Data в NSData
        }

        let locationsStrings = model.locations.map { $0 } // Использование правильного свойства
        if let locationsData = try? encoder.encode(locationsStrings) {
            coreSetModel.locations = NSData(data: locationsData) // Преобразование Data в NSData
        }

        let hintsStrings = model.locations.flatMap { $0 } // Использование правильного свойства
        if let hintsData = try? encoder.encode(hintsStrings) {
            coreSetModel.hints = NSData(data: hintsData) // Преобразование Data в NSData
        }

        if let image = model.coreDataImage {
            coreSetModel.imageSet = image.pngData() // Уже возвращает Data?
        }

        // Безопасное извлечение и преобразование опциональных значений
        coreSetModel.idSet = Int64(model.id ?? 0)
        coreSetModel.ethernetImage = model.image ?? ""
        coreSetModel.nameSet = model.title
        coreSetModel.isPremium = model.isPremium ?? false
        coreSetModel.totalLocations = Int16(model.totalLocations ?? 0)

        return coreSetModel
    }
    
    func convertHistorySetToModel(coreSetModel: HistorySet) -> SetModel {
        
        let decoder = JSONDecoder()
        
        let roles: [String]? = try? decoder.decode([String].self, from: coreSetModel.roles as? Data ?? Data())
        let locationsStrings: [String] = (try? decoder.decode([String].self, from: coreSetModel.locations as? Data ?? Data())) ?? []
        let hintsStrings: [String] = (try? decoder.decode([String].self, from: coreSetModel.hints as? Data ?? Data())) ?? []
        
        let locationsArray = locationsStrings.map { locationString -> Location in
            
            return Location(id: Int.random(in: 1...999999), location: locationString, hints: hintsStrings)
        }
        
        var resizedImage: UIImage? = nil

        if let image = UIImage(data: coreSetModel.imageSet ?? Data()) {
            
            resizedImage = resizeImage(image: image, targetSize: CGSize(width: 250, height: 250))
        }
        
        return SetModel(
            id: Int(coreSetModel.idSet),
            title: coreSetModel.nameSet,
            image: coreSetModel.ethernetImage,
            coreDataImage: resizedImage,
            isPremium: coreSetModel.isPremium,
            totalLocations: Int(coreSetModel.totalLocations),
            locations: locationsArray,
            roles: roles
        )
    }
    
    func updatePlayer(at index: Int, with player: PlayersModel) {
        
        guard index >= 0 && index < playerNames.count else { return }
        
        playerNames[index] = player
    }
    
    func updatePlayerPhoto(in playersArray: [PlayersModel], for player: PlayersModel, with photo: String) -> [PlayersModel] {
        
        var updatedPlayers = playersArray
        
        if let index = updatedPlayers.firstIndex(where: { $0.playerName == player.playerName }) {
            
            updatedPlayers[index].playerPhoto = photo
        }
        
        return updatedPlayers
    }
    
    func getResultOfGame(isByLocationFound: Bool) {
        
        guard let votedPlayer = PlayerWithMostVotes else { return }
        
        if isByLocationFound {
            
            guard let selectedLoc = selectedLocationByPlayer else { return }
        
            if selectedLoc == gameLocation {
                
                if votedPlayer.playerRole == "Spy" {
                    
                    isSpyWon = true
                    saveHistoryGame()
                    print("// MARK: -- GAME IS END, SPY IS WON")
                    
                } else if votedPlayer.playerRole != "Spy" {
                    
                    if timeRemaining <= 0 {
                        
                        retryVoting()
                        
                    } else {
                        
                        closeVotingModal()
                    }
                }
                
            } else if selectedLoc != gameLocation {
                
                if votedPlayer.playerRole == "Spy" {
                    
                    if let player = PlayerWithMostVotes {
                        
                        findedSpiesInGame.append(player)
                        
                        print("currentPlayerIndex: \(currentPlayerIndex)")
                        print("players after remove: \n\(getActivePlayers())")
                    }
                    
                    if spiesCount <= findedSpiesInGame.count {
                        
                        isSpyWon = false
                        saveHistoryGame()
                        
                        print("// MARK: -- GAME IS END, CITIZEN IS WON")
                        
                    } else {
                        
                        if timeRemaining <= 0 {
                            
                            retryVoting()
                            
                        } else {
                            
                            currentVotingStep = .spyLeft
                        }
                    }
                    
                } else if votedPlayer.playerRole != "Spy" {
                    
                    isSpyWon = true
                    saveHistoryGame()
                    
                    print("// MARK: -- GAME IS END, SPY IS WON")
                }
            }
            
        } else if !isByLocationFound {
            
            if PlayerWithMostVotes?.playerRole == "Spy" {
                
                if let player = PlayerWithMostVotes {
                    
                    findedSpiesInGame.append(player)
                    
                    print("currentPlayerIndex: \(currentPlayerIndex)")
                    print("players after remove: \n\(getActivePlayers())")
                    
                }
                
                if spiesCount <= findedSpiesInGame.count {
                    
                    isSpyWon = false
                    saveHistoryGame()
                    print("// MARK: -- GAME IS END, CITIZEN WON")
                    
                } else {
                    
                    if timeRemaining <= 0 {
                        
                        retryVoting()
                        
                    } else {
                        
                        currentVotingStep = .spyLeft
                    }
                }
                
            } else if PlayerWithMostVotes?.playerRole != "Spy" {
                
                isSpyWon = true
                saveHistoryGame()
                print("// MARK: -- GAME IS END, SPY IS WON")
            }
        }
        
        let activePlayers = getActivePlayers()
        
        if activePlayers.count == 2 {
            
            let spyCount = activePlayers.filter { $0.playerRole == "Spy" }.count
            let citizenCount = activePlayers.count - spyCount
            
            if spyCount == 1 && citizenCount == 1 {
                
                isSpyWon = true
                saveHistoryGame()
                
                print("// MARK: -- GAME IS END, SPY IS WON")
                
                return
            }
        }
    }
    
    func retryVoting() {
        
        guard retriedVoting != 2 else {
            
            isSpyWon = true
            saveHistoryGame()
            
            print("// MARK: -- GAME IS END, SPY IS WON")
            
            return
        }
        
        retriedVoting += 1
        
        selectedLocationByPlayer = nil
        PlayerWithMostVotes = nil
        currentPlayerIndex = 0
        selectedByPlayer = 0
        selectedForPlayer = 0
        votes = [:]
        currentVotingStep = .main
    }
    
    func closeVotingModal() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            self.selectedLocationByPlayer = nil
            self.PlayerWithMostVotes = nil
            self.currentPlayerIndex = 0
            self.selectedByPlayer = 0
            self.selectedForPlayer = 0
            self.votes = [:]
            self.currentVotingStep = .main
        }
        
        guard timeRemaining > 0 else { return }
        
        withAnimation(.spring()) {
            
            self.isVoting = false
        }
        
        self.selectedForPlayer = 0
        self.isActiveTimer = true
    }
    
    func getActivePlayers() -> [PlayersModel] {
        
        let activePlayers = self.playerNames.filter { player in
            
            !self.findedSpiesInGame.contains(where: { $0.id == player.id })
        }
        
        print("currentPlayerIndex: \(currentPlayerIndex)")
        
        return activePlayers
    }

    func findPlayerWithMostVotes() {
        
        var voteCounts = [Int: Int]()

        for vote in votes.values {
            
            voteCounts[vote, default: 0] += 1
        }

        let maxVotes = voteCounts.values.max()
        let playersWithMaxVotes = voteCounts.filter { $0.value == maxVotes }.keys

        if playersWithMaxVotes.count == 1, let maxVotePlayerId = playersWithMaxVotes.first {
            
            DispatchQueue.main.async {
             
                self.currentVotingStep = .result
                
                self.PlayerWithMostVotes = self.playerNames.first { $0.id == maxVotePlayerId }
            }
            
        } else {
            
            closeVotingModal()

            PlayerWithMostVotes = PlayersModel(id: 1, playerName: "Slava", playerPhoto: "", playerRole: "Spy")
        }
        
        print("players1: \n\(playerNames)")
        
        currentPlayerIndex = 0
    }
    
    func vote(for playerId: Int, by votingPlayerId: Int) {
        votes[votingPlayerId] = playerId

        // Находим индекс игрока, который только что проголосовал в массиве
        if let currentIndex = getActivePlayers().firstIndex(where: { $0.id == votingPlayerId }) {
            // Проверяем, есть ли следующий игрок в массиве
            if currentIndex + 1 < getActivePlayers().count {
                currentPlayerIndex = currentIndex + 1
            } else {
                // Если следующего игрока нет, завершаем голосование
                endVoting()
            }
        } else {
            print("not found player")
            // Если игрок, который проголосовал, не найден, возможно, его нужно обработать особым образом
        }

        selectedForPlayer = 0
    }
    
    private func endVoting() {
        
        DispatchQueue.main.async {
            
            self.findPlayerWithMostVotes()
        }
    }
    
    @ViewBuilder
    func getVotingSteps() -> some View {
        
        switch currentVotingStep {
            
        case .main:
            MainVoting(viewModel: self)
                .modifier(AnimatedScale())
        case .voting:
            VoteVoting(viewModel: self)
                .modifier(AnimatedScale())
        case .result:
            ResultVoting(viewModel: self)
                .modifier(AnimatedScale())
        case .question:
            QuestionVoting(viewModel: self)
                .modifier(AnimatedScale())
        case .spyLeft:
            TotalResultVoting(viewModel: self)
                .modifier(AnimatedScale())
        }
    }
    
    @ViewBuilder
    func getGameSteps() -> some View {
        
        switch gameTypes {
        case .rules:
            RulesView(isForGame: true, isTopBar: false, playAction: {
                
                self.gameTypes = .cards
            })
        case .cards:
            CardsView(isPlayButton: true, viewModel: self)
        case .timer:
            TimerView(viewModel: self)
                .modifier(AnimatedScale())
        case .ad:
//            AdsView(viewModel: self, type: .fullScreen, isCloseButton: false, closeAction: {})
//                .modifier(AnimatedScale())
            EmptyView()
        }
    }
    
    func getRandomLocation() {
        
        let allLocations = selectedSet.compactMap { $0.locations }.flatMap { $0 }
        
        guard !allLocations.isEmpty else {
            
            gameLocation = Location(id: 4538, location: "Russia", hints: [])
            
            return
        }

        gameLocation = allLocations.randomElement()!
    }

    
    func setupPlayers() {
        
        let gamesPlayed = KCManager.loadNumber(forKey: "subscriptionAvailableGames2")
        
        if !is_paidSubscription {
            
            guard gamesPlayed < KCManager.availableGames else {
                
                isPaywall = true
                
                return
            }
        }
        
        let intForSave = (gamesPlayed + 1)
        
        KCManager.saveNumber(intForSave, forKey: "subscriptionAvailableGames2")
                
        isGame = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.currentStep = .main
        }

        if !is_rules {
            
            gameTypes = .cards
            
        } else if is_rules {
            
            gameTypes = .rules
        }
        
        let actualSpiesCount = min(spiesCount, playersCount)
        var indices = Array(0..<playersCount)

        var spyIndices = Set<Int>()
        while spyIndices.count < actualSpiesCount {
            
            if let randomIndex = indices.randomElement() {
                
                spyIndices.insert(randomIndex)
                indices.removeAll(where: { $0 == randomIndex })
            }
        }

        var allRoles = selectedSet.compactMap { $0.roles }.flatMap { $0 }.shuffled()
        if allRoles.isEmpty || !isRoles {
            // Обработка ситуации, когда нет доступных ролей
            // Например, можно присвоить дефолтную роль или вывести сообщение об ошибке
            allRoles = ["Citizen"]
        }

        let remainingRoles = allRoles
        var roleIndex = 0

        for i in 0..<playersCount {
            
            var playerName: String
            var playerPhoto: String
            var playerRole: String

            if i < playerNames.count {
                
                playerName = playerNames[i].playerName
                playerPhoto = playerNames[i].playerPhoto
                
            } else {
                
                playerName = "Player \(i+1)"
                playerPhoto = "avatar_name"
            }

            if spyIndices.contains(i) {
                
                playerRole = "Spy"
                
            } else {
                
                if !remainingRoles.isEmpty {
                    playerRole = remainingRoles[roleIndex % remainingRoles.count]
                    roleIndex += 1
                } else {
                    // Обработка ситуации, когда нет доступных ролей
                    // Например, можно присвоить дефолтную роль или вывести сообщение об ошибке
                    playerRole = "Citizen" // Или любая другая логика обработки
                }
            }

            let newPlayer = PlayersModel(id: i + 1, playerName: playerName, playerPhoto: playerPhoto, playerRole: playerRole)
            
            if i < playerNames.count {
                
                playerNames[i] = newPlayer
                
            } else {
                
                playerNames.append(newPlayer)
            }
        }

        getRandomLocation()
    }
    
    func updatePlayersCount(to newCount: Int) {
        
        playersCount = newCount
        
        if playerNames.count < playersCount {
            
            let additionalPlayers = Array(repeating: PlayersModel(id: 0, playerName: "", playerPhoto: "avatar_name", playerRole: ""), count: playersCount - playerNames.count)
            
            playerNames.append(contentsOf: additionalPlayers)
            
        } else if playerNames.count > playersCount {
            
            playerNames = Array(playerNames.prefix(playersCount))
        }
    }
    
    public func manageControlGame(buttonType: PlusMinusTypes) {
        
        if currentCard == playerNames.count {
            
            isLastCard = true
            
            timeRemaining = timerCount * 60
            
            if selectedAsker == nil {
                
                selectedAsker = playerNames.randomElement()
            }
            
            guard let randomHint = gameLocation?.hints?.randomElement() else { return }
            
            hint = randomHint
            
            DispatchQueue.main.async {
                
                self.gameTypes = .timer
            }
        }
        
        if buttonType == .plus {
            
            if currentCard != playerNames.count {
                
                withAnimation(.spring()) {
                    
                    self.currentCard += 1
                }
                
            } else if currentCard == playerNames.count {
                
                DispatchQueue.main.async {
                    
                    self.gameTypes = .timer
                }
            }
        
        } else if buttonType == .minus {
            
            if currentCard != 1 {
                
                withAnimation(.spring()) {
                    
                    self.currentCard -= 1
                }
            }
        }
    }
    
    func setupHistory(historyModel: HistoryModel) {
        
        if let coreDataPlayersSet = historyModel.playersModel as? Set<PlayersCoreModel> {
            
            let sortedPlayersArray = coreDataPlayersSet
                .sorted(by: { $0.playerID < $1.playerID })
                .map { corePlayer in
                    
                    PlayersModel(id: Int(corePlayer.playerID), playerName: corePlayer.playerName ?? "", playerPhoto: corePlayer.playerPhoto ?? "", playerRole: corePlayer.playerRole ?? "")
                }
            
            playerNames = sortedPlayersArray
            playersCount = playerNames.count
//            spiesCount = sortedPlayersArray.count(where: { $0.playerRole == "Spy" })
        }
        spiesCount = Int(historyModel.spyCount)
        timerCount = Int(historyModel.time ?? "5") ?? 5
        isHints = historyModel.isHints
        // Round and roles
        
//        if let setModels = historyModel.setModel as? Set<HistorySet> {
        if let setModels = historyModel.setModel as? Set<SetModel> {
//            setsModel = setModels
            for setModel in setModels {
                selectedSet.append(setModel)
            }
        }
        
        if let setModels = historyModel.setModel as? Set<HistorySet> {
            
            let allLocations = setModels.compactMap { getLocationsArray(from: $0) }.flatMap { $0 }
            
//            all21321
        }
        
        let gamesPlayed = KCManager.loadNumber(forKey: "subscriptionAvailableGames2")
        
//        if is_paidSubscription {
//            
//            guard gamesPlayed < KCManager.availableGames else {
//                
//                isPaywall = true
//                
//                return
//            }
//        }
        
        let intForSave = (gamesPlayed + 1)
        
        KCManager.saveNumber(intForSave, forKey: "subscriptionAvailableGames2")
                
        isGame = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.currentStep = .main
        }

        if !is_rules {
            
            gameTypes = .cards
            
        } else if is_rules {
            
            gameTypes = .rules
        }
        
        let actualSpiesCount = min(spiesCount, playersCount)
        var indices = Array(0..<playersCount)

        var spyIndices = Set<Int>()
        while spyIndices.count < actualSpiesCount {
            
            if let randomIndex = indices.randomElement() {
                
                spyIndices.insert(randomIndex)
                indices.removeAll(where: { $0 == randomIndex })
            }
        }

        var allRoles = selectedSet.compactMap { $0.roles }.flatMap { $0 }.shuffled()
        if allRoles.isEmpty || !isRoles {
            // Обработка ситуации, когда нет доступных ролей
            // Например, можно присвоить дефолтную роль или вывести сообщение об ошибке
            allRoles = ["Citizen"]
        }

        let remainingRoles = allRoles
        var roleIndex = 0

        for i in 0..<playersCount {
            
            var playerName: String
            var playerPhoto: String
            var playerRole: String

            if i < playerNames.count {
                
                playerName = playerNames[i].playerName
                playerPhoto = playerNames[i].playerPhoto
                
            } else {
                
                playerName = "Player \(i+1)"
                playerPhoto = "avatar_name"
            }

            if spyIndices.contains(i) {
                
                playerRole = "Spy"
                
            } else {
                
                if !remainingRoles.isEmpty {
                    playerRole = remainingRoles[roleIndex % remainingRoles.count]
                    roleIndex += 1
                } else {
                    // Обработка ситуации, когда нет доступных ролей
                    // Например, можно присвоить дефолтную роль или вывести сообщение об ошибке
                    playerRole = "Citizen" // Или любая другая логика обработки
                }
            }

            let newPlayer = PlayersModel(id: i + 1, playerName: playerName, playerPhoto: playerPhoto, playerRole: playerRole)
            
            if i < playerNames.count {
                
                playerNames[i] = newPlayer
                
            } else {
                
                playerNames.append(newPlayer)
            }
        }

        getRandomLocation()
        
        isGame = true
    }
    
    @ViewBuilder
    func manageViews() -> some View {
        
        switch currentStep {
        case .main:
            MainDesign()
                    .environmentObject(self)
                    .environmentObject(self.setsModel)
                .modifier(AnimatedScale())
        case .names:
                MainNames()
                    .environmentObject(self)
                    .environmentObject(self.dataManager)
                
//            MainNames(viewModel: self, dataManager: self.dataManager)
                .modifier(AnimatedScale())
        case .sets:
                MainSets()
                    .environmentObject(self)
                    .environmentObject(self.setsModel)
//            MainSets(viewModel: self, setsModel: self.setsModel)
                .modifier(AnimatedScale())
        case .newSet:
            NewSet(viewModel: self, setsModel: self.setsModel)
                .modifier(AnimatedScale())
        case .nameFavorites:
                NamesFavorites()
                    .environmentObject(self)
//            NamesFavorites(viewModel: self, dataManager: self.dataManager)
                .modifier(AnimatedScale())
        case .pickAvatar:
                AvatarPicker()
                    .environmentObject(self)
//            AvatarPicker(viewModel: self)
                .modifier(AnimatedScale())
        }
    }
    
    func viewSwitcher(_ type: PlusMinusTypes) {
        
        let types: [StepTypes] = [.main, .names]
        var currentType = types.firstIndex(of: currentStep) ?? 0

        UIApplication.shared.endEditing()

        if type == .minus {
            
            if currentType > 0 {
                
                currentType -= 1
            }
            
        } else if type == .plus {
            
            if currentType < types.count - 1 {
                
                currentType += 1
            }
        }

        currentStep = types[currentType]
    }
    
    func PlusMinusManage(number: Binding<Int>, minLimit: Int, maxLimit: Int, isPlayerCount: Bool = false, buttonType: PlusMinusTypes) {
        
        if buttonType == .minus {
            
            if number.wrappedValue > minLimit {
                
                number.wrappedValue -= 1
                
                if isPlayerCount {
                    
                    updatePlayersCount(to: number.wrappedValue)
                    
                    if spiesCount >= number.wrappedValue {
                        
                        spiesCount = number.wrappedValue - 1
                    }
                }
            }
            
        } else if buttonType == .plus {
            
            if number.wrappedValue < maxLimit {
                
                number.wrappedValue += 1
                
                if isPlayerCount {
                    
                    updatePlayersCount(to: number.wrappedValue)
                }
            }
        }
    }
}

enum StepTypes: CaseIterable {
    
    case main, names
    case sets, newSet, nameFavorites
    case pickAvatar
    
    var text: String {
        
        switch self {
            
        case .main:
            return NSLocalizedString("Game Options", comment: "")
            
        case .names:
            return NSLocalizedString("Names", comment: "")
            
        case .sets:
            return NSLocalizedString("Sets", comment: "")
            
        case .newSet:
            return NSLocalizedString("New Set", comment: "")
            
        case .nameFavorites:
            return NSLocalizedString("Favorites", comment: "")
            
        case .pickAvatar:
            return NSLocalizedString("Pick an Avatar", comment: "")
        }
    }
}

enum PlusMinusTypes {
    
    case plus, minus
}

enum GameTypes: CaseIterable {
    
    case rules, cards, timer, ad
    
    var text: String {
        
        switch self {
            
        case .rules:
            return NSLocalizedString("Rules", comment: "")
            
        case .cards:
            return NSLocalizedString("Handing Out", comment: "")
            
        case .timer:
            return NSLocalizedString("Game", comment: "")
            
        case .ad:
            return NSLocalizedString("Ad", comment: "")
        }
    }
}

func getLocationsArray(from setModel: HistorySet) -> [Location]? {
    
    guard let locationsData = setModel.locations as? Data else {
        
        print("No locations data found")
        
        return []
    }

    let decoder = JSONDecoder()
    
    do {
        
        let locationsArray = try decoder.decode([Location].self, from: locationsData)
        
        return locationsArray
        
    } catch {
        
        print("Error decoding locations: \(error)")
        
        return []
    }
}
