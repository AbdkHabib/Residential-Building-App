import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qatar_data_app/models/process_response.dart';
import 'package:qatar_data_app/screens/app/resident_details_screen.dart';

import '../../preferences/shared_pref_controller.dart';
import '../../provider/resident_details_provider.dart';
import '../../utils/helpers.dart';

class ResidentHomeScreen extends StatefulWidget {
  const ResidentHomeScreen({Key? key}) : super(key: key);

  @override
  State<ResidentHomeScreen> createState() => _ResidentHomeScreenState();
}

class _ResidentHomeScreenState extends State<ResidentHomeScreen> with Helpers {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ResidentDetailsProvider>(context, listen: false).read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff205375),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'population',
          style: GoogleFonts.nunito(
            color: Colors.white,
          ),
        ),
      ),
      body: Consumer<ResidentDetailsProvider>(
        builder:
            (context, ResidentDetailsProvider residentDetailsProvider, child) {
          if (residentDetailsProvider.residentDetails.isNotEmpty) {
            return ListView.builder(
                itemCount: residentDetailsProvider.residentDetails.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResidentDetailsScreen(
                            residentDetails:
                                residentDetailsProvider.residentDetails[index],
                          ),
                        ),
                      );
                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'amount:',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              residentDetailsProvider
                                  .residentDetails[index].amount
                                  .toString(),
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Text(
                              'payment Date:',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              residentDetailsProvider
                                  .residentDetails[index].paymentDate,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Text(
                              'payment Year:',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              residentDetailsProvider
                                  .residentDetails[index].paymentYear,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Text(
                              'payment Details:',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              residentDetailsProvider
                                  .residentDetails[index].paymentDetails,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Text(
                         '________________________________________'
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () async => await deleteResident(index: index),
                      icon: const Icon(Icons.delete),
                    ),
                  );
                });
          } else {
            return Center(
              child: Text(
                'NO DATA',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 22,
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ResidentDetailsScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xff205375),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> deleteResident({required int index}) async {
    ProcessResponse processResponse =
        await Provider.of<ResidentDetailsProvider>(context, listen: false)
            .delete(index: index);
    showSnackBar(context,
        message: processResponse.message, error: !processResponse.success);
  }
}
