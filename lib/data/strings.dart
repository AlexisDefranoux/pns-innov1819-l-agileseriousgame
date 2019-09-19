class Strings {
  static var appBarTitle = "Agile Serious Game";
  static var appBarTitleAdmin = "Panneau d'administration";
  static var appBarTitleJoinLobby = "Rejoindre une partie";
  static var appBarTitleCreateLobby = "Créer une partie";
  static var appButtonJoin = "Rejoindre";
  static var appButtonCreate = "Créer";
  static var appButtonFacilitator = "Facilitateur";
  static var appButtonPlayer = "Participant";
  static var appBarSubTitle1 = "CHRONO";
  static var appBarSubTitle2 = "USER STORY";
  static var appBarSubTitle3 = "SCORE";
  static var lobbyKey = "Saisissez votre clé de partie :";
  static var teamKey = "Saisissez votre nom d'équipe :";
  static var scorePerformance = "Performance";
  static var scoreContinuity = "Continuité";
  static var scoreRanking = "Classement";
  static var chartTeams = "Équipes";
  static var chartPoints = "Points";
  static var chartIterations = "Itérations";
  static var chartTitleRanking = "Classement général des équipes";
  static var chartTitleContinuity = "Continuité des équipes";
  static var chartTitlePlayerPoints = "Points acceptés et refusés";
  static var chartTitlePlayerUserStory = "Users Stories acceptées et refusées";
  static var playerNumber = "Nombre d'équipe";
  static var numberOfPlayer = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];

  static var titlePlanification = "Planification";
  static var titleRealisation = "Réalisation";
  static var titleRevue = "Revue";
  static var titleRetrospective = "Rétrospective";
}

class UserStoryStrings {
  static var userStories = [
    [
      "Nom d’oiseau", //title
      "En tant que Marketing, je veux que le jouet ait un nom pour pouvoir construire une campagne marketing autour de ce nom", //specification
      100, //Score
      [
        "Le nom est en un seul mot",
        "Pas de trait d'union",
        "Pas d'accent"
      ], //criteria content
      1 //release iteration
    ],
    [
      "Roues",
      "En tant qu'enfant, je veux que le jouet ait des roues pour que je puisse l'utiliser avec mes autres petites voitures",
      200,
      ["Je peux rouler en avant et en arrière"],
      1
    ],
    [
      "Bec",
      "En tant qu'enfant, je veux que le jouet ait 1 bec pour qu'il ressemble mieux à un vrai oiseau",
      200,
      ["Le bec est d'une couleur différente du corps"],
      1
    ],
    [
      "Ailes",
      "En tant qu'enfant, je veux que le jouet ait 2 ailes pour que je puisse rêver à le faire voler",
      400,
      ["Les ailes sont ouvertes"],
      1
    ],
    [
      "Initiale",
      "En tant que marketing, je veux que la première lettre du nom du jouet apparaisse sur le corps du jouet pour que l'impact visuel soit plus fort",
      100,
      ["Le jouet ne peut pas être peint (ou écrit)"],
      2
    ],
    [
      "Jambes",
      "En tant que vendeur, je veux que le jouet ait 2 jambes pour que je puisse le mettre en vitrine dans mon magasin",
      200,
      ["Le jouet doit attaquer avec son bec"],
      2
    ],
    [
      "Hauteur",
      "En tant que marketing, je veux que le jouet soit grand pour qu'il ait un air majestueux et qu'il se vende mieux",
      300,
      ["Au moins 20cm de haut"],
      3
    ],
    [
      "Tête",
      "En tant que marketing, je veux que le jouet ait une tête pour qu'il ne soit pas effrayant pour les enfants",
      300,
      ["La tête doit être portée par un cou"],
      3
    ]
  ];
}
