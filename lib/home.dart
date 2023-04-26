import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:koins/koin_model.dart';
import 'package:koins/koin_widget.dart';
import 'package:koins/strings.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Koin> koins = [];
  int total = 100;
  ScrollController controller = ScrollController();

  final effects = [
    // FadeEffect(duration: 300.ms, curve: Curves.easeOut),
    // SlideEffect(begin: Offset(0, -0.5)),
    // ScaleEffect(curve: Curves.elasticOut, duration: 1000.ms),
    FlipEffect(curve: Curves.elasticOut, duration: 1500.ms),
  ];

  final styleButton = const TextStyle(
    fontSize: 16,
    fontFamily: Strings.fontFamilyMontserrat,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
  final styleText = const TextStyle(
    fontSize: 20,
    fontFamily: Strings.fontFamilyMontserrat,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
  final styleTitle = const TextStyle(
    fontSize: 32,
    fontFamily: Strings.fontFamilyMontserrat,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
  final styleDialog = const TextStyle(
    fontSize: 24,
    fontFamily: Strings.fontFamilyMontserrat,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void addKoin(int value) {
    setState(() {
      koins.add(Koin(value: value));
    });
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      ),
    );
  }

  void removeKoin(int index) {
    setState(() {
      koins.removeAt(index);
    });
  }

  void clearKoins() {
    setState(() {
      koins.clear();
    });
  }

  void checkResult() async {
    var sum = 0;
    koins.forEach((e) {
      sum = sum + e.value;
    });
    String icon;
    String message;
    bool success;
    if (sum == total) {
      icon = '👍';
      message = Strings.messageSuccess;
      success = true;
    } else {
      icon = '😕';
      message = Strings.messageFail;
      success = false;
    }

    var result = await showDialog(
      context: context,
      builder: (context) => Dialog(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).pop(),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  icon,
                  style: const TextStyle(fontSize: 72),
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: styleDialog,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (success) clearKoins();
  }

  String taskTitle() {
    if (total < 100) return '$total ${Strings.cent5}';
    if (total == 100) return '${total ~/ 100} ${Strings.curr1}';
    if (total > 100 && total < 500) return '${total ~/ 100} ${Strings.curr2}';
    return '${total ~/ 100} ${Strings.curr5}';
  }

  void showTask() {
    buildWidget(int value) => InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.of(context).pop();
            setState(() {
              total = value;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                strokeAlign: BorderSide.strokeAlignInside,
                width: 2,
                color: value == total
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
              ),
              color:
                  Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
            ),
            child: Column(
              children: [
                Text(
                  value >= 100 ? (value ~/ 100).toString() : value.toString(),
                  style: styleTitle,
                ),
                Text(
                  value >= 100 ? Strings.currShort : Strings.centShort,
                  style: styleText.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
        );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Strings.labelTask,
                style: styleDialog,
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  buildWidget(10),
                  buildWidget(20),
                  buildWidget(50),
                  buildWidget(100),
                  buildWidget(200),
                  buildWidget(300),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  Text(
                    Strings.labelTitle,
                    textAlign: TextAlign.center,
                    style: styleTitle,
                  ),
                  const SizedBox(height: 8),
                  FilledButton.tonal(
                    onPressed: showTask,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 6),
                          Text(
                            taskTitle(),
                            style: const TextStyle(
                              fontSize: 32,
                              fontFamily: Strings.fontFamilyMontserrat,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                koins.isNotEmpty
                    ? SingleChildScrollView(
                        controller: controller,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Center(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              runSpacing: 16,
                              spacing: 16,
                              children: koins
                                  .map(
                                    (e) => Animate(
                                      effects: effects,
                                      child: KoinWidget(
                                        value: e.value,
                                        onTap: () =>
                                            removeKoin(koins.indexOf(e)),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                textAlign: TextAlign.center,
                                Strings.labelHint,
                                style: styleText,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              '👇',
                              style: TextStyle(fontSize: 72),
                            )
                                .animate(
                                    onPlay: (controller) =>
                                        controller.repeat(reverse: false))
                                .slideY(
                                  begin: 0,
                                  end: 0.1,
                                  duration: 1.seconds,
                                  curve: Curves.easeOut,
                                )
                                .then()
                                .slideY(
                                  begin: 0.1,
                                  end: 0.0,
                                  duration: 1.seconds,
                                  curve: Curves.easeOut,
                                )
                          ],
                        ),
                      ).animate().fadeIn(
                          delay: 500.ms,
                          duration: 1.seconds,
                        ),
                if (koins.isNotEmpty)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FilledButton.tonalIcon(
                            icon: const Icon(Icons.clear),
                            onPressed: clearKoins,
                            label: const Text(Strings.labelClear),
                          ),
                          const SizedBox(width: 16),
                          FilledButton.tonalIcon(
                            icon: const Icon(Icons.check),
                            onPressed: checkResult,
                            label: const Text(Strings.labelCheckResult),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32),
            alignment: Alignment.center,
            color: Colors.black,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: AnimateList(
                  interval: 150.ms,
                  effects: effects,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: KoinWidget(
                        value: 1,
                        onTap: () => addKoin(1),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: KoinWidget(
                        value: 2,
                        onTap: () => addKoin(2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: KoinWidget(
                        value: 5,
                        onTap: () => addKoin(5),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: KoinWidget(
                        value: 10,
                        onTap: () => addKoin(10),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: KoinWidget(
                        value: 25,
                        onTap: () => addKoin(25),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: KoinWidget(
                        value: 50,
                        onTap: () => addKoin(50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
