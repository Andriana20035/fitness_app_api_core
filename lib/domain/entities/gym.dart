class Amenity {
  final String id;
  final String name;
  final String iconUrl;

  const Amenity({
    required this.id,
    required this.name,
    required this.iconUrl,
  });
}

class Pricing {
  final double amount;
  final String currency;
  final String period;
  final String formatted;

  const Pricing({
    required this.amount,
    required this.currency,
    required this.period,
    required this.formatted,
  });
}

class Gym {
  final String id;
  final String name;
  final String location;
  final String heroImageUrl;
  final double rating;
  final int reviewCount;
  final String description;
  final bool descriptionExpanded;
  final List<Amenity> amenities;
  final Pricing pricing;

  const Gym({
    required this.id,
    required this.name,
    required this.location,
    required this.heroImageUrl,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.descriptionExpanded,
    required this.amenities,
    required this.pricing,
  });
}

class ReserveAction {
  final String label;
  final bool enabled;

  const ReserveAction({
    required this.label,
    required this.enabled,
  });
}

class GymActions {
  final String backIconUrl;
  final String moreIconUrl;
  final String ratingIconUrl;
  final ReserveAction reserve;

  const GymActions({
    required this.backIconUrl,
    required this.moreIconUrl,
    required this.ratingIconUrl,
    required this.reserve,
  });
}
