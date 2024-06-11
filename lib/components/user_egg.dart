import 'package:flutter/material.dart';
import 'package:reciperescue_client/colors/colors.dart';
import 'package:reciperescue_client/models/user_model.dart';

class UserEgg extends StatefulWidget {
  final UserModel user;
  final VoidCallback onTap;

  const UserEgg({
    Key? key,
    required this.user,
    required this.onTap,
  }) : super(key: key);

  @override
  State<UserEgg> createState() => _UserEggState();
}

class _UserEggState extends State<UserEgg> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
        widget.onTap(); // Call the provided onTap callback
      },
      child: AnimatedContainer(
        margin: EdgeInsets.all(4.0),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
        decoration: BoxDecoration(
          color: _isSelected ? primary : myGrey[200],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 12),
              child: Align(
                alignment: Alignment.topCenter,
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: widget.user.image == null
                      ? const AssetImage('assets/images/logo.png')
                          as ImageProvider<Object>
                      : NetworkImage(widget.user.image ?? '')
                          as ImageProvider<Object>,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  maxLines: 2,
                  '${widget.user.firstName} ${widget.user.lastName}',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
