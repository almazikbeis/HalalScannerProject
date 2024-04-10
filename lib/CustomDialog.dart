import 'package:flutter/material.dart';

class CustomDialog extends StatefulWidget {
  final String title;
  final String content;
  final bool isHalal;
  final VoidCallback onClose;

  const CustomDialog({
    required this.title,
    required this.content,
    required this.isHalal,
    required this.onClose,
  });

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.greenAccent,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0, 10),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              widget.title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Text(
              widget.content,
              style: TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 22),
            widget.isHalal
                ? _buildHalalAnimation()
                : _buildHaramAnimation(),
            SizedBox(height: 22),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: widget.onClose,
                child: Text(
                  'Close',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHalalAnimation() {
    return Container(
      width: 100,
      height: 100,
      child: Center(
        child: Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 80,
        ),
      ),
    );
  }

  Widget _buildHaramAnimation() {
    return Container(
      width: 100,
      height: 100,
      child: Icon(
        Icons.block_rounded,
        color: Colors.red,
          size: 80,
      ),
    );
  }
}
