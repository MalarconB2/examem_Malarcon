class ProviderModel {
  final int providerId;
  final String providerName;
  final String providerLastName;
  final String providerMail;
  final String providerState;

  ProviderModel({
    required this.providerId,
    required this.providerName,
    required this.providerLastName,
    required this.providerMail,
    required this.providerState,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      providerId: json['providerid'] as int,
      providerName: json['provider_name'] as String,
      providerLastName: json['provider_last_name'] as String,
      providerMail: json['provider_mail'] as String,
      providerState: json['provider_state'] as String,
    );
  }
}
