import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../services/api_service.dart';

class ContactProvider extends ChangeNotifier {
  List<Contact> _contacts = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  String? _selectedRelationship;

  List<Contact> get contacts => _contacts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String? get selectedRelationship => _selectedRelationship;

  List<Contact> get filteredContacts {
    List<Contact> filtered = _contacts;
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((contact) =>
        contact.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        contact.phone.contains(_searchQuery)
      ).toList();
    }
    
    if (_selectedRelationship != null && _selectedRelationship!.isNotEmpty) {
      filtered = filtered.where((contact) =>
        contact.relationship == _selectedRelationship
      ).toList();
    }
    
    return filtered;
  }

  List<Contact> get contactsByRelationship {
    Map<String, List<Contact>> grouped = {};
    for (Contact contact in _contacts) {
      if (!grouped.containsKey(contact.relationship)) {
        grouped[contact.relationship] = [];
      }
      grouped[contact.relationship]!.add(contact);
    }
    return grouped.values.expand((x) => x).toList();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> loadContacts() async {
    try {
      _isLoading = true;
      _errorMessage = null;

      final List<Map<String, dynamic>> contactData = await ApiService.getContacts();
      _contacts = contactData.map((data) => Contact.fromJson(data)).toList();
    } catch (e) {
      _setError('Failed to load contacts. Please try again.');
      debugPrint('Error loading contacts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchContacts(String query) async {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> filterByRelationship(String? relationship) async {
    _selectedRelationship = relationship;
    notifyListeners();
  }

  Future<Contact?> getContactById(String contactId) async {
    try {
      final contactData = await ApiService.getContactById(contactId);
      if (contactData != null) {
        return Contact.fromJson(contactData);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting contact: $e');
      return null;
    }
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedRelationship = null;
    notifyListeners();
  }

  List<String> get availableRelationships {
    return _contacts
        .map((contact) => contact.relationship)
        .toSet()
        .toList()
        ..sort();
  }
}
