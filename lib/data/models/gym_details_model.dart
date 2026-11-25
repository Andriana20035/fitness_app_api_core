import '../../domain/entities/gym.dart';

class AmenityModel extends Amenity {
  const AmenityModel({
    required super.id,
    required super.name,
    required super.iconUrl,
  });

  factory AmenityModel.fromJson(Map<String, dynamic> json) => AmenityModel(
        id: json['id'] as String,
        name: json['name'] as String,
        iconUrl: json['iconUrl'] as String,
      );

  factory AmenityModel.fromEntity(Amenity entity) => AmenityModel(
        id: entity.id,
        name: entity.name,
        iconUrl: entity.iconUrl,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'iconUrl': iconUrl,
      };
}

class PricingModel extends Pricing {
  const PricingModel({
    required super.amount,
    required super.currency,
    required super.period,
    required super.formatted,
  });

  factory PricingModel.fromJson(Map<String, dynamic> json) => PricingModel(
        amount: (json['amount'] as num).toDouble(),
        currency: json['currency'] as String,
        period: json['period'] as String,
        formatted: json['formatted'] as String,
      );

  factory PricingModel.fromEntity(Pricing entity) => PricingModel(
        amount: entity.amount,
        currency: entity.currency,
        period: entity.period,
        formatted: entity.formatted,
      );

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'currency': currency,
        'period': period,
        'formatted': formatted,
      };
}

class GymModel extends Gym {
  const GymModel({
    required super.id,
    required super.name,
    required super.location,
    required super.heroImageUrl,
    required super.rating,
    required super.reviewCount,
    required super.description,
    required super.descriptionExpanded,
    required super.amenities,
    required super.pricing,
  });

  factory GymModel.fromJson(Map<String, dynamic> json) => GymModel(
        id: json['id'] as String,
        name: json['name'] as String,
        location: json['location'] as String,
        heroImageUrl: json['heroImageUrl'] as String,
        rating: (json['rating'] as num).toDouble(),
        reviewCount: json['reviewCount'] as int,
        description: json['description'] as String,
        descriptionExpanded: json['descriptionExpanded'] as bool? ?? false,
        amenities: (json['amenities'] as List<dynamic>)
            .map((item) => AmenityModel.fromJson(item as Map<String, dynamic>))
            .toList(),
        pricing: PricingModel.fromJson(json['pricing'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'location': location,
        'heroImageUrl': heroImageUrl,
        'rating': rating,
        'reviewCount': reviewCount,
        'description': description,
        'descriptionExpanded': descriptionExpanded,
        'amenities':
            amenities.map((a) => AmenityModel.fromEntity(a).toJson()).toList(),
        'pricing': PricingModel.fromEntity(pricing).toJson(),
      };
}

class ReserveActionModel extends ReserveAction {
  const ReserveActionModel({
    required super.label,
    required super.enabled,
  });

  factory ReserveActionModel.fromJson(Map<String, dynamic> json) =>
      ReserveActionModel(
        label: json['label'] as String,
        enabled: json['enabled'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'label': label,
        'enabled': enabled,
      };
}

class GymActionsModel extends GymActions {
  const GymActionsModel({
    required super.backIconUrl,
    required super.moreIconUrl,
    required super.ratingIconUrl,
    required ReserveActionModel super.reserve,
  });

  factory GymActionsModel.fromJson(Map<String, dynamic> json) =>
      GymActionsModel(
        backIconUrl: json['backIconUrl'] as String,
        moreIconUrl: json['moreIconUrl'] as String,
        ratingIconUrl: json['ratingIconUrl'] as String,
        reserve: ReserveActionModel.fromJson(
          json['reserve'] as Map<String, dynamic>,
        ),
      );

  Map<String, dynamic> toJson() => {
        'backIconUrl': backIconUrl,
        'moreIconUrl': moreIconUrl,
        'ratingIconUrl': ratingIconUrl,
        'reserve': ReserveActionModel(
          label: reserve.label,
          enabled: reserve.enabled,
        ).toJson(),
      };
}

/// Response of `GET /lab2026/v3/feed/details`.
class GymDetailsResponseModel {
  final GymModel gym;
  final GymActionsModel actions;

  const GymDetailsResponseModel({
    required this.gym,
    required this.actions,
  });

  factory GymDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      GymDetailsResponseModel(
        gym: GymModel.fromJson(json['gym'] as Map<String, dynamic>),
        actions:
            GymActionsModel.fromJson(json['actions'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'gym': gym.toJson(),
        'actions': actions.toJson(),
      };
}
