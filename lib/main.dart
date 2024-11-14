import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


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
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => GroupEventListPage(groupId: group.id)));
              },
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


class GroupEventListPage extends StatelessWidget {
  int groupId;

   GroupEventListPage({super.key, required this.groupId});

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
            Member(name: 'Jawaharlal Nehru', id: 4, code: 'TA', events: [
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

      var currentGroup = groups.firstWhere((group) => group.id == groupId);
      

    return Scaffold(
      appBar: AppBar(
        title: Text(currentGroup.name),  // AppBar with title
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          
          Member member = currentGroup.members[index];

          // Find the next event across all groups
           List<Event> nextMemberEvents = findNextEventForMember(currentGroup, member);
          
          var days, years, eventName;
               

          if(nextMemberEvents.length>0) {
            // DateTime nextEventDate = getNextEventDate(nextEvent.date);
            days = calculateDaysUntilNextEvent(nextMemberEvents[0].date);
            eventName='';
   
            nextMemberEvents.forEach((memberEvent){
              years = calculateYearsSinceEvent(memberEvent.date);
              eventName = '$eventName ${member.name} ${years} ${memberEvent.type}';
            });
          } 

          return ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> MemberEventListPage(memberId: member.id)));
            },
            leading: CircleAvatar(
              radius: 24,
              child: Text(member.code),
            ),
              title: Text(member.name),
              subtitle: Text(eventName),
              trailing: SizedBox(
                width: 48,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('$days', style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),),
                    Text('days')
                  ],
                ),
              )
          );
        },
        itemCount: currentGroup.members.length,
      )
    );
  }
}



class MemberEventListPage extends StatelessWidget {
  int memberId;

   MemberEventListPage({super.key, required this.memberId});

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
            Member(name: 'Jawaharlal Nehru', id: 4, code: 'TA', events: [
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
    Member currentMember = getCurrentMember(groups, memberId);
    List<Event> events = getEventsByMember(groups, memberId);

    return Scaffold(
      appBar: AppBar(
        title: Text(currentMember.name),  // AppBar with title
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          
          Event event = events[index];

          return ListTile(
            leading: CircleAvatar(
              radius: 24,
              child: Text(event.type.substring(0,2).toUpperCase()),
            ),
              title: Text(event.type),
              subtitle: Text(DateFormat('d MMMM yyyy').format(event.date)),
              trailing: SizedBox(
                width: 48,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('${event.daysToNextOccurrence()}', style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),),
                    Text('days')
                  ],
                ),
              )
          );
        },
        itemCount: events.length,
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


  int daysToNextOccurrence() {
    DateTime now = DateTime.now();

    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime nextOccurrence = DateTime(now.year, date.month, date.day);

    // If the event date this year has already passed, set it to the next year
    if (nextOccurrence.isBefore(today)) {
      nextOccurrence = DateTime(today.year + 1, date.month, date.day);
    }

    // If the event is today, return 0
    return nextOccurrence.difference(today).inDays;
  }
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




List<Event> findNextEventForMember(Group group, Member member) {

    List<Event> nextMemberEvents = []; 

    // Collect all events in the group
    List<Event> allMemberEvents = [];
    for (var m in group.members) {
      if(m.id == member.id) {
      for (var event in m.events) {
        allMemberEvents.add(event);
      }
      }
      
    }

    // Find the earliest upcoming event date
    DateTime now = DateTime.now();
    DateTime? nextEventDate;

    for (var memberEvent in allMemberEvents) {
      if ((nextEventDate == null || getNextEventDate(memberEvent.date).isBefore(nextEventDate))) {
        nextEventDate = getNextEventDate(memberEvent.date);
      }
    }

    // Collect all events on the nextEventDate
    if (nextEventDate != null) {
      nextMemberEvents = allMemberEvents.where((memberEvent) => getNextEventDate(memberEvent.date).difference(nextEventDate!).inDays == 0).toList();
    }

    return nextMemberEvents;
}


Member getCurrentMember(List<Group> groups, int memberId) {
  late Member currentMember;
  for (Group group in groups) {
    for (Member member in group.members) {
      if (member.id == memberId) {
         currentMember = member;
         break;
      }
    }
  }
  return currentMember;
}

List<Event> getEventsByMember(List<Group> groups, int memberId) {
   Map<int, Event> eventMap = {};
  for (Group group in groups) {
    for (Member member in group.members) {
      if (member.id == memberId) {
        for (Event event in member.events) {
          if (!eventMap.containsKey(event.id)) {
            eventMap[event.id] = event;
          }
        }
      }
    }
  }
  return eventMap.values.toList();
}