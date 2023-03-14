import 'package:grpc/grpc.dart';
import 'package:server/gekitaiclient/lib/gekitai.pbgrpc.dart';

class GekitaiServices extends GekitaiServiceBase {
  final _messages = <Message>[];
  final _moviments = <Moviment>[];
  final _pushes = <PieceWasPushed>[];
  final _piecesOut = <PieceOutBoard>[];
  final _giveUps = <Empty>[];
  final _acceptGiveUps = <Empty>[];

  @override
  Future<Empty> sendMessage(ServiceCall call, Message request) async {
    _messages.add(request);
    return Empty();
  }

  @override
  Stream<Message> receiveMessages(ServiceCall call, Empty request) async* {
    final seenMessages = <Message>{};
    final sender = request.sender;
    while (true) {
      for (final message in _messages) {
        if (message.sender != sender && !seenMessages.contains(message)) {
          seenMessages.add(message);
          yield message;
        }
      }
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  // envia as jogadas
  @override
  Future<Empty> sendMoviment(ServiceCall call, Moviment request) async {
    _moviments.add(request);
    return Empty();
  }

  @override
  Stream<Moviment> receiveMoviment(ServiceCall call, Empty request) async* {
    final seenMoviments = <Moviment>{};
    while (true) {
      for (final moviment in _moviments) {
        if (!seenMoviments.contains(moviment)) {
          seenMoviments.add(moviment);
          yield moviment;
        }
      }
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  @override
  Future<Empty> sendPiecePushed(
    ServiceCall call,
    PieceWasPushed request,
  ) async {
    _pushes.add(request);
    return Empty();
  }

  @override
  Stream<PieceWasPushed> recievePiecePushed(
    ServiceCall call,
    Empty request,
  ) async* {
    final seenPushes = <PieceWasPushed>{};
    while (true) {
      for (final push in _pushes) {
        if (!seenPushes.contains(push)) {
          seenPushes.add(push);
          yield push;
        }
      }
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  @override
  Future<Empty> sendPieceOutBoard(
    ServiceCall call,
    PieceOutBoard request,
  ) async {
    _piecesOut.add(request);
    return Empty();
  }

  @override
  Stream<PieceOutBoard> recievePieceOutBoard(
      ServiceCall call, Empty request) async* {
    final seenPiecesOut = <PieceOutBoard>{};
    while (true) {
      for (final piece in _piecesOut) {
        if (!seenPiecesOut.contains(piece)) {
          seenPiecesOut.add(piece);
          yield piece;
        }
      }
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  @override
  Future<Empty> sendGiveUP(ServiceCall call, Empty request) async {
    _giveUps.add(request);
    return Empty();
  }

  @override
  Stream<Empty> recieveGivUp(ServiceCall call, Empty request) async* {
    final seengiveUps = <Empty>{};
    while (true) {
      for (final giveUp in _giveUps) {
        if (!seengiveUps.contains(giveUp)) {
          seengiveUps.add(giveUp);
          yield giveUp;
        }
      }
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  @override
  Future<Empty> sendAcceptGiveUP(ServiceCall call, Empty request) async {
    _acceptGiveUps.add(request);
    return Empty();
  }

  @override
  Stream<Empty> recieveAcceptGivUp(ServiceCall call, Empty request) async* {
    final seenAccepsgiveUps = <Empty>{};
    while (true) {
      for (final giveUp in _acceptGiveUps) {
        if (!seenAccepsgiveUps.contains(giveUp)) {
          seenAccepsgiveUps.add(giveUp);
          yield giveUp;
        }
      }
      await Future.delayed(Duration(milliseconds: 100));
      // .then(
      //     // (value) => _resetValues(),
      //     );
    }
  }

  void _resetValues() {
    _messages.clear();
    _moviments.clear();
    _pushes.clear();
    _piecesOut.clear();
    _giveUps.clear();
    _acceptGiveUps.clear();
  }
}

Future<void> main(List<String> args) async {
  final Server server = Server([GekitaiServices()]);
  await server.serve(port: 3000);
  print('Server listening on port ${server.port}...');
}
