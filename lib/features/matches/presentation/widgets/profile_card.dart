import 'package:flutter/material.dart';
import '../../domain/entities/potential_match_entity.dart';
import 'profile_details_sheet.dart';

enum SwipeDirection { left, right }

class ProfileCard extends StatefulWidget {
  final PotentialMatchEntity profile;
  final bool isTop;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;

  const ProfileCard({
    super.key,
    required this.profile,
    this.isTop = false,
    this.onSwipeLeft,
    this.onSwipeRight,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  double _dragDistance = 0;
  double _dragAngle = 0;
  int _currentPhotoIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: widget.isTop ? _onPanUpdate : null,
      onPanEnd: widget.isTop ? _onPanEnd : null,
      child: Transform.translate(
        offset: Offset(_dragDistance, 0),
        child: Transform.rotate(
          angle: _dragAngle,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Background image
                  Positioned.fill(
                    child: widget.profile.photoUrls.isNotEmpty
                        ? Image.network(
                            widget.profile.photoUrls[_currentPhotoIndex],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.person,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.person,
                              size: 100,
                              color: Colors.grey,
                            ),
                          ),
                  ),

                  // Photo indicators
                  if (widget.profile.photoUrls.length > 1)
                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      child: Row(
                        children: List.generate(
                          widget.profile.photoUrls.length,
                          (index) => Expanded(
                            child: Container(
                              height: 4,
                              margin: EdgeInsets.only(
                                right:
                                    index < widget.profile.photoUrls.length - 1
                                        ? 4
                                        : 0,
                              ),
                              decoration: BoxDecoration(
                                color: index == _currentPhotoIndex
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Swipe indicators
                  if (widget.isTop && _dragDistance != 0)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: _dragDistance > 0
                              ? Colors.green.withOpacity(0.3)
                              : Colors.red.withOpacity(0.3),
                        ),
                        child: Center(
                          child: Text(
                            _dragDistance > 0 ? 'LIKE' : 'NOPE',
                            style: TextStyle(
                              color:
                                  _dragDistance > 0 ? Colors.green : Colors.red,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Profile info
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${widget.profile.name}, ${widget.profile.age}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  _showProfileDetails(context);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.profile.location,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          if (widget.profile.bio.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              widget.profile.bio,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Invisible tap areas for photo navigation
                  if (widget.profile.photoUrls.length > 1) ...[
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 200,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: GestureDetector(
                        onTap: _previousPhoto,
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 200,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: GestureDetector(
                        onTap: _nextPhoto,
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragDistance += details.delta.dx;
      _dragAngle = _dragDistance / 1000;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dx;
    final distance = _dragDistance.abs();

    if (distance > 100 || velocity.abs() > 500) {
      if (_dragDistance > 0) {
        widget.onSwipeRight?.call();
      } else {
        widget.onSwipeLeft?.call();
      }
    }

    setState(() {
      _dragDistance = 0;
      _dragAngle = 0;
    });
  }

  void _previousPhoto() {
    if (_currentPhotoIndex > 0) {
      setState(() {
        _currentPhotoIndex--;
      });
    }
  }

  void _nextPhoto() {
    if (_currentPhotoIndex < widget.profile.photoUrls.length - 1) {
      setState(() {
        _currentPhotoIndex++;
      });
    }
  }

  void _showProfileDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfileDetailsSheet(profile: widget.profile),
    );
  }
}
