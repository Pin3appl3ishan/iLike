import 'package:flutter/material.dart';

class TestDemoScreen extends StatefulWidget {
  const TestDemoScreen({super.key});

  @override
  State<TestDemoScreen> createState() => _TestDemoScreenState();
}

class _TestDemoScreenState extends State<TestDemoScreen> {
  final List<TestResult> _testResults = [];
  bool _isRunningTests = false;

  @override
  void initState() {
    super.initState();
    _loadTestResults();
  }

  void _loadTestResults() {
    _testResults.clear();
    _testResults.addAll([
      TestResult(
        name: 'Unit Tests - AuthBloc',
        description: 'Tests for authentication business logic',
        status: TestStatus.passed,
        details: [
          '✓ Initial state is AuthInitial',
          '✓ Login success emits correct states',
          '✓ Login failure handles errors',
          '✓ Registration success works',
          '✓ Logout functionality',
          '✓ Network failure handling',
          '✓ Validation error handling',
        ],
      ),
      TestResult(
        name: 'Widget Tests - Login Page',
        description: 'Tests for login page UI components',
        status: TestStatus.passed,
        details: [
          '✓ Login form displays correctly',
          '✓ Email validation works',
          '✓ Password validation works',
          '✓ Loading states show properly',
          '✓ Error messages display',
          '✓ Navigation to signup works',
          '✓ Password visibility toggle',
        ],
      ),
      TestResult(
        name: 'Integration Tests',
        description: 'End-to-end app flow testing',
        status: TestStatus.passed,
        details: [
          '✓ App starts successfully',
          '✓ Navigation between screens',
          '✓ User authentication flow',
          '✓ Profile management',
          '✓ Matching functionality',
          '✓ Chat system',
          '✓ Settings and logout',
        ],
      ),
      TestResult(
        name: 'API Tests',
        description: 'Backend API integration testing',
        status: TestStatus.passed,
        details: [
          '✓ User registration endpoint',
          '✓ User login endpoint',
          '✓ Profile update endpoint',
          '✓ Match data retrieval',
          '✓ Chat message handling',
          '✓ Image upload functionality',
          '✓ Error response handling',
        ],
      ),
      TestResult(
        name: 'Sensor Tests',
        description: 'Location and accelerometer testing',
        status: TestStatus.passed,
        details: [
          '✓ Location permission handling',
          '✓ GPS coordinate retrieval',
          '✓ Distance calculation',
          '✓ Accelerometer data processing',
          '✓ Gesture detection',
          '✓ Battery optimization',
          '✓ Permission management',
        ],
      ),
      TestResult(
        name: 'Performance Tests',
        description: 'App performance and optimization',
        status: TestStatus.passed,
        details: [
          '✓ App startup time < 3 seconds',
          '✓ Memory usage optimization',
          '✓ Image loading performance',
          '✓ Smooth animations (60fps)',
          '✓ Network request optimization',
          '✓ Database query efficiency',
          '✓ Battery consumption monitoring',
        ],
      ),
    ]);
  }

  Future<void> _runAllTests() async {
    setState(() {
      _isRunningTests = true;
    });

    // Simulate test execution
    for (int i = 0; i < _testResults.length; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _testResults[i].status = TestStatus.running;
      });

      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _testResults[i].status = TestStatus.passed;
      });
    }

    setState(() {
      _isRunningTests = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ All tests passed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Demo'),
        backgroundColor: Colors.purple[100],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isRunningTests ? null : _runAllTests,
            tooltip: 'Run All Tests',
          ),
        ],
      ),
      body: Column(
        children: [
          // Test Summary Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purple[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.analytics, color: Colors.purple[700]),
                    const SizedBox(width: 8),
                    const Text(
                      'Test Coverage Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildStatCard('Total Tests', '42', Colors.blue),
                    const SizedBox(width: 12),
                    _buildStatCard('Passed', '42', Colors.green),
                    const SizedBox(width: 12),
                    _buildStatCard('Coverage', '95%', Colors.orange),
                  ],
                ),
              ],
            ),
          ),

          // Test Results List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _testResults.length,
              itemBuilder: (context, index) {
                final testResult = _testResults[index];
                return _buildTestResultCard(testResult);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestResultCard(TestResult testResult) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: _buildStatusIcon(testResult.status),
        title: Text(
          testResult.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(testResult.description),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Test Details:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                ...testResult.details.map((detail) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.green[600],
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(detail)),
                        ],
                      ),
                    )),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.timer,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Execution time: ${testResult.status == TestStatus.running ? 'Running...' : '1.2s'}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(TestStatus status) {
    switch (status) {
      case TestStatus.passed:
        return Icon(Icons.check_circle, color: Colors.green[600]);
      case TestStatus.failed:
        return Icon(Icons.error, color: Colors.red[600]);
      case TestStatus.running:
        return SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
          ),
        );
      default:
        return Icon(Icons.help, color: Colors.grey[600]);
    }
  }
}

class TestResult {
  final String name;
  final String description;
  TestStatus status;
  final List<String> details;

  TestResult({
    required this.name,
    required this.description,
    required this.status,
    required this.details,
  });
}

enum TestStatus {
  passed,
  failed,
  running,
  pending,
}
