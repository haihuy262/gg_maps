import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_map/bloc/bloc/key_word_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<KeyWordBloc, KeyWordState>(
          builder: (context, state) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).unfocus();
                context.read<KeyWordBloc>().add(UnfocusTextField());
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      onTap: () {
                        context.read<KeyWordBloc>().add(FocusTextField());
                      },
                      onChanged: (value) {
                        context
                            .read<KeyWordBloc>()
                            .add(TextChange(keyWorld: value));
                      },
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Enter Keyword",
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: state.showIconClear
                            ? IconButton(
                                onPressed: () {
                                  searchController.clear();
                                },
                                icon: const Icon(Icons.clear),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    if (state.isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: CircularProgressIndicator(),
                      )
                    else if (searchController.text.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.addresses.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              child: ListTile(
                                leading: const Icon(Icons.location_on_outlined),
                                title: Text.rich(
                                  TextSpan(
                                    children: _getStyledText(
                                      state.addresses[index],
                                      searchController.text,
                                    ),
                                  ),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    _openGoogleMaps(state.addresses[index]);
                                  },
                                  icon: const Icon(Icons.directions),
                                ),
                                onTap: () =>
                                    _openGoogleMaps(state.addresses[index]),
                              ),
                            );
                          },
                        ),
                      )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _openGoogleMaps(String address) async {
    final url = "https://www.google.com/maps/search/?api=1&query=$address";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw "Could not open Google Maps.";
    }
  }

  List<TextSpan> _getStyledText(String result, String keyword) {
    if (keyword.isEmpty) {
      return [
        TextSpan(text: result)
      ]; // Nếu không có từ khóa, trả về kết quả bình thường.
    }

    final spans = <TextSpan>[];
    final keywordLower = keyword.toLowerCase();
    final resultLower = result.toLowerCase();

    int start = 0;
    int index;

    // Tìm tất cả các vị trí xuất hiện của keyword trong result.
    while ((index = resultLower.indexOf(keywordLower, start)) != -1) {
      // Thêm phần không phải từ khóa.
      if (index > start) {
        spans.add(TextSpan(
          text: result.substring(start, index),
        ));
      }
      // Thêm phần từ khóa được in đậm.
      spans.add(TextSpan(
        text: result.substring(index, index + keyword.length),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));
      start = index + keyword.length;
    }

    // Thêm phần còn lại của kết quả nếu có.
    if (start < result.length) {
      spans.add(TextSpan(text: result.substring(start)));
    }

    return spans;
  }
}
