local function InfiniteFusion()
	local self = {}

	-- Define descriptive attributes of the custom extension that are displayed on the Tracker settings
	self.name = "Pokémon Infinite Fusion"
	self.author = "UTDZac"
	self.description = "Fuse two Pokémon together from the Pokémon Infinite Fusion game."
	self.version = "1.3"
	self.url = "https://github.com/UTDZac/InfiniteFusion-IronmonExtension"

	local ExtConstants = {
		offlineFolder = FileManager.getCustomFolderPath() .. "CustomBattlers" .. FileManager.slash,
		onlineUrl = "https://aegide.github.io/",
		fusionFilename1 = "InfiniteFusion1.png",
		fusionFilename2 = "InfiniteFusion2.png",
		unknownName = "???",
		bulletListIcon = "-",
		imageCanvas = "client", -- The emulator surface to draw on. Client > Emucore so that it scales better
		offlineAvailable = false,
		Formats = {
			fusionName = "%s / %s  (%s.%s)", -- e.g Shuckle/Pikachu (213.25)
			fusionFile = "%s.%s.png",
			fusionUrl = "https://raw.githubusercontent.com/Aegide/custom-fusion-sprites/main/CustomBattlers/%s.%s.png",
			curlCommand1 = 'curl --ssl-no-revoke -s -o "%s" -w "%%{http_code}," "%s"', -- Fetches a fusion image and returns http status code
			curlCommand2 = 'curl --ssl-no-revoke -s -o "%s" -w "%%{http_code}" "%s"', -- Fetches a fusion image and returns http status code
		},
		Screens = {
			MainFusion = 1,
			PokemonLookup = 2,
		},
		Colors = {
			text = Drawing.Colors.WHITE,
			highlight = 0xFFFFFF00, -- Yellow
			background = 0xEE000000, -- The first two characters after the '0x' are the opacity
			success = 0xFF00FF00, -- Green
			fail = 0xFFFF0000, -- Red
		},
	}

	ExtConstants.offlineAvailable = FileManager.folderExists(ExtConstants.offlineFolder)

	-- List of all available fusions: key:fusionId, value:fusionName
	-- https://infinitefusion.fandom.com/wiki/Pok%C3%A9dex
	local fusionIdToName = {
		[1] = "Bulbasaur",
		[2] = "Ivysaur",
		[3] = "Venusaur",
		[4] = "Charmander",
		[5] = "Charmeleon",
		[6] = "Charizard",
		[7] = "Squirtle",
		[8] = "Wartortle",
		[9] = "Blastoise",
		[10] = "Caterpie",
		[11] = "Metapod",
		[12] = "Butterfree",
		[13] = "Weedle",
		[14] = "Kakuna",
		[15] = "Beedrill",
		[16] = "Pidgey",
		[17] = "Pidgeotto",
		[18] = "Pidgeot",
		[19] = "Rattata",
		[20] = "Raticate",
		[21] = "Spearow",
		[22] = "Fearow",
		[23] = "Ekans",
		[24] = "Arbok",
		[25] = "Pikachu",
		[26] = "Raichu",
		[27] = "Sandshrew",
		[28] = "Sandslash",
		[29] = "NidoranF",
		[30] = "Nidorina",
		[31] = "Nidoqueen",
		[32] = "NidoranM",
		[33] = "Nidorino",
		[34] = "Nidoking",
		[35] = "Clefairy",
		[36] = "Clefable",
		[37] = "Vulpix",
		[38] = "Ninetales",
		[39] = "Jigglypuff",
		[40] = "Wigglytuff",
		[41] = "Zubat",
		[42] = "Golbat",
		[43] = "Oddish",
		[44] = "Gloom",
		[45] = "Vileplume",
		[46] = "Paras",
		[47] = "Parasect",
		[48] = "Venonat",
		[49] = "Venomoth",
		[50] = "Diglett",
		[51] = "Dugtrio",
		[52] = "Meowth",
		[53] = "Persian",
		[54] = "Psyduck",
		[55] = "Golduck",
		[56] = "Mankey",
		[57] = "Primeape",
		[58] = "Growlithe",
		[59] = "Arcanine",
		[60] = "Poliwag",
		[61] = "Poliwhirl",
		[62] = "Poliwrath",
		[63] = "Abra",
		[64] = "Kadabra",
		[65] = "Alakazam",
		[66] = "Machop",
		[67] = "Machoke",
		[68] = "Machamp",
		[69] = "Bellsprout",
		[70] = "Weepinbell",
		[71] = "Victreebel",
		[72] = "Tentacool",
		[73] = "Tentacruel",
		[74] = "Geodude",
		[75] = "Graveler",
		[76] = "Golem",
		[77] = "Ponyta",
		[78] = "Rapidash",
		[79] = "Slowpoke",
		[80] = "Slowbro",
		[81] = "Magnemite",
		[82] = "Magneton",
		[83] = "Farfetch'd",
		[84] = "Doduo",
		[85] = "Dodrio",
		[86] = "Seel",
		[87] = "Dewgong",
		[88] = "Grimer",
		[89] = "Muk",
		[90] = "Shellder",
		[91] = "Cloyster",
		[92] = "Gastly",
		[93] = "Haunter",
		[94] = "Gengar",
		[95] = "Onix",
		[96] = "Drowzee",
		[97] = "Hypno",
		[98] = "Krabby",
		[99] = "Kingler",
		[100] = "Voltorb",
		[101] = "Electrode",
		[102] = "Exeggcute",
		[103] = "Exeggutor",
		[104] = "Cubone",
		[105] = "Marowak",
		[106] = "Hitmonlee",
		[107] = "Hitmonchan",
		[108] = "Lickitung",
		[109] = "Koffing",
		[110] = "Weezing",
		[111] = "Rhyhorn",
		[112] = "Rhydon",
		[113] = "Chansey",
		[114] = "Tangela",
		[115] = "Kangaskhan",
		[116] = "Horsea",
		[117] = "Seadra",
		[118] = "Goldeen",
		[119] = "Seaking",
		[120] = "Staryu",
		[121] = "Starmie",
		[122] = "Mr. Mime",
		[123] = "Scyther",
		[124] = "Jynx",
		[125] = "Electabuzz",
		[126] = "Magmar",
		[127] = "Pinsir",
		[128] = "Tauros",
		[129] = "Magikarp",
		[130] = "Gyarados",
		[131] = "Lapras",
		[132] = "Ditto",
		[133] = "Eevee",
		[134] = "Vaporeon",
		[135] = "Jolteon",
		[136] = "Flareon",
		[137] = "Porygon",
		[138] = "Omanyte",
		[139] = "Omastar",
		[140] = "Kabuto",
		[141] = "Kabutops",
		[142] = "Aerodactyl",
		[143] = "Snorlax",
		[144] = "Articuno",
		[145] = "Zapdos",
		[146] = "Moltres",
		[147] = "Dratini",
		[148] = "Dragonair",
		[149] = "Dragonite",
		[150] = "Mewtwo",
		[151] = "Mew",
		[152] = "Chikorita",
		[153] = "Bayleef",
		[154] = "Meganium",
		[155] = "Cyndaquil",
		[156] = "Quilava",
		[157] = "Typhlosion",
		[158] = "Totodile",
		[159] = "Croconaw",
		[160] = "Feraligatr",
		[161] = "Sentret",
		[162] = "Furret",
		[163] = "Hoothoot",
		[164] = "Noctowl",
		[165] = "Ledyba",
		[166] = "Ledian",
		[167] = "Spinarak",
		[168] = "Ariados",
		[169] = "Crobat",
		[170] = "Chinchou",
		[171] = "Lanturn",
		[172] = "Pichu",
		[173] = "Cleffa",
		[174] = "Igglybuff",
		[175] = "Togepi",
		[176] = "Togetic",
		[177] = "Natu",
		[178] = "Xatu",
		[179] = "Mareep",
		[180] = "Flaaffy",
		[181] = "Ampharos",
		[182] = "Bellossom",
		[183] = "Marill",
		[184] = "Azumarill",
		[185] = "Sudowoodo",
		[186] = "Politoed",
		[187] = "Hoppip",
		[188] = "Skiploom",
		[189] = "Jumpluff",
		[190] = "Aipom",
		[191] = "Sunkern",
		[192] = "Sunflora",
		[193] = "Yanma",
		[194] = "Wooper",
		[195] = "Quagsire",
		[196] = "Espeon",
		[197] = "Umbreon",
		[198] = "Murkrow",
		[199] = "Slowking",
		[200] = "Misdreavus",
		[201] = "Unown",
		[202] = "Wobbuffet",
		[203] = "Girafarig",
		[204] = "Pineco",
		[205] = "Forretress",
		[206] = "Dunsparce",
		[207] = "Gligar",
		[208] = "Steelix",
		[209] = "Snubbull",
		[210] = "Granbull",
		[211] = "Qwilfish",
		[212] = "Scizor",
		[213] = "Shuckle",
		[214] = "Heracross",
		[215] = "Sneasel",
		[216] = "Teddiursa",
		[217] = "Ursaring",
		[218] = "Slugma",
		[219] = "Magcargo",
		[220] = "Swinub",
		[221] = "Piloswine",
		[222] = "Corsola",
		[223] = "Remoraid",
		[224] = "Octillery",
		[225] = "Delibird",
		[226] = "Mantine",
		[227] = "Skarmory",
		[228] = "Houndour",
		[229] = "Houndoom",
		[230] = "Kingdra",
		[231] = "Phanpy",
		[232] = "Donphan",
		[233] = "Porygon2",
		[234] = "Stantler",
		[235] = "Smeargle",
		[236] = "Tyrogue",
		[237] = "Hitmontop",
		[238] = "Smoochum",
		[239] = "Elekid",
		[240] = "Magby",
		[241] = "Miltank",
		[242] = "Blissey",
		[243] = "Raikou",
		[244] = "Entei",
		[245] = "Suicune",
		[246] = "Larvitar",
		[247] = "Pupitar",
		[248] = "Tyranitar",
		[249] = "Lugia",
		[250] = "Ho-oh",
		[251] = "Celebi",
		[252] = "Azurill",
		[253] = "Wynaut",
		[254] = "Ambipom",
		[255] = "Mismagius",
		[256] = "Honchkrow",
		[257] = "Bonsly",
		[258] = "Mime Jr.",
		[259] = "Happiny",
		[260] = "Munchlax",
		[261] = "Mantyke",
		[262] = "Weavile",
		[263] = "Magnezone",
		[264] = "Lickilicky",
		[265] = "Rhyperior",
		[266] = "Tangrowth",
		[267] = "Electivire",
		[268] = "Magmortar",
		[269] = "Togekiss",
		[270] = "Yanmega",
		[271] = "Leafeon",
		[272] = "Glaceon",
		[273] = "Gliscor",
		[274] = "Mamoswine",
		[275] = "Porygon-Z",
		[276] = "Treecko",
		[277] = "Grovyle",
		[278] = "Sceptile",
		[279] = "Torchic",
		[280] = "Combusken",
		[281] = "Blaziken",
		[282] = "Mudkip",
		[283] = "Marshtomp",
		[284] = "Swampert",
		[285] = "Ralts",
		[286] = "Kirlia",
		[287] = "Gardevoir",
		[288] = "Gallade",
		[289] = "Shedinja",
		[290] = "Kecleon",
		[291] = "Beldum",
		[292] = "Metang",
		[293] = "Metagross",
		[294] = "Bidoof",
		[295] = "Spiritomb",
		[296] = "Lucario",
		[297] = "Gible",
		[298] = "Gabite",
		[299] = "Garchomp",
		[300] = "Mawile",
		[301] = "Lileep",
		[302] = "Cradily",
		[303] = "Anorith",
		[304] = "Armaldo",
		[305] = "Cranidos",
		[306] = "Rampardos",
		[307] = "Shieldon",
		[308] = "Bastiodon",
		[309] = "Slaking",
		[310] = "Absol",
		[311] = "Duskull",
		[312] = "Dusclops",
		[313] = "Dusknoir",
		[314] = "Wailord",
		[315] = "Arceus",
		[316] = "Turtwig",
		[317] = "Grotle",
		[318] = "Torterra",
		[319] = "Chimchar",
		[320] = "Monferno",
		[321] = "Infernape",
		[322] = "Piplup",
		[323] = "Prinplup",
		[324] = "Empoleon",
		[325] = "Nosepass",
		[326] = "Probopass",
		[327] = "Honedge",
		[328] = "Doublade",
		[329] = "Aegislash",
		[330] = "Pawniard",
		[331] = "Bisharp",
		[332] = "Luxray",
		[333] = "Aggron",
		[334] = "Flygon",
		[335] = "Milotic",
		[336] = "Salamence",
		[337] = "Klinklang",
		[338] = "Zoroark",
		[339] = "Sylveon",
		[340] = "Kyogre",
		[341] = "Groudon",
		[342] = "Rayquaza",
		[343] = "Dialga",
		[344] = "Palkia",
		[345] = "Giratina",
		[346] = "Regigigas",
		[347] = "Darkrai",
		[348] = "Genesect",
		[349] = "Reshiram",
		[350] = "Zekrom",
		[351] = "Kyurem",
		[352] = "Roserade",
		[353] = "Drifblim",
		[354] = "Lopunny",
		[355] = "Breloom",
		[356] = "Ninjask",
		[357] = "Banette",
		[358] = "Rotom",
		[359] = "Reuniclus",
		[360] = "Whimsicott",
		[361] = "Krookodile",
		[362] = "Cofagrigus",
		[363] = "Galvantula",
		[364] = "Ferrothorn",
		[365] = "Litwick",
		[366] = "Lampent",
		[367] = "Chandelure",
		[368] = "Haxorus",
		[369] = "Golurk",
		[370] = "Pyukumuku",
		[371] = "Klefki",
		[372] = "Talonflame",
		[373] = "Mimikyu",
		[374] = "Volcarona",
		[375] = "Deino",
		[376] = "Zweilous",
		[377] = "Hydreigon",
		[378] = "Latias",
		[379] = "Latios",
		[380] = "Deoxys",
		[381] = "Jirachi",
		[382] = "Nincada",
		[383] = "Bibarel",
		[384] = "Riolu",
		[385] = "Slakoth",
		[386] = "Vigoroth",
		[387] = "Wailmer",
		[388] = "Shinx",
		[389] = "Luxio",
		[390] = "Aron",
		[391] = "Lairon",
		[392] = "Trapinch",
		[393] = "Vibrava",
		[394] = "Feebas",
		[395] = "Bagon",
		[396] = "Shelgon",
		[397] = "Klink",
		[398] = "Klang",
		[399] = "Zorua",
		[400] = "Budew",
		[401] = "Roselia",
		[402] = "Drifloon",
		[403] = "Buneary",
		[404] = "Shroomish",
		[405] = "Shuppet",
		[406] = "Solosis",
		[407] = "Duosion",
		[408] = "Cottonee",
		[409] = "Sandile",
		[410] = "Krokorok",
		[411] = "Yamask",
		[412] = "Joltik",
		[413] = "Ferroseed",
		[414] = "Axew",
		[415] = "Fraxure",
		[416] = "Golett",
		[417] = "Fletchling",
		[418] = "Fletchinder",
		[419] = "Larvesta",
		[420] = "Stunfisk",
	}
	local nameMaxWidth = 0
	for _, name in pairs(fusionIdToName) do
		local nameWidth = Utils.calcWordPixelLength(name) or 0
		if nameWidth > nameMaxWidth then
			nameMaxWidth = nameWidth
		end
	end
	-- Returns a random valid fusion id, different from previousId (optional)
	local function getRandomFusionId(previousId)
		-- Try up to 42 times to get a different random id
		for i=1, 42, 1 do
			local randomId = math.random(#fusionIdToName)
			if randomId ~= previousId then
				return randomId
			end
		end
	end

	-- Executed when the user clicks the "Check for Updates" button while viewing the extension details within the Tracker's UI
	-- Returns [true, downloadUrl] if an update is available (downloadUrl auto opens in browser for user); otherwise returns [false, downloadUrl]
	-- Remove this function if you choose not to implement a version update check for your extension
	function self.checkForUpdates()
		local versionCheckUrl = "https://api.github.com/repos/UTDZac/InfiniteFusion-IronmonExtension/releases/latest"
		local versionResponsePattern = '"tag_name":%s+"%w+(%d+%.%d+)"'
		local downloadUrl = "https://github.com/UTDZac/InfiniteFusion-IronmonExtension/releases/latest"
		local isUpdateAvailable = Utils.checkForVersionUpdate(versionCheckUrl, self.version, versionResponsePattern, nil)
		return isUpdateAvailable, downloadUrl
	end

	-- The fusion overlay remains hidden until this is set to 'true'
	self.isDisplayed = false

	self.currentScreen = ExtConstants.Screens.MainFusion
	local function clearClientGraphics()
		gui.clearGraphics(ExtConstants.imageCanvas)
	end
	local function changeLargeScreen(screen)
		if not screen then return end
		self.prevScreen = self.currentScreen
		self.currentScreen = screen
		clearClientGraphics()
		Program.redraw(true)
	end

	self.viewedFusionIndex = 1
	function self.viewNextFusion()
		for i = self.viewedFusionIndex, (self.viewedFusionIndex + #self.FusionFiles), 1 do
			local nextIndex = (i % #self.FusionFiles) + 1
			if self.FusionFiles[nextIndex] and self.FusionFiles[nextIndex].canDisplay then
				self.viewedFusionIndex = nextIndex
				break
			end
		end
	end

	local natDexToFusionID = {
		[298] = 252, [360] = 253, [252] = 276, [253] = 277, [254] = 278, [255] = 279, [256] = 280, [257] = 281,
		[258] = 282, [259] = 283, [260] = 284, [280] = 285, [281] = 286, [282] = 287, [292] = 289, [352] = 290,
		[374] = 291, [375] = 292, [376] = 293, [303] = 300, [345] = 301, [346] = 302, [347] = 303, [348] = 304,
		[289] = 309, [359] = 310, [355] = 311, [356] = 312, [321] = 314, [299] = 325, [306] = 333, [330] = 334,
		[350] = 335, [373] = 336, [382] = 340, [383] = 341, [384] = 342, [286] = 355, [291] = 356, [354] = 357,
		[380] = 378, [381] = 379, [386] = 380, [385] = 381, [290] = 382, [287] = 385, [288] = 386, [320] = 387,
		[304] = 390, [305] = 391, [328] = 392, [329] = 393, [349] = 394, [371] = 395, [372] = 396, [315] = 401,
		[285] = 404, [353] = 405,
	}
	local idToNatDex = {}
	for nat, id in pairs(RouteData.NatDexToIndex or {}) do
		idToNatDex[id] = nat
	end
	local function getFusionIdFromInternalId(pokemonID)
		local natID = idToNatDex[pokemonID or false] or pokemonID
		if natID < 252 then
			return natID
		else
			return natDexToFusionID[natID] or 0
		end
	end

	-- Returns a table {x,y,w,h} defining image dimensions based on screen size
	local function getImageDimensions()
		local bottomAreaPadding = TeamViewArea.isDisplayed() and Constants.SCREEN.BOTTOM_AREA or Constants.SCREEN.DOWN_GAP
		local widthRatio = client.screenwidth() / (Constants.SCREEN.WIDTH + Constants.SCREEN.RIGHT_GAP)
		local heightRatio = client.screenheight() / (Constants.SCREEN.HEIGHT + bottomAreaPadding)
		local yOffset = heightRatio > 5 and 160 or 0 -- shift downward if fullscreen (ratio > 5)
		return {
			x = math.floor(70 * widthRatio),
			y = math.floor(10 * widthRatio) + yOffset,
			w = math.floor(120 * widthRatio), -- Image is always a square
			h = math.floor(120 * widthRatio),
		}
	end

	local hamburgerIcon = {
		{0,0,0,0,0,0,0,0,0,0,0},
		{0,1,1,1,1,1,1,1,1,1,0},
		{0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0},
		{0,0,1,1,1,1,1,1,1,0,0},
		{0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0},
		{0,1,1,1,1,1,1,1,1,1,0},
		{0,0,0,0,0,0,0,0,0,0,0},
	}

	local function initFusionsWithLeadPokemon(includeEnemy)
		-- First update the left-fusion with the player's Pokémon
		local fusionFile = self.FusionFiles[1]
		local pokemon = Tracker.getPokemon(1, true) or Tracker.getDefaultPokemon()
		local id = getFusionIdFromInternalId(pokemon.pokemonID)
		if fusionIdToName[id] then
			fusionFile:setId(id)
		else
			fusionFile:setId(0)
		end

		-- Then update the right-fusion with the opposing Pokémon (if exists)
		if includeEnemy then
			fusionFile = self.FusionFiles[2]
			pokemon = Battle.getViewedPokemon(false) or Tracker.getDefaultPokemon()
			id = getFusionIdFromInternalId(pokemon.pokemonID)
			if fusionIdToName[id] then
				fusionFile:setId(id)
			else
				fusionFile:setId(0)
			end
		end
	end

	local pausedByExtension = false
	local function openFusionOverlay(includeEnemy)
		self.isDisplayed = true
		-- If fusion is empty or gameover, fill in with lead Pokémon (if that fusion mon exists)
		local fusionFile = self.FusionFiles[1]
		if fusionFile.fusionId == 0 then
			initFusionsWithLeadPokemon(includeEnemy)
		end
		if not Program.GameTimer.isPaused then
			Program.GameTimer:pause()
			pausedByExtension = true
		end
		self.currentScreen = ExtConstants.Screens.MainFusion
	end
	local function closeFusionOverlay()
		self.isDisplayed = false
		self.Buttons.HamburgerMenu.isOpen = false
		if pausedByExtension then
			Program.GameTimer:unpause()
			pausedByExtension = false
		end
		clearClientGraphics()
	end

	local function clearFetchedFusions()
		-- Clear out alternate fusions
		for i = 3, 24, 1 do
			self.FusionFiles[i] = nil
		end
		for _, file in pairs(self.FusionFiles) do
			file:clear()
		end
		self.viewedFusionIndex = 1
		clearClientGraphics()
	end

	local buttonW, buttonH = 78, 16
	local anyButtonClicked = false
	self.Buttons = {
		MainTrackerNameQuickAccess = {
			-- This button is actually invisible, but it's still clickable
			type = Constants.ButtonTypes.NO_BORDER,
			box = { Constants.SCREEN.WIDTH + 36, 5, 50, 10 },
			isVisible = function() return Program.currentScreen == TrackerScreen end,
			onClick = function()
				-- If already showing, then close
				if self.isDisplayed then
					closeFusionOverlay()
				else
					openFusionOverlay()
				end
				Program.redraw(true)
				anyButtonClicked = true
			end,
		},
		HamburgerMenu = {
			type = Constants.ButtonTypes.PIXELIMAGE,
			image = hamburgerIcon,
			iconColors = { ExtConstants.Colors.text },
			box = { 2, 1, 11, 11 },
			isOpen = false,
			isVisible = function() return self.currentScreen == ExtConstants.Screens.MainFusion end,
			onClick = function(this)
				this.isOpen = not this.isOpen
				Program.redraw(true)
				anyButtonClicked = true
			end,
		},
		ClearFusions = {
			type = Constants.ButtonTypes.NO_BORDER,
			getCustomText = function() return ExtConstants.bulletListIcon .. " Clear fusions" end,
			box = { 0, 12, 30, 11 },
			isVisible = function() return self.currentScreen == ExtConstants.Screens.MainFusion and self.Buttons.HamburgerMenu.isOpen end,
			draw = function(this, shadowcolor)
				local x, y = this.box[1], this.box[2]
				Drawing.drawText(x, y, this:getCustomText(), ExtConstants.Colors.text)
			end,
			onClick = function(this)
				self.Buttons.HamburgerMenu.isOpen = false
				clearFetchedFusions()
				Program.redraw(true)
				anyButtonClicked = true
			end,
		},
		FuseBattlers = {
			type = Constants.ButtonTypes.NO_BORDER,
			getCustomText = function() return ExtConstants.bulletListIcon .. " Fuse battlers" end,
			box = { 0, 24, 30, 11 },
			isVisible = function() return self.currentScreen == ExtConstants.Screens.MainFusion and self.Buttons.HamburgerMenu.isOpen end,
			draw = function(this, shadowcolor)
				local x, y = this.box[1], this.box[2]
				Drawing.drawText(x, y, this:getCustomText(), ExtConstants.Colors.text)
			end,
			onClick = function(this)
				self.Buttons.HamburgerMenu.isOpen = false
				initFusionsWithLeadPokemon(true)
				clearClientGraphics()
				Program.redraw(true)
				anyButtonClicked = true
			end,
		},
		ViewOnline = {
			type = Constants.ButtonTypes.NO_BORDER,
			getCustomText = function() return ExtConstants.bulletListIcon .. " View online" end,
			box = { 0, 36, 30, 11 },
			isVisible = function() return self.currentScreen == ExtConstants.Screens.MainFusion and self.Buttons.HamburgerMenu.isOpen end,
			draw = function(this, shadowcolor)
				local x, y = this.box[1], this.box[2]
				Drawing.drawText(x, y, this:getCustomText(), ExtConstants.Colors.text)
			end,
			onClick = function(this)
				self.Buttons.HamburgerMenu.isOpen = false
				Utils.openBrowserWindow(ExtConstants.onlineUrl)
				anyButtonClicked = true
			end,
		},
		FusionName = {
			type = Constants.ButtonTypes.NO_BORDER,
			box = { 30, 20, Constants.SCREEN.WIDTH - 30 - 30, Constants.SCREEN.HEIGHT - 30 - 20 }, -- Not used
			isVisible = function() return self.currentScreen == ExtConstants.Screens.MainFusion end,
			draw = function(this, shadowcolor)
				local fusionToDraw = self.FusionFiles[self.viewedFusionIndex]
				if not fusionToDraw then return end
				local centerX = Utils.getCenteredTextX(fusionToDraw.fusionName, Constants.SCREEN.WIDTH) - 1
				local color
				if fusionToDraw.fusionName == ExtConstants.unknownName then
					color = ExtConstants.Colors.text
				elseif fusionToDraw.canDisplay then
					color = ExtConstants.Colors.success
				else
					color = ExtConstants.Colors.fail
				end
				Drawing.drawText(centerX, 0, fusionToDraw.fusionName, color)
			end,
		},
		FusionImage = {
			type = Constants.ButtonTypes.NO_BORDER,
			box = { 60, 20, Constants.SCREEN.WIDTH - 60 * 2, 90 },
			isVisible = function() return self.currentScreen == ExtConstants.Screens.MainFusion end,
			draw = function(this, shadowcolor)
				local fusionToDraw = self.FusionFiles[self.viewedFusionIndex]
				if not fusionToDraw then return end

				-- Required to refresh the image canvas
				gui.drawPixel(1, 1, ExtConstants.Colors.background, ExtConstants.imageCanvas)

				if fusionToDraw.canDisplay and FileManager.fileExists(fusionToDraw.filepath) then
					local imgDim = getImageDimensions()
					gui.drawImage(fusionToDraw.filepath, imgDim.x, imgDim.y, imgDim.w, imgDim.h, false, ExtConstants.imageCanvas)
				elseif fusionToDraw.isFetched then
					local missingno = FileManager.buildImagePath(FileManager.Folders.Icons, "missingno", ".png")
					gui.drawImage(missingno, 112, 45)
				end
			end,
			onClick = function()
				self.Buttons.HamburgerMenu.isOpen = false
				self.viewNextFusion()
				Program.redraw(true)
				anyButtonClicked = true
			end,
		},
		LeftPokemon = {
			fusionFileIndex = 1,
			type = Constants.ButtonTypes.ICON_BORDER,
			image = Constants.PixelImages.POKEBALL,
			iconColors = TrackerScreen.PokeBalls.ColorList,
			getText = function(this) return fusionIdToName[this.id or 0] or ExtConstants.unknownName end,
			box = { 2, Constants.SCREEN.HEIGHT - buttonH - 3, buttonW, buttonH },
			isVisible = function() return self.currentScreen == ExtConstants.Screens.MainFusion end,
			updateSelf = function(this)
				this.id = self.FusionFiles[this.fusionFileIndex].fusionId
			end,
			onClick = function(this)
				self.Buttons.HamburgerMenu.isOpen = false
				self.lookupIndex = this.fusionFileIndex
				self.buildPagedButtons()
				changeLargeScreen(ExtConstants.Screens.PokemonLookup)
				LogSearchScreen.refreshDropDowns()
				LogSearchScreen.resetSearchSortFilter()
				Program.changeScreenView(LogSearchScreen)
				anyButtonClicked = true
			end,
		},
		RightPokemon = {
			fusionFileIndex = 2,
			type = Constants.ButtonTypes.ICON_BORDER,
			image = Constants.PixelImages.POKEBALL,
			iconColors = TrackerScreen.PokeBalls.ColorList,
			getText = function(this) return fusionIdToName[this.id or 0] or ExtConstants.unknownName end,
			box = { Constants.SCREEN.WIDTH - buttonW - 3, Constants.SCREEN.HEIGHT - buttonH - 3, buttonW, buttonH },
			isVisible = function() return self.currentScreen == ExtConstants.Screens.MainFusion end,
			updateSelf = function(this)
				this.id = self.FusionFiles[this.fusionFileIndex].fusionId
			end,
			onClick = function(this)
				self.Buttons.HamburgerMenu.isOpen = false
				self.lookupIndex = this.fusionFileIndex
				self.buildPagedButtons()
				changeLargeScreen(ExtConstants.Screens.PokemonLookup)
				LogSearchScreen.refreshDropDowns()
				LogSearchScreen.resetSearchSortFilter()
				Program.changeScreenView(LogSearchScreen)
				anyButtonClicked = true
			end,
		},
		LeftRandomDice = {
			fusionFileIndex = 1,
			type = Constants.ButtonTypes.PIXELIMAGE,
			image = Constants.PixelImages.DICE,
			iconColors = { ExtConstants.Colors.text },
			box = { 2, Constants.SCREEN.HEIGHT - (buttonH * 2) - 3, 14, 14 },
			isVisible = function() return self.currentScreen == ExtConstants.Screens.MainFusion end,
			onClick = function(this)
				self.Buttons.HamburgerMenu.isOpen = false
				local fusionFile = self.FusionFiles[this.fusionFileIndex]
				local id = getRandomFusionId(fusionFile.fusionId)
				fusionFile:setId(id)
				self.refreshButtons()
				Program.redraw(true)
				anyButtonClicked = true
			end,
		},
		RightRandomDice = {
			fusionFileIndex = 2,
			type = Constants.ButtonTypes.PIXELIMAGE,
			image = Constants.PixelImages.DICE,
			iconColors = { ExtConstants.Colors.text },
			box = { Constants.SCREEN.WIDTH - 15, Constants.SCREEN.HEIGHT - (buttonH * 2) - 3, 14, 14 },
			isVisible = function() return self.currentScreen == ExtConstants.Screens.MainFusion end,
			onClick = function(this)
				self.Buttons.HamburgerMenu.isOpen = false
				local fusionFile = self.FusionFiles[this.fusionFileIndex]
				local id = getRandomFusionId(fusionFile.fusionId)
				fusionFile:setId(id)
				self.refreshButtons()
				Program.redraw(true)
				anyButtonClicked = true
			end,
		},
		BothRandomDice = {
			type = Constants.ButtonTypes.PIXELIMAGE,
			image = Constants.PixelImages.DICE,
			iconColors = { ExtConstants.Colors.text },
			box = { (Constants.SCREEN.WIDTH - 14) / 2 - 17, Constants.SCREEN.HEIGHT - 18, 14, 14 },
			clickableArea = { (Constants.SCREEN.WIDTH - 14) / 2 - 17, Constants.SCREEN.HEIGHT - 18, 50, 14 },
			isVisible = function() return self.currentScreen == ExtConstants.Screens.MainFusion end,
			draw = function(this, shadowcolor)
				local color = ExtConstants.Colors.text
				local x, y, w, h = this.box[1], this.box[2], this.box[3], this.box[4]
				Drawing.drawText(x + w, y + 2, "Random >", color, shadowcolor)
				Drawing.drawText(x - 12, y + 2, "<", color, shadowcolor)
			end,
			onClick = function(this)
				self.Buttons.HamburgerMenu.isOpen = false
				for _, fusionFile in pairs(self.FusionFiles) do
					local id = getRandomFusionId(fusionFile.fusionId)
					fusionFile:setId(id)
				end
				self.refreshButtons()
				Program.redraw(true)
				anyButtonClicked = true
			end,
		},
		CurrentPage = {
			type = Constants.ButtonTypes.NO_BORDER,
			getCustomText = function() return self.Pager:getPageText() end,
			box = { 96, Constants.SCREEN.HEIGHT - buttonH + 3, 50, 10, },
			isVisible = function() return self.Pager:isVisible() and self.currentScreen == ExtConstants.Screens.PokemonLookup end,
			draw = function(this, shadowcolor)
				local x, y = this.box[1], this.box[2]
				Drawing.drawText(x + 1, y, this:getCustomText(), ExtConstants.Colors.text, shadowcolor)
			end,
		},
		PrevPage = {
			type = Constants.ButtonTypes.PIXELIMAGE,
			image = Constants.PixelImages.LEFT_ARROW,
			iconColors = { ExtConstants.Colors.text },
			box = { 84, Constants.SCREEN.HEIGHT - buttonH + 4, 10, 10, },
			isVisible = function() return self.Pager:isVisible() and self.currentScreen == ExtConstants.Screens.PokemonLookup end,
			onClick = function()
				self.Pager:prevPage()
				anyButtonClicked = true
			end,
		},
		NextPage = {
			type = Constants.ButtonTypes.PIXELIMAGE,
			image = Constants.PixelImages.RIGHT_ARROW,
			iconColors = { ExtConstants.Colors.text },
			box = { 147, Constants.SCREEN.HEIGHT - buttonH + 4, 10, 10, },
			isVisible = function() return self.Pager:isVisible() and self.currentScreen == ExtConstants.Screens.PokemonLookup end,
			onClick = function()
				self.Pager:nextPage()
				anyButtonClicked = true
			end,
		},
		XIcon = {
			type = Constants.ButtonTypes.PIXELIMAGE,
			image = Constants.PixelImages.CLOSE,
			iconColors = { ExtConstants.Colors.text },
			box = { Constants.SCREEN.WIDTH - 11, 2, 10, 10 },
			isVisible = function() return self.currentScreen == ExtConstants.Screens.MainFusion end,
			onClick = function(this)
				closeFusionOverlay()
				if LogOverlay.isGameOver then
					Program.changeScreenView(GameOverScreen)
				else
					Program.changeScreenView(TrackerScreen)
				end
				anyButtonClicked = true
			end,
		},
		Back = {
			type = Constants.ButtonTypes.PIXELIMAGE,
			image = Constants.PixelImages.BACK_ARROW,
			iconColors = { ExtConstants.Colors.text },
			clickableArea = {Constants.SCREEN.WIDTH - 15, Constants.SCREEN.HEIGHT - 12, 11 + 4, 11 },
			box = { Constants.SCREEN.WIDTH - 15, Constants.SCREEN.HEIGHT - 12, 11, 11 },
			isVisible = function() return self.currentScreen == ExtConstants.Screens.PokemonLookup end,
			onClick = function(this)
				changeLargeScreen(self.prevScreen or ExtConstants.Screens.MainFusion)
				Program.changeScreenView(TrackerScreen)
				self.prevScreen = nil
				anyButtonClicked = true
			end,
		},
	}
	self.Pager = {
		Buttons = {},
		currentPage = 0,
		totalPages = 0,
		isVisible = function(this) return this.totalPages > 1 end,
		defaultSort = function(a, b) return a.name < b.name end,
		realignGrid = function(this)
			local x, y = 3, 3
			local colSpacer = 10
			local rowSpacer = 1
			local maxWidth = Constants.SCREEN.WIDTH - 3
			local maxHeight = self.Buttons.CurrentPage.box[2] - 0

			table.sort(this.Buttons, this.defaultSort)
			this.totalPages = Utils.gridAlign(this.Buttons, x, y, colSpacer, rowSpacer, true, maxWidth, maxHeight)
			this.currentPage = 1

			self.refreshButtons()
		end,
		getPageText = function(this)
			if not self.Pager:isVisible() then return Resources.AllScreens.Page end
			return string.format("%s %s/%s", Resources.AllScreens.Page, this.currentPage, this.totalPages)
		end,
		prevPage = function(this)
			if not self.Pager:isVisible() then return end
			this.currentPage = ((this.currentPage - 2 + this.totalPages) % this.totalPages) + 1
			Program.redraw(true)
		end,
		nextPage = function(this)
			if not self.Pager:isVisible() then return end
			this.currentPage = (this.currentPage % this.totalPages) + 1
			Program.redraw(true)
		end,
	}

	function self.refreshButtons()
		for _, button in pairs(self.Buttons) do
			if type(button.updateSelf) == "function" then
				button:updateSelf()
			end
		end
		for _, button in pairs(self.Pager.Buttons) do
			if type(button.updateSelf) == "function" then
				button:updateSelf()
			end
		end
	end
	function self.buildPagedButtons()
		self.Pager.Buttons = {}
		for id, name in pairs(fusionIdToName) do
			-- local width = Utils.calcWordPixelLength(name or ExtConstants.unknownName)
			local currentlySelected = (id == self.FusionFiles[self.lookupIndex].fusionId)
			local button = {
				type = Constants.ButtonTypes.NO_BORDER,
				id = id, -- fusion id
				name = name, -- acceptable fusion name
				dimensions = { width = nameMaxWidth, height = 12, },
				isSelected = currentlySelected,
				isVisible = function(this) return self.Pager.currentPage == this.pageVisible and self.currentScreen == ExtConstants.Screens.PokemonLookup end,
				-- updateSelf = function(this)
				-- end,
				includeInGrid = function(this)
					-- If no search text entered, show all results
					if LogSearchScreen.searchText == "" then
						return true
					else
						return Utils.containsText(this.name, LogSearchScreen.searchText, true)
					end
				end,
				draw = function(this, shadowcolor)
					if not this.box or not this.box[1] then return end
					local x, y = this.box[1], this.box[2]
					Drawing.drawText(x, y, this.name, ExtConstants.Colors.text)
					if this.isSelected then
						local w = Utils.calcWordPixelLength(this.name)
						local h = this.box[4] - 1
						Drawing.drawSelectionIndicators(x, y + 1, w + 3, h - 2, ExtConstants.Colors.highlight, 1, 4, 1)
					end
				end,
				onClick = function(this)
					self.FusionFiles[self.lookupIndex]:setId(this.id)
					self.refreshButtons()
					changeLargeScreen(ExtConstants.Screens.MainFusion)
					Program.changeScreenView(TrackerScreen)
				end,
			}
			table.insert(self.Pager.Buttons, button)
		end
		self.Pager:realignGrid()
	end

	self.FusionFiles = {
		{
			fusePairIndex = 2,
			filepath = FileManager.getCustomFolderPath() .. ExtConstants.fusionFilename1,
			fusionId = 0,
			fusionName = ExtConstants.unknownName,
			isFetched = false,
			canDisplay = false,
			alternates = {},
			setId = function(this, id)
				this.fusionId = id
				this.isFetched = false
				this.canDisplay = false
			end,
			clear = function(this)
				this:setId(0)
				this.fusionName = ExtConstants.unknownName
			end,
		},
		{
			fusePairIndex = 1,
			filepath = FileManager.getCustomFolderPath() .. ExtConstants.fusionFilename2,
			fusionId = 0,
			fusionName = ExtConstants.unknownName,
			isFetched = false,
			canDisplay = false,
			alternates = {},
			setId = function(this, id)
				this.fusionId = id
				this.isFetched = false
				this.canDisplay = false
			end,
			clear = function(this)
				this:setId(0)
				this.fusionName = ExtConstants.unknownName
			end,
		},
	}

	local function dualOSExecute(command1, command2)
		local fetchMsg = "Fetching fusion images..."
		local outFile = FileManager.prependDir(FileManager.Files.OSEXECUTE_OUTPUT)
		local commandsWithOutput = string.format('echo %s && %s >"%s" && %s >>"%s"', fetchMsg, command1, outFile, command2, outFile) -- >> appends
		local result = os.execute(commandsWithOutput)
		local success = (result == true or result == 0) -- 0 = success in some cases
		if not success then
			return success, {}
		end
		return success, FileManager.readLinesFromFile(outFile)
	end

	local function tryFetchFusionsOffline(fusionFile1, fusionFile2)
		local f1, f2 = fusionFile1, fusionFile2
		f1.filepath = ExtConstants.offlineFolder .. string.format(ExtConstants.Formats.fusionFile, f1.fusionId, f2.fusionId)
		f2.filepath = ExtConstants.offlineFolder .. string.format(ExtConstants.Formats.fusionFile, f2.fusionId, f1.fusionId) -- Reverse the order to get the other fusion
		f1.isFetched = true
		f2.isFetched = true
		f1.canDisplay = FileManager.fileExists(f1.filepath)
		f2.canDisplay = f1.fusionId ~= f2.fusionId and FileManager.fileExists(f2.filepath)

		local createFusionFile = function(referenceFile, letter, path)
			return {
				filepath = path,
				fusionId = referenceFile.fusionId,
				fusionName = string.format("%s [%s]", referenceFile.fusionName, letter),
				isFetched = true,
				canDisplay = true,
				setId = function(this, id)
					this.fusionId = id
					this.isFetched = false
					this.canDisplay = false
				end,
				clear = function(this)
					this:setId(0)
					this.fusionName = ExtConstants.unknownName
				end,
			}
		end

		-- Check for alternate fusion images
		for letter in string.gmatch("abcdefghijklmnopqrstuvwxyz", ".") do
			local foundAny = false
			if f1.canDisplay then
				local altpath = f1.filepath:gsub(".png", letter .. ".png")
				if FileManager.fileExists(altpath) then
					foundAny = true
					self.FusionFiles[#self.FusionFiles + 1] = createFusionFile(f1, letter, altpath)
				end
			end
			if f2.canDisplay then
				local altpath = f2.filepath:gsub(".png", letter .. ".png")
				if FileManager.fileExists(altpath) then
					foundAny = true
					self.FusionFiles[#self.FusionFiles + 1] = createFusionFile(f2, letter, altpath)
				end
			end
			if not foundAny then
				break
			end
		end

		return true
	end

	local function tryFetchFusionsOnline(fusionFile1, fusionFile2)
		local f1, f2 = fusionFile1, fusionFile2
		-- Get both fusion images and http status codes
		local url1 = string.format(ExtConstants.Formats.fusionUrl, f1.fusionId, f2.fusionId)
		local url2 = string.format(ExtConstants.Formats.fusionUrl, f2.fusionId, f1.fusionId) -- Reverse the order to get the other fusion
		local command1 = string.format(ExtConstants.Formats.curlCommand1, f1.filepath, url1)
		local command2 = string.format(ExtConstants.Formats.curlCommand2, f2.filepath, url2)
		local success, output = dualOSExecute(command1, command2)

		output = Utils.split(table.concat(output or {}) or "", ",", true)
		local statusCode1 = output[1] or "404"
		local statusCode2 = output[2] or "404"
		f1.isFetched = true
		f2.isFetched = true
		f1.canDisplay = statusCode1 == "200"
		f2.canDisplay = statusCode2 == "200"

		return success
	end

	local function buildAlternateFusionButtons()
		local altPrefix = "Alternate"

		-- Clear out existing buttons
		local btnKeysToRemove = {}
		for key, _ in pairs(self.Buttons) do
			if string.find(tostring(key), altPrefix, 1, true) then
				table.insert(btnKeysToRemove, key)
			end
		end
		for _, key in pairs(btnKeysToRemove) do
			self.Buttons[key] = nil
		end

		if #self.FusionFiles <= 1 then
			return
		end

		local altButtonsTotalHeight = #self.FusionFiles * (Constants.SCREEN.LINESPACING + 2)
		local offsetY = math.floor((Constants.SCREEN.HEIGHT - 20 - altButtonsTotalHeight) / 2)
		local createAltBtn = function(text, fusionFileIndex)
			local btn = {
				type = Constants.ButtonTypes.FULL_BORDER,
				getText = function() return text end,
				box = { 2, offsetY, Utils.calcWordPixelLength(text) + 5, Constants.SCREEN.LINESPACING},
				textColor = "Default text",
				isVisible = function()
					local canShowFusion = self.FusionFiles[fusionFileIndex] and self.FusionFiles[fusionFileIndex].canDisplay
					local onCorrectScreen = self.currentScreen == ExtConstants.Screens.MainFusion and not self.Buttons.HamburgerMenu.isOpen
					return canShowFusion and onCorrectScreen
				end,
				onClick = function()
					self.viewedFusionIndex = fusionFileIndex
					Program.redraw(true)
				end,
			}
			offsetY = offsetY + btn.box[4] + 2
			return btn
		end

		for i, fusionFile in ipairs(self.FusionFiles) do
			local index = i > 2 and (i - 2) or i
			local altName = (i > 2 and "A" or "F") .. index
			if fusionFile.canDisplay then
				self.Buttons[altPrefix .. altName] = createAltBtn(altName, i)
			end
		end
	end

	local function tryFetchFusions()
		local f1, f2 = self.FusionFiles[1], self.FusionFiles[2]
		-- Don't fetch fusions if both have already been fetched
		if f1.isFetched and f2.isFetched then
			return true
		end
		-- Don't fetch fusions if either ID is invalid
		local id1 = f1.fusionId
		local id2 = f2.fusionId
		if not fusionIdToName[id1] or not fusionIdToName[id2] then
			return false
		end

		-- First clear out old fetched fusions
		clearFetchedFusions()
		f1.fusionId = id1
		f2.fusionId = id2

		local pokemonName1 = fusionIdToName[id1] or ExtConstants.unknownName
		local pokemonName2 = fusionIdToName[id2] or ExtConstants.unknownName
		f1.fusionName = string.format(ExtConstants.Formats.fusionName, pokemonName1, pokemonName2, id1, id2)
		f2.fusionName = string.format(ExtConstants.Formats.fusionName, pokemonName2, pokemonName1, id2, id1)

		local success = false
		if ExtConstants.offlineAvailable then
			success = tryFetchFusionsOffline(f1, f2)
		else
			success = tryFetchFusionsOnline(f1, f2)
		end

		if success then
			buildAlternateFusionButtons()
		end

		-- If the first result is missing but the second is available, show that first
		if not f1.canDisplay and f2.canDisplay then
			self.viewedFusionIndex = 2
		end

		return success
	end

	local prevSearchText = ""
	local function drawScreen()
		if not self.isDisplayed then return end

		if self.currentScreen == ExtConstants.Screens.MainFusion then
			tryFetchFusions()
		elseif self.currentScreen == ExtConstants.Screens.PokemonLookup then
			if LogSearchScreen.searchText ~= prevSearchText then
				prevSearchText = LogSearchScreen.searchText
				self.Pager:realignGrid()
			end
			-- Remove the "Search the log" header, replace with custom
			gui.drawRectangle(Constants.SCREEN.WIDTH + Constants.SCREEN.MARGIN, 0, Constants.SCREEN.RIGHT_GAP, 11, Theme.COLORS["Main background"], Theme.COLORS["Main background"])
			local headerText = Utils.toUpperUTF8(self.name)
			local headerShadow = Utils.calcShadowColor(Theme.COLORS["Main background"])
			Drawing.drawText(Constants.SCREEN.WIDTH + Constants.SCREEN.MARGIN, Constants.SCREEN.MARGIN - 2, headerText, Theme.COLORS["Header text"], headerShadow)
		end

		-- Draw slightly transparent background
		gui.drawRectangle(0, 0, Constants.SCREEN.WIDTH - 1, Constants.SCREEN.HEIGHT, ExtConstants.Colors.background, ExtConstants.Colors.background)

		-- Draw all buttons (if they're visible)
		for _, button in pairs(self.Buttons) do
			Drawing.drawButton(button)
		end
		for _, button in pairs(self.Pager.Buttons) do
			Drawing.drawButton(button)
		end
	end

	-- Executed only once: when the Tracker finishes starting up and after it loads all other required files and code
	function self.startup()
		if not Main.IsOnBizhawk() then return end
		self.currentScreen = ExtConstants.Screens.MainFusion
		clearFetchedFusions()
	end

	-- Executed only once: when the extension is disabled by the user, necessary to undo any customizations, if able
	function self.unload()
		if not Main.IsOnBizhawk() then return end
		clearClientGraphics()
	end

	-- Executed once every 30 frames, after most data from game memory is read in
	function self.afterProgramDataUpdate()
		if not Main.IsOnBizhawk() then return end
		if LogOverlay.isGameOver and not self.isDisplayed then
			initFusionsWithLeadPokemon(true)
		end
	end

	-- Executed once every 30 frames or after any redraw event is scheduled (i.e. most button presses)
	function self.afterRedraw()
		if not Main.IsOnBizhawk() then return end
		if LogOverlay.isDisplayed and self.isDisplayed then
			closeFusionOverlay()
		end
		if not self.isDisplayed then
			return
		end

		self.refreshButtons()
		drawScreen()
	end

	-- [Bizhawk only] Executed each frame (60 frames per second)
	-- CAUTION: Avoid unnecessary calculations here, as this can easily affect performance.
	local prevMouseInput = {}
	function self.inputCheckBizhawk()
		-- Newer Tracker prevents mouse clicks while form is open
		if not Main.IsOnBizhawk() or Input.allowMouse == false then -- Must check on exactly equal to false (nil means missing and is okay)
			return
		end

		local mouseInput = input.getmouse() -- lowercase 'input' pulls directly from Bizhawk API
		-- Check only if pressed when it wasn't pressed before
		if mouseInput["Left"] and not prevMouseInput["Left"] then
			local xmouse = mouseInput["X"]
			local ymouse = mouseInput["Y"] + Constants.SCREEN.UP_GAP
			if self.isDisplayed then
				Input.checkButtonsClicked(xmouse, ymouse, self.Buttons)
				if not anyButtonClicked then
					Input.checkButtonsClicked(xmouse, ymouse, self.Pager.Buttons)
				end
			else
				-- Don't click any screen buttons if this extension isn't being displayed, but allow quick access
				Input.checkButtonsClicked(xmouse, ymouse, { self.Buttons.MainTrackerNameQuickAccess })
			end
		end
		prevMouseInput = mouseInput
		if anyButtonClicked then
			anyButtonClicked = false
		end
	end

	-- Executed before a button's onClick() is processed, and only once per click per button
	-- Param: button: the button object being clicked
	function self.onButtonClicked(button)
		if not Main.IsOnBizhawk() then return end
		if button == GameOverScreen.Buttons.PokemonIcon then
			if self.isDisplayed then
				initFusionsWithLeadPokemon(true)
				changeLargeScreen(ExtConstants.Screens.MainFusion)
			else
				openFusionOverlay()
			end
		end
	end

	return self
end
return InfiniteFusion