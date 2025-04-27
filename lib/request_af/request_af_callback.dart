class RequestAfCallback{
  final void Function() startRequestAf;
  final void Function(bool isB) requestSuccess;
  final void Function() firstRequestAfB;
  final void Function() startAfSuccess;
  final void Function(int code,String msg) startAfFail;

  const RequestAfCallback({
    required this.startRequestAf,
    required this.requestSuccess,
    required this.firstRequestAfB,
    required this.startAfSuccess,
    required this.startAfFail,
  });
}