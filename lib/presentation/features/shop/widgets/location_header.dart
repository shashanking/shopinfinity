import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../features/profile/providers/profile_provider.dart';

class LocationHeader extends ConsumerWidget {
  const LocationHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Location Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              const SizedBox(width: 4),
              const Text(
                'Currently delivering in Patna, Bihar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDarkGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // User and Cart Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => context.push('/settings'),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.transparent,
                      radius: 16,
                      child: Icon(
                        Icons.person_outline_outlined,
                        size: 20,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, ${profile.when(
                            data: (data) => data.name,
                            loading: () => 'Guest',
                            error: (_, __) => 'Guest',
                          )}',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDarkGrey,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      onPressed: () => GoRouter.of(context).push('/cart'),
                      icon: const Icon(Icons.shopping_cart_outlined),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
