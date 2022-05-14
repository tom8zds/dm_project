import 'package:bloc/bloc.dart';
import 'package:dmapicore/api/api_models/protobuf/comic/detail_response.pb.dart';
import 'package:equatable/equatable.dart';

part 'comic_reader_state.dart';

class ComicReaderCubit extends Cubit<ComicReaderState> {
  ComicReaderCubit() : super(ComicReaderInitial());
}
