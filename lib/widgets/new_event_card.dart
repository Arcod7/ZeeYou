import 'package:flutter/material.dart';
import 'package:zeeyou/models/event.dart';

class NewEventCard extends StatelessWidget {
  const NewEventCard({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Ink(
      height: 100,
      width: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (ctx) => const ChatScreen()));
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: event.color,
                    ),
                    child: const Center(
                      child: Text(
                        'Dimanche\n7\nMai',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Anniversaire',
                          style: TextStyle(color: Colors.grey)),
                      Text(
                        event.title,
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text('Organisé par ${event.organizedBy}',
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Icon(
                  Icons.pool,
                  color: event.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
