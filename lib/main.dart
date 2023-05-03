import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    // Enabled Riverpod for the entire application
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}

// Creating an infix operator
extension OptionalInfixAddition<T extends num> on T? {
  T? operator +(T? other) {
    final shadow = this ?? other;
    if (shadow != null) {
      return shadow + (other ?? 0) as T;
    } else {
      return null;
    }
  }
}

class Counter extends StateNotifier<int?> {
  Counter() : super(null);
  void increment() => state = state == null ? 1 : state + 1;
  // export the current state as a simple value
  int? get value => state;
}

// Creating a provider for it
final counterProvider = StateNotifierProvider<Counter, int?>(
  (ref) => Counter(),
);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // if you put your watch above your scaffold anytime it changes
    // entire build function is going to get called again #wasteful computing
    return Scaffold(
      appBar: AppBar(
        title: Consumer(
            builder: (context, ref, child) {
              final count = ref.watch(counterProvider);
              final text =
                  count == null ? 'Press the button' : count.toString();
              return Text(text);
            },
            child: const Text('Winter')),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
              onPressed: () {
                // calling the increment function
                // using ref to access your providers
                ref.read(counterProvider.notifier).increment();
                // ref.read just gets the current snapshot but doesn't listen unlike watch
              },
              child: const Text(
                'Increment Counter',
              ))
        ],
      ),
    );
  }
}
