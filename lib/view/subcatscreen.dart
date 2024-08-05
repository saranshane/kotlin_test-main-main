import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/booking.dart';
import '../models/purohithusers.dart';
import '../providers/authnotifier.dart';
import '../providers/bookingnotifier.dart';
import '../providers/categorynotifier.dart';
import '../providers/datetimeprovider.dart';
import '../providers/loader.dart';
import '../providers/locationstatenotifier.dart';
import '../providers/purohithnotifier.dart';
import '../utils/purohitapi.dart';
import '../widgets/appbar.dart';
import '../widgets/button.dart';
import '../widgets/text_widget.dart';

class SubCat extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  const SubCat({super.key, this.scaffoldMessengerKey});

  @override
  ConsumerState<SubCat> createState() => _SubCatState();
}

class _SubCatState extends ConsumerState<SubCat> {
  TextEditingController address1 = TextEditingController();
  TextEditingController address2 = TextEditingController();
  TextEditingController altmobileno = TextEditingController();

  String bookButtonLabel = 'View details';
  String addresHintText = 'Please enter address1';
  String descriptionHintText = 'Please enter description';
  String altmobileNoHintText = 'Please enter alt Mobile no';
  String? selectedLocation;

  @override
  Widget build(BuildContext context) {
    final productDetails = ModalRoute.of(context)!.settings.arguments as Map;

    final DatabaseReference firebaseRealtimeUsersRef =
        FirebaseDatabase.instance.ref().child('presence');

    return Scaffold(
      appBar: purohithAppBar(context, 'Book ${productDetails['title']}'),
      body: Consumer(
        builder: (context, ref, child) {
          var bookingProvider = ref.read(bookingDataProvider.notifier);
          var isLoading = ref.read(loadingProvider);
          var dateAndTimeNotifier = ref.watch(dateAndTimeProvider.notifier);

          return Center(
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextWidget(
                      controller: address1,
                      hintText: addresHintText,
                      keyBoardType: TextInputType.text,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextWidget(
                      controller: address2,
                      hintText: descriptionHintText,
                      keyBoardType: TextInputType.text,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextWidget(
                      controller: altmobileno,
                      hintText: altmobileNoHintText,
                      keyBoardType: TextInputType.phone,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer(
                        builder: (context, ref, child) {
                          final dateAndTime = ref.watch(dateAndTimeProvider);
                          return GestureDetector(
                            onTap: () async {
                              await dateAndTimeNotifier.pickDate(context);
                              await dateAndTimeNotifier.selectTime(context);
                              print('date:${dateAndTime.date}');
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                dateAndTime.date == null
                                    ? 'Pooja date and time'
                                    : 'Date: ${dateAndTime.date}\nTime: ${dateAndTime.time}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Button(
                    buttonname: "Book ${productDetails['title']}",
                    onTap: isLoading
                        ? null
                        : () async {
                            String addressText = "${address2.text.trim()}";
                            // ${address1.text.trim()}
                            BookingData newBooking = BookingData(
                              // Set properties for the new booking
                              purohitCategory: productDetails['title'],
                              time:
                                  '${ref.read(dateAndTimeProvider).date} ${ref.read(dateAndTimeProvider).time}',
                              address:
                                  "address: ${addressText} description: ${address2.text.trim()} alt mobile no: ${altmobileno.text.trim()}",
                              bookingStatus: 'w',
                              // ... other properties ...
                            );
                            await bookingProvider.sendBooking(
                                ctypeId: productDetails['id'].toString(),
                                otp: true,
                                context: context,
                                bookings: newBooking,
                                ref: ref);

                            print('address:$addressText'); // Close the dialog
                          },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Data> _getFilteredUsers(WidgetRef ref, Map productDetails) {
    var purohith = ref.watch(purohithNotifierProvider);
    var location = ref.watch(locationProvider.notifier);
    if (purohith.data == null) return [];

    return purohith.data!.where((purohith) {
      bool hasMatchingCategory = purohith.catid == productDetails['id'] ||
          purohith.catid == productDetails['parentid'];
      bool hasMatchingLocation = location.currentFilterLocation == null ||
          purohith.location == location.currentFilterLocation;
      return hasMatchingCategory && hasMatchingLocation;
    }).toList();
  }

  Widget _buildUsersListView(
      DatabaseReference firebaseRealtimeUsersRef,
      List<Data> users,
      WidgetRef ref,
      BuildContext context,
      int id,
      String cattype) {
    return StreamBuilder<DatabaseEvent>(
      builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        Map<dynamic, dynamic> fbValues =
            snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: users.length,
          itemBuilder: (con, index) =>
              _buildUserCard(users[index], fbValues, ref, context, id, cattype),
        );
      },
      stream: firebaseRealtimeUsersRef.onValue,
    );
  }

  Widget _buildUserCard(Data user, Map<dynamic, dynamic> fbValues,
      WidgetRef ref, BuildContext context, int ctypeId, String cattype) {
    var token = ref.read(authProvider);
    final foundValue = fbValues.values
        .firstWhere((value) => value['id'] == user.id, orElse: () => null);
    if (foundValue == null) {
      return const SizedBox();
    }

    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(user.username ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    "${PurohitApi().baseUrl}${PurohitApi().purohithDp}${user.id}",
                    headers: {"Authorization": token.accessToken!})),
            subtitle: _buildUserInfo(user),
          ),
          _buildBookButton(
              user, ref, context, ctypeId, user.id.toString(), cattype),
        ],
      ),
    );
  }

  Column _buildUserInfo(Data user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Experience: ${user.expirience}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('Languages: ${user.languages}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('Fee: ${user.getAmountWithPercentageIncrease()}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Row _buildBookButton(Data user, WidgetRef ref, BuildContext context,
      int ctypeId, String purohithId, String cattype) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          flex: 2,
          child: Button(
              buttonname: bookButtonLabel,
              onTap: () {
                Navigator.of(context).pushNamed('profileDetails', arguments: {
                  'url':
                      "${PurohitApi().baseUrl}${PurohitApi().purohithDp}${user.id}",
                  'amount': '₹ ${user.getAmountWithPercentageIncrease()}',
                  'cattype': cattype,
                  'userName': user.username
                });
              }),
        ),
      ],
    );
  }
}
