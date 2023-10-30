import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'leaderboard_entry_data.g.dart';

/// {@template leaderboard_entry_data}
/// A model representing a leaderboard entry containing the player's initials,
/// score, and chosen character.
///
/// Stored in Firestore `leaderboard` collection.
///
/// Example:
/// ```json
/// {
///   "playerInitials" : "ABC",
///   "score" : 1500,
/// }
/// ```
/// {@endtemplate}
@JsonSerializable()
class LeaderboardEntryData extends Equatable {
  /// {@macro leaderboard_entry_data}
  const LeaderboardEntryData({
    required this.playerInitials,
    required this.score,
  });

  /// Factory which converts a [Map] into a [LeaderboardEntryData].
  factory LeaderboardEntryData.fromJson(Map<String, dynamic> json) {
    return _$LeaderboardEntryDataFromJson(json);
  }

  /// Converts the [LeaderboardEntryData] to [Map].
  Map<String, dynamic> toJson() => _$LeaderboardEntryDataToJson(this);

  /// Player's chosen initials for [LeaderboardEntryData].
  ///
  /// Example: 'ABC'.
  @JsonKey(name: 'playerInitials')
  final String playerInitials;

  /// Score for [LeaderboardEntryData].
  ///
  /// Example: 1500.
  @JsonKey(name: 'score')
  final int score;

  /// An empty [LeaderboardEntryData] object.
  static const empty = LeaderboardEntryData(
    score: 0,
    playerInitials: '',
  );

  @override
  List<Object?> get props => [playerInitials, score];
}
