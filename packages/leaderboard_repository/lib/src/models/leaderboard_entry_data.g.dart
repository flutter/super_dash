// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_entry_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaderboardEntryData _$LeaderboardEntryDataFromJson(
        Map<String, dynamic> json) =>
    LeaderboardEntryData(
      playerInitials: json['playerInitials'] as String,
      score: json['score'] as int,
    );

Map<String, dynamic> _$LeaderboardEntryDataToJson(
        LeaderboardEntryData instance) =>
    <String, dynamic>{
      'playerInitials': instance.playerInitials,
      'score': instance.score,
    };
