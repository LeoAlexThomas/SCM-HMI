class CustomerDetailsResponse {
  final String college;
  final String department;
  final String policy;
  final String policyNo;
  final String machineNo;
  final bool isWarrentyExpired;

  CustomerDetailsResponse({
    this.college,
    this.department,
    this.policy,
    this.policyNo,
    this.machineNo,
    this.isWarrentyExpired,
  });
}
