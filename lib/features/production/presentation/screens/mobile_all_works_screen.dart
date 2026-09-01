import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:gestion_integral_jyc/features/production/presentation/widgets/work_card.dart';

class MobileAllWorksScreen extends ConsumerWidget {
  final List<WorkEntity> works;

  const MobileAllWorksScreen({super.key, required this.works});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      itemBuilder: (context, index) {
        return WorkCard(work: works[index]);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemCount: works.length,
    );
  }
}
