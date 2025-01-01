import 'package:atele_seller/core/utils/app_strings.dart';
import 'package:atele_seller/feature/auth/data/seller_model.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> forgotPasswordFormKey = GlobalKey();
  TextEditingController emailIn = TextEditingController();
  TextEditingController phoneNum = TextEditingController();
  TextEditingController passwordIn = TextEditingController();
  TextEditingController emailUp = TextEditingController();
  TextEditingController passwordUp = TextEditingController();
  TextEditingController lacationUp = TextEditingController();
  TextEditingController fristname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  GlobalKey<FormState> scrollkey = GlobalKey<FormState>();
  final sellers = FirebaseFirestore.instance.collection('Sellers');
  String? emailAddress;

  signInWithEmailAndPassword() async {
    try {
      emit(SignInLoading());
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailIn.text, password: passwordIn.text);
      emit(SignInSuccess());
    } on FirebaseAuthException catch (e) {
      emit(SignInError(e.code));
    }
  }

  signInWithGoogle() async {
    try {
      emit(GoolegleSignInLoadingState());
      signOut();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(GoogleSignInSuccessState());
    } catch (e) {
      emit(GoogleSignInErrorState(e.toString()));
    }
  }

  signUpWithEmailAndPassword() async {
    try {
      emit(SignUpLoading());
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailUp.text, password: passwordUp.text);
      emit(SignUpSuccess());

      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      emit(EmailVerificationsuccess());
      bool emailVerified = false;
      while (!emailVerified) {
        await Future.delayed(const Duration(seconds: 5));
        await FirebaseAuth.instance.currentUser!.reload();
        emailVerified = await FirebaseAuth.instance.currentUser!.emailVerified;
        if (emailVerified) {
          addUser(SellerModel(
            sellerName: fristname.text,
            phoneNumber: phoneNum.text,
            location: lacationUp.text,
            sellerId: FirebaseAuth.instance.currentUser!.uid,
            email: emailUp.text,
            ateleName: 'atele',
            sellerImages: 'img',
            ateleImages: 'img2',
          ));
        }
      }
    } on FirebaseAuthException catch (e) {
      emit(SignUpError(e.code));
    }
  }

  addUser(SellerModel sellerModel) async {
    await sellers.doc(FirebaseAuth.instance.currentUser!.uid).set({
      FirebaseStrings.fristname: sellerModel.sellerName,
      FirebaseStrings.ateleName: sellerModel.ateleName,
      FirebaseStrings.phoneNumber: sellerModel.phoneNumber,
      FirebaseStrings.location: sellerModel.location,
      FirebaseStrings.sellerId: sellerModel.sellerId,
      FirebaseStrings.email: sellerModel.email,
      'sellerImages': sellerModel.sellerImages,
      'ateleImages': sellerModel.ateleImages,
    });
  }

  signOut() async {
    try {
      emit(SignOutLoading());
      await FirebaseAuth.instance.signOut();
      emit(SignOutSuccess());
    } on Exception catch (e) {
      emit(SignOutError(e.toString()));
    }
  }

  Future<void> resetPasswordWithEmail() async {
    try {
      emit(ResetPasswordLoadingState());
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailAddress!);
      emit(ResetPasswordSuccessState());
    } on FirebaseAuthException catch (e) {
      emit(ResetPasswordFailuerState(errorMessage: e.code));
    } catch (e) {
      emit(ResetPasswordFailuerState(errorMessage: e.toString()));
    }
  }
}
