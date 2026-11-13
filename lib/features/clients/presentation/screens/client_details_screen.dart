import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';
import 'package:gestion_integral_jyc/core/domain/entities/product_line_item_entity.dart';
import 'package:gestion_integral_jyc/core/enums/work_state.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/client_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/date_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/line_item_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/return_screen_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/summary_card.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/features/clients/presentation/providers/client_history_provider.dart';
import 'package:gestion_integral_jyc/features/clients/presentation/providers/client_provider.dart';
import 'package:gestion_integral_jyc/features/clients/presentation/widgets/client_sales_history.dart';
import 'package:gestion_integral_jyc/features/clients/presentation/widgets/client_works_history.dart';
import 'package:gestion_integral_jyc/features/clients/presentation/widgets/month_filter_field.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:go_router/go_router.dart';

class ClientDetailsScreen extends ConsumerStatefulWidget {
  final ClientEntity client;

  const ClientDetailsScreen({super.key, required this.client});

  @override
  ConsumerState<ClientDetailsScreen> createState() =>
      _ClientDetailsScreenState();
}

class _ClientDetailsScreenState extends ConsumerState<ClientDetailsScreen> {
  final _searchController = TextEditingController();

  String _query = '';

  DateTime? _month;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clientId = widget.client.id;
    if (clientId == null) {
      return const Scaffold(
        body: Center(child: Text('Cliente sin identificador.')),
      );
    }

    final client =
        ref
            .watch(clientProvider)
            .value
            ?.where((c) => c.id == clientId)
            .firstOrNull ??
        widget.client;

    final salesAsync = ref.watch(clientSalesProvider(clientId));
    final worksAsync = ref.watch(clientWorksProvider(clientId));

    final monthSales = (salesAsync.value ?? [])
        .where((s) => _matchesMonth(s.date))
        .toList();
    final monthWorks = (worksAsync.value ?? [])
        .where((w) => _matchesMonth(w.creationDate))
        .toList();

    final filteredSales = monthSales
        .where((s) => _matchesQuery('vta-${s.id}', s.items))
        .toList();
    final filteredWorks = monthWorks
        .where((w) => _matchesQuery('trb-${w.id}', w.items))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.surface,

      body: DefaultTabController(
        length: 2,

        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                  bottom: 8,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    ReturnScreenHeader(
                      title: client.fullName,
                      subtitle:
                          '${client.formattedDocument} · ${client.displayPhone}',
                      additionalSubtitle: client.hasNotes
                          ? client.additionalNotes
                          : null,
                      returnLabel: "Volver a Clientes",
                      returnUri: "/clients",
                    ),

                    const SizedBox(height: 24),

                    _buildSummary(
                      sales: monthSales,
                      works: monthWorks,
                      isLoading: salesAsync.isLoading || worksAsync.isLoading,
                    ),

                    const SizedBox(height: 24),

                    _buildFilters(context),
                  ],
                ),
              ),
            ),

            SliverAppBar(
              pinned: true,
              backgroundColor: AppColors.surface,
              forceElevated: innerBoxIsScrolled,
              automaticallyImplyLeading: false,
              toolbarHeight: 0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),

                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),

                  child: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    dividerColor: AppColors.outline,

                    tabs: [
                      Tab(text: "Ventas (${filteredSales.length})"),
                      Tab(text: "Trabajos (${filteredWorks.length})"),
                    ],
                  ),
                ),
              ),
            ),
          ],

          body: TabBarView(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(24),

                child: salesAsync.when(
                  data: (_) => ClientSalesHistory(
                    sales: filteredSales,
                    emptyMessage: _emptyMessage(
                      'ventas',
                      'Este cliente no tiene ventas registradas.',
                    ),
                    onOpen: (sale) => _openSale(clientId, sale),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(child: Text('Error: $error')),
                ),
              ),

              SingleChildScrollView(
                padding: const EdgeInsets.all(24),

                child: worksAsync.when(
                  data: (_) => ClientWorksHistory(
                    works: filteredWorks,
                    emptyMessage: _emptyMessage(
                      'trabajos',
                      'Este cliente no tiene trabajos registrados.',
                    ),
                    onOpen: (work) => _openWork(clientId, work),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(child: Text('Error: $error')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummary({
    required List<SaleEntity> sales,
    required List<WorkEntity> works,
    required bool isLoading,
  }) {
    final periodLabel = _month == null
        ? "En todo el historial"
        : "En ${_month!.monthYearLabel}";

    final totalSold = sales.fold(0.0, (sum, s) => sum + s.finalAmount);
    final unpaidSales = sales.where((s) => !s.isPaid).toList();
    final unpaidAmount = unpaidSales.fold(0.0, (sum, s) => sum + s.finalAmount);
    final activeWorks = works
        .where((w) => w.actualState != WorkState.finalizado)
        .length;

    String value(String text) => isLoading ? '-' : text;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.isMobileLayout;
        final cardWidth = isMobile
            ? constraints.maxWidth
            : (constraints.maxWidth - 32) / 3;

        final cards = [
          SummaryCard(
            width: cardWidth,
            title: "VENTAS",
            value: value('\$${totalSold.toStringAsFixed(2)}'),
            subtitle: "${sales.length} ventas · $periodLabel",
            icon: Icons.point_of_sale_outlined,
            iconColor: AppColors.primary,
          ),
          SummaryCard(
            width: cardWidth,
            title: "TRABAJOS",
            value: value('${works.length}'),
            subtitle: "$activeWorks en curso · $periodLabel",
            icon: Icons.handyman_outlined,
            iconColor: AppColors.primary,
          ),
          SummaryCard(
            width: cardWidth,
            title: "PENDIENTE DE PAGO",
            value: value('\$${unpaidAmount.toStringAsFixed(2)}'),
            subtitle: "${unpaidSales.length} ventas sin pagar",
            icon: Icons.warning_amber_outlined,
            iconColor: unpaidSales.isEmpty
                ? AppColors.onBackground
                : AppColors.deadlineRed,
          ),
        ];

        return Wrap(spacing: 16, runSpacing: 16, children: cards);
      },
    );
  }

  Widget _buildFilters(BuildContext context) {
    final search = TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _query = value.trim()),
      decoration: InputDecoration(
        hintText: "Buscar producto, descripción, SKU o ID (VTA-12, TRB-5)",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _query.isEmpty
            ? null
            : IconButton(
                tooltip: "Limpiar",
                icon: const Icon(Icons.close),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _query = '');
                },
              ),
      ),
    );

    final monthFilter = MonthFilterField(
      selected: _month,
      onChanged: (month) => setState(() => _month = month),
    );

    if (context.isMobileLayout) {
      return Column(
        children: [search, const SizedBox(height: 12), monthFilter],
      );
    }

    return Row(
      children: [
        Expanded(child: search),
        const SizedBox(width: 16),
        SizedBox(width: 340, child: monthFilter),
      ],
    );
  }

  bool _matchesMonth(DateTime date) =>
      _month == null || date.isSameMonth(_month!);

  bool _matchesQuery(String idText, List<ProductLineItemEntity> items) {
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    return idText.contains(q) ||
        items.any((item) => item.searchableText.contains(q));
  }

  String _emptyMessage(String label, String noneMessage) {
    if (_query.isNotEmpty || _month != null) {
      return "No se encontraron $label con estos filtros.";
    }
    return noneMessage;
  }

  Future<void> _openSale(int clientId, SaleEntity sale) async {
    await context.push('/clients/sale', extra: sale);
    if (!mounted) return;
    ref.invalidate(clientSalesProvider(clientId));
  }

  Future<void> _openWork(int clientId, WorkEntity work) async {
    await context.push('/clients/work', extra: work);
    if (!mounted) return;
    ref.invalidate(clientWorksProvider(clientId));
    ref.invalidate(clientSalesProvider(clientId));
  }
}
