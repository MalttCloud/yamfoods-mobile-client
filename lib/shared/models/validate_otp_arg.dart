/// Arguments passed to validate OTP screen.
class ValidateOtpArg {
  final String phoneNumber;
  final bool isDeleteAccountFlow;

  const ValidateOtpArg({
    required this.phoneNumber,
    this.isDeleteAccountFlow = false,
  });
}
