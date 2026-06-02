import 'dart:ui';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'prediction_result.dart';
import 'string_extensions.dart';

class SymptomSelectorScreen extends StatefulWidget {
  const SymptomSelectorScreen({super.key});

  @override
  State<SymptomSelectorScreen> createState() => _SymptomSelectorScreenState();
}

class _SymptomSelectorScreenState extends State<SymptomSelectorScreen> {
  List<String> allSymptoms = [];
  List<String> displayedSymptoms = [];
  List<String> selectedSymptoms = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSymptoms();
  }

  Future<void> _loadSymptoms() async {
    try {
      final symptoms = await ApiService.getSymptoms();
      setState(() {
        // Format symptom strings: "loss_of_taste" -> "Loss of taste"
        allSymptoms = symptoms;
        displayedSymptoms = symptoms;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading symptoms: $e')),
      );
    }
  }

  void _filterSymptoms(String query) {
    setState(() {
      displayedSymptoms = allSymptoms
          .where((s) => s.replaceAll('_', ' ').toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _submit() async {
    if (selectedSymptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one symptom')),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator(color: Color(0xFF00FFC2))),
    );

    try {
      final result = await ApiService.predictDisease(selectedSymptoms);
      Navigator.pop(context); // Close loading
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PredictionResultScreen(
            disease: result['disease'],
            confidence: result['confidence_score'],
            message: result['message'],
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  String _formatSymptom(String symptom) {
    return symptom.formatSymptom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('AI Diagnosis'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D0D15), Color(0xFF1A1A2E)],
          ),
        ),
        child: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF00FFC2)))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'What are your symptoms?',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    // Selected Symptoms Chips
                    if (selectedSymptoms.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        width: double.infinity,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: selectedSymptoms.map((s) {
                            return Chip(
                              label: Text(_formatSymptom(s)),
                              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                              deleteIconColor: const Color(0xFF00FFC2),
                              onDeleted: () {
                                setState(() {
                                  selectedSymptoms.remove(s);
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(color: Color(0xFF6C63FF)),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    
                    const SizedBox(height: 16),
                    
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _filterSymptoms,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Search symptoms...',
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search, color: Colors.white54),
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Available Symptoms List
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: displayedSymptoms.length,
                        itemBuilder: (context, index) {
                          final symptom = displayedSymptoms[index];
                          final isSelected = selectedSymptoms.contains(symptom);
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? const Color(0xFF6C63FF).withOpacity(0.1) 
                                  : Colors.white.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF00FFC2) : Colors.transparent,
                              ),
                            ),
                            child: ListTile(
                              title: Text(
                                _formatSymptom(symptom),
                                style: const TextStyle(color: Colors.white),
                              ),
                              trailing: isSelected 
                                  ? const Icon(Icons.check_circle, color: Color(0xFF00FFC2))
                                  : const Icon(Icons.add_circle_outline, color: Colors.white38),
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedSymptoms.remove(symptom);
                                  } else {
                                    selectedSymptoms.add(symptom);
                                  }
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    
                    // Submit Button
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: _submit,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFF00FFC2)],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00FFC2).withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'Predict Disease',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}


