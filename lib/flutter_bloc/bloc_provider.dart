import 'package:flutter/widgets.dart';
import '../bloc/bloc.dart';

typedef BlocProviderBuilder<T extends Bloc<dynamic, dynamic>> = T Function(
  BuildContext context,
);

class BlocProvider<T extends Bloc<dynamic, dynamic>> extends StatefulWidget {
  final BlocProviderBuilder<T> builder;

  final Widget child;
  final bool dispose;

  BlocProvider({
    Key key,
    @required this.builder,
    this.dispose = true,
    this.child,
  })  : assert(builder != null),
        super(key: key);

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends Bloc<dynamic, dynamic>>(BuildContext context) {
    //final type = _typeOf<_InheritedBlocProvider<T>>();
    final _InheritedBlocProvider<T> provider = context
        .getElementForInheritedWidgetOfExactType<_InheritedBlocProvider<T>>()
        ?.widget as _InheritedBlocProvider<T>;

    if (provider == null) {
      throw FlutterError(
          "BlocProvider.of() called a context that does not contain in a Bloc of type $T");
    }

    return provider?.bloc;
  }

  static Type _typeOf<T>() => T;

  BlocProvider<T> copyWith(Widget child) {
    return BlocProvider<T>(
      key: key,
      builder: builder,
      child: child,
    );
  }
}

class _BlocProviderState<T extends Bloc<dynamic, dynamic>>
    extends State<BlocProvider<T>> {
  T _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.builder(context);
    if (_bloc == null) {
      throw FlutterError(
          'BlocProvider\'s builder method did not retusrn a bloc');
    }
  }

  @override
  void dispose() {
    if (widget.dispose ?? true) {
      _bloc.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedBlocProvider(
      bloc: _bloc,
      child: widget.child,
    );
  }
}

class _InheritedBlocProvider<T extends Bloc<dynamic, dynamic>>
    extends InheritedWidget {
  final T bloc;
  final Widget child;

  _InheritedBlocProvider({Key key, @required this.bloc, this.child})
      : assert(bloc != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedBlocProvider oldWidget) => false;
}
