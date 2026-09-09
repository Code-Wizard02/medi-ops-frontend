abstract class ValueObject<T> {
  const ValueObject(this.value);

  final T value;

  String? validate();

  bool get isValid => validate() == null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ValueObject<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'ValueObject($value)';
}