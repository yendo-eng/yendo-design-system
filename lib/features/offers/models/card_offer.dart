/// Yendo — CardOffer model
///
/// Represents a single pre-approved credit card offer.
/// The [priority] field determines downsell order:
///   priority 1 = first shown, priority 3 = last resort

class CardOffer {
  const CardOffer({
    required this.id,
    required this.priority,
    required this.name,
    required this.description,
    required this.creditLimit,
    required this.apr,
    required this.cashAdvanceLimit,
    required this.imagePath,
    required this.bulletPoints,
    required this.terms,
    required this.rewardsLine,
    required this.collateralType,
    required this.timeToMoney,
    this.extraValueProp,
  });

  final String id;
  final int priority;
  final String name;
  final String description;
  final String creditLimit;
  final String apr;
  final String cashAdvanceLimit;
  final String imagePath;
  final List<String> bulletPoints;
  final String terms;
  final String rewardsLine;
  final String collateralType;
  final String timeToMoney;
  final String? extraValueProp;

  static List<CardOffer> downsellOptions(
    List<CardOffer> allOffers,
    CardOffer rejectedOffer,
  ) {
    return allOffers
        .where((o) => o.id != rejectedOffer.id)
        .toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));
  }
}

class YendoOffers {
  static const vehicle = CardOffer(
    id: 'vehicle',
    priority: 1,
    name: 'Express Preferred Rewards',
    description: 'Use your vehicle equity to unlock a higher credit limit and earn rewards on every purchase.',
    creditLimit: r'$10,000',
    apr: '29.88%',
    cashAdvanceLimit: r'$400',
    imagePath: 'assets/images/Vehicle.svg',
    bulletPoints: ['Pre-approved up to \$10,000', '1.5% rewards on Autopay'],
    rewardsLine: '1.5% rewards on Autopay',
    collateralType: 'Backed by Vehicle',
    timeToMoney: 'Time to money: 5 minutes',
    extraValueProp: 'Build your credit back',
    terms: 'Annual Percentage Rate (APR) for Purchases: 29.88%\n\nAnnual Percentage Rate (APR) for Cash Advances: 29.88%\n\nAnnual Percentage Rate (APR) for Balance Transfers: 29.88%\n\nPaying Interest: Your due date is at least 25 days after the close of each billing cycle. We will not charge you any interest on purchases if you pay your entire balance by the due date each month.\n\nAnnual Fee: \$40, billed on the date of your first transaction, and annually on that date thereafter.\n\nTransaction Fees\nForeign Transactions: 3% of the transaction amount, in U.S. dollars\nBalance Transfers: \$5 or 5% of the amount of balance transfer, whichever is greater',
  );

  static const home = CardOffer(
    id: 'home',
    priority: 2,
    name: 'Keystone Reserve Rewards',
    description: 'Leverage your home equity for a competitive credit limit with premium rewards benefits.',
    creditLimit: r'$2,000',
    apr: '24.99%',
    cashAdvanceLimit: r'$400',
    imagePath: 'assets/images/Home.svg',
    bulletPoints: ['Pre-approved up to \$2,000', '1.5% rewards on Autopay'],
    rewardsLine: '1.5% rewards on Autopay',
    collateralType: 'Backed by Fixtures',
    timeToMoney: 'Time to money: 3 minutes',
    terms: 'Annual Percentage Rate (APR) for Purchases: 24.99%\n\nAnnual Percentage Rate (APR) for Cash Advances: 24.99%\n\nPaying Interest: Your due date is at least 25 days after the close of each billing cycle.\n\nAnnual Fee: \$0\n\nTransaction Fees\nForeign Transactions: 3% of the transaction amount, in U.S. dollars',
  );

  static const unsecured = CardOffer(
    id: 'unsecured',
    priority: 3,
    name: 'Flex Preferred Rewards',
    description: 'No collateral needed. Build your credit and earn rewards with our flexible unsecured card.',
    creditLimit: r'$750',
    apr: '28.99-35.99%',
    cashAdvanceLimit: r'$400',
    imagePath: 'assets/images/Unsecured.svg',
    bulletPoints: ['Pre-approved up to \$750', '1.5% rewards on Autopay'],
    rewardsLine: '1.5% rewards on Autopay',
    collateralType: 'Non-backed',
    timeToMoney: 'Time to money: 3 minutes',
    extraValueProp: 'No time to wait for full credit line',
    terms: 'Annual Percentage Rate (APR) for Purchases: 29.88%–35.88%\n\nAnnual Percentage Rate (APR) for Cash Advances: 29.88%\n\nPaying Interest: Your due date is at least 25 days after the close of each billing cycle.\n\nAnnual Fee: \$0\n\nTransaction Fees\nForeign Transactions: 3% of the transaction amount, in U.S. dollars',
  );

  static const autoRefi = CardOffer(
    id: 'autoRefi',
    priority: 4,
    name: 'Auto Refi v2',
    description: 'Refinance your auto loan and access a higher limit backed by your car.',
    creditLimit: r'$18,000',
    apr: '29.88%',
    cashAdvanceLimit: r'$400',
    imagePath: 'assets/images/Vehicle.svg',
    bulletPoints: ['Pre-approved up to \$18,000', '1.5% rewards on Autopay'],
    rewardsLine: '1.5% rewards on Autopay',
    collateralType: 'Backed by Car',
    timeToMoney: 'Time to money: X minutes',
    terms: 'Annual Percentage Rate (APR) for Purchases: 29.88%\n\nAnnual Percentage Rate (APR) for Cash Advances: 29.88%\n\nPaying Interest: Your due date is at least 25 days after the close of each billing cycle.\n\nAnnual Fee: \$0\n\nTransaction Fees\nForeign Transactions: 3% of the transaction amount, in U.S. dollars',
  );

  /// The 3 pre-approved offers shown in the offers selection flow.
  static const all = [vehicle, home, unsecured];

  /// All 4 products — used in the comparison table.
  static const allProducts = [vehicle, home, unsecured, autoRefi];
}
