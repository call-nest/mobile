class Message{
  final String message;
  final String senderId;
  final String receiverId;
  final DateTime time;

  Message({required this.message, required this.senderId, required this.receiverId, required this.time});
}