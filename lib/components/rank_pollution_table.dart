import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_model.dart';

class GasPollutionTable extends StatelessWidget {
  final List<UserModel> users;

  GasPollutionTable({required this.users});

  @override
  Widget build(BuildContext context) {
    final sortedUsers = users
      ..sort((a, b) => b.sumOfGasPollution.compareTo(a.sumOfGasPollution));

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('🏆 Top Earth Keepers',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: DataTable(
                columnSpacing: 20.0,
                columns: [
                  const DataColumn(label: Text('')),
                  DataColumn(
                      label: Text('Name',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ))),
                  DataColumn(
                      label: Text('CO2 Score',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ))),
                ],
                rows: sortedUsers.asMap().entries.map((entry) {
                  int index = entry.key;
                  UserModel user = entry.value;
                  return DataRow(cells: [
                    DataCell(Text(
                      (index + 1).toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    )), // Place
                    DataCell(Text('${user.firstName} ${user.lastName}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ))), // Name
                    DataCell(Text(user.sumOfGasPollution.toStringAsFixed(2),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ))), // Gas Pollution Score
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
