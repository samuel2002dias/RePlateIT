import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main/widgets/filtros.dart';

class BusinessSearchBar extends StatefulWidget {
  final List<QueryDocumentSnapshot<Object?>> botaoList;
  final ValueChanged<List<String>> onSearch;

  const BusinessSearchBar(
      {Key? key, required this.botaoList, required this.onSearch})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<BusinessSearchBar> {
  final TextEditingController _filter = TextEditingController();

  _SearchBarState() {
    _filter.addListener(_search);
  }

  void _search() {
    var searchQuery = _filter.text;
    var filteredList = widget.botaoList
        .where((botao) {
          return botao
              .get("business_name")
              .toLowerCase()
              .contains(searchQuery.toLowerCase());
        })
        .map((e) => e.id)
        .toList();
    widget.onSearch(filteredList);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 60.0, bottom: 10.0),
      child: Container(
        padding: const EdgeInsets.only(top: 10.0, left: 25.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _filter,
                decoration: const InputDecoration(
                  hintText: 'Pesquisa',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    borderSide: BorderSide(
                      color: Color(0xFF90EE60),
                      width: 3.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    borderSide: BorderSide(
                      color: Color(0xFF90EE60),
                      width: 3.0,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: IconButton(
                icon: const Icon(Icons.filter_list_rounded),
                iconSize: 40.0,
                onPressed: () {
                  print("CLICK BOTAO FLITRO");
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => FiltrosWidget(name: "Filtros")),
                  );
                  _filter.clear();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
