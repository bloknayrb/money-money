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
  ('LOVE', 'Gas'),
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
  ('JIFFY LUBE', 'Transportation'),
  ('VALVOLINE', 'Transportation'),
  ('FIRESTONE', 'Transportation'),
  ('AUTOZONE', 'Transportation'),
  ('PEP BOYS', 'Transportation'),
  ("O'REILLY", 'Transportation'),
  ('ADVANCE AUTO', 'Transportation'),
  ('NAPA AUTO', 'Transportation'),
  ('MIDAS', 'Transportation'),
  ('GOODYEAR', 'Transportation'),
  ('DISCOUNT TIRE', 'Transportation'),
  ('MAACO', 'Transportation'),
  ('MEINEKE', 'Transportation'),
  ('SAFELITE', 'Transportation'),

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
];

/// Investment account transaction rules (matched by account type).
///
/// Each tuple is (payeeContains, targetCategoryName, accountType).
/// These rules only fire when the transaction's account matches the
/// specified account type.
const investmentMerchantMappings = <(String, String, String)>[
  // -------------------------------------------------------------------------
  // Dividends (income)
  // -------------------------------------------------------------------------
  ('DIVIDEND', 'Dividends', 'brokerage'),
  ('DIVIDEND', 'Dividends', '401k'),
  ('DIVIDEND', 'Dividends', 'ira'),
  ('DIVIDEND', 'Dividends', 'roth_ira'),
  ('DIVIDEND', 'Dividends', 'hsa'),
  ('DIV REINVEST', 'Dividends', 'brokerage'),
  ('REINVEST', 'Dividends', 'brokerage'),

  // -------------------------------------------------------------------------
  // Interest (income)
  // -------------------------------------------------------------------------
  ('INTEREST', 'Interest', 'brokerage'),
  ('INTEREST', 'Interest', 'hsa'),

  // -------------------------------------------------------------------------
  // Buy / Sell (income parent: Investments)
  // -------------------------------------------------------------------------
  ('BUY', 'Investments', 'brokerage'),
  ('BOUGHT', 'Investments', 'brokerage'),
  ('PURCHASE', 'Investments', 'brokerage'),
  ('SELL', 'Investments', 'brokerage'),
  ('SOLD', 'Investments', 'brokerage'),
  ('SALE', 'Investments', 'brokerage'),

  // -------------------------------------------------------------------------
  // Capital Gains (income subcategory)
  // -------------------------------------------------------------------------
  ('CAPITAL GAIN', 'Capital Gains', 'brokerage'),

  // -------------------------------------------------------------------------
  // Contributions
  // -------------------------------------------------------------------------
  ('CONTRIBUTION', 'Investments', '401k'),
  ('CONTRIBUTION', 'Investments', 'ira'),
  ('CONTRIBUTION', 'Investments', 'roth_ira'),
  ('CONTRIBUTION', 'Investments', 'hsa'),
  ('EMPLOYER MATCH', 'Investments', '401k'),

  // -------------------------------------------------------------------------
  // Investment Fees (expense)
  // -------------------------------------------------------------------------
  ('ADVISORY FEE', 'Advisory Fees', 'brokerage'),
  ('ADVISORY FEE', 'Advisory Fees', '401k'),
  ('MANAGEMENT FEE', 'Advisory Fees', 'brokerage'),
  ('EXPENSE RATIO', 'Advisory Fees', '401k'),
  ('COMMISSION', 'Trading Commissions', 'brokerage'),
];
