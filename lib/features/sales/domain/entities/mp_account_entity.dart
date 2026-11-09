class MpAccountEntity {
  final bool isConnected;
  final String? nickname;
  final bool needsReconnection;
  final DateTime? lastSync;

  const MpAccountEntity({
    required this.isConnected,
    this.nickname,
    this.needsReconnection = false,
    this.lastSync,
  });

  const MpAccountEntity.disconnected() : this(isConnected: false);
}
