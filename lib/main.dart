import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Animations')),
        body: ListView(
          children: const [
            TestScaleWithoutAnimation(),
            // Explicit Animations
            TestScaleWithAnimation(),
            TestCustomPainter(),
            TestAnimatedWidget(),
            TestScaleTransition(),
            TestAnimatedBuilder(),
            // Implicit Animations
            TestTweenAnimationBuilder(),
            TestAnimatedScale(),
          ],
        ),
      ),
    );
  }
}

class MyCircle extends StatelessWidget {
  const MyCircle({Key? key, required this.color}) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 4.0),
        shape: BoxShape.circle,
      ),
    );
  }
}

// without animation

class TestScaleWithoutAnimation extends StatefulWidget {
  const TestScaleWithoutAnimation({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TestScaleWithoutAnimationState();
  }
}

class TestScaleWithoutAnimationState extends State<TestScaleWithoutAnimation> {
  var scale = 1.0;

  void toggle() {
    setState(() {
      scale = scale == 1.0 ? 0.5 : 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(8),
      onTap: toggle,
      title: Transform.scale(
        scale: scale,
        child: const MyCircle(color: Colors.black),
      ),
    );
  }
}

// explicit animation using addListener and setState

class TestScaleWithAnimation extends StatefulWidget {
  const TestScaleWithAnimation({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TestScaleWithAnimationState();
  }
}

class TestScaleWithAnimationState extends State<TestScaleWithAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  void toggle() {
    if (controller.isDismissed) {
      controller.forward();
    } else if (controller.isCompleted) {
      controller.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    animation = Tween<double>(begin: 1.0, end: 0.5).animate(controller);
    animation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(8),
      onTap: toggle,
      title: Transform.scale(
        scale: animation.value,
        child: const MyCircle(color: Colors.red),
      ),
    );
  }
}

// explicit animation using CustomPainter

class TestCustomPainter extends StatefulWidget {
  const TestCustomPainter({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TestCustomPainterState();
  }
}

class TestCustomPainterState extends State<TestCustomPainter>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  void toggle() {
    if (controller.isDismissed) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    animation = Tween<double>(begin: 1.0, end: 0.5).animate(controller);
    animation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(8),
      onTap: toggle,
      title: MyPaintedCircle(scale: animation.value),
    );
  }
}

class MyPaintedCircle extends StatelessWidget {
  const MyPaintedCircle({Key? key, required this.scale}) : super(key: key);

  final double scale;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Center(
        child: CustomPaint(
          painter: MyPainter(
            radius: 50.0 * scale,
            myPaint: Paint()
              ..color = Colors.orange
              ..strokeWidth = 4.0
              ..style = PaintingStyle.stroke,
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  MyPainter({required this.radius, required this.myPaint});

  final double radius;
  final Paint myPaint;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset.zero, radius, myPaint);
  }

  @override
  bool shouldRepaint(covariant MyPainter oldDelegate) {
    return oldDelegate.radius != radius;
  }
}

// explicit animation using AnimatedWidget

class TestAnimatedWidget extends StatefulWidget {
  const TestAnimatedWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TestAnimatedWidgetState();
  }
}

class TestAnimatedWidgetState extends State<TestAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  void toggle() {
    if (controller.isDismissed) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    animation = Tween<double>(begin: 1.0, end: 0.5).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(8),
      onTap: toggle,
      title: MyAnimatedScale(
        animation: animation,
        child: const MyCircle(color: Colors.amber),
      ),
    );
  }
}

class MyAnimatedScale extends AnimatedWidget {
  const MyAnimatedScale({
    Key? key,
    required Animation<double> animation,
    required this.child,
  }) : super(key: key, listenable: animation);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Transform.scale(scale: animation.value, child: child);
  }
}

// explicit animation using ScaleTransition

class TestScaleTransition extends StatefulWidget {
  const TestScaleTransition({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TestScaleTransitionState();
  }
}

class TestScaleTransitionState extends State<TestScaleTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  void toggle() {
    if (controller.isDismissed) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    animation = Tween<double>(begin: 1.0, end: 0.5).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(8),
      onTap: toggle,
      title: ScaleTransition(
        scale: animation,
        child: const MyCircle(color: Colors.green),
      ),
    );
  }
}

// explicit animation using AnimatedBuilder

class TestAnimatedBuilder extends StatefulWidget {
  const TestAnimatedBuilder({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TestAnimatedBuilderState();
  }
}

class TestAnimatedBuilderState extends State<TestAnimatedBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  void toggle() {
    if (controller.isDismissed) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    animation = Tween<double>(begin: 1.0, end: 0.5).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(8),
      onTap: toggle,
      title: MyScaleTransition(
        animation: animation,
        child: const MyCircle(color: Colors.blue),
      ),
    );
  }
}

class MyScaleTransition extends StatelessWidget {
  const MyScaleTransition({
    Key? key,
    required this.animation,
    required this.child,
  }) : super(key: key);

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(scale: animation.value, child: child);
      },
      child: child,
    );
  }
}

// implicit animation using TweenAnimationBuilder

class TestTweenAnimationBuilder extends StatefulWidget {
  const TestTweenAnimationBuilder({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TestTweenAnimationBuilderState();
  }
}

class TestTweenAnimationBuilderState extends State<TestTweenAnimationBuilder> {
  var begin = 1.0;
  var end = 1.0;

  void toggle() {
    setState(() {
      if (end == 1.0) {
        begin = 1.0;
        end = 0.5;
      } else {
        begin = 0.5;
        end = 1.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(8),
      onTap: toggle,
      title: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: begin, end: end),
        duration: const Duration(seconds: 1),
        builder: (context, scale, child) {
          return Transform.scale(scale: scale, child: child);
        },
        child: const MyCircle(color: Colors.indigo),
      ),
    );
  }
}

// implicit animation using AnimatedScale

class TestAnimatedScale extends StatefulWidget {
  const TestAnimatedScale({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TestAnimatedScaleState();
  }
}

class TestAnimatedScaleState extends State<TestAnimatedScale> {
  var scale = 1.0;

  void toggle() {
    setState(() {
      scale = scale == 1.0 ? 0.5 : 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(8),
      onTap: toggle,
      title: AnimatedScale(
        child: const MyCircle(color: Colors.purple),
        duration: const Duration(seconds: 1),
        scale: scale,
      ),
    );
  }
}