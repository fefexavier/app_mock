
import 'package:firebase_auth/firebase_auth.dart';

class AutenticacaoServico {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Cadastrar um novo usuário
  Future<UserCredential?> cadastrarUsuario({
    required String nome,
    required String senha,
    required String email,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      // Atualizar o nome do usuário
      await userCredential.user?.updateDisplayName(nome);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Erro ao cadastrar usuário: ${e.message}');
      rethrow;
    }
  }

  /// Fazer login
  Future<UserCredential?> loginUsuario({
    required String email,
    required String senha,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Erro ao fazer login: ${e.message}');
      rethrow;
    }
  }

  /// Fazer logout
  Future<void> logoutUsuario() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Erro ao fazer logout: $e');
    }
  }

  /// Recuperar senha
  Future<void> recuperarSenha({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      print('E-mail de recuperação enviado para $email');
    } on FirebaseAuthException catch (e) {
      print('Erro ao enviar e-mail de recuperação: ${e.message}');
    }
  }

  /// Obter o usuário atual
  User? obterUsuarioAtual() {
    return _firebaseAuth.currentUser;
  }

  /// Atualizar o nome do usuário
  Future<void> atualizarNomeUsuario(String nome) async {
    try {
      await _firebaseAuth.currentUser?.updateDisplayName(nome);
    } catch (e) {
      print('Erro ao atualizar o nome do usuário: $e');
    }
  }
}
