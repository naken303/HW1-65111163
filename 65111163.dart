import 'dart:io';

class Room {
  String roomNumber;
  String roomType;
  double price;
  bool isBooked;

  Room(this.roomNumber, this.roomType, this.price, [this.isBooked = false]);

  void bookRoom() {
    if (!isBooked) {
      isBooked = true;
      print("Booked room $roomNumber successfully.");
    } else {
      print("Room $roomNumber is already booked.");
    }
  }

  void cancelBooking() {
    if (isBooked) {
      isBooked = false;
      print("Canceled room $roomNumber successfully.");
    } else {
      print("Room $roomNumber is not booked yet.");
    }
  }
}

class Guest {
  String name;
  String guestId;
  List<Room> bookedRooms = [];

  Guest(this.name, this.guestId);

  void bookRoom(Room room) {
    if (!room.isBooked) {
      room.bookRoom();
      bookedRooms.add(room);
      print('$name has booked room ${room.roomNumber}.');
    } else {
      print("Room ${room.roomNumber} is already booked.");
    }
  }

  void cancelRoom(Room room) {
    if (room.isBooked && bookedRooms.contains(room)) {
      room.cancelBooking();
      bookedRooms.remove(room);
      print('$name has canceled booking for room ${room.roomNumber}.');
    } else {
      print('$name did not book room ${room.roomNumber}.');
    }
  }
}

class Hotel {
  List<Room> rooms = [];
  List<Guest> guests = [];

  void addRoom(Room room) {
    for (var r in rooms) {
      if (r.roomNumber == room.roomNumber) {
        print("Already have room ${room.roomNumber}");
        return;
      }
    }
    rooms.add(room);
    print("Room ${room.roomNumber} has been added.");
  }

  void removeRoom(Room room) {
    if (rooms.contains(room)) {
      if (room.isBooked) {
        print("Room ${room.roomNumber} is currently booked. Are you sure you want to delete it? \n yes(y)/no(n):");
        var option = stdin.readLineSync();
        if (option?.toLowerCase() == 'y') {
          room.cancelBooking();
          rooms.remove(room);
          print("Room ${room.roomNumber} has been removed.");
        } else {
          return;
        }
      } else {
        rooms.remove(room);
        print("Room ${room.roomNumber} has been removed.");
      }
    } else {
      print('Room ${room.roomNumber} does not exist.');
    }
  }

  void registerGuest(Guest guest) {
    for (var g in guests) {
      if (g.guestId == guest.guestId) {
        print("Guest ID ${guest.guestId} is already used.");
        return;
      }
      if (g.name == guest.name) {
        print("Name ${guest.name} is already used.");
        return;
      }
    }
    guests.add(guest);
    print('Guest ${guest.name} has been registered.');
  }

  void bookRoom(String guestId, String roomNumber) {
    Guest? guest = getGuest(guestId);
    Room? room = getRoom(roomNumber);
    if (guest != null && room != null) {
      guest.bookRoom(room);
    }
  }

  void cancelRoom(String guestId, String roomNumber) {
    Guest? guest = getGuest(guestId);
    Room? room = getRoom(roomNumber);
    if (guest != null && room != null) {
      guest.cancelRoom(room);
    }
  }

  Room? getRoom(String roomNumber) {
    for (var room in rooms) {
      if (room.roomNumber == roomNumber) {
        return room;
      }
    }
    print('Room $roomNumber not found.');
    return null;
  }

  Guest? getGuest(String guestId) {
    for (var guest in guests) {
      if (guest.guestId == guestId) {
        return guest;
      }
    }
    print('Guest with ID $guestId not found.');
    return null;
  }
}

void main() {
  var hotel = Hotel();

  while (true) {
    print('\nHotel Management System');
    print('1. Add Room');
    print('2. Remove Room');
    print('3. Register Guest');
    print('4. Book Room');
    print('5. Cancel Room Booking');
    print('6. View Rooms');
    print('7. View Guests');
    print('8. Exit');
    stdout.write('Enter your choice: ');
    var choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        stdout.write('Enter room number: ');
        var roomNumber = stdin.readLineSync();

        String? roomType;
        while (roomType == null) {
          stdout.write('Enter room type (Single/Double/Suite): ');
          var inputRoomType = stdin.readLineSync();
          if (inputRoomType != null && (inputRoomType.toLowerCase() == 'single' || inputRoomType.toLowerCase() == 'double' || inputRoomType.toLowerCase() == 'suite')) {
            roomType = inputRoomType;
          } else {
            print('Invalid room type. Please enter Single, Double, or Suite.');
          }
        }

        double? price;
        while (price == null) {
          stdout.write('Enter room price: ');
          var inputPrice = stdin.readLineSync();
          try {
            price = double.parse(inputPrice!);
          } catch (e) {
            print('Invalid price. Please enter a valid number.');
          }
        }

        var room = Room(roomNumber!, roomType, price);
        hotel.addRoom(room);
        break;

      case '2':
        stdout.write('Enter room number to remove: ');
        var roomNumber = stdin.readLineSync();
        var room = hotel.getRoom(roomNumber!);
        if (room != null) {
          hotel.removeRoom(room);
        }
        break;

      case '3':
        stdout.write('Enter guest name: ');
        var name = stdin.readLineSync();
        stdout.write('Enter guest ID: ');
        var guestId = stdin.readLineSync();
        var guest = Guest(name!, guestId!);
        hotel.registerGuest(guest);
        break;

      case '4':
        stdout.write('Enter guest ID: ');
        var guestId = stdin.readLineSync();
        stdout.write('Enter room number to book: ');
        var roomNumber = stdin.readLineSync();
        hotel.bookRoom(guestId!, roomNumber!);
        break;

      case '5':
        stdout.write('Enter guest ID: ');
        var guestId = stdin.readLineSync();
        stdout.write('Enter room number to cancel booking: ');
        var roomNumber = stdin.readLineSync();
        hotel.cancelRoom(guestId!, roomNumber!);
        break;

      case '6':
        print('Rooms:');
        for (var room in hotel.rooms) {
          print('Room Number: ${room.roomNumber}, Type: ${room.roomType}, Price: ${room.price}, IsBooked: ${room.isBooked}');
        }
        break;

      case '7':
        print('Guests:');
        for (var guest in hotel.guests) {
          print('Guest Name: ${guest.name}, Guest ID: ${guest.guestId}, Booked Rooms: ${guest.bookedRooms.map((room) => room.roomNumber).join(', ')}');
        }
        break;

      case '8':
        exit(0);

      default:
        print('Invalid choice. Please try again.');
    }
  }
}
// (I can explain this thing for sure.)
