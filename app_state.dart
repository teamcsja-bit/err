
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/errand_post.dart';
import 'models/errand_request.dart';
import 'models/user_profile.dart';


class AppState extends ChangeNotifier {

  void setCurrentUser(UserProfile user) {
    // Check if user exists, else add and set as current
    int idx = users.indexWhere((u) => u.email == user.email);
    if (idx == -1) {
      users.add(user);
      loggedInUserIndex = users.length - 1;
    } else {
      loggedInUserIndex = idx;
    }
    notifyListeners();
  }
  int tokenBalance = 5;
  List<String> tokenHistory = [];
  List<ErrandPost> posts = [];
  List<ErrandRequest> requests = [];

  // Dummy users with passwords
  final List<UserProfile> users = [
    UserProfile(
      email: 'jerin@gmail.com',
      name: 'Jerin',
      village: 'Greenfield',
      city: 'Metrocity',
      pincode: '123456',
      gender: 'Male',
      phone: '9876543210',
      bio: 'Hello, I am Jerin!',
      password: 'hello123',
      ),
    UserProfile(
      email: 'alex@gmail.com',
      name: 'Alex',
      village: 'Sunrise',
      city: 'Hilltown',
      pincode: '654321',
      gender: 'Female',
      phone: '9876501234',
      bio: 'Hey, I am Alex!',
      password: 'alexpass',
      ),
  ];

  int? loggedInUserIndex;

  UserProfile? get currentUser =>
      loggedInUserIndex != null ? users[loggedInUserIndex!] : null;

  void setLoggedInUserByIndex(int idx) {
    loggedInUserIndex = idx;
    notifyListeners();
  }

  void updateCurrentUserProfile({
    String? name,
    String? village,
    String? city,
    String? pincode,
    String? gender,
    String? phone,
    String? bio,
    String? password,
  }) {
    if (loggedInUserIndex == null) return;
    final user = users[loggedInUserIndex!];

    if (name != null) user.name = name;
    if (village != null) user.village = village;
    if (city != null) user.city = city;
    if (pincode != null) user.pincode = pincode;
    if (gender != null) user.gender = gender;
    if (phone != null) user.phone = phone;
    if (bio != null) user.bio = bio;

    notifyListeners();
  }

  void clearLoggedInUser() {
    loggedInUserIndex = null;
    notifyListeners();
  }

  void spendToken(String reason) {
    tokenBalance -= 1;
    tokenHistory.add('Spent 1 token: $reason');
    notifyListeners();
  }

  void earnTokens(int amount, String reason) {
    tokenBalance += amount;
    tokenHistory.add('Earned $amount tokens: $reason');
    notifyListeners();
  }

  Future<void> addPost(ErrandPost post) async {
    posts.add(post);
    notifyListeners();
    await FirebaseFirestore.instance.collection('posts').doc(post.id).set({
      'id': post.id,
      'type': post.type,
      'place': post.place,
      'item': post.item,
      'userNickname': post.userNickname,
      'eta': post.eta.toIso8601String(),
      'radiusKm': post.radiusKm,
      'status': post.status,
      'createdAt': post.createdAt.toIso8601String(),
      'expiresAt': post.expiresAt.toIso8601String(),
    });
  }

  Future<void> fetchPosts() async {
    final snapshot = await FirebaseFirestore.instance.collection('posts').get();
    posts = snapshot.docs.map((doc) {
      final data = doc.data();
      return ErrandPost(
        id: data['id'],
        type: data['type'],
        place: data['place'],
        item: data['item'],
        userNickname: data['userNickname'],
        eta: DateTime.parse(data['eta']),
        radiusKm: (data['radiusKm'] as num).toDouble(),
        status: data['status'],
        createdAt: DateTime.parse(data['createdAt']),
        expiresAt: DateTime.parse(data['expiresAt']),
      );
    }).toList();

    // Auto-delete expired posts
    for (final post in List<ErrandPost>.from(posts)) {
      if (post.isExpired) {
        await deletePost(post.id);
      }
    }
    notifyListeners();
  }

  Future<void> deletePost(String postId) async {
    posts.removeWhere((p) => p.id == postId);
    notifyListeners();
    await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
  }

  Future<void> deleteRequest(String requestId) async {
    requests.removeWhere((r) => r.id == requestId);
    notifyListeners();
    await FirebaseFirestore.instance.collection('requests').doc(requestId).delete();
  }

  void updatePostStatus(String id, String status) {
    for (var post in posts) {
      if (post.id == id) {
        post.status = status;
      }
    }
    notifyListeners();
  }

  void addRequest(ErrandRequest req) {
    requests.add(req);
    notifyListeners();
  }

  void updateRequestStatus(String id, String status) {
    for (var req in requests) {
      if (req.id == id) {
        req.status = status;
      }
    }
    notifyListeners();
  }
}

final appState = AppState();
