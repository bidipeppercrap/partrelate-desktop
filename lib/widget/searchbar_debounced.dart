import 'dart:async';

import 'package:flutter/material.dart';

class SearchBarDebounced extends StatefulWidget {
  const SearchBarDebounced({
    super.key,
    required this.onSearch,
    this.onChanged,
    this.hintText = 'Search...',
  });

  final Function(String search) onSearch;
  final Function(String text)? onChanged;
  final String hintText;

  @override
  State<SearchBarDebounced> createState() => _SearchBarDebouncedState();
}

class _SearchBarDebouncedState extends State<SearchBarDebounced> {
  Timer? _debounce;
  final Duration _debounceDuration = const Duration(milliseconds: 300);

  _onSearchChanged(String text) async {
    if (widget.onChanged != null) widget.onChanged!(text);
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () async {
      await widget.onSearch(text);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: TextField(
          decoration: InputDecoration(hintText: widget.hintText),
          onChanged: _onSearchChanged,
        ),
      ),
    );
  }
}
