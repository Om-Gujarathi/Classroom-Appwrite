import 'dart:collection';

import 'package:appwrite/appwrite.dart';
import 'package:attendance/constants/appwrite_constants.dart';
import 'package:attendance/models/user_model.dart';
import 'package:attendance/utils/show_snack_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AuthState extends ChangeNotifier {
  Client client = Client();
  late Teams teams;
  late Account account;
  late bool _isLoggedIn;
  late User? _user;
  late String _error;
  late Databases databases;
  late Realtime realtime;
  bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  User? get user => _user;
  String get error => _error;
  bool get isLoading => _isLoading;

  AuthState() {
    _init();
  }

  _init() {
    _isLoggedIn = false;
    _user = null;
    account = Account(client);
    teams = Teams(client);
    databases = Databases(client);
    realtime = Realtime(client);
    client
        .setEndpoint(AppwriteConstants.endpoint)
        .setProject(AppwriteConstants.projectId);
    _checkIsLoggedIn();
  }

  _checkIsLoggedIn() async {
    try {
      _isLoading = true;
      _user = await _getAccount();
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print(e);
    }
  }

  Future<User?> _getAccount() async {
    try {
      final res = await account.get();
      if (res.status) {
        return User.fromJson(res.toMap());
      } else {
        return null;
      }
    } catch (e) {
      throw e;
    }
  }

  createAccount(String name, String email, String password) async {
    try {
      _isLoading = true;
      await account.create(
          name: name, email: email, password: password, userId: ID.unique());
      login(email, password);
      _isLoading = false;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      print(error.toString());
    }
  }

  login(String email, String password) async {
    try {
      final result =
          await account.createEmailSession(email: email, password: password);
      if (result.current) {
        _isLoggedIn = true;
        _user = await _getAccount();
        notifyListeners();
      }
    } catch (error) {
      print(error.toString());
    }
  }

  logout() {
    _isLoggedIn = false;
    _user = null;
    account.deleteSession(sessionId: 'current');
    notifyListeners();
  }

  createTeam({required String name}) async {
    _isLoading = true;
    notifyListeners();
    await teams.create(teamId: ID.unique(), name: name);
    _isLoading = false;
    notifyListeners();
  }

  inviteToTeam({required String teamId, required String emailId}) async {
    final result = await teams.createMembership(
      teamId: teamId,
      email: emailId,
      roles: ['member'],
      url: '',
    );
  }

  acceptTeamInvite() async {
    final result = await teams.updateMembershipStatus(
        teamId: "640492a1a089cfa256c0",
        membershipId: '6405741f6676099d4e04',
        userId: '6404718fbdb12b1e640f',
        secret:
            'd9a77544baeb61e858fad802bffdd5a0b011603c24f8b8ca15380091120c25a07d927fd402ce5fdde6b336caef70f4769012086de5ca336268c258e4e7300c3f15e5673b448e18dbdc4ea7a279537e0c1a40f9cdeef5240af7a198cf7d8109b951865ca51ea46c769e508b14f63ce8c53b7bf30d68e58365b42fcb31499d539b');
    print(result.toMap());
  }

  Future listTeams() {
    return teams.list();
  }

  Future<String> createAttendance({required String teamId}) async {
    final doc = await databases.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.attendanceCollectionId,
        documentId: ID.unique(),
        data: {
          "teamId": teamId,
          "date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
          "status": true,
          "presentId": [],
          "owner": _user!.id
        });

    return doc.$id;
  }

  Future<User> getUserFromId({required String userId}) async {
    final doc = await databases.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollectionId,
      documentId: userId,
    );
    // print("USER RETUNED");
    // print(doc.toMap());

    return User.fromJson(doc.toMap()["data"]);
  }

  markPresenty(
      {required BuildContext context,
      required String docId,
      required String teamId}) async {
    final result = await databases.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.attendanceCollectionId,
        documentId: docId);

    if (!result.data['status']) {
      showSnackBar(context, "ATTENDANCE HAS BEEN STOPPED BY FACULTY");
      return;
    }
    List temp = result.data['presentId'];
    temp.add(user?.id);

    databases.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.attendanceCollectionId,
        documentId: docId,
        data: {'presentId': temp});
  }

  listAllDocsOfTeam({required String teamId}) async {
    return databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.attendanceCollectionId,
        queries: [
          Query.equal('teamId', teamId),
        ]);
  }

  RealtimeSubscription getLatestPresenty({required String docId}) {
    return realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.attendanceCollectionId}.documents.$docId'
    ]);
  }

  whenPresentyStopped({required RealtimeSubscription subscription}) {
    subscription.close();
  }

  Future listTeamMemberships({required String teamId}) {
    return teams.listMemberships(teamId: teamId);
  }

  Future getTeamOwner({required String docId}) async {
    print("GETTING TEAM OWNER : ${docId}");
    final res = await databases.getDocument(
        collectionId: AppwriteConstants.attendanceCollectionId,
        databaseId: AppwriteConstants.databaseId,
        documentId: docId);
    if (_user!.id == res.toMap()["data"]["owner"]) {
      return true;
    } else {
      return false;
    }
  }

  stopOrStartAttendance({required String docId, required bool currStatus}) {
    databases.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.attendanceCollectionId,
        documentId: docId,
        data: {'status': !currStatus});
  }
}
