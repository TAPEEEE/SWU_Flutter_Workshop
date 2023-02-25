part of 'map_bloc.dart';

class MapState extends Equatable {
  const MapState(this.CurrentPosotion);
  final LatLng CurrentPosotion;

  @override
  List<Object> get props => [CurrentPosotion];
}