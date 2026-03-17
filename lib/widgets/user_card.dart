import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String username;
  final String? profileImageUrl;
  final String? bio;
  final bool isFollowing;
  final VoidCallback onTap;
  final VoidCallback? onFollowTap;

  const UserCard({
    Key? key,
    required this.username,
    this.profileImageUrl,
    this.bio,
    this.isFollowing = false,
    required this.onTap,
    this.onFollowTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: profileImageUrl != null ? NetworkImage(profileImageUrl!) : null,
                child: profileImageUrl == null ? const Icon(Icons.person) : null,
              ),
              const SizedBox(height: 8),
              Text(
                username,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (bio != null) ...[
                const SizedBox(height: 4),
                Text(
                  bio!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 8),
              if (onFollowTap != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onFollowTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFollowing ? Colors.grey[300] : Colors.red,
                    ),
                    child: Text(
                      isFollowing ? 'Seguido' : 'Seguir',
                      style: TextStyle(
                        color: isFollowing ? Colors.black : Colors.white,
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
