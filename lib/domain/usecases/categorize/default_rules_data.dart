/// (payeeContains, targetCategoryName) pairs for default auto-categorization.
///
/// payeeContains is matched against the NORMALIZED (uppercase) payee name.
/// Category names must match exactly what CategorySeeder creates.
const defaultMerchantMappings = <(String, String)>[
  // -------------------------------------------------------------------------
  // Groceries (parent category — no subcategories)
  // -------------------------------------------------------------------------
  ('KROGER', 'Groceries'),
  ('SAFEWAY', 'Groceries'),
  ('PUBLIX', 'Groceries'),
  ('HEB', 'Groceries'),
  ('H-E-B', 'Groceries'),
  ('ALDI', 'Groceries'),
  ('TRADER JOE', 'Groceries'),
  ('WHOLE FOODS', 'Groceries'),
  ('SPROUTS', 'Groceries'),
  ('WEGMANS', 'Groceries'),
  ('GIANT', 'Groceries'),
  ('FOOD LION', 'Groceries'),
  ('HARRIS TEETER', 'Groceries'),
  ('MEIJER', 'Groceries'),
  ('LIDL', 'Groceries'),
  ('WINCO', 'Groceries'),
  ('PIGGLY WIGGLY', 'Groceries'),
  ('STOP & SHOP', 'Groceries'),
  ('HANNAFORD', 'Groceries'),
  ('FOOD4LESS', 'Groceries'),
  ('GROCERY OUTLET', 'Groceries'),
  ('MARKET BASKET', 'Groceries'),
  ('SAVE A LOT', 'Groceries'),
  ('WINN DIXIE', 'Groceries'),
  ('INGLES', 'Groceries'),
  ('FRESH MARKET', 'Groceries'),
  ('NATURAL GROCERS', 'Groceries'),

  // -------------------------------------------------------------------------
  // Dining → Coffee Shops
  // -------------------------------------------------------------------------
  ('STARBUCKS', 'Coffee Shops'),
  ('DUNKIN', 'Coffee Shops'),
  ('PEET', 'Coffee Shops'),
  ('DUTCH BROS', 'Coffee Shops'),
  ('CARIBOU COFFEE', 'Coffee Shops'),
  ('TIM HORTON', 'Coffee Shops'),
  ('PHILZ', 'Coffee Shops'),
  ('BLUE BOTTLE', 'Coffee Shops'),

  // -------------------------------------------------------------------------
  // Dining → Fast Food
  // -------------------------------------------------------------------------
  ('MCDONALD', 'Fast Food'),
  ('CHICK-FIL-A', 'Fast Food'),
  ('TACO BELL', 'Fast Food'),
  ('BURGER KING', 'Fast Food'),
  ('WENDY', 'Fast Food'),
  ('SUBWAY', 'Fast Food'),
  ('CHIPOTLE', 'Fast Food'),
  ('POPEYE', 'Fast Food'),
  ('FIVE GUYS', 'Fast Food'),
  ('JACK IN THE BOX', 'Fast Food'),
  ('SONIC DRIVE', 'Fast Food'),
  ('ARBY', 'Fast Food'),
  ('PANDA EXPRESS', 'Fast Food'),
  ('WHATABURGER', 'Fast Food'),
  ('IN-N-OUT', 'Fast Food'),
  ('RAISING CANE', 'Fast Food'),
  ('JERSEY MIKE', 'Fast Food'),
  ('JIMMY JOHN', 'Fast Food'),
  ('FIREHOUSE SUBS', 'Fast Food'),
  ('CULVER', 'Fast Food'),
  ('ZAXBY', 'Fast Food'),
  ('WINGSTOP', 'Fast Food'),
  ('LITTLE CAESARS', 'Fast Food'),
  ('KFC', 'Fast Food'),

  // -------------------------------------------------------------------------
  // Dining → Restaurants
  // -------------------------------------------------------------------------
  ('PANERA', 'Restaurants'),
  ('DOMINO', 'Restaurants'),
  ('PIZZA HUT', 'Restaurants'),
  ('OLIVE GARDEN', 'Restaurants'),
  ('APPLEBEE', 'Restaurants'),
  ('CHILI', 'Restaurants'),
  ('OUTBACK', 'Restaurants'),
  ('CRACKER BARREL', 'Restaurants'),
  ('RED LOBSTER', 'Restaurants'),
  ('TEXAS ROADHOUSE', 'Restaurants'),
  ('IHOP', 'Restaurants'),
  ('DENNY', 'Restaurants'),
  ('WAFFLE HOUSE', 'Restaurants'),
  ('CHEESECAKE FACTORY', 'Restaurants'),
  ('BUFFALO WILD WINGS', 'Restaurants'),
  ('GOLDEN CORRAL', 'Restaurants'),
  ('BOB EVANS', 'Restaurants'),
  ('RED ROBIN', 'Restaurants'),
  ('LONGHORN STEAK', 'Restaurants'),
  ('RUTH CHRIS', 'Restaurants'),
  ('BENIHANA', 'Restaurants'),
  ('CHEDDAR', 'Restaurants'),
  ('NOODLES & COMPANY', 'Restaurants'),

  // -------------------------------------------------------------------------
  // Dining → Delivery
  // -------------------------------------------------------------------------
  ('DOORDASH', 'Delivery'),
  ('GRUBHUB', 'Delivery'),
  ('UBER EATS', 'Delivery'),
  ('POSTMATES', 'Delivery'),
  ('INSTACART', 'Delivery'),
  ('SEAMLESS', 'Delivery'),

  // -------------------------------------------------------------------------
  // Transportation → Gas
  // -------------------------------------------------------------------------
  ('SHELL', 'Gas'),
  ('EXXON', 'Gas'),
  ('CHEVRON', 'Gas'),
  ('SUNOCO', 'Gas'),
  ('WAWA', 'Gas'),
  ('SHEETZ', 'Gas'),
  ('RACETRAC', 'Gas'),
  ('MARATHON', 'Gas'),
  ('CIRCLE K', 'Gas'),
  ('CASEY', 'Gas'),
  ('QUIKTRIP', 'Gas'),
  ('PILOT', 'Gas'),
  ('FLYING J', 'Gas'),
  ('LOVES TRAVEL', 'Gas'),
  ("LOVE'S TRAVEL", 'Gas'),
  ('VALERO', 'Gas'),
  ('CITGO', 'Gas'),
  ('PHILLIPS 66', 'Gas'),
  ('CONOCO', 'Gas'),
  ('MURPHY', 'Gas'),
  ('SPEEDWAY', 'Gas'),
  ('KWIK TRIP', 'Gas'),
  ('BUCCEE', 'Gas'),
  ('THORNTON', 'Gas'),

  // -------------------------------------------------------------------------
  // Transportation → Public Transit
  // -------------------------------------------------------------------------
  ('WMATA', 'Public Transit'),
  ('MTA', 'Public Transit'),
  ('CTA', 'Public Transit'),
  ('BART', 'Public Transit'),
  ('LYFT', 'Public Transit'),

  // -------------------------------------------------------------------------
  // Transportation → Parking
  // -------------------------------------------------------------------------
  ('PARKWHIZ', 'Parking'),
  ('SPOTHERO', 'Parking'),
  ('LAZ PARKING', 'Parking'),
  ('PARK MOBILE', 'Parking'),

  // -------------------------------------------------------------------------
  // Transportation → Auto Maintenance
  // -------------------------------------------------------------------------
  ('JIFFY LUBE', 'Auto Maintenance'),
  ('VALVOLINE', 'Auto Maintenance'),
  ('FIRESTONE', 'Auto Maintenance'),
  ('AUTOZONE', 'Auto Maintenance'),
  ('PEP BOYS', 'Auto Maintenance'),
  ("O'REILLY", 'Auto Maintenance'),
  ('ADVANCE AUTO', 'Auto Maintenance'),
  ('NAPA AUTO', 'Auto Maintenance'),
  ('MIDAS', 'Auto Maintenance'),
  ('GOODYEAR', 'Auto Maintenance'),
  ('DISCOUNT TIRE', 'Auto Maintenance'),
  ('MAACO', 'Auto Maintenance'),
  ('MEINEKE', 'Auto Maintenance'),
  ('SAFELITE', 'Auto Maintenance'),

  // -------------------------------------------------------------------------
  // Entertainment → Subscriptions
  // -------------------------------------------------------------------------
  ('NETFLIX', 'Subscriptions'),
  ('HULU', 'Subscriptions'),
  ('DISNEY+', 'Subscriptions'),
  ('DISNEY PLUS', 'Subscriptions'),
  ('SPOTIFY', 'Subscriptions'),
  ('HBO', 'Subscriptions'),
  ('PARAMOUNT+', 'Subscriptions'),
  ('PARAMOUNT PLUS', 'Subscriptions'),
  ('PEACOCK', 'Subscriptions'),
  ('YOUTUBE PREM', 'Subscriptions'),
  ('APPLE MUSIC', 'Subscriptions'),
  ('APPLE TV', 'Subscriptions'),
  ('ADOBE', 'Subscriptions'),
  ('MICROSOFT 365', 'Subscriptions'),
  ('DROPBOX', 'Subscriptions'),
  ('ICLOUD', 'Subscriptions'),
  ('NOTION', 'Subscriptions'),
  ('CRUNCHYROLL', 'Subscriptions'),
  ('AUDIBLE', 'Subscriptions'),
  ('KINDLE UNLIMITED', 'Subscriptions'),
  ('SIRIUS', 'Subscriptions'),
  ('PANDORA', 'Subscriptions'),
  ('TIDAL', 'Subscriptions'),
  ('AMAZON PRIME', 'Subscriptions'),

  // -------------------------------------------------------------------------
  // Entertainment → Games
  // -------------------------------------------------------------------------
  ('STEAM', 'Games'),
  ('PLAYSTATION', 'Games'),
  ('XBOX', 'Games'),
  ('NINTENDO', 'Games'),
  ('EPIC GAMES', 'Games'),

  // -------------------------------------------------------------------------
  // Entertainment → Events
  // -------------------------------------------------------------------------
  ('TICKETMASTER', 'Events'),
  ('STUBHUB', 'Events'),
  ('VIVID SEATS', 'Events'),
  ('SEATGEEK', 'Events'),
  ('EVENTBRITE', 'Events'),
  ('FANDANGO', 'Events'),
  ('AMC THEATRES', 'Events'),
  ('REGAL CINEMA', 'Events'),
  ('CINEMARK', 'Events'),

  // -------------------------------------------------------------------------
  // Healthcare → Pharmacy
  // -------------------------------------------------------------------------
  ('CVS', 'Pharmacy'),
  ('WALGREENS', 'Pharmacy'),
  ('RITE AID', 'Pharmacy'),

  // -------------------------------------------------------------------------
  // Personal Care → Gym
  // -------------------------------------------------------------------------
  ('PLANET FITNESS', 'Gym'),
  ('LA FITNESS', 'Gym'),
  ('ORANGETHEORY', 'Gym'),
  ('ANYTIME FITNESS', 'Gym'),
  ('EQUINOX', 'Gym'),
  ('YMCA', 'Gym'),
  ('GOLD GYM', 'Gym'),
  ('CRUNCH FITNESS', 'Gym'),
  ('LIFETIME FITNESS', 'Gym'),
  ('CROSSFIT', 'Gym'),

  // -------------------------------------------------------------------------
  // Personal Care → Haircuts
  // -------------------------------------------------------------------------
  ('GREAT CLIPS', 'Haircuts'),
  ('SUPERCUTS', 'Haircuts'),
  ('SPORTS CLIPS', 'Haircuts'),

  // -------------------------------------------------------------------------
  // Personal Care → Cosmetics
  // -------------------------------------------------------------------------
  ('ULTA', 'Cosmetics'),
  ('SEPHORA', 'Cosmetics'),
  ('BATH & BODY', 'Cosmetics'),
  ('SALLY BEAUTY', 'Cosmetics'),

  // -------------------------------------------------------------------------
  // Pets → Supplies
  // -------------------------------------------------------------------------
  ('PETCO', 'Supplies'),
  ('PETSMART', 'Supplies'),
  ('CHEWY', 'Supplies'),

  // -------------------------------------------------------------------------
  // Pets → Vet
  // -------------------------------------------------------------------------
  ('BANFIELD', 'Vet'),
  ('VCA ANIMAL', 'Vet'),

  // -------------------------------------------------------------------------
  // Housing → Utilities
  // -------------------------------------------------------------------------
  ('COMCAST', 'Utilities'),
  ('XFINITY', 'Utilities'),
  ('SPECTRUM', 'Utilities'),
  ('VERIZON', 'Utilities'),
  ('T-MOBILE', 'Utilities'),
  ('XCEL ENERGY', 'Utilities'),
  ('DUKE ENERGY', 'Utilities'),
  ('WASTE MGMT', 'Utilities'),
  ('WASTE MANAGEMENT', 'Utilities'),
  ('REPUBLIC SERVICE', 'Utilities'),
  ('WATER UTILITY', 'Utilities'),
  ('ELECTRIC CO', 'Utilities'),
  ('DOMINION ENERGY', 'Utilities'),
  ('SOUTHERN COMPANY', 'Utilities'),
  ('CONSUMERS ENERGY', 'Utilities'),
  ('ENTERGY', 'Utilities'),
  ('FIRSTENERGY', 'Utilities'),
  ('CENTERPOINT', 'Utilities'),
  ('COX COMM', 'Utilities'),
  ('FRONTIER COMM', 'Utilities'),
  ('CRICKET WIRELESS', 'Utilities'),
  ('BOOST MOBILE', 'Utilities'),
  ('MINT MOBILE', 'Utilities'),

  // -------------------------------------------------------------------------
  // Shopping → Clothing
  // -------------------------------------------------------------------------
  ('NIKE', 'Clothing'),
  ('OLD NAVY', 'Clothing'),
  ('GAP', 'Clothing'),
  ('ZARA', 'Clothing'),
  ('NORDSTROM', 'Clothing'),
  ('MACYS', 'Clothing'),
  ("MACY'S", 'Clothing'),
  ('KOHLS', 'Clothing'),
  ("KOHL'S", 'Clothing'),
  ('TJ MAXX', 'Clothing'),
  ('TJMAXX', 'Clothing'),
  ('MARSHALLS', 'Clothing'),
  ('ROSS', 'Clothing'),
  ('BURLINGTON', 'Clothing'),
  ('FOREVER 21', 'Clothing'),
  ('H&M', 'Clothing'),
  ('UNIQLO', 'Clothing'),
  ('AMERICAN EAGLE', 'Clothing'),
  ('BANANA REPUBLIC', 'Clothing'),
  ('EXPRESS', 'Clothing'),
  ('LULULEMON', 'Clothing'),
  ('ADIDAS', 'Clothing'),
  ('UNDER ARMOUR', 'Clothing'),
  ('FOOT LOCKER', 'Clothing'),
  ('FINISH LINE', 'Clothing'),

  // -------------------------------------------------------------------------
  // Shopping → Electronics
  // -------------------------------------------------------------------------
  ('BEST BUY', 'Electronics'),
  ('APPLE STORE', 'Electronics'),
  ('MICRO CENTER', 'Electronics'),
  ('B&H PHOTO', 'Electronics'),
  ('NEWEGG', 'Electronics'),

  // -------------------------------------------------------------------------
  // Shopping → Home Goods
  // -------------------------------------------------------------------------
  ('HOME DEPOT', 'Home Goods'),
  ('LOWES', 'Home Goods'),
  ("LOWE'S", 'Home Goods'),
  ('BED BATH', 'Home Goods'),
  ('POTTERY BARN', 'Home Goods'),
  ('CRATE & BARREL', 'Home Goods'),
  ('PIER 1', 'Home Goods'),
  ('IKEA', 'Home Goods'),
  ('WAYFAIR', 'Home Goods'),
  ('WORLD MARKET', 'Home Goods'),
  ('WILLIAMS SONOMA', 'Home Goods'),
  ('RESTORATION HARDWARE', 'Home Goods'),
  ('ACE HARDWARE', 'Home Goods'),
  ('MENARDS', 'Home Goods'),
  ('HARBOR FREIGHT', 'Home Goods'),
  ('TRUE VALUE', 'Home Goods'),

  // -------------------------------------------------------------------------
  // Education → Books
  // -------------------------------------------------------------------------
  ('BARNES & NOBLE', 'Books'),
  ('HALF PRICE BOOKS', 'Books'),

  // -------------------------------------------------------------------------
  // Education → Courses
  // -------------------------------------------------------------------------
  ('UDEMY', 'Courses'),
  ('COURSERA', 'Courses'),
  ('SKILLSHARE', 'Courses'),
  ('MASTERCLASS', 'Courses'),
  ('LINKEDIN LEARNING', 'Courses'),

  // -------------------------------------------------------------------------
  // Travel → Flights
  // -------------------------------------------------------------------------
  ('SOUTHWEST', 'Flights'),
  ('DELTA AIR', 'Flights'),
  ('UNITED AIR', 'Flights'),
  ('AMERICAN AIR', 'Flights'),
  ('JETBLUE', 'Flights'),
  ('SPIRIT AIR', 'Flights'),
  ('FRONTIER AIR', 'Flights'),
  ('ALASKA AIR', 'Flights'),

  // -------------------------------------------------------------------------
  // Travel → Hotels
  // -------------------------------------------------------------------------
  ('MARRIOTT', 'Hotels'),
  ('HILTON', 'Hotels'),
  ('HYATT', 'Hotels'),
  ('IHG', 'Hotels'),
  ('BEST WESTERN', 'Hotels'),
  ('AIRBNB', 'Hotels'),
  ('VRBO', 'Hotels'),

  // -------------------------------------------------------------------------
  // Gifts & Donations → Charity
  // -------------------------------------------------------------------------
  ('RED CROSS', 'Charity'),
  ('UNITED WAY', 'Charity'),
  ('SALVATION ARMY', 'Charity'),
  ('GOODWILL', 'Charity'),

  // -------------------------------------------------------------------------
  // Housing → Insurance (home/renters)
  // -------------------------------------------------------------------------
  ('STATE FARM', 'Insurance'),
  ('ALLSTATE', 'Insurance'),
  ('GEICO', 'Insurance'),
  ('PROGRESSIVE', 'Insurance'),
  ('USAA', 'Insurance'),
  ('LIBERTY MUTUAL', 'Insurance'),
  ('NATIONWIDE', 'Insurance'),
  ('FARMERS INS', 'Insurance'),

  // -------------------------------------------------------------------------
  // 2025-era additions (curated; see plan for excluded entries)
  // -------------------------------------------------------------------------

  // EV charging → Gas
  ('TESLA SUPERCHARGER', 'Gas'),
  ('TESLA CHARGING', 'Gas'),
  ('ELECTRIFY AMERICA', 'Gas'),
  ('EVGO', 'Gas'),
  ('CHARGEPOINT', 'Gas'),
  ('BLINK CHARGING', 'Gas'),

  // Telehealth → Medical
  ('TELADOC', 'Medical'),
  ('BETTERHELP', 'Medical'),
  ('TALKSPACE', 'Medical'),
  ('HIMS', 'Medical'),
  ('HERS', 'Medical'),
  ('RO HEALTH', 'Medical'),

  // Modern Subscriptions
  ('SUBSTACK', 'Subscriptions'),
  ('PATREON', 'Subscriptions'),
  ('MAX.COM', 'Subscriptions'),
  ('HBO MAX', 'Subscriptions'),
  ('GITHUB', 'Subscriptions'),
  ('CHATGPT', 'Subscriptions'),
  ('ANTHROPIC', 'Subscriptions'),
  ('CLAUDE.AI', 'Subscriptions'),
  ('PERPLEXITY', 'Subscriptions'),
  ('1PASSWORD', 'Subscriptions'),
  ('LASTPASS', 'Subscriptions'),
  ('PROTON', 'Subscriptions'),
  ('NORDVPN', 'Subscriptions'),
  ('EXPRESSVPN', 'Subscriptions'),

  // Public Transit (micromobility)
  ('LIME', 'Public Transit'),
  ('BIRD RIDES', 'Public Transit'), // bare 'BIRD' too generic
  ('CITI BIKE', 'Public Transit'),
  ('REVEL', 'Public Transit'),

  // Groceries — specific warehouse strings (bare 'COSTCO' would match COSTCO GAS)
  ('COSTCO WHSE', 'Groceries'),
  ('COSTCO WHOLESALE', 'Groceries'),
  ("SAM'S CLUB", 'Groceries'),
  ('SAMS CLUB', 'Groceries'),
  ('GOPUFF', 'Groceries'),
  ('THRIVE MARKET', 'Groceries'),
  ('MISFITS MARKET', 'Groceries'),
  ('IMPERFECT FOODS', 'Groceries'),

  // Delivery
  ('CAVIAR', 'Delivery'),
  ('CHOWNOW', 'Delivery'),

  // Clothing
  ('SHEIN', 'Clothing'),
  ('ZAPPOS', 'Clothing'),
  ('REI CO-OP', 'Clothing'), // bare 'REI' too generic
  ('PATAGONIA', 'Clothing'),

  // Coffee Shops
  ('BLACK ROCK COFFEE', 'Coffee Shops'),
  ('BIGGBY', 'Coffee Shops'),

  // Restaurants (modern chains)
  ('SWEETGREEN', 'Restaurants'),
  ('CAVA', 'Restaurants'),
  ('SHAKE SHACK', 'Restaurants'),
  ('MOD PIZZA', 'Restaurants'),
  ('BLAZE PIZZA', 'Restaurants'),
];

/// Investment account transaction rules (matched by account type).
///
/// Each tuple is (payeeContains, targetCategoryName, accountType).
/// These rules only fire when the transaction's account matches the
/// specified account type.
const investmentMerchantMappings = <(String, String, String)>[
  // -------------------------------------------------------------------------
  // Dividends (income) — specific patterns first, then broad
  // -------------------------------------------------------------------------
  ('DIV REINVEST', 'Dividends', 'brokerage'),
  ('DIV REINVEST', 'Dividends', '401k'),
  ('DIV REINVEST', 'Dividends', 'ira'),
  ('DIV REINVEST', 'Dividends', 'roth_ira'),
  ('DIV REINVEST', 'Dividends', 'hsa'),
  ('REINVEST DIV', 'Dividends', 'brokerage'),
  ('REINVEST DIV', 'Dividends', '401k'),
  ('REINVEST DIV', 'Dividends', 'ira'),
  ('REINVEST DIV', 'Dividends', 'roth_ira'),
  ('INCOME DIST', 'Dividends', 'brokerage'),
  ('INCOME DIST', 'Dividends', '401k'),
  ('DIVIDEND', 'Dividends', 'brokerage'),
  ('DIVIDEND', 'Dividends', '401k'),
  ('DIVIDEND', 'Dividends', 'ira'),
  ('DIVIDEND', 'Dividends', 'roth_ira'),
  ('DIVIDEND', 'Dividends', 'hsa'),
  // "DIV " (trailing space) catches Fidelity short form: "DIV - ISHARES..."
  ('DIV ', 'Dividends', 'brokerage'),
  ('DIV ', 'Dividends', '401k'),
  ('DIV ', 'Dividends', 'ira'),
  ('DIV ', 'Dividends', 'roth_ira'),
  ('DIV ', 'Dividends', 'hsa'),
  ('DIST -', 'Dividends', 'brokerage'),
  ('REINVEST', 'Dividends', 'brokerage'),
  ('REINVEST', 'Dividends', '401k'),
  ('REINVEST', 'Dividends', 'ira'),
  ('REINVEST', 'Dividends', 'roth_ira'),

  // -------------------------------------------------------------------------
  // Interest (income)
  // -------------------------------------------------------------------------
  ('INTEREST', 'Interest', 'brokerage'),
  ('INTEREST', 'Interest', '401k'),
  ('INTEREST', 'Interest', 'ira'),
  ('INTEREST', 'Interest', 'roth_ira'),
  ('INTEREST', 'Interest', 'hsa'),

  // -------------------------------------------------------------------------
  // Capital Gains (income subcategory)
  // -------------------------------------------------------------------------
  ('CAPITAL GAIN', 'Capital Gains', 'brokerage'),
  ('CAPITAL GAIN', 'Capital Gains', '401k'),
  ('CAPITAL GAIN', 'Capital Gains', 'ira'),
  ('CAPITAL GAIN', 'Capital Gains', 'roth_ira'),
  ('CAP GAIN', 'Capital Gains', 'brokerage'),
  ('CAP GAIN', 'Capital Gains', '401k'),

  // -------------------------------------------------------------------------
  // Buy / Sell / Trade
  // -------------------------------------------------------------------------
  ('BUY', 'Investments', 'brokerage'),
  ('BUY', 'Investments', '401k'),
  ('BOUGHT', 'Investments', 'brokerage'),
  ('PURCHASE', 'Investments', 'brokerage'),
  ('PURCHASE', 'Investments', '401k'),
  ('SELL', 'Investments', 'brokerage'),
  ('SELL', 'Investments', '401k'),
  ('SOLD', 'Investments', 'brokerage'),
  ('SALE', 'Investments', 'brokerage'),
  ('REDEMPTION', 'Investments', 'brokerage'),
  ('REDEMPTION', 'Investments', '401k'),

  // -------------------------------------------------------------------------
  // Contributions
  // -------------------------------------------------------------------------
  ('EMPLOYER MATCH', 'Investments', '401k'),
  ('EMPLOYER CONTRIB', 'Investments', '401k'),
  ('EE CONTRIB', 'Investments', '401k'),
  ('ER CONTRIB', 'Investments', '401k'),
  ('CONTRIBUTION', 'Investments', '401k'),
  ('CONTRIBUTION', 'Investments', 'ira'),
  ('CONTRIBUTION', 'Investments', 'roth_ira'),
  ('CONTRIBUTION', 'Investments', 'hsa'),
  ('PRETAX', 'Investments', '401k'),
  ('ROTH DEFERRAL', 'Investments', '401k'),
  ('DEFERRAL', 'Investments', '401k'),
  ('PAYROLL', 'Investments', '401k'),
  ('PAYROLL', 'Investments', 'hsa'),
  ('CATCH-UP', 'Investments', '401k'),
  ('SAFE HARBOR', 'Investments', '401k'),
  ('PROFIT SHARING', 'Investments', '401k'),

  // -------------------------------------------------------------------------
  // Transfers / Rollovers
  // -------------------------------------------------------------------------
  ('TRANSFERS IN/OUT', 'Investments', '401k'),
  ('TRANSFERS IN/OUT', 'Investments', 'ira'),
  ('TRANSFERS IN/OUT', 'Investments', 'roth_ira'),
  ('TRANSFER IN', 'Investments', '401k'),
  ('TRANSFER IN', 'Investments', 'ira'),
  ('TRANSFER IN', 'Investments', 'roth_ira'),
  ('TRANSFER IN', 'Investments', 'hsa'),
  ('TRANSFER OUT', 'Investments', '401k'),
  ('TRANSFER OUT', 'Investments', 'ira'),
  ('TRANSFER OUT', 'Investments', 'roth_ira'),
  ('TRANSFER OUT', 'Investments', 'hsa'),
  ('ROLLOVER', 'Investments', '401k'),
  ('ROLLOVER', 'Investments', 'ira'),
  ('ROTH CONVERSION', 'Investments', 'roth_ira'),
  ('EXCHANGE IN', 'Investments', '401k'),
  ('EXCHANGE OUT', 'Investments', '401k'),
  ('REBALANCE', 'Investments', '401k'),
  ('REBALANCE', 'Investments', 'brokerage'),

  // -------------------------------------------------------------------------
  // Distributions
  // -------------------------------------------------------------------------
  ('DISTRIBUTION', 'Distributions', '401k'),
  ('DISTRIBUTION', 'Distributions', 'ira'),
  ('DISTRIBUTION', 'Distributions', 'roth_ira'),
  ('RMD', 'Distributions', 'ira'),
  ('RMD', 'Distributions', '401k'),
  ('WITHDRAWAL', 'Distributions', '401k'),
  ('WITHDRAWAL', 'Distributions', 'ira'),
  ('DISBURSEMENT', 'Distributions', '401k'),
  ('HARDSHIP', 'Distributions', '401k'),
  ('LOAN REPAY', 'Investments', '401k'),
  ('LOAN DISBURS', 'Investments', '401k'),

  // -------------------------------------------------------------------------
  // Investment Fees (expense)
  // -------------------------------------------------------------------------
  ('RECORDKEEP', 'Advisory Fees', '401k'),
  ('AUDIT FEE', 'Advisory Fees', '401k'),
  ('IQPA', 'Advisory Fees', '401k'),
  ('ADMIN FEE', 'Advisory Fees', '401k'),
  ('PLAN FEE', 'Advisory Fees', '401k'),
  ('PARTICIPANT FEE', 'Advisory Fees', '401k'),
  ('ADVISORY FEE', 'Advisory Fees', 'brokerage'),
  ('ADVISORY FEE', 'Advisory Fees', '401k'),
  ('ADVISORY FEE', 'Advisory Fees', 'ira'),
  ('ADVISORY FEE', 'Advisory Fees', 'roth_ira'),
  ('MANAGEMENT FEE', 'Advisory Fees', 'brokerage'),
  ('MANAGEMENT FEE', 'Advisory Fees', '401k'),
  ('EXPENSE RATIO', 'Advisory Fees', '401k'),
  ('CUSTODIAL FEE', 'Advisory Fees', 'ira'),
  ('CUSTODIAL FEE', 'Advisory Fees', 'roth_ira'),
  ('ANNUAL FEE', 'Advisory Fees', 'brokerage'),
  ('ANNUAL FEE', 'Advisory Fees', 'ira'),
  ('ANNUAL FEE', 'Advisory Fees', 'roth_ira'),
  ('ACCOUNT FEE', 'Advisory Fees', 'brokerage'),
  ('ACCOUNT FEE', 'Advisory Fees', 'ira'),
  ('ACCOUNT FEE', 'Advisory Fees', 'roth_ira'),
  ('ACCOUNT FEE', 'Advisory Fees', 'hsa'),
  ('COMMISSION', 'Trading Commissions', 'brokerage'),
];
