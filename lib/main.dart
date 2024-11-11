import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: 'Mabrookul',  // Title of the app
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:  MyHomePage(),  // Main home page widget
    );
  }
}

class MyHomePage extends StatelessWidget {
   MyHomePage({super.key});

    // Initialize the data

    List<Group> groups = [
      Group(code: 'BO', name: 'Bombaywalas', id: 1, members: [
        Member(name: 'Taha Murtaza', id: 1, code: 'TA', events: [
          Event(date: DateTime(2008, 11, 14,), type: "Birthday", id: 1),
           Event(date: DateTime(2024, 10, 28,), type: "Japan Trip", id: 2),
        ]),
        Member(name: 'Abbas Hussain', id: 2, code: 'AB', events: [
          Event(date: DateTime(2023, 11, 12,), type: "Birthday", id: 3),
        ]),
         Member(name: 'Hussain Murtaza', id: 3, code: 'HU', events: [
          Event(date: DateTime(1996, 09, 24,), type: "Birthday", id: 4),
        ]),
      ]),
        Group(code: 'MA', name: 'Mafias', id: 2, members: [
        Member(name: 'Taha Murtaza', id: 1, code: 'TA', events: [
          Event(date: DateTime(2008, 11, 14,), type: "Birthday", id: 1),
           Event(date: DateTime(2024, 10, 28,), type: "Japan Trip", id: 2),
        ]),
            Member(name: 'Jawaharlal Nehru', id: 1, code: 'TA', events: [
          Event(date: DateTime(1950, 11, 14,), type: "Birthday", id: 1),
        ]),
         Member(name: 'Hussain Murtaza', id: 3, code: 'HU', events: [
          Event(date: DateTime(1996, 09, 24,), type: "Birthday", id: 4),
        ]),
      ]),
        Group(code: 'OL', name: 'Oldly Weds', id: 3, members: [
         Member(name: 'Hussain Murtaza', id: 3, code: 'HU', events: [
          Event(date: DateTime(1996, 09, 24,), type: "Birthday", id: 4),
        ]),
      ])
    ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Mabrookul!'),  // AppBar with title
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {

          Group group = groups[index];

          // Find the next event across all groups
           List<MemberEvent> nextMemberEvents = findNextEventForGroup(group);
          
          var days, years, eventName;
               

          if(nextMemberEvents.length>0) {
            // DateTime nextEventDate = getNextEventDate(nextEvent.date);
            days = calculateDaysUntilNextEvent(nextMemberEvents[0].event.date);
            eventName='';
   
            nextMemberEvents.forEach((memberEvent){
              years = calculateYearsSinceEvent(memberEvent.event.date);
              eventName = '$eventName ${memberEvent.member.name} ${years} ${memberEvent.event.type}';
            });
          } 

          return ListTile(
            leading: CircleAvatar(
              radius: 24,
              child: Text(group.code),
            ),
              title: Text(group.name),
              subtitle: Text(eventName),
              trailing: SizedBox(
                width: 48,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('${days}', style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),),
                    Text('days')
                  ],
                ),
              )
          );
        },
        itemCount: groups.length,
      )
    );
  }
}



class Group {
  int id;
  String code;
  String name;
  List<Member> members;

  Group({required this.id, required this.name, required this.code, required this.members});

}

class Member {
  int id;
  String code;
  String name;
  List<Event> events;

  Member({required this.id, required this.name, required this.code, required this.events});
}


class Event {
  int id;
  DateTime date;
  String type;

  Event({required this.id, required this.type, required this.date});
} 


class MemberEvent<Member, Event> {
  final Member member;
  final Event event;

  MemberEvent(this.member, this.event); // Constructor that initializes the fields
}

DateTime getNextEventDate(DateTime eventDate) { // 14 11 2008
  DateTime currentDate = DateTime.now(); // 11 11 2024
  
  // Check if the event has already occurred this year 14 11 2024
  DateTime nextEvent = DateTime(currentDate.year, eventDate.month, eventDate.day);

  // If the event has passed this year, set the next event to next year
  if (nextEvent.isBefore(currentDate)) {
    nextEvent = DateTime(currentDate.year + 1, eventDate.month, eventDate.day);
  }

  return nextEvent;
}

int calculateDaysUntilNextEvent(DateTime eventDate) {
  DateTime nextEvent = getNextEventDate(eventDate);

  // Calculate the duration in days
  Duration difference = nextEvent.difference(DateTime.now());
  return difference.inDays + 1;
}

int calculateYearsSinceEvent(DateTime eventDate) {
  DateTime nextEvent = getNextEventDate(eventDate);

  return nextEvent.year - eventDate.year;
}

List<MemberEvent> findNextEventForGroup(Group group) {

    List<MemberEvent> nextMemberEvents = []; 

    // Collect all events in the group
    List<MemberEvent> allMemberEvents = [];
    for (var member in group.members) {
      for (var event in member.events) {
        allMemberEvents.add(MemberEvent(member, event));
      }
    }

    // Find the earliest upcoming event date
    DateTime now = DateTime.now();
    DateTime? nextEventDate;

    for (var memberEvent in allMemberEvents) {
      if ((nextEventDate == null || getNextEventDate(memberEvent.event.date).isBefore(nextEventDate))) {
        nextEventDate = getNextEventDate(memberEvent.event.date);
      }
    }

    // Collect all events on the nextEventDate
    if (nextEventDate != null) {
      nextMemberEvents = allMemberEvents.where((memberEvent) => getNextEventDate(memberEvent.event.date).difference(nextEventDate!).inDays == 0).toList();
    }

    return nextMemberEvents;
}


