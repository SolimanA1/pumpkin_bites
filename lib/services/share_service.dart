import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bite_model.dart';
import '../services/audio_player_service.dart';
import '../screens/share_dialog.dart';

class ShareService {
  // Singleton pattern
  static final ShareService _instance = ShareService._internal();
  factory ShareService() => _instance;
  ShareService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Enhanced share method with dialog for snippet selection
  Future<void> shareBite(BuildContext context, BiteModel bite, {
    AudioPlayerService? audioService,
    Duration? currentPosition,
    Duration? totalDuration,
  }) async {
    try {
      if (audioService != null && currentPosition != null && totalDuration != null) {
        // Show the enhanced share dialog
        final result = await showDialog<bool>(
          context: context,
          builder: (context) => ShareDialog(
            bite: bite,
            audioService: audioService,
            currentPosition: currentPosition,
            totalDuration: totalDuration,
          ),
        );
        
        // The dialog handles everything internally and returns true on success
        return;
      }
      
      // Fallback to simple sharing if no audio service is provided
      await _simpleShare(context, bite);
    } catch (e) {
      print('Error in shareBite: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not share content: $e')),
      );
    }
  }
  
  // Simple share method without snippet selection (for backward compatibility)
  Future<void> _simpleShare(BuildContext context, BiteModel bite) async {
    try {
      // Generate a deep link for the bite
      final deepLink = await _generateDeepLink(bite.id);
      
      // Create a message to share
      final message = _createShareMessage(bite, deepLink);
      
      // Use the Share.share from share_plus package
      await Share.share(message, subject: 'Check out this bite from Pumpkin Bites!');
      
      // Track the share in analytics
      _trackShare(bite.id);
    } catch (e) {
      print('Error in _simpleShare: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not share content: $e')),
      );
    }
  }
  
  // Create a share message based on the bite content
  String _createShareMessage(BiteModel bite, String deepLink) {
    return '''
I just listened to "${bite.title}" on Pumpkin Bites and thought you might enjoy it too!

${bite.description}

Check it out here: $deepLink
''';
  }
  
  // Generate a deep link to the specific bite
  Future<String> _generateDeepLink(String biteId) async {
    // For now, we'll use a simple URL format
    // In a production app, you would use Firebase Dynamic Links or a similar service
    return 'https://pumpkinbites.app/bite/$biteId';
  }
  
  // Track the share in analytics
  Future<void> _trackShare(String biteId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;
      
      // Update the user's share count
      await _firestore.collection('users').doc(user.uid).update({
        'shares': FieldValue.increment(1),
      });
      
      // Add to share history
      await _firestore.collection('users').doc(user.uid).collection('shares').add({
        'biteId': biteId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      
      // Update the bite's share count
      await _firestore.collection('bites').doc(biteId).update({
        'shareCount': FieldValue.increment(1),
      });
    } catch (e) {
      print('Error tracking share: $e');
    }
  }
  
  // Get user's share history
  Future<List<Map<String, dynamic>>> getShareHistory() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];
      
      final querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('shares')
          .orderBy('timestamp', descending: true)
          .get();
      
      final List<Map<String, dynamic>> shares = [];
      
      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final biteId = data['biteId'] as String;
        
        // Get bite details
        try {
          final biteDoc = await _firestore.collection('bites').doc(biteId).get();
          if (biteDoc.exists) {
            final biteData = biteDoc.data()!;
            shares.add({
              'id': doc.id,
              'biteId': biteId,
              'biteTitle': biteData['title'] ?? 'Unknown Bite',
              'timestamp': data['timestamp'],
              'snippetStart': data['snippetStart'],
              'snippetDuration': data['snippetDuration'],
              'message': data['message'],
            });
          }
        } catch (e) {
          print('Error getting bite details: $e');
        }
      }
      
      return shares;
    } catch (e) {
      print('Error getting share history: $e');
      return [];
    }
  }
}