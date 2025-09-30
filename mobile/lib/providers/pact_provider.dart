import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/pact.dart';
import '../services/api_service.dart';

class PactProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();
  
  List<Pact> _pacts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Pact> get pacts => _pacts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Pact> get activePacts => _pacts.where((pact) => !pact.isCompleted).toList();
  List<Pact> get completedPacts => _pacts.where((pact) => pact.isCompleted).toList();

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> loadPacts(String userId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Load from backend API only
      final List<Map<String, dynamic>> pactData = await ApiService.getUserPacts('created');
      _pacts = pactData.map((data) => Pact.fromJson(data)).toList();
    } catch (e) {
      _errorMessage = 'Failed to load pacts. Please try again.';
      debugPrint('Error loading pacts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPact({
    required String title,
    required String description,
    required String creatorId,
    required String recipientId,
    required String recipientName,
    required String recipientPhone,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Create pact using API service
      await ApiService.createPact(
        title: title,
        description: description,
        recipientId: recipientId,
        recipientName: recipientName,
        recipientPhone: recipientPhone,
      );

      // Refresh the pacts list
      await loadPacts(creatorId);
    } catch (e) {
      _errorMessage = 'Failed to create pact. Please try again.';
      debugPrint('Error creating pact: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> completePact(String pactId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _firestore.collection('pacts').doc(pactId).update({
        'isCompleted': true,
        'completedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final index = _pacts.indexWhere((pact) => pact.id == pactId);
      if (index != -1) {
        _pacts[index] = _pacts[index].copyWith(
          isCompleted: true,
          completedAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
    } catch (e) {
      _setError('Failed to complete pact. Please try again.');
      debugPrint('Error completing pact: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deletePact(String pactId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _firestore.collection('pacts').doc(pactId).delete();
      
      _pacts.removeWhere((pact) => pact.id == pactId);
    } catch (e) {
      _setError('Failed to delete pact. Please try again.');
      debugPrint('Error deleting pact: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get pacts by recipient (for incoming requests)
  Future<List<Pact>> getPactsByRecipient(String recipientId) async {
    try {
      final querySnapshot = await _firestore
          .collection('pacts')
          .where('recipientId', isEqualTo: recipientId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Pact.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('Error loading recipient pacts: $e');
      return [];
    }
  }

  // Real-time listener for pacts
  void startListeningToPacts(String userId) {
    _firestore
        .collection('pacts')
        .where('creatorId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _pacts = snapshot.docs
          .map((doc) => Pact.fromFirestore(doc))
          .toList();
      notifyListeners();
    });
  }
}
