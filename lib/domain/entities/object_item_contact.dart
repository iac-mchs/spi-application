class ObjectItemContact {
  final String name;
  final String phone;

  ObjectItemContact(this.name, this.phone);

  ObjectItemContact.from(ObjectItemContact contact)
    : name = contact.name,
      phone = contact.phone;
}