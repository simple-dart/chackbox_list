import 'dart:html';

import 'package:simple_dart_ui_core/simple_dart_ui_core.dart';

class CheckboxList<T> extends PanelComponent
    with ValueChangeEventSource<List<T>>, MixinDisable
    implements StateComponent<List<T>> {
  final List<CheckboxInputElement> checkboxes = <CheckboxInputElement>[];
  ObjectRendererAdapter<T> objectRendererAdapter = (object) => StringRenderer<T>()..object = object;
  ObjectStringAdapter<T> adapter = (object) => object.toString();
  final List<T> optionList = <T>[];

  CheckboxList() : super('CheckboxList') {
    vertical = true;
  }

  List<T> get value {
    assert(checkboxes.length == optionList.length,
        'radioButtons is not actual(${checkboxes.length} != ${optionList.length})');
    final ret = <T>[];
    for (var i = 0; i < optionList.length; i++) {
      if (checkboxes[i].checked == true) {
        ret.add(optionList[i]);
      }
    }
    return ret;
  }

  set value(List<T> newValue) {
    checkboxes.forEach((rb) {
      rb.checked = false;
    });
    if (newValue.isEmpty) {
      return;
    }
    for (var i = 0; i < optionList.length; i++) {
      final option = optionList[i];
      if (newValue.contains(option)) {
        checkboxes[i].checked = true;
      }
    }
  }

  @override
  String get state {
    final value = this.value;
    if (value.isEmpty) {
      return '';
    }
    return value.map((e) => adapter(e)).join(',');
  }

  @override
  set state(String newValue) => value = optionList.where((element) => adapter(element) == newValue).toList();

  void initOptions(List<T> options) {
    clear();
    checkboxes.clear();
    optionList
      ..clear()
      ..addAll(options);
    options.forEach((option) {
      final rowPanel = Panel()..vAlign = Align.center;
      final checkbox = CheckboxInputElement();

      final objectRenderer = objectRendererAdapter(option);
      objectRenderer.element.onClick.listen((e) {
        final oldValue = value;
        if (disabled) {
          return;
        }
        checkbox.checked = checkbox.checked != true;
        fireValueChange(oldValue, value);
      });

      checkbox.onChange.listen((ev) {
        fireValueChange(value, value);
      });
      checkboxes.add(checkbox);
      rowPanel.element.children.add(checkbox);
      rowPanel.add(objectRenderer);
      add(rowPanel);
    });
  }

  void focus() {
    element.focus();
  }

  @override
  List<Element> get disableElements => checkboxes;
}
