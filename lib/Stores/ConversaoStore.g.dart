// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ConversaoStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ConversaoStore on _ConversaoStoreBase, Store {
  final _$statusConversaoAtom =
      Atom(name: '_ConversaoStoreBase.statusConversao');

  @override
  int get statusConversao {
    _$statusConversaoAtom.reportRead();
    return super.statusConversao;
  }

  @override
  set statusConversao(int value) {
    _$statusConversaoAtom.reportWrite(value, super.statusConversao, () {
      super.statusConversao = value;
    });
  }

  final _$textoReconhecidoAtom =
      Atom(name: '_ConversaoStoreBase.textoReconhecido');

  @override
  String get textoReconhecido {
    _$textoReconhecidoAtom.reportRead();
    return super.textoReconhecido;
  }

  @override
  set textoReconhecido(String value) {
    _$textoReconhecidoAtom.reportWrite(value, super.textoReconhecido, () {
      super.textoReconhecido = value;
    });
  }

  @override
  String toString() {
    return '''
statusConversao: ${statusConversao},
textoReconhecido: ${textoReconhecido}
    ''';
  }
}
