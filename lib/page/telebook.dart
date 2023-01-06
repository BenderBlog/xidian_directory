/*
Telephone UI of the Xidian Directory.
Copyright (C) 2022 SuperBart

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

Please refer to ADDITIONAL TERMS APPLIED TO XIDIAN_DIRECTORY SOURCE CODE
if you want to use.
*/
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:xidian_directory/weight.dart';
import 'package:xidian_directory/model/telephone.dart';
import 'package:xidian_directory/repository/session.dart';

/// Intro of the telephone book (address book if you want).
class TeleBookWindow extends StatelessWidget {
  const TeleBookWindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => getTelephoneData(true),
      child: FutureBuilder<List<TeleyInformation>>(
        future: getTelephoneData(false),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("坏事: ${snapshot.error}"));
            } else {
              return ListView(
                children: [
                  for (var i in snapshot.data) DepartmentWindow(toUse: i),
                ],
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

/// Each entry of the telephone book is shown in a card,
/// which stored in an information class called [TeleyInformation].
class DepartmentWindow extends StatelessWidget {
  final TeleyInformation toUse;
  final List<Widget> mainCourse = [];

  double white(context) => MediaQuery.of(context).size.width > 900
      ? MediaQuery.of(context).size.width * 0.125
      : 12.5;

  DepartmentWindow({Key? key, required this.toUse}) : super(key: key) {
    mainCourse.addAll([
      Text(
        toUse.title,
        textAlign: TextAlign.left,
        textScaleFactor: 1.4,
      ),
      const Divider(),
    ]);

    if (toUse.isNorth == true) {
      mainCourse.add(const SizedBox(height: 5));
      mainCourse.add(InsideWindow(
        address: toUse.northAddress,
        phone: toUse.northTeley,
      ));
    }
    if (toUse.isSouth == true) {
      mainCourse.add(const SizedBox(height: 5));
      mainCourse.add(InsideWindow(
          address: toUse.southAddress, phone: toUse.southTeley, isSouth: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShadowBox(
      margin: EdgeInsets.symmetric(horizontal: white(context), vertical: 12.5),
      child: Container(
        padding: const EdgeInsets.all(12.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: mainCourse,
        ),
      ),
    );
  }
}

/// Each element of the card is created in here.
/// Needs the information, I am tired to tell.
class InsideWindow extends StatelessWidget {
  final String? address;
  final String? phone;
  final bool isSouth;

  const InsideWindow(
      {Key? key,
      required this.address,
      required this.phone,
      this.isSouth = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 237, 242, 247),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Text(
              isSouth ? "南校区" : "北校区",
              textAlign: TextAlign.left,
              textScaleFactor: 1.00,
            ),
            if (address != null)
              Row(
                children: [
                  const SizedBox(width: 10),
                  const Icon(Icons.house),
                  const SizedBox(width: 5),
                  Text(address!)
                ],
              ),
            if (phone != null) const Spacer(),
            if (phone != null)
              Row(
                children: [
                  const SizedBox(width: 10),
                  const Icon(Icons.phone),
                  const SizedBox(width: 5),
                  Text(phone!)
                ],
              )
          ],
        ),
      ),
    );
  }
}
